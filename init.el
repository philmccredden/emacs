;; Phil's custom emacs config

;; Load the config from config.org
(require 'org) 
(org-babel-load-file (expand-file-name (concat user-emacs-directory "config.org")))
