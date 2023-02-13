;;; Package --- Summary
;;; Commentary:
;;; Code:

(
 ;;stable ("default" . ((user-emacs-directory . "~/Emacsn/stable")))
 ("gnu"      . ((user-emacs-directory . "~/Emacsn/gnu")))
 ("test"      . ((user-emacs-directory . "~/Emacsn/test")))

 ;;stable ("stable"  . ((user-emacs-directory . "~/Emacsn/stable")))
 ;;dev ("dev"     . ((user-emacs-directory . "~/Emacsn/dev")))

 ;; ("doom" . ((user-emacs-directory . "~/Emacsn/doom")
 ;;            (env .https://github.com/overtone/emacs-live.git (("DOOMDIR" . "~/.doom.d")))))

 ;;doom ("doom"    . ((user-emacs-directory . "~/Emacsn/doom")))

 ;; spacemacs example with customization dir.
 ;; (("spacemacs" . ((user-emacs-directory . "~/Emacsn/space")
 ;;                  (env . (("SPACEMACSDIR" . "~/.spacemacs")))))

 ;; Spacemacs
 ;;space ("space"   . ((user-emacs-directory . "~/Emacsn/space")))

 ;; Prelude
 ;;prelude ("prelude"   . ((user-emacs-directory . "~/Emacsn/prelude")))

 ;; Emacs live
 ;;live ("live"    . ((user-emacs-directory . "~/Emacsn/live")))

 ;; Emacs from Hell
 ;;hell ("hell"    . ((user-emacs-directory . "~/Emacsn/hell")))

 ;; Emacs from Scratch
 ;;efs ("efs"      . ((user-emacs-directory . "~/Emacsn/efs")))

 ;; Uncle Daves
 ;;ude ("ude"      . ((user-emacs-directory . "~/Emacsn/ude")))

 ;; Servers
 ;; Stable
 ;;stable ("exwm" . ((user-emacs-directory . "~/Emacsn/stable")
 ;;stable  	     (server-name . "exwm")))
 ;;stable ("mail" . ((user-emacs-directory . "~/Emacsn/stable")
 ;;stable 	     (server-name . "mail")))
 ;;stable ("common" . ((user-emacs-directory . "~/Emacsn/stable")
 ;;stable 	       (server-name . "common")))

 ;; Doom
 ;;doom ("doom-server" . ((user-emacs-directory . "~/Emacsn/doom")
 ;;doom                   (server-name . "doom")
 ;;doom                   (env . (("DOOMDIR" . "~/.doom.d")))))

 ;; Vanilla
 ("gnu-server" . ((user-emacs-directory . "~/Emacsn/gnu")
	          (server-name . "gnu")))

 )

(provide '.emacs-profiles.el)
;;; emacs-profiles-orig.el ends here
