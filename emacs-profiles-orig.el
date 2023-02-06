;;; Package --- Summary
;;; Commentary:
;;; Code:

(
 ;;stable ("default" . ((user-emacs-directory . "~/Emacs/stable")))
 ("gnu"      . ((user-emacs-directory . "~/Emacs/gnu")))
 ("test"      . ((user-emacs-directory . "~/Emacs/test")))

 ;;stable ("stable"  . ((user-emacs-directory . "~/Emacs/stable")))
 ;;dev ("dev"     . ((user-emacs-directory . "~/Emacs/dev")))

 ;; ("doom" . ((user-emacs-directory . "~/Emacs/doom")
 ;;            (env . (("DOOMDIR" . "~/.doom.d")))))

 ;;doom ("doom"    . ((user-emacs-directory . "~/Emacs/doom")))

 ;; (("spacemacs" . ((user-emacs-directory . "~/Emacs/space")
 ;;                  (env . (("SPACEMACSDIR" . "~/.spacemacs")))))

 ;;space ("space"   . ((user-emacs-directory . "~/Emacs/space")))
 ;;prelude ("prelude"   . ((user-emacs-directory . "~/Emacs/prelude")))

 ;; Servers
 ;;stable ("exwm" . ((user-emacs-directory . "~/Emacs/stable")
 ;;stable  	     (server-name . "exwm")))
 ;;stable ("mail" . ((user-emacs-directory . "~/Emacs/stable")
 ;;stable 	     (server-name . "mail")))
 ;;stable ("common" . ((user-emacs-directory . "~/Emacs/stable")
 ;;stable 	       (server-name . "common")))

 ;;doom ("doom-server" . ((user-emacs-directory . "~/.doom-emacs")
 ;;doom                   (server-name . "doom")
 ;;doom                   (env . (("DOOMDIR" . "~/.doom.d")))))
 ("gnu-server" . ((user-emacs-directory . "~/Emacs/gnu")
	          (server-name . "gnu")))

 ;; emacs distribution: DOOM-emacs
 ;;doom ("doom-server2" . ((user-emacs-directory . "~/Emacs/doom")
 ;;doom	    (server-name . "doom")
 ;;doom	    (env . (("DOOMDIR" . "~/.doom.d")))))

 )

(provide '.emacs-profiles.el)
;;; emacs-profiles-orig.el ends here
