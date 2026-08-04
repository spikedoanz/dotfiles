;; disable startup screen
(setq inhibit-startup-screen t)

;; disable initial message on scratch buffer
(setq initial-scratch-message nil)

;; disable menu elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; show line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; use spaces rather than tabs
(setq-default indent-tabs-mode nil)

;; parenthesis matching highlighting
(show-paren-mode 1)


;; packages
(require 'package)

(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(use-package solarized-theme
  :ensure t
  :config
  (load-theme 'solarized-light t))


;; font setup
(set-face-attribute 'default nil
                    :family "JuliaMono"
                    :height 160)

(set-face-attribute 'fixed-pitch nil
                    :family "JuliaMono"
                    :height 1.0)

(set-face-attribute 'fixed-pitch-serif nil
                    :family "JuliaMono"
                    :height 1.0)

;; make bar transparent
(add-to-list 'default-frame-alist
             '(ns-transparent-titlebar . t))


;; agda
(setq auto-mode-alist
   (append
     '(("\\.agda\\'" . agda2-mode)
       ("\\.lagda.md\\'" . agda2-mode))
     auto-mode-alist))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil)
 '(safe-local-variable-values '((eval turn-off-auto-fill))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda --emacs-mode locate")))
