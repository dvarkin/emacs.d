;;; Dima's .emacs config
(defconst *is-a-mac* (eq system-type 'darwin))

(load-theme 'misterioso)

;; font size
(set-face-attribute 'default (selected-frame) :height 150)

;; PATH

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setenv "PATH" (concat (getenv "PATH") ":$HOME/bin"))

(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("$HOME/bin")))

;; load plugins path

;; switch windows

(global-set-key [s-left] 'windmove-left) 
(global-set-key [s-right] 'windmove-right) 
(global-set-key [s-up] 'windmove-up) 
(global-set-key [s-down] 'windmove-down)

(scroll-bar-mode -1)
(tool-bar-mode -1)
;;(menu-bar-mode -1)
(show-paren-mode 1)
;;(global-hl-line-mode 1)
;;(global-linum-mode t)

;; MELPA

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

;; IDO

(require 'ido)
(ido-mode t)

;; Paredit
(add-to-list 'load-path "~/.emacs.d/elpa/paredit-24/")
(require 'paredit)
(paredit-mode 1)
(add-hook 'clojure-mode-hook #'paredit-mode)

;; rainbow delimiters

(add-to-list 'load-path "~/.emacs.d/elpa/rainbow-delimiters-2.1.1/")
(require 'rainbow-delimiters)
(rainbow-delimiters-mode 1)

(add-to-list 'load-path (expand-file-name "init" user-emacs-directory))

(require 'init-erlang)

;;; Web-mode
(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))


(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(setq web-mode-extra-snippets '(("erb" . (("name" . ("beg" . "end"))))))
(setq web-mode-extra-auto-pairs '(("erb" . (("open" "close")))))

(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
(setq web-mode-enable-auto-pairing t)


;; YAML

(add-hook 'yaml-mode-hook
        (lambda ()
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


;; types script

;; sample config
(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode +1)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode +1)
            ;; company is an optional dependency. You have to
            ;; install it separately via package-install
            (company-mode-on)))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; Tide can be used along with web-mode to edit tsx files
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (tide-setup)
              (flycheck-mode +1)
              (setq flycheck-check-syntax-automatically '(save mode-enabled))
              (eldoc-mode +1)
              (company-mode-on))))

;; project-root

;; FSharp

(unless (package-installed-p 'fsharp-mode)
  (package-install 'fsharp-mode))

(require 'fsharp-mode)


;; YASNIPPET

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
