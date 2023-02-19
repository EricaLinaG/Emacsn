# Makefile to install and maintain chemacs2 and a
# few emacs configurations.
#
# The default emacs install is mine.  Ericas-emacs.
# It can be easily changed to be yours or another.
#
# There will be a stable and dev install of the default,
# There is also a test install which defaults to vanilla gnu
# when not in use. It can be used to test a fresh install
# with 'make test-install'.
#
# There is also a vanilla gnu install, as well as
# doom, spacemacs, prelude, emacs-live, emacs-from-scratch,
# emacs-from-hell and uncle-daves-emacs as well as ericas if you
# want them.
#
# There are also daemon profiles for different installs.

# This Makefile prints lots of more readable stuff,
# no need to see every echo unless debugging.
.SILENT:

# Where Emacs installations and this Emacsn will live.
# ~/Emacsn ?
emacs-home := $(PWD)

# Where to put Emacsn helper script
emacsn-home := ~/bin

# We just make sure this exists.
config-custom := ~/.config/emacs-custom.el

# This repo actually.  Used to create emacs-home.
emacsn := ericalinag/Emacsn.git

# helper variables for moving .emacs and .emacs.d out of the way
# find out if we have a .emacs and .emacs.d to worry about.
move-dot-emacs := $(or $(and $(wildcard $(HOME)/.emacs),1),0)
move-dot-emacs.d := $(or $(and $(wildcard $(HOME)/.emacs.d),1),0)
# so we can have uniquely named backups. being lazy.
seconds-now := $(shell date +%s)

# a generic update script to run git pull and package update.
# for configurations which dont provide a an update other than list-packages U.
generic-update := $(emacs-home)/generic-update.el

#############################################################################
#####  Define the default repo for dev, stable and test.
#####  Define their install and update commands.
#####
#####  This is where you would put your emacs repo in order to use your own.
#####
#####  <profile-name>-repo-flags can be set to a branch
#####                            or what you need to give clone.
#####
#####  Everyone has a different way of managing packages. mostly the generic-update
#####  generic-update.el provided seems to do the trick where there is no
#####  clear update mechanism other than list packages.
#####
#####  Both uncle-daves and Prelude seem to work this way. Follow their examples.
#####  spacemacs update is an interesting example.
#############################################################################

# Change these if you want a different flavor of emacs as
# your default/stable/dev/test repo.
#
# Only Ericas, Doom and spacemacs provide a command line way of installing
# or updating the packages and code base. The rest use list-packages.
# Which also works with Ericas. Ericas keeps its packages in a list, and
# uses list-packages so probably the generic rule would also work there.
#
# default profiles source repos
default-emacs-repo := ericalinag/ericas-emacs.git
# default-repo-flags := -b somebranch
dev-repo := $(default-emacs-repo)
stable-repo := $(default-emacs-repo)
test-repo := $(default-emacs-repo)

# We can use the plain vanilla emacs to load our packages.
# ericas-emacs has install.el and update.el which can be run like this
# we just need to add the final install folder name.
# We just have to be where we want them, --chdir works.
default-install-cmd-pre := emacs --script install.el --chdir $(emacs-home)
default-update-cmd-pre  := emacs --script update.el --chdir $(emacs-home)

# An easier rule for those installs that dont have an api for this.
# dev-install-cmd := emacs --with-profile dev
# dev-update-cmd := emacs --with-profile dev

# Install and update commands for each of the default target profiles.
# These could just be the above, emacs will usually try to install and update
# when it is started the first time. It might just take a while.
dev-install-cmd := $(default-install-cmd-pre)/dev
dev-update-cmd := $(default-update-cmd-pre)/dev

test-install-cmd := $(default-install-cmd-pre)/test
test-update-cmd := $(default-update-cmd-pre)/test

stable-install-cmd := $(default-install-cmd-pre)/stable
stable-update-cmd := $(default-update-cmd-pre)/stable

#############################################################################
#####  Additional Emacs configuration definitions.
#####  define a <profile-name>-repo, -install-cmd, and -update-cmd
#####  add the profile name to the profiles variable below.
#####
#####  Except for Doom and Ericas theres really not much point to the
#####  the install and update commmands.
#####  Emacs will install packages when you start it the first time.
#####
#####  Doom has commands - they say to use them.
#####
#####  Ericas has a function, which works well, but so does list-packages.
#####  Its nice to not wait the first time it fires up and also to
#####  have a single update for code and packages.
#############################################################################

# Make it easy to keep ericas-emacs if the default changes.
# It has simple install and update scripts that can be called with vanilla emacs.
ericas-repo := ericalinag/ericas-emacs.git
#  ericas-repo-flags := -b with-helm
ericas-install-cmd := emacs --script install.el --chdir $(emacs-home)/ericas
ericas-update-cmd := emacs --script update.el --chdir $(emacs-home)/ericas

