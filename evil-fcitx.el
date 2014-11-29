; `$ fcitx-remote' return 0 - no input focus
;                         1 - default IME(English)
;                         2 - user's IME
; `$ fcitx-remote -c' will set IME to 1 - default IME
; `$ fcitx-remote -o' will set IME to 2 - user's IME

;;;;;;;;;; User configs

; for me I don't use C-q quite often
(defvar back-to-default-state-key "C-q")
(defalias 'q 'quote)

; Indicator to be displayed in mode-line, like <N>/<I> for Evil-mode
(defvar user-IME-state-indicator "[ZH]")
(defvar default-IME-state-indicator "[EN]")

; 2 is the return value of `$ fcitx-remote' when you toggle on your IME
; usaully don't need to change this
(defvar user-IME-ID "2\n")

;;;;;;;;;; End of user configs

(defvar IME-state-mode-line-tag default-IME-state-indicator)

(defun get-current-IME ()
  (if (equal (shell-command-to-string "fcitx-remote")
			 user-IME-ID)
	  "user-IME"
	"default-IME"))

(defvar IME-state
  (concat (get-current-IME)
		  "-state"))

(defun switch-to-default-IME ()
  (shell-command "fcitx-remote -c"))

(defun switch-to-user-IME ()
  (shell-command "fcitx-remote -o"))

(defun IME-state-setter (state)
  (setq IME-state state)
  (cond
   ((string-equal state "default-IME-state")
	(setq IME-state-mode-line-tag "[EN]"))
   ((string-equal state "user-IME-state")
	(setq IME-state-mode-line-tag "[ZH]")))
  (force-mode-line-update))

(defun exit-insert-evil-fcitx ()
  "When exit insert with user-IME, set IME-state to user-IME-state"
  (if (equal (get-current-IME) "user-IME")
	  (progn
		(IME-state-setter "user-IME-state")
		(switch-to-default-IME)
		; print-msg
		(shell-command "echo \"IME state recorded\""))
	(IME-state-setter "default-IME-state")))

(add-hook 'evil-insert-state-exit-hook
		  'exit-insert-evil-fcitx)

(defun entry-insert-evil-fcitx ()
  "When entry insert with user-IME-state, switch back to user-IME"
  ; clear this tag in insert mode
  (progn 
	(setq IME-state-mode-line-tag "")
	(force-mode-line-update))
  (print "test point")
  (if (and (equal IME-state "user-IME-state"))
	  (progn
		(switch-to-user-IME)
		; print-msg
		(shell-command "echo \"IME state Restored\""))))

(add-hook 'evil-insert-state-entry-hook
		  'entry-insert-evil-fcitx)

(defun back-to-default-state()
  (interactive)
  (if (or (string-equal IME-state "user-IME-state")
		  (string-equal (get-current-IME) "user-IME"))
	  (progn
		(switch-to-default-IME)
		(IME-state-setter "default-IME-state")
		(evil-normal-state)
		(shell-command "echo \"IME-state cleanred\""))
	(shell-command "echo \"unchanged\"")))

(global-set-key (kbd back-to-default-state-key)
				'back-to-default-state)

(provide 'evil-fcitx)
