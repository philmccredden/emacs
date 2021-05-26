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

(global-display-line-numbers-mode 1)
					;    (setq display-line-numbers-type 'relative)

;; Disable line numbers for some modes
(dolist (mode '(term-mode-hook
		shell-mode-hook
		treemacs-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(show-paren-mode 1)                   ; match paranthesis
(global-hl-line-mode t)               ; highlights the current line
(setq revert-without-query '(".pdf")) ; don't require yes to the reload of pdf

(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq split-height-threshold nil)     ; open buffers vertically
(setq split-width-threshold 0)

(defvar runemacs/default-font-size 160)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "Source Code Pro" :height runemacs/default-font-size)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :init (load-theme 'doom-palenight t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(use-package general
  :after evil
  :config
  (general-create-definer pm/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (pm/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/config.org")))))

(general-create-definer pm/ctrl-c-keys
  :prefix "C-c")

(pm/leader-keys
  "t"  '(:ignore t :which-key "toggles")
  "tt" '(counsel-load-theme :which-key "choose theme"))

(pm/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Dropbox/@Work")
    (setq projectile-project-search-path '("~/Dropbox/@Work")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
(use-package forge)

(require 'org)
'(org-agenda-files nil) ; reset variable
(setq org-directory "~/Dropbox/org")
(setq org-agenda-files (list org-directory))

(global-visual-line-mode t)
(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

					; Startup with content in folder state
(setq org-startup-folded t)

					; Todo Keywords
(setq org-todo-keywords
      (quote
       ((sequence "TODO" "ACTIVE" "HOLD" "WAITING" "|" "DONE" "CANCELED"))))

(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "green" :weight bold))
	("ACTIVE" . (:foreground "blue" :weight bold))
	("HOLD" . (:foreground "orange" :weight bold))
	("WAITING" . (:foreground "red" :weight bold))
	("DONE" . (:foreground "cyan" :weight bold))
	("CANCELED" . (:foreground "gray" :weight bold))))

					; google like searching for org files
(setq org-agenda-search-view-always-boolean t) 

					; Clean up extra export files
(setq org-latex-logfiles-extensions (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl")))

(setq org-tags-exclude-from-inheritance '("project"))

(setq org-capture-templates
      '(("t" "Work Todo" entry (file "~/Dropbox/org/work.org")
	 "* TODO %?\n%U" :empty-lines 1)
	("e" "Emacs Config Todo" entry (file+headline "~/Dropbox/org/emacs.org" "Tasks")
	 "* TODO %?\n  %i\n  %a")))

;; easy window switchingo
(use-package switch-window
  :ensure t
  :bind
  ;; default C-x o is other-window
  ;; default C-x C-o is delete-blank-lines
  (("C-x o" . switch-window)
   ("C-x C-o" . switch-window))
  :config
  (setq switch-window-multiple-frames t)
  (setq switch-window-shortcut-style 'qwerty)
  ;; when Emacs is run as client, the first shortcut does not appear
  ;; "x" acts as a dummy; remove first entry if not running server
  (setq switch-window-qwerty-shortcuts '("x" "a" "s" "d" "f" "j" "k" "l" ";" "w" "e" "r" "u" "i" "o" "q" "t" "y" "p"))
  (setq switch-window-increase 3))

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))
(add-to-list 'org-structure-template-alist '("la" . "src latex"))

(setq org-src-fontify-natively t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(require 'ox-latex)
(add-to-list 'org-latex-classes
	     '("beamer"
	       "\\documentclass\[presentation\]\{beamer\}"
	       ("\\section\{%s\}" . "\\section*\{%s\}")
	       ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
	       ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))

(setq ispell-program-name "/usr/local/bin/aspell")
					; for org mode
(add-hook 'org-mode-hook 'flyspell-mode)
					; comments in programming mode
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

; location to place backups
(setq backup-directory-alist `(("." . "~/Dropbox/emacs/backups")))

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(use-package helm)
(helm-mode)
(use-package helm-org)
(use-package helm-org-rifle)
					;  :config
					;  (global-set-key (kbd "C-c C-w") #'helm-org-rifle-org-directory))
					;  (global-set-key (kbd "C-c C-w") #'helm-org-rifle--refile))
					;  (global-set-key (kbd "C-c C-w") #'helm-org-rifle-org-directory)

(pm/leader-keys
  "d" 'helm-org-rifle-org-directory)

(require 'deft)
(setq deft-extensions '("org"))
(setq deft-directory "~/Dropbox/org")
(setq deft-default-extension "org")
(setq deft-text-mode 'org-mode)
(setq deft-use-filename-as-title nil)
(setq deft-use-filter-string-for-filename t)
(setq deft-auto-save-interval 0)
(setq deft-recursive t)
(global-set-key (kbd "C-c d") 'deft-find-file)
(global-set-key (kbd "C-c D") 'deft)

(defadvice doc-view-display (after fit-width activate)
  (doc-view-fit-width-to-window))

;; Set our nickname & real-name as constant variables
(setq
 erc-nick "ltgimlet"     ; Our IRC nick
 erc-user-full-name "ltgimlet") ; Our /whois name

;; Define a function to connect to a server
(defun some-serv ()
  (lambda ()
    (interactive)
    (erc :server "freenode.com"
	 :port   "6667")))

;; Or assign it to a keybinding
;; This example is also using erc's TLS capabilities:
(global-set-key "\C-cen"
		(lambda ()
		  (interactive)
		  (erc-tls :server "server2.example.com"
			   :port   "6697")))

(setq abbrev-file-name "~/dropbox/common/abbrev_defs")
(setq save-abbrevs 'silent) ; save abbrevs when files save
(setq-default abbrev-mode t)

(use-package org-ref)
(setq reftex-default-bibliography '("~/Dropbox/common/MyLibrary.bib"))

;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/Dropbox/org/notes.org"
      org-ref-default-bibliography '("~/Dropbox/common/MyLibrary.bib")
      org-ref-pdf-directory "~/Dropbox/org/bibtex-pdfs/")

;;; Install epdfinfo via 'brew install pdf-tools --HEAD' and then install the
;;; pdf-tools elisp via the use-package below. To upgrade the epdfinfo
;;; server, just do 'brew upgrade pdf-tools' prior to upgrading to newest
;;; pdf-tools package using Emacs package system. If things get messed
;;; up, just do 'brew uninstall pdf-tools', wipe out the elpa
;;; pdf-tools package and reinstall both as at the start.

					;(use-package pdf-tools
					; 	:ensure t
					;	:config
					;	(custom-set-variables
					;	  '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
					;   (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
					;(pdf-tools-install)

					;(use-package org-pdftools
					;  :hook (org-mode . org-pdftools-setup-link))

					; open pdf in pdftools 
(add-to-list 'org-file-apps '("\\.pdf\\'" . emacs))

(use-package elfeed
  :commands elfeed
  :config
  (setq elfeed-feeds
	'("https://nullprogram.com/feed/"
	  "https://ambrevar.xyz/atom.xml"
	  "https://valdyas.org/fading/feed/"
	  "https://www.reddit.com/r/emacs/.rss")))

(global-set-key (kbd "C-x w") 'elfeed)
