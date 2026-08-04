;; disable startup screen
(setq inhibit-startup-screen t)

;; disable initial message on scratch buffer
(setq initial-scratch-message nil)

;; disable menu elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; show line numbers
;; (add-hook 'prog-mode-hook #'display-line-numbers-mode)

(defun toggle-line-numbers-absolute ()
  (interactive)
  (if (and display-line-numbers-mode
           (eq display-line-numbers t))
      (display-line-numbers-mode -1)
    (setq-local display-line-numbers t)
    (display-line-numbers-mode 1)))

(defun toggle-line-numbers-relative ()
  (interactive)
  (if (and display-line-numbers-mode
           (eq display-line-numbers 'relative))
      (display-line-numbers-mode -1)
    (setq-local display-line-numbers 'relative)
    (display-line-numbers-mode 1)))

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

(setq evil-want-C-u-scroll t)
(use-package evil
  :init
  :config
  (evil-mode 1))

;; font setup
(set-face-attribute 'default nil
                    :family "JuliaMono"
                    :height 160)

;; make bar transparent
(add-to-list 'default-frame-alist
             '(ns-transparent-titlebar . t))

;; reload config
(defun reload-file ()
  "Reload the current Emacs configuration."
  (interactive)
  (load-file user-init-file)
  (message "Reloaded %s" user-init-file))

;; tabs
(tab-bar-mode 1)

(setq tab-bar-close-button-show nil
      tab-bar-new-button-show nil)


;; convenient tab switching.
(global-set-key (kbd "C-<tab>") #'tab-bar-switch-to-next-tab)
(global-set-key (kbd "C-S-<tab>") #'tab-bar-switch-to-prev-tab)

;; create and close tabs.
(global-set-key (kbd "C-c t n") #'tab-bar-new-tab)
(global-set-key (kbd "C-c t k") #'tab-bar-close-tab)
(global-set-key (kbd "C-c t r") #'tab-bar-rename-tab)

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
 '(package-selected-packages '(evil solarized-theme))
 '(safe-local-variable-values '((eval turn-off-auto-fill))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda --emacs-mode locate")))
