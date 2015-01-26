; evil-fcitx.el -- providing auto toggling on the top of fcitx-remote
; something about fcitx-remote program:
; `$ fcitx-remote' return 0 - no input focus
;                         1 - default IME(English)
;                         2 - user's IME
; `$ fcitx-remote -c' will set IME to 1 - default IME
; `$ fcitx-remote -o' will set IME to 2 - user's IME

;;;;;;;;;; User configs

; for me I don't use C-q quite often
(defvar force-back-to-default-state-key "C-q")
(unless (boundp 'qu)
  (defalias 'qu 'quote))

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
  (when (not (equal (get-current-IME) "default-IME"))
	(shell-command "fcitx-remote -c")
	(message "switch to default IME")))

(defun switch-to-user-IME ()
  (when (not (equal (get-current-IME) "user-IME"))
	(shell-command "fcitx-remote -o")
	(message "switch to user IME")))

(defun IME-state-setter (state)
  "Set IME-state and update mode-line tag"
  (setq IME-state state)
  (update-IME-mode-line-tag state))

(defun update-IME-mode-line-tag (IME-state)
  "set the IME-state-mode-line-tag right next to the evil-mode-line-tag"
  (when (listp mode-line-format)
	; set the mode-line-tag first
	(cond
	 ((equal IME-state "default-IME-state")
	  (setq IME-state-mode-line-tag default-IME-state-indicator))
	 ((equal IME-state "user-IME-state")
	  (setq IME-state-mode-line-tag user-IME-state-indicator))
	 (else
	  (print "error")))	
	; then remove the tag itself
	(setq mode-line-format
		  (delq 'IME-state-mode-line-tag mode-line-format))
	; just like the evil-refresh-mode-line
	(let ((mlpos mode-line-format) 
		  pred)
	  ; the position is right next to evil-mode-line-tag
	   ; don't quite understand this condition
	  (while (and mlpos
				  ; some elem in the mode-line-format could be a list
				  ; so the sym is defined like this
				  (let ((sym (or (car-safe (car mlpos))
								 (car mlpos))))
					(not (eq 'evil-mode-line-tag sym))))
		; pred are the stuffs include and after the current sym
		(setq pred mlpos
			  mlpos (cdr mlpos)))
	  (cond
	   ((not mlpos))
	   ((not nil)
		(setcdr mlpos (cons 'IME-state-mode-line-tag (cdr mlpos)))))
	  (force-mode-line-update)))) 

; init with defulat-IME-state
(update-IME-mode-line-tag "default-IME-state")

(defun exit-insert-evil-fcitx ()
  "When exit insert with user-IME, remember it"
  (if (equal (get-current-IME) "user-IME")
	  (progn
		(IME-state-setter "user-IME-state")
		(switch-to-default-IME)
		(message "IME state recorded"))
	(IME-state-setter "default-IME-state")))

(add-hook 'evil-insert-state-exit-hook
		  'exit-insert-evil-fcitx)

(defun entry-insert-evil-fcitx ()
  "When entry insert with user-IME-state, restore the user-IME"
  ; Do not show mode-line-tag in insert state
  ; Emacs cannot get IME info in real time, 
  ; so it may be confusing when in insert state
  (progn 
	(setq IME-state-mode-line-tag "[--]")
	(force-mode-line-update))
  (if (and (equal IME-state "user-IME-state"))
	  (progn
		(switch-to-user-IME)
		; print-msg
		(message "IME state Restored"))))

(add-hook 'evil-insert-state-entry-hook
		  'entry-insert-evil-fcitx)

(defun force-back-to-default-state()
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
		;(evil-normal-state)
		(message "IME-state cleanred"))))

(global-set-key (kbd force-back-to-default-state-key)
				'force-back-to-default-state)

; switch back to default-IME-state after input some non-ascii chars
; as argument of find-char(backward) search(backward) replace command
(defadvice evil-find-char (after change-to-user-IME-after-find-char
								  (&optional count char))
	  (switch-to-default-IME))
(ad-activate 'evil-find-char)

(defadvice evil-find-char-backward (after change-to-user-IME-after-rfind-char
										  (&optional count char))
  (switch-to-default-IME))
(ad-activate 'evil-find-char-backward)

(defadvice evil-search-forward (after change-to-user-IME-state-after-search
                                      ())
  (switch-to-default-IME))
(ad-activate 'evil-search-forward)

(defadvice evil-search-backward (after change-to-user-IME-state-after-rsearch
                                      ())
  (switch-to-default-IME))
(ad-activate 'evil-search-backward)

(defadvice evil-replace (after change-to-user-IME-state-after-find-char
							   (beg end &optional type char))
  (switch-to-default-IME))
(ad-activate 'evil-replace)

(provide 'evil-fcitx)
