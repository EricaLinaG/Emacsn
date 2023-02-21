# Makefile --- To install Chemacs2 and some Emacs configurations to go with it.
# Commentary:
#############################################################################
# Makefile to install and maintain chemacs2 and a
# few emacs configurations.
#
# The default emacs install is mine.  Ericas-emacs.
# It can be easily changed to be yours or another.
#
# There will be a stable dev and test installs of the default,
# Test is to be used to test a fresh install
# with 'make test-install'.
#
# There is also a vanilla gnu 'install', as well as
# doom, spacemacs, prelude, emacs-live, emacs-from-scratch,
# emacs-from-hell and uncle-daves-emacs as well as ericas if you
# want them.
#
# There are also daemon profiles for different installs.
#############################################################################

# Code:

# This Makefile prints lots of more readable stuff,
# no need to see every echo unless debugging.
.SILENT:

# Here, where this Emacsn and its installations will live.
emacs-home := $(PWD)

# Where to put Emacsn helper script
emacsn-home := ~/bin

# We just make sure this exists in a harmless way.
config-custom := ~/.config/emacs-custom.el

# helper variables for moving .emacs and .emacs.d out of the way
# find out if we have a .emacs and .emacs.d to worry about.
move-dot-emacs := $(or $(and $(wildcard $(HOME)/.emacs),1),0)
move-dot-emacs.d := $(or $(and $(wildcard $(HOME)/.emacs.d),1),0)
# so we can have uniquely named backups. being lazy.
seconds-now := $(shell date +%s)

# We get our brains from here:

include profiles.mk

#############################################################################
# Set up our profile lists from whatever we got.
#############################################################################
profiles := $(default-profiles) $(optional-profiles)
update-profiles := $(shell echo $(profiles) | sed 's/[a-zA-Z\-]*/&-update /g')
remove-profiles := $(shell echo $(profiles) | sed 's/[a-zA-Z\-]*/&-remove /g')
remove-optional-profiles := $(shell echo $(optonal-profiles) \
				| sed 's/[a-zA-Z\-]*/&-remove /g')
insert-profiles := $(shell echo $(profiles) | sed 's/[a-zA-Z\-]*/&-insert /g')

test-sed:
	echo $(profiles)
	echo '$(profiles)' | sed 's/[a-zA-Z\-]*/&-update /g'

# > make print-update-profiles
# update-profiles := ericas-update space-update doom-update prelude-update
#      live-update from-hell-update from-scratch-update uncle-daves-update


############################################################
#  Target Rules
############################################################
# Very handy rule to print any make variable.
# make print-VARIABLE
# ie. make print-profiles, make print-default-repo
print-%  : ; @echo $* = $($*)

# Profile targets,
# Clone them to their target directory.
# Add/uncomment them into ~/.emacs-profiles.el.
# Run them how they like to install themselves.
#
# Profile entries in emacs-profiles-orig.el start with ;;<profile>
# ie. ;;stable ("stable" . (....))
# so that we can easily enable them when a profile is installed.
# It starts earlier when install-chemacs installs emacs-profiles-orig.el
# to ~/emacs-profiles.el.
# Each time we come through here we get it from ~/, add/uncomment the target
# entries and put it back. We leave a copy here for convenience.
#

$(profiles):
	printf "\n\n-----------------------------------------------------\n"

	printf "Adding profile for $@ to ~/.emacs-profiles.el\n"
	$(call insert-profile,$@)

	printf "\nCloning repo for $@\n\n"
	git clone $($@-repo-flags) $($@-repo) $(emacs-home)/$@

	printf "\n\n-------------------------------------------\n"
	printf "Running install for: $@\n"
	printf "Not exiting automatically to check errors\n\n"
	printf "Exit Emacs with C-x C-c as needed when done\n"
	printf "\-------------------------------------------\n"

	cd $@; $($@-install-cmd)

	printf "\n\nInstall finished for: $@\n"
	printf "\---------------------------------------------\n"

