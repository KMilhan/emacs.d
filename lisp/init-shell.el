;;; init-shell.el --- Shell scripting helpers -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'zsh-mode)
  (add-to-list 'auto-mode-alist '("\\.zsh\\'" . zsh-mode))
  (add-to-list 'auto-mode-alist '("\\.zshrc\\'" . zsh-mode))
  (add-to-list 'auto-mode-alist '("\\.zprofile\\'" . zsh-mode))
  (add-to-list 'auto-mode-alist '("\\.zlogin\\'" . zsh-mode))
  (add-to-list 'auto-mode-alist '("\\.zshenv\\'" . zsh-mode))
  (add-to-list 'auto-mode-alist '("\\.zsh-theme\\'" . zsh-mode))
  (add-to-list 'interpreter-mode-alist '("zsh" . zsh-mode)))

(when (maybe-require-package 'reformatter)
  (reformatter-define shfmt-format
    :program "shfmt"
    :args '("-i" "2" "-ci" "-bn")
    :lighter " ShFmt")

  (defun sanityinc/shfmt-enable ()
    "Enable shfmt formatting-on-save when appropriate."
    (when (and (executable-find "shfmt")
               (not (derived-mode-p 'zsh-mode)))
      (shfmt-format-on-save-mode 1)))

  (add-hook 'sh-mode-hook 'sanityinc/shfmt-enable)
  (with-eval-after-load 'sh-script
    (when (fboundp 'bash-ts-mode)
      (add-hook 'bash-ts-mode-hook 'sanityinc/shfmt-enable)))))


(provide 'init-shell)
;;; init-shell.el ends here
