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
# There are also daemon rprofiles for different installs.
#############################################################################

# Code:

# This Makefile prints lots of more readable stuff,
# no need to see every echo unless debugging.
.SILENT:

# Where to get ourselves from.
emacsn-repo := https://github.com/ericalinag/Emacsn

# Where to put Emacsn helper script
emacsn-home := ~/bin

###########################################################################
### Less to change from here down.  Help text is at the bottom.
### Profile entries are in profiles.mk
### Templates are all something-template.txt
###########################################################################

# Here, where this Emacsn and its installations will live.
emacs-home := $(PWD)

# Here we keep dated versions of .emacs-profiles, .emacs.d, ~/.emacs
dot-backups := $(PWD)/dot-backups

# The last backup is the current one. We want the second one.
find-last-backup := ls -t $(dot-backups) | head -2 | tail -1

# We just make sure this exists in a harmless way.
config-custom := ~/.config/emacs-custom.el

# helper variables
# find out if we have a .emacs and .emacs.d to worry about.
move-dot-emacs := $(or $(and $(wildcard $(HOME)/.emacs),1),0)
move-dot-emacs.d := $(or $(and $(wildcard $(HOME)/.emacs.d),1),0)

#has-profiles := $(or $(and $(wildcard $(HOME)/.emacs-profiles.el),1),0)
# we only really want to save it if its not a link.
has-profiles := $(shell find ~ -maxdepth 1 -name .emacs-profiles.el -type f )

# so we can have uniquely named backups.
# %F.%s = yyyy-mm-dd.epoch-seconds.
seconds-now := $(shell date +%F.%s)

# We get our profile brains from here:

include profiles.mk

#############################################################################
# Set up our profile lists from whatever we got.
#############################################################################
profiles := $(default-profiles) $(optional-profiles)
update-profiles := $(shell echo $(profiles) | sed 's/[a-zA-Z\-]*/&-update /g')
remove-profiles := $(shell echo $(profiles) | sed 's/[a-zA-Z\-]*/&-remove /g')
remove-default-profiles := $(shell echo $(default-profiles) | sed 's/[a-zA-Z\-]*/&-remove /g')
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

show-%  : ; @echo $* profile:
	grep '^$*' profiles.mk

# Add a new empty install profile
new-empty-profile-%  :
	printf "Creating Empty, vanilla gnu, profile installation: $*\n"
	mkdir -p $*
	printf "Inserting profile entry.\n"
	$(call insert-profile,$*)

# Create a new profile from name and repo. passed on cli.
# make new-profile name=foobar repo=https://github.com/ericalinag/ericas-emacs.git
new-profile :
	printf "Creating new profile definition in profiles.mk\n"
	printf "Using generic install and update rules.\n"
	printf "Edit profiles.mk if you want something else.\n"
	printf "Profile Name: $(name)\n"
	printf "Repository: $(repo)\n"
	sed 's/gnu/$(name)/g' profile-template.txt | \
		sed 's{your-repo-url{$(repo){' >> profiles.mk
	echo " " >> profiles.mk

# change the name of the default-profile-name in profiles.mk
assign-default:
	printf "Assigning $(name) to default in profiles.mk\n"
	sed 's/\(default-profile-name[ ]*\=\).*/\1 $(name)/g' profiles.mk > profiles.tmp
	mv profiles.tmp profiles.mk

# another way.
assign-default-% :
	printf "Assigning $* to default in profiles.mk\n"
	sed 's/\(default-profile-name[ ]*\=\).*/\1 $*/g' profiles.mk > profiles.tmp
	mv profiles.tmp profiles.mk

# Add a new profile and install it.
# make install-new name=<your profile name> repo=<your repo url>
install-new:  new-profile
	$(MAKE) $(name)

# Add a new profile and reinstall the default profiles with it.
# make install-new-default name=<your profile name> repo=<your repo url>
install-new-default:  new-profile assign-default
	make reinstall-default-profiles name=$(name) repo=$(repo)

