;;; init-shell.el --- Shell scripting helpers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defun sanityinc/zsh-file-name-p (filename)
  "Return non-nil if FILENAME is a zsh script or startup file."
  (and filename
       (string-match-p
        "\\(?:\\.zsh\\(?:rc\\|env\\)?\\|\\.zprofile\\|\\.zlogin\\|\\.zsh-theme\\)\\'"
        (file-name-nondirectory filename))))

(defun sanityinc/setup-zsh-sh-mode ()
  "Use zsh semantics when `sh-mode' visits zsh-specific files."
  (when (sanityinc/zsh-file-name-p buffer-file-name)
    (setq-local sh-shell-file (or (executable-find "zsh") "zsh"))
    (unless (eq sh-shell 'zsh)
      (sh-set-shell "zsh" t nil))))

(add-to-list 'auto-mode-alist '("\\.zprofile\\'" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.zsh-theme\\'" . sh-mode))
(add-to-list 'interpreter-mode-alist '("zsh" . sh-mode))
(add-hook 'sh-mode-hook 'sanityinc/setup-zsh-sh-mode)

(when (maybe-require-package 'reformatter)
  (reformatter-define shfmt-format
    :program "shfmt"
    :args '("-i" "2" "-ci" "-bn")
    :lighter " ShFmt")

  (defun sanityinc/shfmt-enable ()
    "Enable shfmt formatting-on-save when appropriate."
    (when (and (executable-find "shfmt")
               (not (or (sanityinc/zsh-file-name-p buffer-file-name)
                        (and (boundp 'sh-shell) (eq sh-shell 'zsh)))))
      (shfmt-format-on-save-mode 1)))

  (add-hook 'sh-mode-hook 'sanityinc/shfmt-enable)
  (with-eval-after-load 'sh-script
    (when (fboundp 'bash-ts-mode)
      (add-hook 'bash-ts-mode-hook 'sanityinc/shfmt-enable))))


(provide 'init-shell)
;;; init-shell.el ends here
