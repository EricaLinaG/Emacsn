# configurations.mk --- definitions for Emacs configurations to install, remove.
#
# Commentary:
# Just a bunch of make variables with profile name prefixes.
# Basically where an Emacs repo is, how to re-pull it,
# how to invoke its package install the first time,
# how to update it, and the clone flags for when we want a branch.

# Code:

# Helpers.

# Shortcuts; How we know from where to install and how to update.
git-pull  := git pull origin
git-hub   := https://github.com
git-lab   := https://gitlab.com

# Construct an emacs install command.
# Leave emacs alive or it kill it when its done.
# $(emacs-nw-profile) <profile-name> $(eval-kill-emacs)
emacs-profile = emacs --with-profile
emacs-nw-profile = emacs -nw --with-profile
# ask first.
kill-emacs = (save-buffers-kill-terminal nil)
kill-emacs! = (save-buffers-kill-terminal t)
eval-kill-emacs = --eval '$(kill-emacs!)'
doomsync = bin/doom sync
org-tangle = (org-babel-execute-buffer)

# A generic update script to run package update.
# for use with configurations which dont provide a
# an update other than list-packages U.
generic-update := $(emacs-home)/generic-update.el
generic-update-cmd := emacs -nw --script $(generic-update)

# A shell no-op/noop so we dont need to worry when composing with
# things that dont want to do anything.
# Extra names for clarity in code.
# no-pull is necessary for those who wish to not have a pull or
# an update on update. It allows this compounded shell command to work
# with and without a command. For example with no-pull and git-pull.
#            cd foo;true; emacs -nw --script $(generic-update)
#            cd foo;git pull origin; emacs -nw --script $(generic-update)
no-pull    := true
no-update  := true
no-install := true
no-op      := true


#############################################################################
# Directions for adding another install.
#
# Make your own entry here and do what you want. You need an init.el
# in the root of your config. You probably do. Everyone does so far.
#
# Here is a template to use just copy it down to the bottom
# Change all the 'gnus' to your profile name.
# and fill in your repo url.
#
# The rest will satisfy your needs If;
#    You are happy with just running emacs once for the initial package
#	load on install.
#    You would like update to 'git pull origin', and then
#	do install-packages for all-selected-packages.
#
# copy-pasta
# ------------------------------------------------------------------
# # gnu
# optional-configs += gnu
# gnu-repo         = your-repo-url
# gnu-repo-flags   =
# gnu-install-cmd  = $(emacs-nw-profile) gnu $(eval-kill-emacs)
# gnu-update-pull  = $(git-pull)
# gnu-update-cmd   = $(generic-update-cmd)
# ------------------------------------------------------------------
#
##########################################################################
# Define your own, and redefine default to use yours as you like.
##########################################################################
# The Default Profile
# Change this to use a different configuration with (default|stable)|dev|test.
default-configuration-name = ericas
default-org-profile = stable
org-emacs-nw = $(emacs-nw-profile) $(default-org-profile)

# Dev, stable and test.
# Create a virtual default configuration for everyone.
default-profile     = $($(default-configuration-name)-profile)
default-repo        = $($(default-configuration-name)-repo)
default-repo-flags  = $($(default-configuration-name)-repo-flags)
default-update-pull = $($(default-configuration-name)-update-pull)
default-install-cmd = $($(default-configuration-name)-install-cmd)
default-update-cmd  = $($(default-configuration-name)-update-cmd)

# Dev
default-configs  := dev
dev-repo         = $(default-repo)
dev-update-pull  = $(default-update-pull)
dev-install-cmd  = $(default-install-cmd)
dev-update-cmd   = $(default-update-cmd)

# Stable
default-configs    += stable
stable-repo        = $(default-repo)
stable-update-pull = $(default-update-pull)
stable-install-cmd = $(default-install-cmd)
stable-update-cmd  = $(default-update-cmd)

# Test
default-configs  += test
test-repo        = $(default-repo)
test-update-pull = $(default-update-pull)
test-install-cmd = $(default-install-cmd)
test-update-cmd  = $(default-update-cmd)

# > make print-default-configs
# default-configs := dev stable test

#############################################################################
#####  Additional Emacs configuration definitions.
#############################################################################

