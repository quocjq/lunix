(setq doom-theme 'doom-monokai-spectrum)

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

(setq confirm-kill-emacs nil)        ;; Don't confirm on exit
(setq display-line-numbers-type 'relative)
(setq doom-big-font-mode 1)
(setq flycheck-mode 1)
(setq auto-save-default t)
(setq delete-by-moving-to-trash t)
(save-place-mode 1)
(let ((lfile (concat doom-local-dir "straight/repos/transient/lisp/transient.el")))
  (if (file-exists-p lfile)
      (load lfile)))

(modify-all-frames-parameters
 '((right-divider-width . 0)
   (internal-border-width . 0)))
(dolist (face '(window-divider
                window-divider-first-pixel
                window-divider-last-pixel))
  (face-spec-reset-face face)
  (set-face-foreground face (face-attribute 'default :background)))
(set-face-background 'fringe (face-attribute 'default :background))

(map! :leader
      :desc "Comment line" "-" #'comment-line)

(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle org-mode"                "O" #'org-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle line numbers"            "l" #'doom/toggle-line-numbers
       :desc "Toggle truncate lines"          "t" #'toggle-truncate-lines
       :desc "Toggle olivetti mode"           "o" #'olivetti-mode
       :desc "Toggle Org Roam UI"             "n" #'org-roam-ui-mode))

(map! :leader
      (:prefix ("o" . "open here")
       :desc "Open project director here"     "e" #'project-dired))

(map! :n "g s" #'evil-surround-change)

(map! :leader
       :desc "Switch to workspace 1"          "1" #'+workspace/switch-to-0
       :desc "Switch to workspace 2"          "2" #'+workspace/switch-to-1
       :desc "Switch to workspace 3"          "3" #'+workspace/switch-to-2
       :desc "Switch to workspace 4"          "4" #'+workspace/switch-to-3
       :desc "Switch to workspace 5"          "5" #'+workspace/switch-to-4
       :desc "Switch to workspace 6"          "6" #'+workspace/switch-to-5
       :desc "Switch to workspace 7"          "7" #'+workspace/switch-to-6
       :desc "Switch to workspace 8"          "8" #'+workspace/switch-to-7
)

(setq org-modern-table-vertical 1)
(add-hook 'org-mode-hook
          (lambda ()
            (interactive)
            (olivetti-mode 1)))
(setq org-modern-table t)
(add-hook 'org-mode-hook #'hl-todo-mode)
(after! org
 (setq org-agenda-span 'day)
 (setq org-super-agenda-mode 1))
(setq
org-directory "~/org" ; Let's put files here.
org-agenda-files (list org-directory)                  ; Seems like the obvious place.
org-use-property-inheritance t                         ; It's convenient to have properties inherited.
org-log-done 'time                                     ; Having the time a item is done sounds convenient.
org-list-allow-alphabetical t                          ; Have a. A. a) A) list bullets.
org-catch-invisible-edits 'smart                       ; Try not to accidently do weird stuff in invisible regions.
org-export-with-sub-superscripts '{}                   ; Don't treat lone _ / ^ as sub/superscripts, require _{} / ^{}.
org-export-allow-bind-keywords t                       ; Bind keywords can be handy
org-image-actual-width '(0.9))
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
org-ellipsis " […]")

(custom-theme-set-faces!
 'doom-monokai-spectrum
 '(org-level-4 :inherit outline-3 :height 1.2)
 '(org-level-3 :inherit outline-3 :height 1.3)
 '(org-level-2 :inherit outline-2 :height 1.4)
 '(org-level-1 :inherit outline-1 :height 1.5)
 '(org-document-title  :height 2.8 :bold t :underline nil))

(use-package! org-modern
 :hook (org-mode . org-modern-mode)
 :config
 (set-face-attribute 'org-modern-label nil :height 1.3) ;; This make the TODO, WAIT, DONE, etc more readable
 (setq
 org-modern-table-vertical 1
 org-modern-todo-faces -1
 org-modern-table-horizontal 0.2
 org-modern-todo-faces
 '(("TODO" :inverse-video t :inherit org-todo          :foreground "#A3BE8C" :weight bold)
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
   ("quote" "❝" "❞"))
 org-modern-progress nil
 org-modern-priority nil
 org-modern-horizontal-rule (make-string 36 ?─))
 (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo)))
(global-org-modern-mode)

(use-package! websocket
 :after org-roam)
(use-package! org-roam-ui
 :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
 :config
  (setq org-roam-ui-sync-theme t
  org-roam-ui-follow t
  org-roam-ui-update-on-save t
  org-roam-ui-open-on-start t))

(use-package! org-appear
 :hook (org-mode . org-appear-mode)
 :config
 (setq
 org-appear-autoemphasis t
 org-appear-autosubmarkers t
 org-appear-autolinks nil)
 ;; for proper first-time setup, `org-appear--set-elements'
 ;; needs to be run after other hooks have acted.
 (run-at-time nil nil #'org-appear--set-elements))

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang string)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))
(defvar org-babel-lang-list
  '("bash" "sh" "nix" "emacs-lisp"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))

(setq which-key-idle-delay 0.5) ;; I need the help, I really do
(setq which-key-allow-multiple-replacements t)
(after! which-key
 (pushnew!
  which-key-replacement-alist
  '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
  '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
 ))

(add-hook 'olivetti-mode-on-hook (lambda () (display-line-numbers-mode -1)))
(add-hook 'olivetti-mode-off-hook (lambda () (display-line-numbers-mode 1) (setq display-line-numbers-type 'relative)))
(setq olivetti-body-width 130)

(defun my/get-current-hyprland-signature ()
  (let* ((hypr-dir (format "/run/user/%d/hypr/" (user-uid)))
         (sigs (when (file-directory-p hypr-dir)
                 (directory-files hypr-dir nil "^[^.]" t))))
    (cl-find-if (lambda (sig)
                  (file-exists-p
                   (expand-file-name (concat sig "/.socket.sock") hypr-dir)))
                sigs)))

(defun my/update-hyprland-signature ()
  (when (getenv "WAYLAND_DISPLAY")
    (let ((new-sig (my/get-current-hyprland-signature)))
      (if new-sig
          (progn
            (setenv "HYPRLAND_INSTANCE_SIGNATURE" new-sig)
            (message "✓ Updated HYPRLAND_INSTANCE_SIGNATURE to: %s" new-sig))
        (message "⚠ Could not find active Hyprland signature")))))


(after! emacs-everywhere
  (my/update-hyprland-signature)
  (add-to-list 'emacs-everywhere-system-configs
               '((wayland . Hyprland)
                 :focus-command ("hyprctl" "dispatch" "focuswindow" "address:%w")
                 :info-function emacs-everywhere--app-info-linux-hyprland))

  (defun emacs-everywhere--app-info-linux-hyprland ()
    (require 'json)
    (let* ((json-string (emacs-everywhere--call "hyprctl" "-j" "activewindow"))
           (json-object (json-read-from-string json-string))
           (window-id (alist-get 'address json-object))
           (app-name (alist-get 'class json-object))
           (window-title (alist-get 'title json-object))
           (window-at (alist-get 'at json-object))
           (window-size (alist-get 'size json-object))
           (window-geometry (list (if window-at (aref window-at 0) 0)
                                  (if window-at (aref window-at 1) 0)
                                  (if window-size (aref window-size 0) 800)
                                  (if window-size (aref window-size 1) 600))))
      (make-emacs-everywhere-app
       :id (or window-id "0x0")
       :class (or app-name "unknown")
       :title (or window-title "untitled")
       :geometry window-geometry))))
