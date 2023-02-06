;;; Package --- Summary
;;; Commentary:
;;; Code:

(
 ;;stable ("default" . ((user-emacs-directory . "~/Emacs/stable")))
 ("gnu"      . ((user-emacs-directory . "~/Emacsn/gnu")))
 ("test"      . ((user-emacs-directory . "~/Emacsn/test")))

 ;;stable ("stable"  . ((user-emacs-directory . "~/Emacsn/stable")))
 ;;dev ("dev"     . ((user-emacs-directory . "~/Emacsn/dev")))

 ;; ("doom" . ((user-emacs-directory . "~/Emacsn/doom")
 ;;            (env . (("DOOMDIR" . "~/.doom.d")))))

 ;;doom ("doom"    . ((user-emacs-directory . "~/Emacsn/doom")))

 ;; (("spacemacs" . ((user-emacs-directory . "~/Emacsn/space")
 ;;                  (env . (("SPACEMACSDIR" . "~/.spacemacs")))))

 ;;space ("space"   . ((user-emacs-directory . "~/Emacsn/space")))
 ;;prelude ("prelude"   . ((user-emacs-directory . "~/Emacsn/prelude")))

 ;; Servers
 ;;stable ("exwm" . ((user-emacs-directory . "~/Emacsn/stable")
 ;;stable  	     (server-name . "exwm")))
 ;;stable ("mail" . ((user-emacs-directory . "~/Emacsn/stable")
 ;;stable 	     (server-name . "mail")))
 ;;stable ("common" . ((user-emacs-directory . "~/Emacsn/stable")
 ;;stable 	       (server-name . "common")))

 ;;doom ("doom-server" . ((user-emacs-directory . "~/Emacsn/doom")
 ;;doom                   (server-name . "doom")
 ;;doom                   (env . (("DOOMDIR" . "~/.doom.d")))))
 ("gnu-server" . ((user-emacs-directory . "~/Emacsn/gnu")
	          (server-name . "gnu")))

 )

(provide '.emacs-profiles.el)
;;; emacs-profiles-orig.el ends here
