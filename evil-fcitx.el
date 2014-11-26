; `$ fcitx-remote' return 0 - no input focus
;                         1 - default IME(English)
;                         2 - user's IME
; `$ fcitx-remote -c' will set IME to 1 - default IME
; `$ fcitx-remote -o' will set IME to 2 - user's IME

; ime-user-state
(defvar back-to-default-state-key "C-q")
(defvar user-IME-ID "2\n")

(defvar IME-state
  (concat (get-current-ime)
		  "-state"))

(defun get-current-IME ()
  (if (equal (shell-command-to-string "fcitx-remote")
			 user-IME-ID)
	  "user-IME"
	"default-IME"))

(defun switch-to-default-IME ()
  (shell-command "fcitx-remote -c"))

(defun switch-to-user-IME ()
  (shell-command "fcitx-remote -o"))

(defun exit-insert-evil-fcitx ()
  "When exit insert with user-IME, set IME-state to user-IME-state"
  (if (equal (get-current-IME) "user-IME")
	  (progn
		(setq IME-state "user-IME-state")
		; print-msg
		(shell-command "echo \"IME state recorded\""))
	(setq IME-state "default-IME-state")))

(add-hook 'evil-insert-state-exit-hook
		  'exit-insert-evil-fcitx)

(defun entry-insert-evil-fcitx ()
  "When entry insert with user-IME-state, switch back to user-IME"
  (if (and (equal IME-state "user-IME-state")
		   (equal (get-current-IME) "default-IME-state"))
	  (progn
		(switch-to-user-IME)
		; print-msg
		(shell-command "echo \"IME state Restored\""))))

(add-hook 'evil-insert-state-entry-hook
		  'entry-insert-evil-fcitx)

(defun back-to-default-state()
  (interactive)
  (setq IME-state (get-current-IME))
  (if (or (equal IME-state user-IME)
		  )
	  (progn
		(switch-to-default-IME)
		(setq IME-state "default-IME-state")
		(evil-normal-state)
		(shell-command "echo \"IME-state cleanred\""))
	(shell-command "echo \"unchanged\"")))

(global-set-key (kbd back-to-default-state-key)
				'back-to-default-state)

(provide 'evil-fcitx)
