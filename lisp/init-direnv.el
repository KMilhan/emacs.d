;;; init-direnv.el --- Integrate with direnv -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'envrc)
  (with-eval-after-load 'envrc
    (define-key envrc-mode-map (kbd "C-c e") 'envrc-command-map))
  (sanityinc/add-idle-startup-hook 'envrc-global-mode 2 1))

(provide 'init-direnv)

;;; init-direnv.el ends here
