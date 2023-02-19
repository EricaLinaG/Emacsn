;;; Package --- Summary
;;; Commentary:
;;; Code:

(
 ;;stable ("default" . ((user-emacs-directory . "-PWD-/stable")))
 ("gnu"      . ((user-emacs-directory . "-PWD-/gnu")))
 ("test"      . ((user-emacs-directory . "-PWD-/test")))

 ;;stable ("stable"  . ((user-emacs-directory . "-PWD-/stable")))
 ;;dev ("dev"     . ((user-emacs-directory . "-PWD-/dev")))

 ;; ("doom" . ((user-emacs-directory . "-PWD-/doom")
 ;;            (env .https://github.com/overtone/emacs-live.git (("DOOMDIR" . "~/.doom.d")))))

 ;;doom ("doom"    . ((user-emacs-directory . "-PWD-/doom")))

 ;; spacemacs example with customization dir.
 ;; (("spacemacs" . ((user-emacs-directory . "-PWD-/space")
 ;;                  (env . (("SPACEMACSDIR" . "~/.spacemacs")))))

 ;; Spacemacs
 ;;space ("space"   . ((user-emacs-directory . "-PWD-/space")))

 ;; Prelude
 ;;prelude ("prelude"   . ((user-emacs-directory . "-PWD-/prelude")))

 ;; Emacs live
 ;;live ("live"    . ((user-emacs-directory . "-PWD-/live")))

 ;; Emacs from Hell
 ;;hell ("hell"    . ((user-emacs-directory . "-PWD-/hell")))

 ;; Emacs from Scratch
 ;;from-scratch ("from-scratch"      . ((user-emacs-directory . "-PWD-/from-scratch")))

 ;; Uncle Daves
 ;;uncle-daves ("uncle-daves"      . ((user-emacs-directory . "-PWD-/uncle-daves")))

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
