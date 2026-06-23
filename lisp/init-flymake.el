;;; init-flymake.el --- Configure Flymake global behaviour -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(maybe-require-package 'flymake "1.2.1")

;; Use flycheck checkers with flymake, to extend its coverage
(when (maybe-require-package 'flymake-flycheck)
  ;; Disable flycheck checkers for which we have flymake equivalents
  (with-eval-after-load 'flycheck
    (setq-default
     flycheck-disabled-checkers
     (append (default-value 'flycheck-disabled-checkers)
             '(emacs-lisp emacs-lisp-checkdoc emacs-lisp-package sh-shellcheck))))

  (add-hook 'flymake-mode-hook 'flymake-flycheck-auto)

  (defun sanityinc/flymake-enable-in-buffer (buffer)
    "Enable Flymake in BUFFER if it is still a local file buffer."
    (when (buffer-live-p buffer)
      (with-current-buffer buffer
        (when (and buffer-file-name
                   (not (file-remote-p buffer-file-name))
                   (not (bound-and-true-p flymake-mode)))
          (let ((debug-on-error nil))
            (condition-case err
                (flymake-mode 1)
              (error
               (message "Not enabling Flymake in %s: %s"
                        (buffer-name)
                        (error-message-string err)))))))))

  (defun sanityinc/flymake-maybe-enable ()
    "Enable Flymake after startup settles in local file buffers."
    (when (and buffer-file-name
               (not (file-remote-p buffer-file-name)))
      (run-with-idle-timer 0.5 nil
                           'sanityinc/flymake-enable-in-buffer
                           (current-buffer))))

  (add-hook 'prog-mode-hook 'sanityinc/flymake-maybe-enable))

(with-eval-after-load 'flymake
  ;; Provide some flycheck-like bindings in flymake mode to ease transition
  (define-key flymake-mode-map (kbd "C-c ! l") 'flymake-show-buffer-diagnostics)
  (define-key flymake-mode-map (kbd "C-c ! n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "C-c ! p") 'flymake-goto-prev-error)
  (define-key flymake-mode-map (kbd "C-c ! c") 'flymake-start))

(unless (version< emacs-version "28.1")
  (setq eldoc-documentation-strategy 'eldoc-documentation-compose)

  (add-hook 'flymake-mode-hook
            (lambda ()
              (add-hook 'eldoc-documentation-functions 'flymake-eldoc-function nil t))))

(provide 'init-flymake)
;;; init-flymake.el ends here
