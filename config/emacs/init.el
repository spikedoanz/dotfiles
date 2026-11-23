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
;;
;; These palettes use the original Solarized colors, but name each color after
;; the job it does.  Edit the values here to change both built-in and package
;; faces without needing an external theme package.
(defconst my-dark-theme-colors
  '((background             . "#002b36")
    (background-subtle      . "#073642")
    (foreground             . "#839496")
    (foreground-muted       . "#586e75")
    (foreground-strong      . "#93a1a1")
    (border                 . "#073642")
    (cursor                 . "#839496")
    (selection-background  . "#93a1a1")
    (selection-foreground  . "#002b36")
    (search-background     . "#d33682")
    (search-foreground     . "#002b36")
    (attention-background  . "#b58900")
    (attention-foreground  . "#002b36")
    (error                  . "#dc322f")
    (warning                . "#b58900")
    (success                . "#859900")
    (info                   . "#268bd2")
    (link                   . "#b58900")
    (accent                 . "#6c71c4")
    (keyword                . "#859900")
    (string                 . "#2aa198")
    (type                   . "#b58900")
    (constant               . "#268bd2")
    (special                . "#cb4b16"))
  "Semantic colors for `my-solarized-dark'.")

(defconst my-light-theme-colors
  '((background             . "#fdf6e3")
    (background-subtle      . "#eee8d5")
    (foreground             . "#657b83")
    (foreground-muted       . "#93a1a1")
    (foreground-strong      . "#586e75")
    (border                 . "#eee8d5")
    (cursor                 . "#657b83")
    (selection-background  . "#93a1a1")
    (selection-foreground  . "#fdf6e3")
    (search-background     . "#d33682")
    (search-foreground     . "#fdf6e3")
    (attention-background  . "#b58900")
    (attention-foreground  . "#fdf6e3")
    (error                  . "#dc322f")
    (warning                . "#b58900")
    (success                . "#859900")
    (info                   . "#268bd2")
    (link                   . "#b58900")
    (accent                 . "#6c71c4")
    (keyword                . "#859900")
    (string                 . "#2aa198")
    (type                   . "#b58900")
    (constant               . "#268bd2")
    (special                . "#cb4b16"))
  "Semantic colors for `my-solarized-light'.")

