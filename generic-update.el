;;; generic-update --- Update selected packages.

;;; Commentary:
;;; Give a script to run to update all the packages as needed.
;;; This will only work if run from the directory it is in.

;;; The purpose is to be able to do an update from the command line.
;;; This will 'git pull origin main' to update the code base and then
;;; try to update the installed packages.
;;;
;;; We change the user-emacs-directory to here so that Emacs will install
;;; its packages here.

;;; This is for emacs configurations which rely solely on list-packages for
;;; package installation and updates.

;;; Presumably those systems will install new packages automatically if
;;; the code base changes and introduces any.

;;; Code:

;;; Because when we get here, emacs is still pointing at ~/.emacs.d and we
;;; need it to point here. I'm not yet sure why it doesn't point here.
;;; chemacs must not set it when we use --script which means we can
;;; just run this with vanilla emacs and fool it to point here so
;;; our packages get installed.

;; (shell-command "git pull origin master")
(shell-command "git pull origin HEAD")

;; Trick emacs to be here, instead of .emacs.d
;; Requires being here or using emacs --chdir <here> to work.
(setq user-emacs-directory default-directory)
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(require 'package)

(when (not package-archive-contents)
  (package-refresh-contents))

(list-packages t)
(package-install-selected-packages)

(provide 'generic-update)
;;; generic-update.el ends here
