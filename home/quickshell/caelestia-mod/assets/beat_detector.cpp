// main.cpp

// C++ Standard Library
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <memory>
#include <atomic>
#include <chrono>
#include <csignal>
#include <iomanip>
#include <sstream>
#include <stdexcept>
#include <algorithm>
#include <cmath>
#include <cstring>

// Third-party libraries
#include <pipewire/pipewire.h>
#include <spa/param/audio/format-utils.h>
#include <spa/param/props.h>
#include <aubio/aubio.h>

// --- Configuration Struct ---
struct Config {
    uint32_t buffer_size = 512;
    bool enable_logging = true;
    bool enable_performance_stats = true;
    bool enable_pitch_detection = false;
    bool enable_visual_feedback = true;
};

// --- Global Signal Handler ---
// A global atomic flag is a clean way for a C-style signal handler
// to communicate with the main application loop.
static std::atomic<bool> g_should_quit{false};

void signal_handler(int signal) {
    std::cout << "\n Received signal " << signal << ", shutting down gracefully..." << std::endl;
    g_should_quit = true;
}


/**
 * @class BeatDetector
 * @brief Captures system audio via PipeWire and performs real-time beat, onset,
 * and pitch detection using the Aubio library.
 *
 * This class encapsulates all the necessary PipeWire and Aubio objects.
 * Resources are managed using RAII principles with std::unique_ptr and custom deleters,
 * ensuring automatic cleanup and exception safety.
 */
class BeatDetector {
public:
    /**
     * @brief Constructs and initializes the BeatDetector.
     * @param config Configuration settings for the detector.
     * @throws std::runtime_error if initialization of PipeWire or Aubio fails.
     */
    explicit BeatDetector(const Config& config);

    /**
     * @brief Destructor. Cleans up resources automatically via RAII.
     * Prints final performance statistics if enabled.
     */
    ~BeatDetector();

    // Delete copy and move operations to prevent misuse
    BeatDetector(const BeatDetector&) = delete;
    BeatDetector& operator=(const BeatDetector&) = delete;
    BeatDetector(BeatDetector&&) = delete;
    BeatDetector& operator=(BeatDetector&&) = delete;

    /**
     * @brief Starts the PipeWire main loop and begins processing audio.
     * This function will block until stop() is called or a signal is received.
     */
    void run();

    /**
     * @brief Signals the PipeWire main loop to stop.
     */
    void stop();

private:
    // --- Constants ---
    static constexpr uint32_t SAMPLE_RATE = 44100;
    static constexpr uint32_t CHANNELS = 1;
    static constexpr size_t BPM_HISTORY_SIZE = 10;
    static constexpr size_t MAX_PROCESS_TIMES = 1000;

    // --- Custom Deleters for RAII ---
    struct PwMainLoopDeleter { void operator()(pw_main_loop* l) { if(l) pw_main_loop_destroy(l); } };
    struct PwContextDeleter { void operator()(pw_context* c) { if(c) pw_context_destroy(c); } };
    struct PwCoreDeleter { void operator()(pw_core* c) { if(c) pw_core_disconnect(c); } };
    struct PwStreamDeleter { void operator()(pw_stream* s) { if(s) pw_stream_destroy(s); } };

    // --- Member Variables ---
    Config config_;
    const uint32_t fft_size_;

    // PipeWire objects (RAII-managed)
    std::unique_ptr<pw_main_loop, PwMainLoopDeleter> main_loop_;
    std::unique_ptr<pw_context, PwContextDeleter> context_;
    std::unique_ptr<pw_core, PwCoreDeleter> core_;
    std::unique_ptr<pw_stream, PwStreamDeleter> stream_;

    // Aubio objects (RAII-managed)
    std::unique_ptr<aubio_tempo_t, decltype(&del_aubio_tempo)> tempo_;
    std::unique_ptr<aubio_onset_t, decltype(&del_aubio_onset)> onset_;
    std::unique_ptr<aubio_pitch_t, decltype(&del_aubio_pitch)> pitch_;
    std::unique_ptr<fvec_t, decltype(&del_fvec)> input_buffer_;
    std::unique_ptr<fvec_t, decltype(&del_fvec)> tempo_output_buffer_;
    std::unique_ptr<fvec_t, decltype(&del_fvec)> pitch_output_buffer_;

    // State and Statistics
    std::ofstream log_file_;
    std::chrono::steady_clock::time_point start_time_;
    uint64_t total_beats_{0};
    uint64_t total_onsets_{0};
    float last_bpm_{0.0f};
    std::vector<float> recent_bpms_;
    std::vector<double> process_times_;

    // --- Initialization ---
    void init_logging();
    void init_aubio();
    void init_pipewire();

