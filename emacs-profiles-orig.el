;;; Package --- Summary
;;; Commentary:
;;; Code:

(
 ;;stable ("default" . ((user-emacs-directory . "-PWD-/stable")))
 ("gnu"      . ((user-emacs-directory . "-PWD-/gnu")))
 ("test"      . ((user-emacs-directory . "-PWD-/test")))

 ;;doom ("doomdir" . ((user-emacs-directory . "-PWD-/doom")
 ;;doom            (env .https://github.com/overtone/emacs-live.git (("DOOMDIR" . "~/.doom.d")))))

 ;; spacemacs example with customization dir.
 ;;space (("spacemacs" . ((user-emacs-directory . "-PWD-/space")
 ;;space                  (env . (("SPACEMACSDIR" . "~/.spacemacs")))))


 ;; -INSERT-HERE-
 ;;doom ("doom"    . ((user-emacs-directory . "-PWD-/doom")))

 ;; Servers
 ;; Stable
 ;;stable ("exwm" . ((user-emacs-directory . "-PWD-/stable")
 ;;stable  	     (server-name . "exwm")))
 ;;stable ("mail" . ((user-emacs-directory . "-PWD-/stable")
 ;;stable 	     (server-name . "mail")))
 ;;stable ("common" . ((user-emacs-directory . "-PWD-/stable")
 ;;stable 	       (server-name . "common")))

 ;; Doom
 ;;doom ("doom-server" . ((user-emacs-directory . "-PWD-/doom")
 ;;doom                   (server-name . "doom")
 ;;doom                   (env . (("DOOMDIR" . "~/.doom.d")))))

 ;; Vanilla
 ("gnu-server" . ((user-emacs-directory . "-PWD-/gnu")
	          (server-name . "gnu")))

 )

(provide '.emacs-profiles.el)
;;; emacs-profiles-orig.el ends here