#############################################################################
#####  This is where you would put your emacs repo in order to use your own.
#####
#####  <profile-name>-repo-flags can be set to a branch
#####                            or what you need to give to clone.
#####
#####  Everyone has a different way of managing packages. Doom really likes to
#####  take care of things for you.
#####
#####  Mostly the generic-update that is the
#####  generic-update.el provided seems to do the trick where there is no
#####  clear update mechanism other than 'git pull' and a 'list-packages U'.
#####
#####  - Both uncle-daves and Prelude seem to work this way. Follow their examples.
#####  - Ericas can work this way, but has two elisp scripts. It has a ready
#####       package list so it knows what its supposed to have.
#####  - Spacemacs update is an interesting example.
#####  - Emacs from Scratch and Hell, use use-package and keeps auto update on, so
#####       other than the pull there is really nothing to do. I believe Uncle Daves is
#####       this way also.
#####
#####  I would really emphasise that reading the doc for any emacs distro is
#####  a good idea to get started. I know mine,
#####  but I dont know these others well.
#############################################################################

# First one: set optional-configs
# Ericas-Emacs
optional-configs   = ericas
ericas-status      = Works
ericas-repo        = $(git-hub)/ericalinag/ericas-emacs.git
ericas-repo-flags  =
ericas-update-pull = $(git-pull)
ericas-install-cmd = emacs --script install.el
ericas-update-cmd  = emacs --script update.el
ericas-message     = See Readme: make browse-ericas

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

# Prelude
optional-configs    += prelude
prelude-status      = Works
prelude-repo        = $(git-hub)/bbatsov/prelude.git
prelude-repo-flags  =
prelude-update-pull = $(git-pull)
prelude-install-cmd = $(emacs-nw-profile) prelude $(eval-kill-emacs)
prelude-update-cmd  = $(generic-update-cmd)
prelude-message     = See Readme: make browse-prelude

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

## Sacha keeps an el but, seems best to tangle it anyway. So,
## we do. then we run again with the new init.el that we have
## to fake out with a link. Why no one makes init.el...
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

## org based configurations:
## added $(default-org-profile) and $(org-emacs-nw)
## so we can use a known good emacs with org
## completely configured so that untangling all the various things work.

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

## rougier : this wont work right off. needs untangling. And we have to fool it into
## rougier : to putting itself here rather than ~/.emacs.org.
## rougier : The install stops so you can see, how it fails.
## rougier : It is documented. See: 'make browse-rougier'.
## rougier : for org configs we run emacs twice on install, once to untangle,
## rougier : and again to initialize it. I left the kill off of the first invocation
## rougier : because thats where the problem lies. Once the untangling works.
## rougier : an update may not work, if the link has been broken, not sure.
## rougier
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
The problems are documented. \
This gets us as far as it can. The tangle has problems.\
This is an org config,\
so we run emacs once to tangle it using 'stable'. Then run it again so\
it will hopefully load all its packages. It may fail on either step,\
so intervention may be required. There are documented problems.\
		Go see the readme with 'make browse-rougier'.
## rougier

# make print-optional-configs
# optional-configs  := ericas spacemacs doom prelude live from-hell from-scratch uncle-daves

# configurations.mk ends here

## for-writers
## this is a .spacemacs.d repo
## to manage that in chemacs we need to know its doom.
## the -arch variable tells us its spacemacs. This gives us special behavior
## for configurations which are 'just' configurations for doom or spacemacs.
optional-configs += for-writers
for-writers-arch	 = spacemacs
for-writers-status       = Works.
for-writers-repo         = https://github.com/frankjonen/emacs-for-writers.git
for-writers-repo-flags   =
for-writers-install-cmd  = $(emacs-nw-profile) for-writers $(eval-kill-emacs)
# for-writers-install-cmd  = $(no-install)
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
This seems to work reasonably. There are frequently problems with loading \
everything the first time. This install will likely need some aide. \
For some reason, it requires this install cmd runs doom/reload twice. \
It starts loading packages and syncing up with this config the second \
time. That is When the Compilation buffer appears. \
To watch the progress in emacs 'SPC b i' for ibuffer, then choose the compilation buffer \
If/when it fails, restart the load with M-x doom/reload \
Fonts: \
You will need overpass and carlito fonts, or to change them in config.el and \
then do another 'doom/reload'. If you set your environment $DOOMDIR, to here, you can \
run the usual doom shell commands and get proper results. \
Theres no Evil here, so you may want to load that. \
## hotel-california-for-writers

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
