;; Phil's custom emacs config

;; Load the config from config.org
(require 'org) 
(org-babel-load-file (expand-file-name (concat user-emacs-directory "config.org")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" default))
 '(helm-minibuffer-history-key "M-p")
 '(org-agenda-files
   '("~/Dropbox/org/emacs.org" "~/Dropbox/org/cofcsa.org" "~/Dropbox/org/feeds.org" "~/Dropbox/org/gladstone_uca.org" "~/Dropbox/org/inbox.org" "~/Dropbox/org/personal.org" "~/Dropbox/org/peter-rivett.org" "~/Dropbox/org/ppw.org" "~/Dropbox/org/setup.org" "~/Dropbox/org/shared-future.org" "~/Dropbox/org/southside.org" "~/Dropbox/org/test-beamer.org" "~/Dropbox/org/test.org" "~/Dropbox/org/work.org"))
 '(package-selected-packages
   '(spacemacs-theme org-ref yasnippet-snippets helm-org-rifle helm-org helm deft org-evil org-dropbox elfeed-org elfeed org-pdftools pdf-tools switch-window ace-window smex Smex org-bullets hydra general all-the-icons ivy command-log-mode doom-themes use-package evil))
 '(pdf-tools-handle-upgrades nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0)))))
