;;; init-uiua.el --- Support for the Uiua programming language -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(if (and (sanityinc/treesit-ready-p 'uiua)
         (maybe-require-package 'uiua-ts-mode))
    (add-to-list 'auto-mode-alist '("\\.ua\\'" . uiua-ts-mode))
  (maybe-require-package 'uiua-mode))

(with-eval-after-load 'eglot
  (when (executable-find "uiua")
    (add-to-list 'eglot-server-programs '((uiua-mode uiua-ts-mode) . ("uiua" "lsp")))))

(maybe-require-package 'nixpkgs-fmt)

(provide 'init-uiua)
;;; init-uiua.el ends here
