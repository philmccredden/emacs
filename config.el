(defvar efs/default-font-size 140)
(defvar efs/default-variable-font-size 140)

(setq inhibit-startup-message t)  ; turn off splash screen

(tool-bar-mode -1)   ; turn tool bar off
(menu-bar-mode -1)   ; turn menu bar off
(scroll-bar-mode -1) ; scoll bars off
(tooltip-mode -1)    ; Disable tooltips
(set-fringe-mode 10) ; Give some breathing room

;; Set up the visible bell
(setq visible-bell t)

; Display relative line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers 'relative)

;; Answering just 'y' or 'n' will suffice
(defalias 'yes-or-no-p 'y-or-n-p)

;; Backup config
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                       ("org" . "https://orgmode.org/elpa/")
                       ("elpa" . "https://elpa.gnu.org/packages/")))

		       (package-initialize)
		       (unless package-archive-contents
		       (package-refresh-contents))

		       ;; Initialize use-package on non-Linux platforms
		       (unless (package-installed-p 'use-package)
		       (package-install 'use-package))

		       (require 'use-package)
		       (setq use-package-always-ensure t)

(use-package doom-themes
:init (load-theme 'doom-palenight t))

;; Download Evil
(unless (package-installed-p 'evil)
(package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)

; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
term-mode-hook
shell-mode-hook
treemacs-mode-hook
eshell-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default nil :font "Menlo" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Menlo" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height efs/default-variable-font-size :weight 'regular)
(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
'(package-selected-packages (quote (doom-themes use-package evil))))
(custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
)

(require 'org-tempo)
