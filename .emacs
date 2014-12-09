(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Man-width 80)
 '(cdlatex-simplify-sub-super-scripts nil)
 '(inhibit-startup-screen t)
 '(org-CUA-compatible nil)
 '(org-clock-idle-time 10)
 '(shift-select-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#2B2B2B" :foreground "#8FB28F" :box -1)))))
;; END OF CUSTOM

;; --------------------------------------------------------------------------------
;; interface tinkering and general setup
;; --------------------------------------------------------------------------------

(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(menu-bar-mode 0)
(show-paren-mode 1)
(normal-erase-is-backspace-mode 1)    ;fix backspace in terminals (watchout for X)
 
;; use 'y' or 'n' instead of "yes" or "no"
(fset 'yes-or-no-p 'y-or-n-p)

;; backup settings. TODO rotation
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))

;; prevent tab indenting
(setq-default indent-tabs-mode nil)

;; let *grep* mess with this buffer, not others
(add-to-list 'same-window-buffer-names "*grep*")

(set-face-attribute 'default nil :height 110)
;; (set-face-attribute 'default nil :height 100)

(prefer-coding-system 'utf-8) ;TODO verify that this works in linux too...

;; Load custom function definitions
(load "~/.emacs.d/custom-functions.el")

;; --------------------------------------------------------------------------------
;; General Packages
;; --------------------------------------------------------------------------------
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;; Install missing packages
(dolist (package '(color-theme
                   color-theme-solarized
                   zenburn-theme
                   ergoemacs-mode
                   haskell-mode))
  (if (not (package-installed-p package))
      (package-install package)))

;; Looks
(require 'color-theme)
(color-theme-initialize)

;; install with M-x package-install zenburn-theme etc.
(load-theme 'solarized-dark t)
;; (load-theme 'solarized-light t)
;; (load-theme 'zenburn t)

;; ErgoEmacs
(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "dv")
;; (require 'ergoemacs-mode)
;; (ergoemacs-mode 1)

(set-default-font "Terminus-12")


;; (add-to-list 'load-path "/home/mattias/.emacs.d")
;; (require 'sticky-windows)
;; (global-set-key [(control x) (?0)] 'sticky-window-delete-window)
;; (global-set-key [(control x) (?1)] 'sticky-window-delete-other-windows)
;; (global-set-key [(control x) (?9)] 'sticky-window-keep-window-visible)

(require 'ido)
(ido-mode t)

(require 'undo-tree)
(global-undo-tree-mode)

;; --------------------------------------------------------------------------------
;; eshell
;; --------------------------------------------------------------------------------
(defalias 'ffo 'find-file-other-window)

;; --------------------------------------------------------------------------------
;; org mode
;; --------------------------------------------------------------------------------
;; (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(setq org-startup-indented t)
;; (add-to-list 'load-path "/home/mattias/.emacs.d/elpa/cdlatex-4.0")
;; (add-to-list 'load-path "/home/mattias/.emacs.d/elpa")

;; --------------------------------------------------------------------------------
;; programming
;; --------------------------------------------------------------------------------

;; 
;; C
;; 
(setq c-default-style "linux"
      c-basic-offset 4)

;;
;;haskell-mode, install with M-x package-install haskell-mode
;;
(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hic?$"     . haskell-mode)
                ("\\.hsc$"     . haskell-mode)
                ("\\.chs$"    . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))
(autoload 'haskell-mode "haskell-mode"
   "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
   "Major mode for editing literate Haskell scripts." t)

;adding the following lines according to which modules you want to use:
;; (require 'inf-haskell)

(add-hook 'haskell-mode-hook 'turn-on-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 
   (function
    (lambda ()
      (setq haskell-program-name "ghci"))))

;; 
;; Python
;; 

;; 
;; RePy
;; 
(add-to-list 'auto-mode-alist '("\\.repy$" . python-mode))

;; ;; 
;; ;; multi-web-mode
;; ;; 
;; (require 'multi-web-mode)
;; (setq mweb-default-major-mode 'html-mode)
;; (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;;                   (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;;                   (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;; (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;; (multi-web-global-mode 1)

;; ;; 
;; ;; matlab-mode
;; ;; 
;; (add-to-list 'load-path "/home/mattias/src/matlab-emacs/matlab-emacs")
;; (load-library "matlab-load")

;; (autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
;; (add-to-list
;;  'auto-mode-alist
;;  '("\\.m$" . matlab-mode))
;; (setq matlab-indent-function t)
;; (setq matlab-shell-command "matlab")


;; --------------------------------------------------------------------------------
;; key bindings
;; 
;; This set of keys, `C-c' followed by a single character,
;; is strictly reserved for individuals' own use.
;; --------------------------------------------------------------------------------

;; Contol keys
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
(global-set-key (kbd "C-s") 'save-buffer)
;; (global-set-key (kbd "C-7") 'ergoemacs-select-current-line) ;would like to have
                                        ;on fn too...
(global-set-key (kbd "C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-b") 'buffer-menu)
;; Meta keys (while Meta almost never works on the ipad, ESC key chords do)
;; Window management
(global-set-key (kbd "M-2") 'delete-window)
(global-set-key (kbd "M-3") 'delete-other-windows)
(global-set-key (kbd "M-4") 'split-window-right)
(global-set-key (kbd "M-$") 'split-window-below)
(global-set-key (kbd "M-<") 'beginning-of-buffer)
(global-set-key (kbd "M->") 'end-of-buffer)
(global-set-key (kbd "M-u") 'undo-tree-undo)
(global-set-key (kbd "M-r") 'undo-tree-redo)

;; fn keys
(global-set-key (kbd "<f2>") 'comment-indent-new-line)
(global-set-key (kbd "<f3>") 'execute-extended-command)
(global-set-key (kbd "<f4>") 'ergoemacs-select-current-line)
(global-set-key (kbd "<f5>") 'other-window)
(global-set-key (kbd "S-<f5>") 'mat-previous-window)
(global-set-key (kbd "<f6>") 'kill-line)
(global-set-key (kbd "S-<f6>") 'mat-kill-line-backward)
(global-set-key (kbd "<f7>") 'backward-kill-word)
(global-set-key (kbd "<f8>") 'kill-word)
(global-set-key (kbd "<f9>") 'comment-dwim)
(global-set-key (kbd "<f11>") 'backward-word)
(global-set-key (kbd "<f12>") 'forward-word)
(global-set-key (kbd "S-<up>") 'scroll-down-command)
(global-set-key (kbd "S-<down>") 'scroll-up-command)
;; shift left and right, see ergoemacs-forward-open-bracket and friends.
;; It is no use, ipad does not recognize shifted keys anyway. Maybe do something with meta?

;; (global-set-key (kbd "C-}") 'enlarge-window-horizontally)
;; (global-set-key (kbd "C-{") 'shrink-window-horizontally)
;; (global-set-key (kbd "M-}") 'enlarge-window)
;; (global-set-key (kbd "M-{") 'shrink-window)
;; (global-set-key (kbd "M-N") 'scroll-up-line)
;; (global-set-key (kbd "M-P") 'scroll-down-line)

(global-set-key "\C-xar" 'align-regexp)
;; todo write function that aligns equal signs!

;; org mode keys
(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key "\C-cr" '(doc-view-revert-buffer nil t))
;;(global-set-key "\C-cr" 'revert-noconfirm)

;; (defun revert-noconfirm
;;   "revert dv buffer without confirmation"
;;   (doc-view-revert-buffer nil t))

;; w3m keys
;; (global-set-key [C-tab] 'w3m-next-buffer)
;; (global-set-key [C-iso-lefttab] 'w3m-previous-buffer)

(put 'narrow-to-region 'disabled nil)

;; (require 'w3m-load)
;;(setq browse-url-browser-function 'w3m-browse-url)
;;(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

;; --------------------------------------------------------------------------------
;; latex and text
;; --------------------------------------------------------------------------------

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;; (add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'latex-mode-hook 'visual-line-mode)

(setq cdlatex-env-alist
     '(("axiom" "\\begin{axiom}\nAUTOLABEL\n?\n\\end{axiom}\n" nil)
       ("lstlisting" "\\begin{lstlisting}[style=syn?]\n\n\\end{lstlisting}\n" nil)))
(setq cdlatex-command-alist
 '(("axm" "Insert axiom env"   "" cdlatex-environment ("axiom") t nil)
   ("ist" "Insert lstlisting env"   "" cdlatex-environment ("lstlisting") t nil)
   ("sus"       "Insert a \\subsubsection{} statement"
        "\\subsubsection{?}" cdlatex-position-cursor nil t nil)))

(require 'reftex)
;; (require 'cdlatex) ; needed?|
(add-hook 'LaTeX-mode-hook
	  '(lambda ()
	    (turn-on-reftex)
	    (turn-on-cdlatex)))

;; pdflatex?
(setq TeX-PDF-mode t)

(setq TeX-electric-escape nil)
(setq TeX-default-macro "kvproductname")

;; Ispell in windows

;; (add-to-list 'exec-path "C:/Program Files (x86)/GnuWin32/Aspell/bin")
;; (setq ispell-program-name "aspell")
;; (require 'ispell)

;;text-mode
;; (add-hook 'TeX-mode-hook 'turn-off-auto-fill)
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-to-list 'load-path "/usr/share/emacs/site-lisp/tex-utils")
;;(require 'xdvi-search)

;; ispell in swedish
;;(setq ispell-program-name "hunspell")

;;(add-hook 'text-mode-hook '(lambda () (ispell-change-dictionary "svenska" nil)))
;;(add-hook 'text-mode-hook '(lambda () (flyspell-mode nil)))
;
; fix flyspell problem
;;(setq flyspell-issue-welcome-flag nil) 


;; --------------------------------------------------------------------------------
;; Dired
;; --------------------------------------------------------------------------------

(put 'dired-find-alternate-file 'disabled nil)

;; 
;; dired use gnuls instead of ls. We really don't want to do this other
;; than on freebsd. .emacs_local anybody?

;; (setq ls-lisp-use-insert-directory-program t)      ;; use external ls
;; (setq insert-directory-program "/usr/local/bin/gnuls") ;; ls program name

;; --------------------------------------------------------------------------------
;; trashcan
;; --------------------------------------------------------------------------------
;; (global-set-key (kbd "C-]") 'other-window)
;; (global-set-key (kbd "C-.") 'other-window) ;; these work poorly in xterm.
;; (global-set-key (kbd "C-o") 'other-window)
;; (global-set-key (kbd "C-,") 'previous-multiframe-window)
;; (global-set-key (kbd "C-S-o") 'previous-multiframe-window)

;;(global-set-key (kbd "C-[") 'previous-multiframe-window)

;; ;; Rebind `C-x C-b' for `buffer-menu'
;; (global-set-key "\C-x\C-b" 'buffer-menu)
;; (global-set-key (kbd "M-;") 'comment-dwim)
