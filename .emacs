(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
 )
;; END OF CUSTOM

;; --------------------------------------------------------------------------------
;; interface tinkering and general setup
;; --------------------------------------------------------------------------------

(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(menu-bar-mode 0)
(show-paren-mode 1)

;; Packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;; Install missing packages
(dolist (package '(color-theme color-theme-solarized ergoemacs-mode haskell-mode))
  (if (not (package-installed-p package))
      (package-install package)))

;; Looks
(require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-hober)))

(color-theme-initialize)
;; install with M-x package-install zenburn-theme etc.
;; (load-theme 'solarized-dark t)
;; (load-theme 'solarized-light t)
(load-theme 'zenburn t)

;; Working stuff to make emacsclient use correct theme:

;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions
;;               '(lambda (f)
;;                  (with-selected-frame f
;;                    (when (window-system f) (color-theme-solarized-dark)))))
;;   (color-theme-solarized-dark))

(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "dv")
(require 'ergoemacs-mode)
(ergoemacs-mode 1)

(set-default-font "Terminus-14")

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

;; (add-to-list 'load-path "/home/mattias/.emacs.d")
;; (require 'sticky-windows)
;; (global-set-key [(control x) (?0)] 'sticky-window-delete-window)
;; (global-set-key [(control x) (?1)] 'sticky-window-delete-other-windows)
;; (global-set-key [(control x) (?9)] 'sticky-window-keep-window-visible)

;; ;; colors
;; (cond ((fboundp 'global-font-lock-mode)
;;        ;; Customize face attributes
;;        (setq font-lock-face-attributes
;;              ;; Symbol-for-Face Foreground Background Bold Italic Underline
;;              '((font-lock-comment-face       "Gold")
;;                (font-lock-string-face        "Grey50")
;;                (font-lock-keyword-face       "Red")
;;                (font-lock-function-name-face "Green")
;;                (font-lock-variable-name-face "RoyalBlue")
;;                (font-lock-type-face          "Grey")
;;                (font-lock-reference-face     "Purple")
;;                (eshell-prompt                "Blue")
;;                ))
;;        ;; Load the font-lock package.
;;        (require 'font-lock)
;;        ;; Maximum colors
;;        (setq font-lock-maximum-decoration t)
;;        ;; Turn on font-lock in all modes that support it
;;        (global-font-lock-mode t)))

;; --------------------------------------------------------------------------------
;; eshell
;; --------------------------------------------------------------------------------
(defalias 'ffo 'find-file-other-window)

;; --------------------------------------------------------------------------------
;; org mode
;; --------------------------------------------------------------------------------
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
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

;; (global-set-key (kbd "C-]") 'other-window)
;; (global-set-key (kbd "C-.") 'other-window) ;; these work poorly in xterm.
;; (global-set-key (kbd "C-o") 'other-window)
;; (global-set-key (kbd "C-,") 'previous-multiframe-window)
;; (global-set-key (kbd "C-S-o") 'previous-multiframe-window)

;;(global-set-key (kbd "C-[") 'previous-multiframe-window)
;; (global-set-key (kbd "C-}") 'enlarge-window-horizontally)
;; (global-set-key (kbd "C-{") 'shrink-window-horizontally)
;; (global-set-key (kbd "M-}") 'enlarge-window)
;; (global-set-key (kbd "M-{") 'shrink-window)
;; (global-set-key (kbd "M-N") 'scroll-up-line)
;; (global-set-key (kbd "M-P") 'scroll-down-line)
;; ;; Rebind `C-x C-b' for `buffer-menu'
;; (global-set-key "\C-x\C-b" 'buffer-menu)
(global-set-key (kbd "M-;") 'comment-dwim)

;; ;; Simulate ergoemacs keys...
;; (global-set-key (kbd "M-I") 'previous-line)
;; (global-set-key (kbd "M-K") 'next-line)
;; (global-set-key (kbd "M-J") 'backward-char)
;; (global-set-key (kbd "M-L") 'forward-char)
;; (global-set-key (kbd "M-S") 'other-window)
;; (global-set-key (kbd "M-$") 'split-window-right)
;; (global-set-key (kbd "M-4") 'split-window-below)
;; (global-set-key (kbd "C-d") 'move-end-of-line)

;;from haskell tutorial
;; (global-set-key "\M-C" 'compile)
;; (global-set-key "\C-^" 'next-error)
;; other programming stuff
;;(global-set-key "\C-cc" 'comment-region) ;; already bound
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

;; really bad to set globally
;; (global-set-key (kbd "<next>") 'doc-view-scroll-up-or-next-page)
;; (global-set-key (kbd "<prior>") 'doc-view-scroll-down-or-previous-page)

;; (add-hook 'doc-view-mode-hook
;;           '(lamda ()
;;                   (define-key doc-view-mode-map "<next>"
;;                     'doc-view-scroll-up-or-next-page)
;;                   (define-key doc-view-mode-map "<prior>"
;;                     'doc-view-scroll-down-or-previous-page)
;;                   ))

;; (setq ergoemacs-variant nil)
;; (ergoemacs-mode 1)

(put 'narrow-to-region 'disabled nil)

;; (require 'w3m-load)
;;(setq browse-url-browser-function 'w3m-browse-url)
;;(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

;; ;; optional keyboard short-cut
;; (global-set-key "\C-xm" 'browse-url-at-point)

;; --------------------------------------------------------------------------------
;; latex and text
;; --------------------------------------------------------------------------------

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)

;; pdflatex?
(setq TeX-PDF-mode t)

;;tex-mode
(add-hook 'TeX-mode-hook 'turn-off-auto-fill)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-to-list 'load-path "/usr/share/emacs/site-lisp/tex-utils")
;;(require 'xdvi-search)
;; (require 'cdlatex)

;; ispell in swedish
;;(setq ispell-program-name "hunspell")

;;(add-hook 'text-mode-hook '(lambda () (ispell-change-dictionary "svenska" nil)))
;;(add-hook 'text-mode-hook '(lambda () (flyspell-mode nil)))
;
; fix flyspell problem
;;(setq flyspell-issue-welcome-flag nil) 



;; --------------------------------------------------------------------------------
;; trashcan
;; --------------------------------------------------------------------------------

;;(require 'ipython)
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((haskell . t)
;;    (python . t)))

;; emerge app-emacs/color-theme
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/color-theme/color-theme.el")
;; (require 'color-theme)
;; (eval-after-load "color-theme"
;;   '(progn
;;      (color-theme-initialize)
;;      (color-theme-hober)))


;; emerge app-emacs/icicles
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/icicles/")

;;
;; collaborative editing
;; 
;; (load-file "/home/mattias/src/rudel/rudel-loaddefs.el")
(put 'dired-find-alternate-file 'disabled nil)

;; 
;; dired use gnuls instead of ls. We really don't want to do this other
;; than on freebsd. .emacs_local anybody?

(setq ls-lisp-use-insert-directory-program t)      ;; use external ls
(setq insert-directory-program "/usr/local/bin/gnuls") ;; ls program name