$(profiles):
	printf "\-----------------------------------------------------\n"

	printf "Adding profile for $@ to .emacs-profiles.el\n"
	$(call insert-profile,$@)

	printf "Cloning $($@-repo) into $(emacs-home)/$@\n"
	git clone $($@-repo-flags) $($@-repo) $(emacs-home)/$@

	printf "\-------------------------------------------\n"
	printf "Running install for: $@\n"
	printf "\-------------------------------------------\n"

	cd $@; $($@-install-cmd)

	printf "Install finished for: $@\n"
	printf "\---------------------------------------------\n"

 # Emacs home is a path. Sed doesnt like it when its contents
 # have delimiters in them, use :.
 # sed 's:\-PWD\-:$(emacs-home):' \

make-server-entry = $(shell sed 's/\-NAME\-/$(1)/g' server-entry-template.txt | \
			sed 's:\-PWD\-:$(emacs-home):g')

make-boot-entry = $(shell sed 's/\-NAME\-/$(1)/g' boot-entry-template.txt | \
			sed 's:\-PWD\-:$(emacs-home):g')

# tester.
mk-server-entry-% :
	echo $*  Making entry
	echo 	'$(call make-server-entry,$*)'

# # Find -insert-here- and put an entry in.
# # Uncomment any lines beginning with ;;<profile>
insert-profile = \
	$(shell sed '/-INSERT-HERE-/a $(call make-server-entry,$(1))'       \
		.emacs-profiles.el > .tmp-profiles.el)                  \
	$(shell sed 's/;;$(1)//' .tmp-profiles.el > .emacs-profiles.el) \
	$(call backup-profile)

# the old way. oy.
# insert-profile = \
# 	$(shell sed '/-INSERT-HERE-/a \
# 		\\(\"$(1)\" . \
# 		\(\(user-emacs-directory \. \"$(emacs-home)/$(1)\"\)\)\)' \
# 		~/.emacs-profiles.el > .emacs-profiles.el)                \
# 	$(shell sed 's/;;$(1)//' .emacs-profiles.el > ~/.emacs-profiles.el)
#	$(call backup-profile)


# Insert the profile into the .emacs-profiles. Just a test really.
$(insert-profiles):
	$(eval profile=$(shell echo $@ | sed 's/\-insert$$//g' ))
	printf "Adding profile for $(profile) to .emacs-profiles.el\n"
	$(call insert-profile,$(profile))


# We just run the commands we were given for the profile.
# cd to the installation's direcory,
# maybe do a git pull,
# then maybe some emacs command to run an update of packages.
$(update-profiles):
	$(eval profile-name=$(shell echo $@ | sed 's/\-update$$//g' ))
	printf "Running update for profile: $(profile-name)\n"
	cd $(profile-name); ($@-pull); $($@-cmd)

$(remove-profiles):
	$(eval profile-name=$(shell echo $@ | sed 's/\-remove$$//g' ))
	printf "Removing profile: $(profile-name)\n"
	rm -rf $(profile-name)

rm-all-optional: $(remove-optional-profiles)
rm-all-profiles: $(remove-profiles)
rm-default-profiles: $(remove-default-profiles)
install-default-profiles: add-test stable dev
reinstall-default-profiles: rm-default-profiles install-default-profiles

# how to set a variable during rule eval.
test-var-set:
	$(eval target-path=$(shell echo $@ | sed 's/\-.*$$//g' ))
	printf "was: $@ is:  $(target-path)"


# Relink the profiles to ~/.emacs-profiles.el
relink-profiles:
	$(call link-profiles)

# copy the last saved profile to ~/ uses -t, not sort on extension.

restore-last-profiles:
	$(eval last-backup=$(shell $(find-last-backup) ))
	printf Restoring last-backup)
	cp $(last-backup) .emacs-profiles.el

backup-profile = \
	echo Backing up .emacs-profiles.el to $(dot-backups), $(seconds-now) \
	cp .emacs-profiles.el $(dot-backups)/.emacs-.profiles.el.$(seconds-now)

link-profiles = \
	printf "Linking .emacs-profiles.el to $(HOME)/.emacs-profiles.el.\n" \
	rm -f $(HOME)/.emacs-profiles.el 			             \
	ln -s $(HOME)/.emacs-profiles.el .emacs-profiles.el

.PHONY: emacs-profiles.el
# Create a fresh set of profiles and link them to Home.
emacs-profiles.el:
	printf "\n\nCreating a fresh .emacs-profiles.el from original template.\n"
	printf "Setting Paths to here $(PWD).\n\n"
	sed 's:\-PWD\-:$(PWD):' emacs-profiles-orig.el > .emacs-profiles.el
	$(call link-profiles)
	$(call backup-profile)

