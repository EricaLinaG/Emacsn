# Makefile to install and maintain chemacs2 and a
# few emacs configurations.
#
# The default emacs install is mine.  Ericas-emacs.
# It can be easily changed to be yours.
#
# There will be a stable and dev install of the default,
# There is also a test install which defaults to vanilla gnu
# when not in use. It can be used to test a fresh install
# with 'make test-install'.
#
# There is also a vanilla gnu install, as well as
# doom, spacemacs, prelude and ericas if you want them.
#
# There are also daemon profiles for exwm, mail, common,
# and doom servers.

# This Makefile prints lots of more readable stuff,
# no need to see every echo.
.SILENT:

# Where Emacs installations and this Emacsn will live.
emacs-home := ~/Emacsn

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


#############################################################################
#####  Define the default repo for dev, stable and test.
#####  Define their install and update commands.
#####
#####  This is where you would put your emacs repo in order to use your own.
#####  It is likely you have no easy way to do a package update or install other
#####  than using list-packages.
#####
#####  Both Spacemacs and Prelude work this way. Follow their examples.
#####  OR adapt the insert.el and update.el from Ericas-Emacs to your own.
#############################################################################

# emacs installation repos
default-emacs-repo := ericalinag/ericas-emacs.git
dev-repo := $(default-emacs-repo)
stable-repo := $(default-emacs-repo)
test-repo := $(default-emacs-repo)

# We can use the plain vanilla emacs to load our packages.
# ericas-emacs has install.el and update.el which can be run like this
# we just need to add the final install folder name.
# We just have to be where we want them, --chdir works.
default-install-cmd-pre := emacs --script install.el --chdir $(emacs-home)
default-update-cmd-pre  := emacs --script update.el --chdir $(emacs-home)

# install and update commands for each of the default target profiles.
dev-install-cmd := $(default-install-cmd-pre)/dev
dev-update-cmd := $(default-update-cmd-pre)/dev

test-install-cmd := $(default-install-cmd-pre)/test
test-update-cmd := $(default-update-cmd-pre)/test

stable-install-cmd := $(default-install-cmd-pre)/stable
stable-update-cmd := $(default-update-cmd-pre)/stable

#############################################################################
#####  emacs configuration definitions.
#####  define a <profile-name>-repo, -install-cmd, and -update-cmd
#####  add the profile name to the profiles variable above.
#############################################################################

# Make it easy to keep ericas-emacs if the default changes.
# It has simple install and update scripts that can be called with vanilla emacs.
ericas-repo := ericalinag/ericas-emacs.git
ericas-install-cmd := emacs --script install.el --chdir $(emacs-home)/ericas
ericas-update-cmd := emacs --script update.el --chdir $(emacs-home)/ericas

# spacemacs doesn't provide a way to install or update besides (list-packages)
# so we just run it.
space-repo := syl20bnr/spacemacs.git
space-install-cmd := emacs --with-profile space
space-update-cmd := emacs --with-profile space

# prelude doesn't provide a way to install or update besides (list-packages)
# so we just run it.
prelude-repo := bbatsov/prelude.git
prelude-install-cmd := emacs --with-profile prelude
prelude-update-cmd := emacs --with-profile prelude

# doom has hybrid shell/elisp scripts to run.
doom-repo := hlissner/doom-emacs.git
doom-install-cmd := $(emacs-home)/doom/bin/doom install
doom-update-cmd := $(emacs-home)/doom/bin/doom update

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
profiles := gnu stable dev test doom space prelude ericas

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
	cp .emacs-profiles ~/
	printf "\nCloning repo for $@\n\n"
	git clone https://github.com/$($@-repo) $(emacs-home)/$@
	printf "\n\n-------------------------------------------\n"
	printf "Running install for: $@\n"
	printf "Exit Emacs with C-x C-c as needed when done\n"
	printf "-------------------------------------------\n\n"
	$($@-install-cmd)
	printf "\n\nInstall finished for: $@\n"
	printf "-----------------------------------------------------\n\n"


update-profiles := stable-update dev-update test-update doom-update
$(update-profiles):
	printf "\n\nRunning update for profile: $@\n\n"
	$($@-update-cmd)

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

# copy .emacs-profiles.el to ~/
.PHONY: chemacs-profiles
chemacs-profiles:
	printf "\n\nCopying .emacs-profiles.el to ~/.\n\n"
	cat .emacs-profiles.el
	printf "\n\n\n"
	cp .emacs-profiles.el ~/

install-emacsn:
	mkdir -p $(emacsn-home)
	cp emacsn $(emacsn-home)

touch-custom:
	touch $(config-custom)

# check emacsn out into emacs-home unless we are already there.
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
install-chemacs:
	cp emacs-profiles-orig.el .emacs-profiles.el
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
