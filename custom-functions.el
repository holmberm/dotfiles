(defun ergoemacs-select-current-line ()
  "Select the current line"
  (interactive)
  (end-of-line) ; move to end of line
  (set-mark (line-beginning-position)))

(defun mat-previous-window ()
  (interactive)
  (other-window -1))

(defun mat-kill-line-backward ()
  "Overly aggressive deletion backwards"
  (interactive)
  (kill-line -1))
