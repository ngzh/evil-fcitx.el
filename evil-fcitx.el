; evil-fcitx.el -- providing auto toggling on the top of fcitx-remote
; something about fcitx-remote program:
; `$ fcitx-remote' return 0 - no input focus
;                         1 - default IME(English)
;                         2 - user's IME
; `$ fcitx-remote -c' will set IME to 1 - default IME
; `$ fcitx-remote -o' will set IME to 2 - user's IME

;;;;;;;;;; User configs

; for me I don't use C-q quite often
(defvar back-to-default-state-key "C-q")
(defalias 'qu 'quote)

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
  (concat (get-current-IME) "-state"))

(defun switch-to-default-IME ()
  (shell-command "fcitx-remote -c"))

(defun switch-to-user-IME ()
  (shell-command "fcitx-remote -o"))

(defun IME-state-setter (state)
  "Set IME-state and update mode-line indicator"
  (setq IME-state state)
  (cond
   ((equal state "default-IME-state")
	(setq IME-state-mode-line-tag default-IME-state-indicator))
   ((equal state "user-IME-state")
	(setq IME-state-mode-line-tag user-IME-state-indicator))
   (else
	(print "error")))
  (force-mode-line-update))

(defun exit-insert-evil-fcitx ()
  "When exit insert with user-IME, set IME-state to user-IME-state"
  (if (equal (get-current-IME) "user-IME")
	  (progn
		(IME-state-setter "user-IME-state")
		(switch-to-default-IME)
		(message "IME state recorded"))
	(IME-state-setter "default-IME-state")))

(add-hook 'evil-insert-state-exit-hook
		  'exit-insert-evil-fcitx)

(defun entry-insert-evil-fcitx ()
  "When entry insert with user-IME-state, switch back to user-IME"
  ; Do not show indicator in insert state
  ; Emacs cannot get IME-info in real time, 
  ; so it may be confusing when in insert state
  (progn 
	(setq IME-state-mode-line-tag "")
	(force-mode-line-update))
  (if (and (equal IME-state "user-IME-state"))
	  (progn
		(switch-to-user-IME)
		; print-msg
		(message "IME state Restored"))))

(add-hook 'evil-insert-state-entry-hook
		  'entry-insert-evil-fcitx)

(defun back-to-default-state()
  "Clear the IME-state and switch back to normal state"
  (interactive)
  ; This is quite ugly now, I may consider another way later
  ; clear IME-state when 1. When in User-IME-state
  ;                      2. When IME is User-IME
  (if (or (equal IME-state "user-IME-state")
		  (equal (get-current-IME) "user-IME"))
	  (progn
		(switch-to-default-IME)
		(IME-state-setter "default-IME-state")
		(evil-normal-state)
		(message "IME-state cleanred"))))

(global-set-key (kbd back-to-default-state-key)
				'back-to-default-state)

(provide 'evil-fcitx)
