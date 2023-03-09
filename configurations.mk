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

include base-configurations.mk


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

# Erics-Emacs
optional-configs  += erics
erics-status      = Not tested
erics-repo        = $(git-hub)/ericgebhart/emacs-setup.git
erics-repo-flags  =
erics-install-cmd  = $(emacs-nw-profile) scimax $(eval-kill-emacs)
erics-update-pull  = $(git-pull)
erics-update-cmd   = $(generic-update-cmd)
erics-message     = See Readme: make browse-erics
## Erics-Emacs