    // --- Audio Processing ---
    void process_audio();
    void handle_audio_event(bool is_beat, bool is_onset, float pitch_hz, double process_time_ms);

    // --- User Feedback & Stats ---
    void print_startup_info() const;
    void print_final_stats() const;
    [[nodiscard]] std::string generate_beat_visual(float bpm, bool is_beat) const;
    [[nodiscard]] float get_average_bpm() const;

    // --- PipeWire Callbacks (static) ---
    static void on_stream_state_changed(void* userdata, pw_stream_state old_state, pw_stream_state new_state, const char* error);
    static void on_stream_process(void* userdata);
};


// --- Implementation ---

BeatDetector::BeatDetector(const Config& config)
    : config_(config),
      fft_size_(config.buffer_size * 2),
      tempo_(nullptr, &del_aubio_tempo),
      onset_(nullptr, &del_aubio_onset),
      pitch_(nullptr, &del_aubio_pitch),
      input_buffer_(nullptr, &del_fvec),
      tempo_output_buffer_(nullptr, &del_fvec),
      pitch_output_buffer_(nullptr, &del_fvec)
{
    start_time_ = std::chrono::steady_clock::now();
    recent_bpms_.reserve(BPM_HISTORY_SIZE);
    if (config_.enable_performance_stats) {
        process_times_.reserve(MAX_PROCESS_TIMES);
    }

    init_logging();
    init_aubio();
    init_pipewire();

    print_startup_info();
}

BeatDetector::~BeatDetector() {
    // RAII handles all resource cleanup (PipeWire & Aubio objects).
    // We just need to print stats and close the file handle.
    if (config_.enable_visual_feedback) {
        std::cout << std::endl; // Move to a new line after the visualizer
    }
    print_final_stats();

    if (log_file_.is_open()) {
        log_file_.close();
    }
    
    // De-initialize the PipeWire library
    pw_deinit();
    
    std::cout << "\n Cleanup complete - All resources freed!" << std::endl;
}

void BeatDetector::init_logging() {
    if (!config_.enable_logging) return;

    auto now = std::chrono::system_clock::now();
    auto time_t = std::chrono::system_clock::to_time_t(now);
    std::stringstream filename;
    filename << "beat_log_" << std::put_time(std::localtime(&time_t), "%Y%m%d_%H%M%S") << ".txt";

    log_file_.open(filename.str());
    if (!log_file_.is_open()) {
        throw std::runtime_error("Failed to open log file: " + filename.str());
    }

    log_file_ << "# Beat Detection Log - " << std::put_time(std::localtime(&time_t), "%Y-%m-%d %H:%M:%S") << "\n";
    log_file_ << "# Timestamp,BPM,IsBeat,IsOnset,Pitch(Hz),ProcessTime(ms)\n";
    std::cout << " Logging to: " << filename.str() << std::endl;
}

void BeatDetector::init_aubio() {
    input_buffer_.reset(new_fvec(config_.buffer_size));
    tempo_output_buffer_.reset(new_fvec(1)); // For both tempo and onset
    if (!input_buffer_ || !tempo_output_buffer_) {
        throw std::runtime_error("Failed to create Aubio input/output buffers.");
    }

    tempo_.reset(new_aubio_tempo("default", fft_size_, config_.buffer_size, SAMPLE_RATE));
    if (!tempo_) {
        throw std::runtime_error("Failed to create Aubio tempo detector.");
    }
    
    onset_.reset(new_aubio_onset("default", fft_size_, config_.buffer_size, SAMPLE_RATE));
    if (!onset_) {
        throw std::runtime_error("Failed to create Aubio onset detector.");
    }

    if (config_.enable_pitch_detection) {
        pitch_output_buffer_.reset(new_fvec(1));
        pitch_.reset(new_aubio_pitch("default", fft_size_, config_.buffer_size, SAMPLE_RATE));
        if (!pitch_output_buffer_ || !pitch_) {
            throw std::runtime_error("Failed to create Aubio pitch detector.");
        }
        aubio_pitch_set_unit(pitch_.get(), "Hz");
    }
}

void BeatDetector::init_pipewire() {
    pw_init(nullptr, nullptr);

    main_loop_.reset(pw_main_loop_new(nullptr));
    if (!main_loop_) throw std::runtime_error("Failed to create PipeWire main loop.");

    context_.reset(pw_context_new(pw_main_loop_get_loop(main_loop_.get()), nullptr, 0));
    if (!context_) throw std::runtime_error("Failed to create PipeWire context.");

    core_.reset(pw_context_connect(context_.get(), nullptr, 0));
    if (!core_) throw std::runtime_error("Failed to connect to PipeWire core.");

    static*/