# Do the work. A make function for side effects.
# Find -insert-here- and put an entry in.
# Uncomment any lines beginning with ;;<profile>
insert-profile = \
	$(shell sed '/-INSERT-HERE-/a \
		\\(\"$(1)\" . \
		\(\(user-emacs-directory \. \"$(emacs-home)/$(1)\"\)\)\)' \
		~/.emacs-profiles.el > .emacs-profiles.el)                \
	$(shell sed 's/;;$(1)//' .emacs-profiles.el > ~/.emacs-profiles.el)

# Insert the profile into the .emacs-profiles. Just a test really.
$(insert-profiles):
	$(eval profile=$(shell echo $@ | sed 's/\-insert$$//g' ))
	printf "Adding profile for $(profile) to ~/.emacs-profiles.el\n"
	$(call insert-profile,$(profile))


# We just run the commands we were given for the profile.
# cd to the installation's direcory,
# maybe do a git pull,
# then maybe some emacs command to run an update of packages.
$(update-profiles):
	$(eval profile-name=$(shell echo $@ | sed 's/\-update$$//g' ))
	printf "\n\nRunning update for profile: $(profile-name)\n\n"
	cd $(profile-name); ($@-pull); $($@-cmd)

$(remove-profiles):
	$(eval profile-name=$(shell echo $@ | sed 's/\-remove$$//g' ))
	printf "\n\nRemoving profile: $(profile-name)\n\n"
	rm -rf $(profile-name)

rm-all-optional: $(remove-optional-profiles)
rm-all-profiles: $(remove-profiles)

# how to set a variable during rule eval.
test-var-set:
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

# a file dependency might be nice, but really we just want a new one.
.PHONY: emacs-profiles.el
emacs-profiles.el:
	printf "\n\nCreating a fresh .emacs-profiles.el from original template.\n"
	printf "Setting Paths to here $(PWD).\n\n"
	sed 's:\-PWD\-:$(PWD):' emacs-profiles-orig.el > .emacs-profiles.el
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

# Move with preserve dot emacs.
.PHONY: backup-dot-emacs
backup-dot-emacs:  mv.emacs.d mv.emacs

# Scorch dot emacs.
remove-dot-emacs:
	printf "\n\nRemoving ~/.emacs and ~/.emacs.d\n\n"
	rm -rf ~/.emacs.d
	rm -f ~/.emacs

# Chemacs goes in emacs.d, make initial chemacs profiles.
install-chemacs: emacs-profiles.el
	printf "\n\nCloning chemacs into ~/.emacs.d\n\n"
	git clone https://github.com/plexus/chemacs2.git ~/.emacs.d

# Add a gnu profile. Nothing to do really. Point at an empty emacs.d.
add-gnu:
	mkdir -p $(emacs-home)/gnu
	mkdir -p $(emacs-home)/test

all: mu4e install-all

# Not sure about mu4e installation at this point. I think it just works now.
# I need to test that.

# Prepare for install
#  move ~/.emacs, ~/.emacs.d, clone emacsn -> emacs home.
prepare-install: backup-dot-emacs mk-emacs-home

# prepare and install emacsn, chemacs, chemacs profiles, stable and dev
# This includes gnu and test profiles which are vanilla gnu emacs
install: clean prepare-install install-emacsn add-gnu install-chemacs stable dev

# Prepare and install everything we have. I wouldn't advise.
# The install plus: doom, spacemacs, and prelude.
all: install optional-profiles

# Make targets for managing the testing a fresh install.
# Nuke it so we can clone a new one.
remove-test:
	printf "\n\nRemoving the test install\n"
	rm -f $(emacs-home)/test

# Clean it out so we can still use it as vanilla
clean-test:
	printf "\n\nCleaning out the test install\n"
	rm -f $(emacs-home)/test/*

# Remove the current test, and test a fresh install from github.
test-install: remove-test test
	emacs --with-profile test --debug-init

clean:
	rm -f .emacs-profiles.el
