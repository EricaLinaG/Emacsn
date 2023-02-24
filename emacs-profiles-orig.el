;;; Package --- Summary
;;; Commentary:
;;; Code:

(("default" . ((user-emacs-directory . "-PWD-/stable")))
 ("gnu"      . ((user-emacs-directory . "-PWD-/gnu")))
 ("gnu-server" . ((user-emacs-directory . "-PWD-/gnu")
	          (server-name . "gnu")))
 ("test"      . ((user-emacs-directory . "-PWD-/test")))
 ("test-server" . ((user-emacs-directory . "-PWD-/test")
	          (server-name . "test")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; -INSERT-HERE-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; Persistent profiles from here down.

 ;; Stable
 ;;stable ("exwm" . ((user-emacs-directory . "-PWD-/stable")
 ;;stable  	     (server-name . "exwm")))
 ;;stable ("mail" . ((user-emacs-directory . "-PWD-/stable")
 ;;stable 	     (server-name . "mail")))
 ;;stable ("common" . ((user-emacs-directory . "-PWD-/stable")
 ;;stable 	       (server-name . "common")))

 ;; Doom
 ;;doom ("doomdir-server" . ((user-emacs-directory . "-PWD-/doom")
 ;;doom                      (server-name . "doom")
 ;;doom                      (env . (("DOOMDIR" . "~/.doom.d")))))

 ;;doom ("doomdir" . ((user-emacs-directory . "-PWD-/doom")
 ;;doom            (env . (("DOOMDIR" . "~/.doom.d")))))

 ;; spacemacs example with customization dir.
 ;;space (("spacemacs" . ((user-emacs-directory . "-PWD-/space")
 ;;space                  (env . (("SPACEMACSDIR" . "~/.spacemacs")))))

 )

(provide '.emacs-profiles.el)
;;; emacs-profiles-orig.el ends here
