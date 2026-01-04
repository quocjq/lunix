;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;;; order-specific package
;; for org mode preview
(package! org :recipe
  (:host nil :repo "https://git.tecosaur.net/mirrors/org-mode.git" :remote "mirror" :fork
   (:host nil :repo "https://git.tecosaur.net/tec/org-mode.git" :branch "dev" :remote "tecosaur")
   :files
   (:defaults "etc")
   :build t :pre-build
   (with-temp-file "org-version.el"
     (require 'lisp-mnt)
     (let
         ((version
           (with-temp-buffer
             (insert-file-contents "lisp/org.el")
             (lm-header "version")))
          (git-version
           (string-trim
            (with-temp-buffer
              (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
              (buffer-string)))))
       (insert
        (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
        (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
        "(provide 'org-version)\n"))))
  :pin nil)

(unpin! org)


;;; normal package
(package! drag-stuff)
(package! jinx)
(package! calibredb)
(package! nov)
(package! olivetti)
(unpin! org-roam)
(package! org-roam-ui)
(package! org-appear :recipe (:host github :repo "awth13/org-appear")
  :pin "32ee50f8fdfa449bbc235617549c1bccb503cb09")
(package! org-transclusion)
(package! org-super-agenda)
(package! fcitx)