(deftheme my-solarized-dark
  "A self-contained, semantically named Solarized dark theme."
  :background-mode 'dark)

(deftheme my-solarized-light
  "A self-contained, semantically named Solarized light theme."
  :background-mode 'light)

(defun my-install-theme-faces (theme colors)
  "Define THEME faces using the semantic color alist COLORS."
  (let ((background            (alist-get 'background colors))
        (background-subtle     (alist-get 'background-subtle colors))
        (foreground            (alist-get 'foreground colors))
        (foreground-muted      (alist-get 'foreground-muted colors))
        (foreground-strong     (alist-get 'foreground-strong colors))
        (border                (alist-get 'border colors))
        (cursor                (alist-get 'cursor colors))
        (selection-background (alist-get 'selection-background colors))
        (selection-foreground (alist-get 'selection-foreground colors))
        (search-background    (alist-get 'search-background colors))
        (search-foreground    (alist-get 'search-foreground colors))
        (attention-background (alist-get 'attention-background colors))
        (attention-foreground (alist-get 'attention-foreground colors))
        (error-color           (alist-get 'error colors))
        (warning-color         (alist-get 'warning colors))
        (success-color         (alist-get 'success colors))
        (info-color            (alist-get 'info colors))
        (link-color            (alist-get 'link colors))
        (accent-color          (alist-get 'accent colors))
        (keyword-color         (alist-get 'keyword colors))
        (string-color          (alist-get 'string colors))
        (type-color            (alist-get 'type colors))
        (constant-color        (alist-get 'constant colors))
        (special-color         (alist-get 'special colors)))
    (custom-theme-set-faces
     theme
     ;; Core editor chrome.
     `(default ((t (:foreground ,foreground :background ,background))))
     `(cursor ((t (:background ,cursor))))
     `(fringe ((t (:foreground ,foreground-muted :background ,background))))
     `(vertical-border ((t (:foreground ,border))))
     `(window-divider ((t (:foreground ,border))))
     `(window-divider-first-pixel ((t (:foreground ,border))))
     `(window-divider-last-pixel ((t (:foreground ,border))))
     `(header-line ((t (:foreground ,foreground-strong
                                    :background ,background-subtle
                                    :box nil))))
     `(mode-line ((t (:foreground ,foreground-strong
                                  :background ,background-subtle
                                  :box (:line-width 1 :color ,border)))))
     `(mode-line-active ((t (:inherit mode-line))))
     `(mode-line-inactive ((t (:foreground ,foreground-muted
                                           :background ,background
                                           :box (:line-width 1 :color ,border)))))
     `(minibuffer-prompt ((t (:foreground ,info-color :weight bold))))
     `(line-number ((t (:foreground ,foreground-muted
                                    :background ,background))))
     `(line-number-current-line ((t (:foreground ,foreground-strong
                                                 :background ,background-subtle
                                                 :weight bold))))
     `(fill-column-indicator ((t (:foreground ,border))))
     `(hl-line ((t (:background ,background-subtle :extend t))))
     `(highlight ((t (:background ,background-subtle))))
     `(region ((t (:foreground ,selection-foreground
                               :background ,selection-background
                               :extend t))))
     `(secondary-selection ((t (:background ,background-subtle :extend t))))
     `(trailing-whitespace ((t (:background ,error-color))))
     `(shadow ((t (:foreground ,foreground-muted))))
     `(escape-glyph ((t (:foreground ,accent-color))))

     ;; Search, matching, and navigation.
     `(isearch ((t (:foreground ,search-foreground
                                :background ,search-background))))
     `(isearch-fail ((t (:foreground ,selection-foreground
                                     :background ,error-color
                                     :weight bold))))
     `(lazy-highlight ((t (:foreground ,attention-foreground
                                       :background ,attention-background))))
     `(match ((t (:foreground ,foreground-strong
                              :background ,background-subtle
                              :weight bold))))
     `(show-paren-match ((t (:foreground ,attention-foreground
                                         :background ,success-color
                                         :weight bold))))
     `(show-paren-mismatch ((t (:foreground ,selection-foreground
                                            :background ,error-color
                                            :weight bold))))

     ;; Messages and interactive elements.
     `(error ((t (:foreground ,error-color))))
     `(warning ((t (:foreground ,warning-color))))
     `(success ((t (:foreground ,success-color))))
     `(link ((t (:foreground ,link-color :underline t))))
     `(link-visited ((t (:foreground ,accent-color :underline t))))
     `(button ((t (:foreground ,link-color :underline t))))
     `(tooltip ((t (:foreground ,foreground :background ,background-subtle))))
     `(help-key-binding ((t (:foreground ,foreground-strong
                                        :background ,background-subtle
                                        :box (:line-width 1 :color ,border)))))
     `(completions-common-part ((t (:foreground ,info-color :weight bold))))
     `(completions-annotations ((t (:foreground ,foreground-muted))))

     ;; Syntax.  These remain useful if `global-font-lock-mode' is enabled.
     `(font-lock-builtin-face ((t (:foreground ,accent-color))))
     `(font-lock-comment-face ((t (:foreground ,foreground-muted))))
     `(font-lock-comment-delimiter-face ((t (:foreground ,foreground-muted))))
     `(font-lock-constant-face ((t (:foreground ,constant-color :weight bold))))
     `(font-lock-doc-face ((t (:foreground ,string-color :slant italic))))
     `(font-lock-function-name-face ((t (:foreground ,info-color))))
     `(font-lock-keyword-face ((t (:foreground ,keyword-color :weight bold))))
     `(font-lock-negation-char-face ((t (:foreground ,special-color :weight bold))))
     `(font-lock-preprocessor-face ((t (:foreground ,constant-color))))
     `(font-lock-string-face ((t (:foreground ,string-color))))
     `(font-lock-type-face ((t (:foreground ,type-color))))
     `(font-lock-variable-name-face ((t (:foreground ,info-color))))
     `(font-lock-warning-face ((t (:foreground ,error-color :weight bold))))

     ;; Common built-in modes and packages used by this configuration.
     `(dired-directory ((t (:foreground ,info-color))))
     `(dired-flagged ((t (:foreground ,error-color))))
     `(dired-header ((t (:foreground ,selection-foreground
                                     :background ,info-color
                                     :weight bold))))
     `(dired-ignored ((t (:foreground ,foreground-muted))))
     `(dired-mark ((t (:foreground ,warning-color :weight bold))))
     `(dired-marked ((t (:foreground ,accent-color :weight bold))))
     `(dired-symlink ((t (:foreground ,string-color :slant italic))))
     `(compilation-error ((t (:foreground ,error-color))))
     `(compilation-warning ((t (:foreground ,warning-color))))
     `(compilation-info ((t (:foreground ,success-color))))
     `(tab-bar ((t (:foreground ,foreground-muted :background ,background))))
     `(tab-bar-tab ((t (:foreground ,foreground-strong
                                    :background ,background-subtle
                                    :weight bold
                                    :box (:line-width 1 :color ,border)))))
     `(tab-bar-tab-inactive ((t (:foreground ,foreground-muted
                                             :background ,background
                                             :box (:line-width 1 :color ,border)))))
     `(org-level-1 ((t (:foreground ,info-color :weight bold))))
     `(org-level-2 ((t (:foreground ,success-color :weight bold))))
     `(org-level-3 ((t (:foreground ,warning-color :weight bold))))
     `(org-level-4 ((t (:foreground ,accent-color :weight bold))))
     `(org-code ((t (:foreground ,string-color))))
     `(org-verbatim ((t (:foreground ,special-color))))
     `(org-block ((t (:foreground ,foreground :background ,background-subtle))))
     `(markdown-header-face ((t (:foreground ,info-color :weight bold))))
     `(markdown-code-face ((t (:foreground ,string-color
                                           :background ,background-subtle))))
     `(evil-ex-info ((t (:foreground ,info-color))))
     `(evil-ex-substitute-matches ((t (:foreground ,search-foreground
                                                  :background ,search-background))))
     `(evil-ex-substitute-replacement ((t (:foreground ,attention-foreground
                                                      :background ,success-color)))))))

(my-install-theme-faces 'my-solarized-dark my-dark-theme-colors)
(my-install-theme-faces 'my-solarized-light my-light-theme-colors)

(provide-theme 'my-solarized-dark)
(provide-theme 'my-solarized-light)

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
      (enable-theme
       (if (eq appearance 'dark)
           'my-solarized-dark
         'my-solarized-light)))))

;; Force a fresh application after `reload-file', including palette edits.
(setq my-last-system-appearance nil)
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

;; Show hexadecimal color literals using the color they describe.  This uses a
;; deliberately minimal, buffer-local font-lock setup, so ordinary syntax
;; highlighting remains disabled.  The supported forms are #RGB, #RGBA,
;; #RRGGBB, and #RRGGBBAA; alpha is ignored because Emacs faces are opaque.
(defconst my-hex-color-regexp
  "#\\(?:[[:xdigit:]]\\{8\\}\\|[[:xdigit:]]\\{6\\}\\|[[:xdigit:]]\\{4\\}\\|[[:xdigit:]]\\{3\\}\\)\\_>"
  "Regexp matching CSS-style hexadecimal color literals.")

(defun my-normalize-hex-color (literal)
  "Return opaque #RRGGBB for hexadecimal color LITERAL."
  (let ((digits (substring literal 1)))
    (downcase
     (pcase (length digits)
       ((or 3 4)
        (format "#%c%c%c%c%c%c"
                (aref digits 0) (aref digits 0)
                (aref digits 1) (aref digits 1)
                (aref digits 2) (aref digits 2)))
       (6 literal)
       (8 (substring literal 0 7))))))

(defun my-hex-color-face ()
  "Return a readable face for the hexadecimal color at point."
  (let* ((background (my-normalize-hex-color
                      (match-string-no-properties 0)))
         (rgb (color-name-to-rgb background))
         (brightness (+ (* 0.299 (nth 0 rgb))
                        (* 0.587 (nth 1 rgb))
                        (* 0.114 (nth 2 rgb))))
         (foreground (if (> brightness 0.55) "#000000" "#ffffff")))
    `(:foreground ,foreground :background ,background)))

(defconst my-hex-color-font-lock-keywords
  `((,my-hex-color-regexp (0 (my-hex-color-face) prepend)))
  "The only font-lock rule enabled by `my-hex-color-highlighting-mode'.")

(define-minor-mode my-hex-color-highlighting-mode
  "Display hexadecimal color literals with their represented color."
  :lighter nil
  (if my-hex-color-highlighting-mode
      (progn
        (setq-local font-lock-defaults
                    '(my-hex-color-font-lock-keywords t))
        (font-lock-mode 1)
        (font-lock-flush))
    (font-lock-mode -1)))

(defun my-enable-hex-color-highlighting ()
  "Enable color literals in buffers where they are likely to occur."
  (when (derived-mode-p 'prog-mode 'text-mode 'conf-mode)
    (my-hex-color-highlighting-mode 1)))

;; Run after global font-lock has honored `global-font-lock-mode', leaving this
;; one intentionally enabled local rule in programming, text, and config files.
(add-hook 'after-change-major-mode-hook
          #'my-enable-hex-color-highlighting
          t)
(my-enable-hex-color-highlighting)

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
   '(activity-watch-mode evil ghostel markdown-mode texfrag))
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
