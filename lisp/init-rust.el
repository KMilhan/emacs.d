;;; init-rust.el --- Support for the Rust language -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'rust-mode)
  (when (maybe-require-package 'flycheck-rust)
    (with-eval-after-load 'rust-mode
      (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))
  (when (executable-find "rust-analyzer")
    (add-hook 'rust-mode-hook 'eglot-ensure)))

(provide 'init-rust)
;;; init-rust.el ends here
