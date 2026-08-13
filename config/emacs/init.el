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
(setq-default tab-width 2)

;; parenthesis matching highlighting
(show-paren-mode 1)

;; vim-style: only write on manual save
(setq auto-save-default nil)
(setq make-backup-files nil)

;; typography / spacing
(setq-default line-spacing 0.15)

;; flow to 80 chars
(setq-default fill-column 80)
(global-visual-line-mode -1)
(setq-default truncate-lines nil)

(setq make-backup-files nil)        ;; no file~ backups
(setq auto-save-default nil)        ;; no #file# auto-saves
(setq create-lockfiles nil)         ;; no .#file lockfiles

;; packages
(require 'package)

(setq package-archives
      '(
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nong
nu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")
       )
)
	

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; themes
(defun my-system-dark-p ()
  (string=
   (string-trim
    (shell-command-to-string
     "defaults read -g AppleInterfaceStyle 2>/dev/null"))
   "Dark"))

(defvar my-last-system-appearance nil)
(defvar my-appearance-timer nil)

(defun my-sync-theme-with-macos ()
  (let ((appearance (if (my-system-dark-p) 'dark 'light)))
    (unless (eq appearance my-last-system-appearance)
      (setq my-last-system-appearance appearance)
      (mapc #'disable-theme custom-enabled-themes)
      (load-theme
       (if (eq appearance 'dark)
           'solarized-dark
         'solarized-light)
       t))))

(my-sync-theme-with-macos)

(when my-appearance-timer
  (cancel-timer my-appearance-timer))

(setq my-appearance-timer
      (run-with-timer 2 2 #'my-sync-theme-with-macos))   

(setq evil-want-C-u-scroll t)
(use-package evil
  :init
  :config
  (evil-mode 1))

(use-package ghostel
  :ensure t
  :init
  (setq ghostel-module-auto-install 'download)
  :bind ("C-x m" . ghostel))

;; disable syntax highlighting
(global-font-lock-mode -1)

;; font setup
(set-face-attribute 'default nil
                    :family "JuliaMono"
                    :height 160
                    :weight 'light)
(set-face-attribute 'fixed-pitch nil
                    :family "JuliaMono"
                    :height 1.0)

(set-face-attribute 'variable-pitch nil
                    :family "JuliaMono"
                    :height 1.0)
(with-eval-after-load 'org
  (dolist (face '(org-level-1
                  org-level-2
                  org-level-3
                  org-level-4
                  org-level-5
                  org-level-6
                  org-level-7
                  org-level-8))
    (set-face-attribute face nil
                        :family 'unspecified
                        :height 1.0
                        :weight 'bold)))

;; make bar transparent
;; (add-to-list 'default-frame-alist
;;              '(ns-transparent-titlebar . t))

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
 '(package-selected-packages
   '(activity-watch-mode evil ghostel markdown-mode solarized-theme texfrag))
 '(safe-local-variable-values '((eval turn-off-auto-fill))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda --emacs-mode locate")))
(put 'dired-find-alternate-file 'disabled nil)
