## Prelude
optional-configs    += prelude
prelude-arch        =
prelude-status      = Works
prelude-repo        = $(git-hub)/bbatsov/prelude.git
prelude-repo-flags  =
prelude-update-pull = $(git-pull)
prelude-install-cmd = $(emacs-nw-profile) prelude $(eval-kill-emacs)
prelude-update-cmd  = $(generic-update-cmd)
prelude-message     = See Readme: make browse-prelude
## Prelude

# Emacs-Live
optional-configs  += live
live-status       = Works
live-repo         = $(git-hub)/overtone/emacs-live.git
live-repo-flags   =
live-update-pull  = $(git-pull)
live-install-cmd  = $(emacs-nw-profile) live $(eval-kill-emacs)
live-update-cmd   = $(generic-update-cmd)
live-message      = See Readme: make browse-live

# Emacs from Hell
# Im assuming its the same as Emacs from Scratch.
optional-configs      += from-hell
from-hell-status      = Works
from-hell-repo        = $(git-hub)/daviwil/emacs-from-hell.git
from-hell-repo-flags  =
from-hell-update-pull = $(git-pull)
from-hell-install-cmd = $(emacs-nw-profile) from-hell $(eval-kill-emacs)
from-hell-update-cmd  = $(no-update)
from-hell-message      = See Readme: make browse-from-hell

# Emacs from Scratch
# emacs from scratch has auto updating so we dont need to do that.
# we'll just pull the code and let it take care of its self.
optional-configs         += from-scratch
from-scratch-status      = Works
from-scratch-repo        = $(git-hub)/daviwil/emacs-from-scratch.git
from-scratch-repo-flags  =
from-scratch-update-pull = $(git-pull)
from-scratch-install-cmd = $(emacs-nw-profile) from-scratch $(eval-kill-emacs)
from-scratch-update-cmd  = $(no-update)
from-scratch-message      = See Readme: make browse-from-scratch

# Uncle Daves Emacs
# I think this might also be the same as Emacs from Scratch.
# I havent looked to see if it has auto update on.
optional-configs        += uncle-daves
uncle-daves-status      = Works
uncle-daves-repo        = $(git-hub)/daedreth/UncleDavesEmacs.git
uncle-daves-repo-flags  =
uncle-daves-update-pull = $(git-pull)
uncle-daves-install-cmd = $(emacs-nw-profile) uncle-daves $(eval-kill-emacs)
uncle-daves-update-cmd  = $(generic-update-cmd)
uncle-daves-message      = See Readme: make browse-uncle-daves

## purcell
optional-configs += purcell
purcell-status       = Works
purcell-repo         = https://github.com/purcell/emacs.d.git
purcell-repo-flags   =
purcell-install-cmd  = $(emacs-nw-profile) purcell $(eval-kill-emacs)
purcell-update-pull  = $(git-pull)
purcell-update-cmd   = $(generic-update-cmd)
purcell-message      = See Readme: make browse-purcell
## purcell

## centaur
optional-configs += centaur
centaur-status       = Works
centaur-repo         = https://github.com/seagle0128/.emacs.d.git
centaur-repo-flags   =
centaur-install-cmd  = $(emacs-nw-profile) centaur $(eval-kill-emacs)
centaur-update-pull  = $(git-pull)
centaur-update-cmd   = $(generic-update-cmd)
centaur-message      = See Readme: make browse-centaur
## centaur

## lolsmacs
optional-configs += lolsmacs
lolsmacs-status       = Works
lolsmacs-repo         = https://github.com/grettke/lolsmacs.git
lolsmacs-repo-flags   =
lolsmacs-install-cmd  = ln -s lolsmacs.el init.el; \
			echo \(lolsmacs-init\) >> init.el; \
			$(emacs-nw-profile) lolsmacs $(eval-kill-emacs)
lolsmacs-update-pull  = $(git-pull)
lolsmacs-update-cmd   = $(generic-update-cmd)
lolsmax-message       = See Readme: make browse-lolsmax
## lolsmacs