# mv .emacs-profiles.el $(Dot-backups)/.emacs-.profiles.el.$(seconds-now)

install-emacsn:
	printf "\n\nCopying emacsn to $(emacsn-home)\n"
	cp emacsn $(emacsn-home)

touch-custom:
	touch $(config-custom)

backup-profiles:
	printf "\nBacking up .emacs-profiles.el to \
	$(dot-backups)/.emacs-profiles.el.$(seconds-now)\n"
	$(call backup-profile)

# check emacsn out into emacs-home unless we are already there.
# this is out of date. Its not this complicated anymore.
mk-emacs-home:
ifneq ($(PWD), $(emacs-home))
	printf "\n\nCreating Emacs Home: $(emacs-home)\n"
	git clone https://github.com/$(emacsn) $(emacs-home)
else
	printf "\n\nWe are in Emacs Home: $(emacs-home)\n"
endif

# These move .emacs-profiles.el
.PHONY: mv.emacs-profiles.el
mv.emacs-profiles.el:
ifneq ($(has-profiles), 0)
	printf "\n\nMoving ~/.emacs-profiles.el to $(dot-backups).emacs-profiles-orig.el.$(seconds-now)\n"
	mv ~/.emacs-profiles.el $(dot-backups)/.emacs-profiles-orig.el.$(seconds-now)
endif

# These move .emacs and .emacs.d to .bak.<epoch seconds>
.PHONY: mv.emacs
mv.emacs:
ifneq ($(move-dot-emacs), 0)
	ls -l ~/.emacs
	printf "\n\nMoving ~/.emacs to .bak.xxxx\n"
	printf "\n\nMoving ~/.emacs to $(dot-backups).emacs.bak.$(seconds-now)\n"
	mv ~/.emacs ~/.emacs.bak.$(seconds-now)
endif

.PHONY: mv.emacs.d
mv.emacs.d:
ifneq ($(move-dot-emacs.d), 0)
	ls -l ~/.emacs.d
	printf "\n\nMoving ~/.emacs.d to $(dot-backups)/.emacs.d.bak.$(seconds-now)\n"
	mv ~/.emacs.d ~/.emacs.d.bak.$(seconds-now)
endif

# BAckup all the dot emacs.
.PHONY: backup-dot-emacs
backup-dot-emacs:  mv.emacs.d mv.emacs mv.emacs-profiles.el

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
add-test:
	mkdir -p $(emacs-home)/test

add-gnu: add-test
	mkdir -p $(emacs-home)/gnu

all: install-all

dot-backups:
	mkdir -p dot-backups

# The minimum, if Emacsn has been installed once.
init: dot-backups emacs-profiles.el add-gnu

# Prepare for install
#  move ~/.emacs, ~/.emacs.d, clone emacsn -> emacs home.
prepare-install: touch-custom backup-dot-emacs init

# prepare and install emacsn, chemacs, chemacs profiles, stable and dev
install-base: clean prepare-install install-emacsn add-gnu install-chemacs

install: install-base stable dev

# Prepare and install everything we have. I wouldn't advise.
# The install plus: doom, spacemacs, and prelude.
all: install optional-profiles

