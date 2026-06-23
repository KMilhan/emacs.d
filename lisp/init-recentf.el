;;; init-recentf.el --- Settings for tracking recent files -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default
 recentf-max-saved-items 1000
 recentf-exclude `("/tmp/" "/ssh:" ,(concat package-user-dir "/.*-autoloads\\.el\\'")))

(defun sanityinc/recentf-mode-startup ()
  "Enable `recentf-mode' and record files opened during startup."
  (recentf-mode 1)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when buffer-file-name
        (recentf-add-file buffer-file-name)))))

(sanityinc/add-idle-startup-hook 'sanityinc/recentf-mode-startup 1)


(provide 'init-recentf)
;;; init-recentf.el ends here