## scimax
optional-configs += scimax
scimax-status       = Works
scimax-repo         = https://github.com/jkitchin/scimax.git
scimax-repo-flags   =
scimax-install-cmd  = $(emacs-nw-profile) scimax $(eval-kill-emacs)
scimax-update-pull  = $(git-pull)
scimax-update-cmd   = $(generic-update-cmd)
scimax-message      = See Readme: make browse-scimax
## scimax

## caiohcs
optional-configs += caiohcs
caiohcs-status       = Works. Nice Org config. Nice features.
caiohcs-repo         = https://github.com/caiohcs/my-emacs
caiohcs-repo-flags   =
caiohcs-install-cmd  = $(emacs-nw-profile) caiohcs $(eval-kill-emacs)
caiohcs-update-pull  = $(git-pull)
caiohcs-update-cmd   = $(generic-update-cmd)
caiohcs-message      = Nice Org-based config. Use Emacs or See Readme: make browse-caiohcs
## caiohcs

# Ericas-Emacs
optional-configs   = ericas
ericas-status      = Works
ericas-repo        = $(git-hub)/ericalinag/ericas-emacs.git
ericas-repo-flags  =
ericas-update-pull = $(git-pull)
ericas-install-cmd = emacs --script install.el
ericas-update-cmd  = emacs --script update.el
ericas-message     = See Readme: make browse-ericas

# Doom
# doom has hybrid shell/elisp scripts to run.
# doom doesn't need or want a pull, it takes care of that.
optional-configs  += doom
doom-status       = Works
doom-repo         = $(git-hub)/hlissner/doom-emacs.git
doom-repo-flags   =
doom-update-pull  = $(no-pull)
doom-install-cmd  = bin/doom install
doom-update-cmd   = bin/doom upgrade
doom-message      = See Readme: make browse-doom

# Spacemacs
# We can construct a lisp function to do its update.
# probably its install too. I havent gone looking.
optional-configs  += spacemacs
spacemacs-status      = Works
spacemacs-repo        = $(git-hub)/syl20bnr/spacemacs.git
spacemacs-repo-flags  =
spacemacs-update-pull = $(git-hub)
spacemacs-install-cmd = $(emacs-nw-profile) spacemacs $(eval-kill-emacs)
spacemacs-update-el   = '((lambda ()\
			(configuration-layer/update-packages)\
			(save-buffers-kill-terminal t)))'

spacemacs-update-cmd  = emacs -nw --with-profile spacemacs \
			  --eval $(space-update-el)
spacemacs-message     = See Readme: make browse-spacemacs

# Spacemacs
## sachac
optional-configs += sachac
sachac-status       = Tested. Fails to load. Various problems. Requires hacking.
sachac-repo         = https://github.com/sachac/.emacs.d.git
sachac-repo-flags   =
sachac-install-cmd  = $(org-emacs-nw) \
			--eval '(with-temp-buffer         \
	  			(find-file "Sacha.org")   \
				$(org-tangle))	  \
				$(eval-kill-emacs)'            \
			ln -s Sacha.el init.el;           \
			$(emacs-nw-profile) sachac $(eval-kill-emacs)
sachac-update-pull  = $(git-pull)
sachac-update-cmd   = $(generic-update-cmd)
sachac-message      = See Readme: 'make browse-sachac' \
See also: 'make show-sachac' \
There are missing local dependencies and other things which will \
cause the install to fail along the way. It is a bit of hacking.
## sachac

## panadestein
## Basically this needs to be tangled by a different install with org +...
## we go untangle it to hopefully make an init.el. Then we run emacs again
## with the new profile so it can load its self up.
optional-configs += panadestein
panadestein-status       = Cannot tangle this to an el. No babel-execute for org!
panadestein-repo         = https://github.com/Panadestein/emacsd.git
panadestein-repo-flags   =
panadestein-install-cmd  = $(org-emacs-nw) \
				--eval '(with-temp-buffer                  \
	  				  (find-file "content/index.org")  \
					  $(org-tangle)                  \
					  $(kill-emacs))'                  \
			   $(emacs-nw-profile) panadestein $(eval-kill-emacs)

