# profiles.mk --- definitions for Emacs configurations to enable
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
# $(emacs-nw-profile) <profile-name> $(kill-emacs)
emacs-profile = emacs --with-profile
emacs-nw-profile = emacs -nw --with-profile
kill-emacs = --eval '(save-buffers-kill-terminal t)'

# A generic update script to run package update.
# for use with configurations which dont provide a
# an update other than list-packages U.
generic-update := $(emacs-home)/generic-update.el
generic-update-cmd := emacs -nw --script $(generic-update)

# These are necessary for those who with to not have a pull or
# an update on update. It allows this compounded shell command to work
#            cd foo;  ; emacs -nw --scripte $(generic-update)
# by putting true in the empty spot.
# no-update isnt necessary because its at the end. But you never know.
no-pull   := true
no-update := true


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
# # Gnu
# default-profiles += gnu
# gnu-repo         = your-repo-url
# gnu-repo-flags   =
# gnu-pull         = $(git-pull)
# gnu-install-cmd  = $(emacs-nw-profile) gnu $(kill-emacs)
# gnu-update-cmd   = $(generic-update-cmd)
# ------------------------------------------------------------------
#
##########################################################################
# Define your own, and redefine default to use yours as you like.
##########################################################################
# The Default Profile
# Change this to use a different configuration with (default|stable)|dev|test.
default-profile-name = ericas

# Dev, stable and test.
# shouldn't need to touch these.
default-profile     = $($(default-profile-name)-profile)
default-repo        = $($(default-profile-name)-repo)
default-repo-flags  = $($(default-profile-name)-repo-flags)
default-update-pull = $($(default-profile-name)-update-pull)
default-install-cmd = $($(default-profile-name)-install-cmd)
default-update-cmd  = $($(default-profile-name)-update-cmd)

# Dev
default-profiles := dev
dev-repo         = $(default-repo)
dev-update-pull  = $(default-update-pull)
dev-install-cmd  = $(default-install-cmd)
dev-update-cmd   = $(default-update-cmd)

# Stable
default-profiles   += stable
stable-repo        = $(default-repo)
stable-update-pull = $(default-update-pull)
stable-install-cmd = $(default-install-cmd)
stable-update-cmd  = $(default-update-cmd)

# Test
default-profiles += test
test-repo        = $(default-repo)
test-update-pull = $(default-update-pull)
test-install-cmd = $(default-install-cmd)
test-update-cmd  = $(default-update-cmd)

# > make print-default-profiles
# default-profiles := dev stable test

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

# First one: set optional-profiles
# Ericas-Emacs
optional-profiles  = ericas
ericas-repo        = $(git-hub)/ericalinag/ericas-emacs.git
ericas-repo-flags  =
ericas-update-pull = $(git-pull)
ericas-install-cmd = emacs --script install.el
ericas-update-cmd  = emacs --script update.el

# Spacemacs
# We can construct a lisp function to do its update.
# probably its install too. I havent gone looking.
optional-profiles += space
space-repo        = $(git-hub)/syl20bnr/spacemacs.git
space-repo-flags  =
space-update-pull = $(git-hub)
space-install-cmd = $(emacs-nw-profile) space $(kill-emacs)
space-update-el   = '((lambda ()\
			(configuration-layer/update-packages)\
			(save-buffers-kill-terminal t)))'

space-update-cmd  = emacs -nw --with-profile space \
			  --eval $(space-update-el)

# Doom
# doom has hybrid shell/elisp scripts to run.
# doom doesn't need or want a pull, it takes care of that.
optional-profiles += doom
doom-repo         = $(git-hub)/hlissner/doom-emacs.git
doom-repo-flags   =
doom-update-pull  = $(no-pull)
doom-install-cmd  = $(emacs-home)/doom/bin/doom install
doom-update-cmd   = $(emacs-home)/doom/bin/doom upgrade

# Prelude
# using a pull with the generic update seems to work.
optional-profiles   += prelude
prelude-repo        = $(git-hub)/bbatsov/prelude.git
prelude-repo-flags  =
prelude-update-pull = $(git-pull)
prelude-install-cmd = $(emacs-nw-profile) prelude $(kill-emacs)
prelude-update-cmd  = $(generic-update-cmd)

# Emacs-Live
# using a pull with the generic update seems to work.
optional-profiles += live
live-repo         = $(git-hub)/overtone/emacs-live.git
live-repo-flags   =
live-update-pull  = $(git-pull)
live-install-cmd  = $(emacs-nw-profile) live $(kill-emacs)
live-update-cmd   = $(generic-update-cmd)

# Emacs from Hell
# Im assuming its the same as Emacs from Scratch.
optional-profiles     += from-hell
from-hell-repo        = $(git-hub)/daviwil/emacs-from-hell.git
from-hell-repo-flags  =
from-hell-update-pull = $(git-pull)
from-hell-install-cmd = $(emacs-nw-profile) from-hell $(kill-emacs)
from-hell-update-cmd  = $(no-update)

# Emacs from Scratch
# emacs from scratch has auto updating so we dont need to do that.
# we'll just pull the code and let it take care of its self.
optional-profiles        += from-scratch
from-scratch-repo        = $(git-hub)/daviwil/emacs-from-scratch.git
from-scratch-repo-flags  =
from-scratch-update-pull = $(git-pull)
from-scratch-install-cmd = $(emacs-nw-profile) from-scratch $(kill-emacs)
from-scratch-update-cmd  = $(no-update)

# Uncle Daves Emacs
# I think this might also be the same as Emacs from Scratch.
# I havent looked to see if it has auto update on.
optional-profiles       += uncle-daves
uncle-daves-repo        = $(git-hub)/daedreth/UncleDavesEmacs.git
uncle-daves-repo-flags  =
uncle-daves-update-pull = $(git-pull)
uncle-daves-install-cmd = $(emacs-nw-profile) uncle-daves $(kill-emacs)
uncle-daves-update-cmd  = $(generic-update-cmd)

# make print-optional-profiles
# optional-profiles := ericas space doom prelude live from-hell from-scratch uncle-daves

# profiles.mk ends here
