(let ((light-theme 'doom-tomorrow-day)
      (dark-theme 'doom-vibrant)
      (system-theme
       (or (and (memq system-type '(gnu gnu/linux gnu/kfreebsd))
                (require 'dbus nil t)
                (caar
                 (ignore-errors
                   (dbus-call-method
                    :session
                    "org.freedesktop.portal.Desktop" "/org/freedesktop/portal/desktop"
                    "org.freedesktop.portal.Settings" "Read"
                    "org.freedesktop.appearance" "color-scheme"))))
           0)))
  (pcase system-theme
    (1 dark-theme)
    (2 light-theme)
    (_ dark-theme)))

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 17))

(setq frame-title-format
      '(""
        (:eval
         (if (string-match-p (regexp-quote (or (bound-and-true-p org-roam-directory) "\u0000"))
                             (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?\s buffer-file-name))
           "%b"))
        (:eval
         (when-let ((project-name (and (featurep 'projectile) (projectile-project-name))))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

(setq display-line-numbers-type t)   ;; Turn line numbers on
(setq confirm-kill-emacs nil)        ;; Don't confirm on exit
(setq display-line-numbers-type 'relative)
(setq initial-buffer-choice 'vterm) ;; Eshell is initial buffer
(setq doom-big-font-mode t)

(map! :leader
      :desc "Comment line" "-" #'comment-line)

(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Toggle eshell split"            "e" #'+eshell/toggle
       :desc "Toggle vterm split"             "v" #'+vterm/toggle
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle line numbers"            "l" #'doom/toggle-line-numbers
       :desc "Toggle markdown-view-mode"      "m" #'dt/toggle-markdown-view-mode
       :desc "Toggle truncate lines"          "t" #'toggle-truncate-lines
))
(map! :leader
       :desc "Toggle treemacs"                "e" #'+treemacs/toggle
       :desc "Tangle file"                    "l" #'org-babel-tangle
)
(map! :i "TAB" #'up-list)
(setq display-line-numbers-type t)
(map! :leader
      (:prefix ("o" . "open here")
       :desc "Open eshell here"    "e" #'+eshell/here
))

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(defun dt/toggle-markdown-view-mode ()
  "Toggle between `markdown-mode' and `markdown-view-mode'."
  (interactive)
  (if (eq major-mode 'markdown-view-mode)
      (markdown-mode)
    (markdown-view-mode)))

(setq org-directory "~/Org/")
(setq org-modern-table-vertical 1)
(setq org-modern-table t)
(add-hook 'org-mode-hook #'hl-todo-mode)

(custom-theme-set-faces!
'doom-one
'(org-level-8 :inherit outline-3 :height 1.0)
'(org-level-7 :inherit outline-3 :height 1.0)
'(org-level-6 :inherit outline-3 :height 1.1)
'(org-level-5 :inherit outline-3 :height 1.1)
'(org-level-4 :inherit outline-3 :height 1.5)
'(org-level-3 :inherit outline-3 :height 1.7)
'(org-level-2 :inherit outline-2 :height 1.9)
'(org-level-1 :inherit outline-1 :height 2.0)
'(org-document-title  :height 2.8 :bold t :underline nil))

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (set-face-attribute 'org-modern-label nil :height 2.0) ;; This make the TODO, WAIT, DONE, etc more readable
  (setq org-modern-star '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-list '((43 . "➤")
                          (45 . "–")
                          (42 . "•"))
        org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo           :foreground "#A3BE8C" :weight bold)
          ("PROJ" :inverse-video t :inherit +org-todo-project :foreground "#88C0D0" :weight bold)
          ("HOLD" :inverse-video t :inherit +org-todo-onhold  :foreground "#8FBCBB" :weight bold)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold  :foreground "#81A1C1" :weight bold)
          ("KILL" :inverse-video t :inherit +org-todo-cancel  :foreground "#EBCB8B" :weight bold)
          ("NO"   :inverse-video t :inherit +org-todo-cancel  :foreground "#30343d" :weight bold))
        org-modern-footnote
        (cons nil (cadr org-script-display))
        org-modern-block-fringe nil
        org-modern-block-name
        '((t . t)
          ("src" "»" "«")
          ("example" "»–" "–«")
          ("quote" "❝" "❞")
          ("export" "⏩" "⏪"))
        org-modern-progress nil
        org-modern-priority nil
        org-modern-horizontal-rule (make-string 36 ?─)
        org-modern-keyword
        '((t . t)
          ("title" . "𝙏")
          ("subtitle" . "𝙩")
          ("author" . "𝘼")
          ("email" . "")
          ("date" . "𝘿")
          ("property" . "󰠳")
          ("options" . #("󰘵" 0 1 (display (height 0.75))))
          ("startup" . "⏻")
          ("macro" . "𝓜")
          ("bind" . "󰌷")
          ("bibliography" . "")
          ("print_bibliography" . "󰌱")
          ("cite_export" . "⮭")
          ("print_glossary" . "󰌱ᴬᶻ")
          ("glossary_sources" . "󰒻")
          ("include" . "⇤")
          ("setupfile" . "⇚")
          ("html_head" . "🅷")
          ("html" . "🅗")
          ("latex_class" . "🄻")
          ("latex_class_options" . "🄻󰒓")
          ("latex_header" . "🅻")
          ("latex_header_extra" . "🅻⁺")
          ("latex" . "🅛")
          ("beamer_theme" . "🄱")
          ("beamer_color_theme" . "🄱󰏘")
          ("beamer_font_theme" . "🄱𝐀")
          ("beamer_header" . "🅱")
          ("beamer" . "🅑")
          ("attr_latex" . "🄛")
          ("attr_html" . "🄗")
          ("attr_org" . "𝑜")
          ("call" . "󰜎")
          ("name" . "⁍")
          ("header" . "›")
          ("caption" . "☰")
          ("results" . "↪")))
  (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo)))

(modify-all-frames-parameters
 '((right-divider-width . 0)
   (internal-border-width . 0)))
(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))
(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-agenda-tags-column 0
 org-ellipsis "…")

(global-org-modern-mode)

(setq which-key-idle-delay 0.5) ;; I need the help, I really do
(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))
