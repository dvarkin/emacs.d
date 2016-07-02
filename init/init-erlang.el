;; Erlang main mode

(setq load-path (cons "/usr/local/lib/erlang/lib/tools-2.8.3/emacs/" load-path))

(require 'erlang-start)
(setq erlang-root-dir "/usr/local/lib/erlang/")
(setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(setq erlang-man-root-dir "/usr/local/lib/erlang/man")
(setq erlang-electric-commands '(erlang-electric-comma,
                                   erlang-electric-semicolon))

(require 'flycheck)

(defun erlang-find-project-root (dirname)
  (let* ((project-dir (locate-dominating-file dirname "erlang.mk")))
    (if project-dir
	(let* ((parent-dir (file-name-directory (directory-file-name project-dir)))
	       (top-project-dir (if (and parent-dir (not (string= parent-dir "/")))
				    (erlang-find-project-root parent-dir)
				  nil)))
	  (if top-project-dir
	      top-project-dir
	    project-dir))
      project-dir)))


(defun erlang-add-deps-libs (internal-path file-dir)
  (let ((project-root (file-truename (erlang-find-project-root file-dir))))
    (split-string
     (delq nil
	   (mapconcat (lambda (x)
			(if (not (or (string= ".." x) (string= "." x)))
			    (concat project-root "deps/" x internal-path)))
		      (directory-files (concat  project-root "deps"))
		      " ")))))


(add-hook 'erlang-mode-hook
	  (lambda ()
	    (setq flycheck-erlang-library-path (erlang-add-deps-libs "/ebin" (file-name-directory (file-truename (buffer-file-name)))))
	    (setq flycheck-erlang-include-path (erlang-add-deps-libs "/include" (file-name-directory (file-truename (buffer-file-name)))))
	    (flycheck-mode)))

(require 'flycheck-tip)
(flycheck-tip-use-timer 'verbose)

;; Distel

(push "~/.emacs.d/distel/elisp/" load-path)
(require 'distel)
(distel-setup)

;; Default node name

;; prevent annoying hang-on-compile
(defvar inferior-erlang-prompt-timeout t)
;; default node name to emacs@localhost
(setq inferior-erlang-machine-options '("-sname" "emacs"))
;; tell distel to default to that node
(setq erl-nodename-cache
      (make-symbol
       (concat
        "emacs@"
        ;; Mac OS X uses "name.local" instead of "name", this should work
        ;; pretty much anywhere without having to muck with NetInfo
        ;; ... but I only tested it on Mac OS X.;
	(car (split-string (shell-command-to-string "name.local"))))))

(add-hook 'after-init-hook 'global-company-mode)

(push "~/.emacs.d/company-distel/" load-path)
(require 'company-distel)
;;(add-to-list 'company-backends 'company-distel)


;; load snippets

(add-hook 'erlang-mode-hook #'yas-minor-mode)

(provide 'init-erlang)