space-repo := syl20bnr/spacemacs.git
space-install-cmd := emacs --with-profile space
# spacemacs has a function to do its updates so we use that.
# we do a git pull
# then call the update function, and then exit.
#
# this is very similar to generic-update.el
# this almost works. the git pull happens in the wrong place
# the extra parens are necessary.
space-update-el := '((lambda ()\
			(shell-command "git pull origin HEAD")\
			(configuration-layer/update-packages)\
			(save-buffers-kill-terminal t)))'

space-update-cmd := emacs -nw --with-profile space \
		--eval $(space-update-el) --chdir $(emacs-home)/space

# doom has hybrid shell/elisp scripts to run.
doom-repo := hlissner/doom-emacs.git
doom-install-cmd := $(emacs-home)/doom/bin/doom install
doom-update-cmd := $(emacs-home)/doom/bin/doom update

# there is a generic-update rule, so we dont need those vars for
# the following profile installations. or maybe there are other
# choices for each that I dont know.
#
# just the profile to the list of generic profile targets under
# update-generic-profiles. This just uses list-packages as its updater.
# The name should be of the form <profile name>~update.
#
# The generic rule essentially runs default emacs, --with-profile doesnt
# work with the --script or --batch options.
# changes directorys to the target profile,
# git pull origin HEAD,
# list packages,
# install selected packages.
# exit

# this is used in the generic update rule below.
generic-update-cmd := emacs -nw --script $(generic-update)     \
				--chdir $(emacs-home)/

# using the generic update seems to work.
prelude-repo := bbatsov/prelude.git
prelude-install-cmd := emacs --with-profile prelude

# using the generic update seems to work.
live-repo := overtone/emacs-live.git
live-install-cmd := emacs --with-profile live

# I'm assuming this works the same as emacs from scratch.
# so use the generic update function
hell-repo := daviwil/emacs-from-hell.git
hell-install-cmd := emacs --with-profile hell

# emacs from scratch has auto updating so we dont need to do that.
# our generic update still works, it pulls a new version and then
# runs a package update, which there aren't any.
from-scratch-repo := daviwil/emacs-from-scratch.git
from-scratch-install-cmd := emacs --with-profile from-scratch

# generic update yay.
uncle-daves-repo := daedreth/UncleDavesEmacs.git
uncle-daves-install-cmd := emacs --with-profile uncle-daves


#############################################################################
# Profiles that can be installed, and updated.
#    We dont actually install gnu because there isnt anything to do.
#    it is the same with test initially, - its a placeholder for when
#    testing recently pushed changes.
#    Make targets will exist for <profile> and <profile>-update
#
#    If new configurations are added, they should also be added to
#    emacs-profiles-orig.el so they can be automatically uncommented.
#############################################################################
# make it nicer to print the targets in a meaningful way.
optional-profiles := doom space prelude ericas live from-scratch hell uncle-daves
default-profiles := gnu stable dev test
profiles := $(default-profiles) $(optional-profiles)

# for the configs that have independent update commands
update-profiles := stable-update dev-update test-update doom-update\
		ericas-update space-update

# If the configuration can use the generic update .el just put it in here
# watch the '~'.  Theres no need for profile-update-cmd for these.
# tricky. Use tilde to say where to start deleting to create the path
update-generic-profiles := uncle-daves~update from-scratch~update \
			hell~update prelude~update

############################################################
#  Target Rules
############################################################
# test if target replaces inside a variable name. It does.
testit-repo := someplace-far-far-away
testit:
	printf "$($@-repo)"

# handy diagnostic rule.
# make print-VARIABLE ie. make print-profiles, make print-emacs-home
print-%  : ; @echo $* = $($*)

# Profile targets,
# Clone them to their target directory.
# Add/uncomment them into ~/.emacs-profiles.el.
# Run them how they like to install themselves.
#
# profile entries in emacs-profiles-orig.el start with ;;<profile>
# ie. ;;stable
# so that we can easily enable them when a profile is installed.
# It starts earlier when install-chemacs installs emacs-profiles-orig.el
# to ~/. Each time we come through here we get it from ~/, uncomment the target
# entries and put it back. We leave a copy here just in case.
#
$(profiles):
	printf "\n\n-----------------------------------------------------\n"
	printf "Adding profile for $@ to ~/.emacs-profiles.el\n"
	sed 's/;;$@//' ~/.emacs-profiles.el > .emacs-profiles.el
	cp .emacs-profiles.el ~/
	printf "\nCloning repo for $@\n\n"
	git clone $($@-repo-flags) https://github.com/$($@-repo) $(emacs-home)/$@
	printf "\n\n-------------------------------------------\n"
	printf "Running install for: $@\n"
	printf "Not exiting automatically to check errors\n\n"
	printf "Exit Emacs with C-x C-c as needed when done\n"
	printf "\-------------------------------------------\n"
	$($@-install-cmd)
	printf "\n\nInstall finished for: $@\n"
	printf "\---------------------------------------------\n"


# We just run the command we were given. doom, ericas, spacemacs.
$(update-profiles):
	printf "\n\nRunning update for profile: $@\n\n"
	$($@-cmd)

