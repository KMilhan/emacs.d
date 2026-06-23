;;; init-go.el --- Support the Go programming language -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(if (and (fboundp 'go-ts-mode)
         (sanityinc/treesit-ready-p 'go))
    (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
  (when (maybe-require-package 'go-mode)
    (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))))

(when (and (fboundp 'go-mod-ts-mode)
           (sanityinc/treesit-ready-p 'gomod))
  (add-to-list 'auto-mode-alist '("/go\\.\\(?:mod\\|work\\)\\'" . go-mod-ts-mode)))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '((go-mode go-ts-mode) . ("gopls"))))

(when (maybe-require-package 'reformatter)
  (reformatter-define gofmt-format
    :program (sanityinc/executable-find-or-user-error "gofmt")
    :lighter " GoFmt")
  (add-hook 'go-mode-hook 'gofmt-format-on-save-mode)
  (add-hook 'go-ts-mode-hook 'gofmt-format-on-save-mode))

(when (executable-find "gopls")
  (add-hook 'go-mode-hook 'eglot-ensure)
  (add-hook 'go-ts-mode-hook 'eglot-ensure))

(provide 'init-go)
;;; init-go.el ends here