# Clean it out so we can still use it as vanilla
clean-test:
	printf "\n\nCleaning out the test install\n"
	rm -f $(emacs-home)/test/*

# Remove the current test, do a fresh install from github.
# Run it with debug-init.
test-install: test-remove test
	emacs --with-profile test --debug-init

# clone emacsn into path.
# make new-emacsn path=/my/new/place/to/put/emacsn.
new-emacsn: backup-profiles
	printf "\n Creating new emacsn at: $(path)"
	git clone $(emacsn-repo) $(path)

show-profiles:
	printf "\n   The current ~/.emacs-profiles:\n"
	printf "========================================\n"
	cat .emacs-profiles.el

show-installs:
	printf "\n   Installations:\n"
	printf "========================================\n"
	ls -dfF * | grep '/$$' | sed 's:/$$::'

show-default:
	printf "\n   The default installation:\n"
	printf "   Installed in stable, dev and test.\n"
	printf "========================================\n"
	grep '^default-profile-name' profiles.mk

show-optional:
	printf "\n   All Optional installations:\n"
	printf "========================================\n"
	printf "$(optional-profiles)"

show-available:
	printf "\n   UnInstalled, Available installations:\n"
	printf "========================================\n"
	comm -23 <(echo $(profiles) | cut -d= -f2 | sed 's/ /\n/g' | sort) \
	<(ls -dfF * | grep '/$$' | sed 's:/$$::' | sort)

status-header:
	printf "=======================================\n"
	printf "   Emacsn: Current Status\n"

status-end:
	printf "========================================\n"

status: status-header show-default show-installs show-available status-end

help:
	printf "==================================================================\n"
	printf "    Useful make targets.\n"
	printf "\n  Information\n"
	printf "==================================================================\n"
	printf " status         -  The status of the Emacsn, what is installed,\n"
	printf "                   what is available.\n"
	printf " show-profiles  -  Basically a 'cat' of .emacs-profiles.el\n"
	printf "    In Emacs:  M-x describe-variable chemacs-profiles \n"

	printf " print-<variable> -  Print any make <variable>\n\n"
	printf "          'make print-profiles'\n\n"
	printf " show-<name>    -  Show the profile definition for <name>.\n\n"
	printf "          'make show-uncle-daves'\n\n"

	printf " backup-profiles - Make a time stamped backup of .emacs-profiles.el.\n"
	printf " backup-dot-emacs -  Backup emacs.d, .emacs and .emacs-profiles.el\n"
	printf "\n  Removing installations\n"
	printf "==================================================================\n"
	printf " <profile>-remove   - Remove the installation <profile>\n"
	printf " rm-all-optional    - Remove installs from the optional list.\n"
	printf " rm-all-profiles    - Scorched earth.\n"

	printf "\n  Managing the test installation.\n"
	printf "==================================================================\n"
	printf " test-install - remove it, install it, run it with debug-init.\n"
	printf " clean-test   - remove it, then add-test.\n"
	printf " add-test     - Just do a 'mkdir -p test'.\n"

	printf "\n  Profile name targets.\n"
	printf "==================================================================\n"
	printf " name         - install a configuration\n"
	printf " name-update  - update an install\n"
	printf " name-remove  - remove an install\n"
	printf " name-insert  - insert profile entry into .emacs-profiles.el\n"

	printf "\n  Managing the default profiles as a group, stable, dev and test\n"
	printf "==================================================================\n"
	printf " rm-default-profiles        - remove them\n"
	printf " install-default-profiles   - install them\n"
	printf " reinstall-default-profiles - remove and reinstall them.\n"

	printf "\n  Secondary Emacsn location ?\n"
	printf "==================================================================\n"
	printf " new-emacsn - Just make a fresh install of Emacsn somewhere.\n"

	printf "\n make new-emacsn path=/my/new/place/to/put/emacsn\n\n"

	printf " init - All that is needed to initialize a second Emacsn.\n"
	printf "        This creates and relinks .emacs-profiles.el.\n"
	printf " relink-profiles - Relink .emacs-profiles.el to here.\n"

	printf "\n  Profile Management\n"
	printf "==================================================================\n"
	printf " new-profile          -  Create a new default profile from name and repo.\/"

	printf "\n make new-profile name=foo repo=https://github.com/ericalinag/ericas-emacs.git\n"
	printf " assign-default       - Assign a name to the default profile.\n"
	printf "\n make assign-default name=foo\n\n"

	printf " install-new          - Create a new profile, and install it \n"

	printf "\n make install-new name=foo repo=https://github.com/ericalinag/ericas-emacs.git\n\n"

	printf " install-new-default  - Create a new profile, set it as default, \n"
	printf " 		      reinstall the default profiles.\n"

	printf "\n make install-new-default name=foo repo=https://github.com/ericalinag/ericas-emacs.git\n\n"

	printf " new-empty-profile-<name>  - Create an empty install and profile entry\n"
	printf "                       for <name>.\n\n"
	printf "          make new-empty-profile-foo\n\n"

	printf " backup-profiles - Copy .emacs-profiles to $(dot-backups)\n"
	printf "		   with a timestamp.\n"
	printf " restore-last-profiles - Copy the last backup of .emacs-profiles.el to ~/\n"
	printf "==================================================================\n"