# generic rule, for generic update method. works for some.
# the double $$ is for keeping it from being interpreted and
# one of them makes to the shell for execution. the g is necessary.
# for make to be happy.
$(update-generic-profiles):
	$(eval target-path=$(shell echo $@ | sed 's/~.*$$//g' ))
	$(shell $(generic-update-cmd)/$(target-path))

foo-bar:
	$(eval target-path=$(shell echo $@ | sed 's/\-.*$$//g' ))
	printf "was: $@ is:  $(target-path)"


# is there a better way? I hope so.
# link mbsyncrc and hope mu4e is installed properly already.
.PHONY: mu4e
mu4e: mbsync
	printf "On Arch linux, mu4e should be loaded from site packages automatically"
	printf "if mu has been installed. sudo pacman -S mu\n"
#       the hacky way I used to do it.
#	cp -r ~/.cache/yay/mu-git/src/mu/mu4e $(HOME)/elisp/extensions/

.PHONY: mbsync
mbsync:
	print "linking mbysyncrc to ~/.mbsyncrc\n\n"
	ln -s $(PWD)/mbsyncrc $(HOME)/.mbsyncrc

clean-links:
	rm $(HOME)/.mbsyncrc

retrieve-profiles.el:
	printf "\n\nRetrieving .emacs-profiles.el from ~/.\n\n"
	cp ~/.emacs-profiles.el .

.emacs-profiles.el:
	printf "\n\nCreating a fresh .emacs-profiles.el from original template.\n"
	printf "Setting Paths to here $(PWD).\n\n"
	sed 's:\-PWD\-:$(PWD):' emacs-profiles-orig.el > .emacs-profiles.el

# copy .emacs-profiles.el to ~/
.PHONY: chemacs-profiles
chemacs-profiles: .emacs-profiles.el
	printf "\n\nCopying .emacs-profiles.el to ~/.\n\n"
	cat .emacs-profiles.el
	printf "\n\n\n"
	cp .emacs-profiles.el ~/

install-emacsn:
	printf "\n\nCopying emacsn to $(emacsn-home)\n"
	cp emacsn $(emacsn-home)

touch-custom:
	touch $(config-custom)

# check emacsn out into emacs-home unless we are already there.
# this is out of date. Its not this complicated anymore.
mk-emacs-home: touch-custom
ifneq ($(PWD), $(emacs-home))
	printf "\n\nCreating Emacs Home: $(emacs-home)\n"
	git clone https://github.com/$(emacsn) $(emacs-home)
else
	printf "\n\nWe are in Emacs Home: $(emacs-home)\n"
	printf "\n\nNOT creating emacs home since we are there.\n"
endif

# These move .emacs and .emacs.d to .bak.<epoch seconds>
.PHONY: mv.emacs
mv.emacs:
ifneq ($(move-dot-emacs), 0)
	ls -l ~/.emacs
	printf "\n\nMoving ~/.emacs to .bak.xxxx\n"
	mv ~/.emacs ~/.emacs.bak.$(seconds-now)
endif

.PHONY: mv.emacs.d
mv.emacs.d:
ifneq ($(move-dot-emacs.d), 0)
	ls -l ~/.emacs.d
	printf "\n\nMoving ~/emacs.d to .bak.xxxxx\n"
	mv ~/.emacs.d ~/.emacs.d.bak.$(seconds-now)
endif

# move with preserve dot emacs.
.PHONY: backup-dot-emacs
backup-dot-emacs:  mv.emacs.d mv.emacs

# scorch dot emacs.
remove-dot-emacs:
	printf "\n\nRemoving ~/.emacs and ~/.emacs.d\n\n"
	rm -rf ~/.emacs.d
	rm -f ~/.emacs

# Chemacs goes in emacs.d, make initial chemacs profiles.
install-chemacs: .emacs-profiles.el
	cp .emacs-profiles.el ~/
	printf "\n\nCloning chemacs into ~/.emacs.d\n\n"
	git clone https://github.com/plexus/chemacs2.git ~/.emacs.d

# Add a gnu profile. Nothing to do really. Point at an empty emacs.d.
add-gnu:
	mkdir -p $(emacs-home)/gnu
	mkdir -p $(emacs-home)/test

all: mu4e install-all

# not sure about mu4e installation at this point. I think it just works now.
# I need to test that.

# prepare for install
#  move ~/.emacs, ~/.emacs.d, clone emacsn -> emacs home.
prepare-install: backup-dot-emacs mk-emacs-home

# prepare and install emacsn, chemacs, chemacs profiles, stable and dev
# This includes gnu and test profiles which are vanilla gnu emacs
install: prepare-install install-emacsn add-gnu install-chemacs stable dev

# prepare and install everything we have.
# the install plus: doom, spacemacs, and prelude.
install-all: install doom space prelude ericas

# make targets for managing the testing a fresh install.
# Nuke it so we can clone a new one.
remove-test:
	printf "\n\nRemoving the test install\n"
	rm -f $(emacs-home)/test

# clean it out so we can still use it as vanilla
clean-test:
	printf "\n\nCleaning out the test install\n"
	rm -f $(emacs-home)/test/*

# Remove the current test, and test a fresh install from github.
test-install: remove-test test
	emacs --with-profile test --debug-init