panadestein-update-pull  = $(git-pull)
panadestein-update-cmd   = $(generic-update-cmd)
panadestein-message      = This requires untangling which will fail on this first \
install step. Babel cannot tangle org. I have that installed. This does not install. \
## panadestein

optional-configs += rougier
rougier-status       = !! Almost. Org tangle fails. See: 'make browse-rougier'
rougier-repo         = https://github.com/rougier/dotemacs.git
rougier-repo-flags   =
rougier-install-cmd  = rm -f ~/.emacs.org ;      \
			ln -s $(PWD)/rougier ~/.emacs.org ;  \
			$(org-emacs-nw)                      \
			--eval '(with-temp-buffer            \
	  			  (find-file "dotemacs.org")   \
				  $(org-tangle)	    	     \
				  $(kill-emacs!));'              \
			$(emacs-nw-profile) rougier $(eval-kill-emacs)

rougier-update-pull  = $(git-pull)
rougier-update-cmd   = $(generic-update-cmd)
rougier-message  = See the readme:  'make browse-rougier' \
    The problems are documented. This gets us as far as it can.
## rougier

## for-writers
optional-configs += for-writers
for-writers-arch         = spacemacs
for-writers-status       = Almost works, testing -arch var.
for-writers-message      =
for-writers-repo         = https://github.com/frankjonen/emacs-for-writers.git
for-writers-repo-flags   =
for-writers-install-cmd  = $(no-install)
for-writers-update-pull  = $(git-pull)
for-writers-update-cmd   = $(spacemacs-update-cmd)
for-writers-message      = Seems like close to vanilla spacemacs. I dunno.
## for-writers

doom-load = --eval '(progn (doom/reload)(doom/reload))'
## hotel-california-for-writers
## this is a .doom.d repo it has its own doom in the doom folder.
optional-configs += hotel-california-for-writers
hotel-california-for-writers-arch         = doom
hotel-california-for-writers-status       = Works - May take some initial help.
hotel-california-for-writers-repo         = https://github.com/jacmoe/.doom.d.git
hotel-california-for-writers-repo-flags   =
hotel-california-for-writers-install-cmd  = doom/$(doomsync); \
                        $(emacs-nw-profile) \
                          hotel-california-for-writers \
                          $(doom-load)
hotel-california-for-writers-update-pull  = $(git-pull)
hotel-california-for-writers-update-cmd   = doom/bin/doom update

hotel-california-for-writers-message   = \
This seems to work reasonably.  I've installed it a lot of times. \
There are other things to install. See make browse-hotel-california-for-writers \
At a minimum Fonts: \
You will need Overpass and Carlito fonts, or to change them in config.el and \
then do another 'doom/reload'.

## ericas-evil-doom-for-writers
## this is a .doom.d repo it has its own doom in the doom folder.
optional-configs += ericas-evil-doom-for-writers
ericas-evil-doom-for-writers-arch         = doom
ericas-evil-doom-for-writers-status       = Works - May take some initial help.
ericas-evil-doom-for-writers-repo         = https://github.com/ericalinag/ericas-evil-doom-for-writers.git
ericas-evil-doom-for-writers-repo-flags   =
ericas-evil-doom-for-writers-install-cmd  = doom/$(doomsync); \
                                                $(emacs-nw-profile) \
                                                  ericas-evil-dom-for-writers \
                                                  $(doom-load)
ericas-evil-doom-for-writers-update-pull  = $(git-pull)
ericas-evil-doom-for-writers-update-cmd   = doom/bin/doom update

ericas-evil-doom-for-writers-message   = \
This is hotel-california-for-writers with evil, and then some.\
See make browse ericas-evil-doom-for-writers
## ericas-evil-doom-for-writers
