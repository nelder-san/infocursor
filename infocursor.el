
;;; infocursor.el --- change cursor color and shape with mode dependence.
;;; Code:


(defvar infocursor-mode)

;; (about) Cursor switchers
;;;###autoload
(defcustom infocursor-overwrite-flag t
  "Activate overwrite cursor shape"
  :type 'boolean :group 'cursor)

;;;###autoload
(defcustom infocursor-read-only-flag t
  "Activate read-only sursor shape"
  :type 'boolean :group 'cursor)

;;;###autoload
(defcustom infocursor-input-method-flag t
  "Activate input-method cursor color"
  :type 'boolean :group 'cursor)

;; (about) Cursor shape and color values
;;;###autoload
(defcustom infocursor-color-default (or (cdr (assq 'cursor-color default-frame-alist))
					"brown2")
  "Default cursor color"
  :type 'color :group 'cursor)

;;;###autoload
(defcustom infocursor-color-input-method "goldenrod2"
  "Input method cursor color"
  :type 'color :group 'cursor)

;;;###autoload
(defcustom infocursor-shape-default 'box
  "Default cursor shape"
  :type 'symbol :group 'cursor)

;;;###autoload
(defcustom infocursor-shape-read-only 'hollow
  "Read-only cursor shape"
  :type 'symbol :group 'cursor)

;;;###autoload
(defcustom infocursor-shape-overwrite 'hbar
  "Overwrite-mode cursor shape"
  :type 'symbol :group 'cursor)


;; (about) Commands
;;;###autoload
(defun infocursor-set-shape (cursor-type)
  "Set cursor shape in current frame. Interactive."
  (interactive
   (list (intern (completing-read "Cursor type: "
                                  (mapcar 'list '("box" "hollow" "bar" "hbar" nil))))))
  (modify-frame-parameters (selected-frame) (list (cons 'cursor-type cursor-type))))


;; (about) Functions
(defun infocursor-shape ()
  "Set cursor shape for read-only/overwrite mode activated"
  (infocursor-set-shape (if  (and buffer-read-only overwrite-mode)
			    infocursor-shape-read-only
			  (if buffer-read-only
			      infocursor-shape-read-only
			    (if overwrite-mode
				infocursor-shape-overwrite
			      infocursor-shape-default))))
  )


(defun infocursor-color ()
  "Switch color if input-method activated"
  (set-cursor-color (if current-input-method
                        infocursor-color-input-method
                      infocursor-color-default))
  )


(defun infocursor-activate ()
  (if (or infocursor-overwrite-flag
	  infocursor-read-only-flag)
      (add-hook 'post-command-hook 'infocursor-shape)
    (remove-hook 'post-command-hook 'infocursor-shape) )
  (if infocursor-input-method-flag
      (add-hook 'post-command-hook 'infocursor-color)
    (remove-hook 'post-command-hook 'infocursor-color))
  )


(defun infocursor-set-default ()
  (infocursor-set-shape infocursor-shape-default)
  (set-cursor-color infocursor-color-default)
  (remove-hook 'post-command-hook 'infocursor-shape)
  (remove-hook 'post-command-hook 'infocursor-color)
  )


;; (about) infocursor minor-mode
(define-minor-mode infocursor-mode
  "infocursor minor mode"
  :global t
  :lighter nil
  (if infocursor-mode
      (infocursor-activate)
    (infocursor-set-default)) )


(provide 'infocursor)
;;; infocursor.el ends here


