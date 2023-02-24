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

# Where to get ourselves from.
emacsn-repo := https://github.com/ericalinag/Emacsn

# Where to put Emacsn helper script
emacsn-home := ~/bin

###########################################################################
### Less to change from here down.
### Emacs configuration entries are in configurations.mk
### Templates are all something-template.txt
###########################################################################

# Here, where this Emacsn and its installations will live.
emacs-home := $(PWD)

# Here we keep dated versions of .emacs-profiles.el, .emacs.d, ~/.emacs
dot-backups := $(PWD)/dot-backups

# Our timestamp.
# so we can have uniquely and commonly named backups.
# %F.%s = yyyy-mm-dd.epoch-seconds.
# Used for an extension everytime we backup.
seconds-now := $(shell date +%F.%s)

# The last backup is the current one. We want the second one.
# uses -t, not sort on extension.
find-last-backup := ls -t $(dot-backups) | head -2 | tail -1
# Sorted with sort. so by title date.
find-last-backup := ls -a $(dot-backups) | sort -r | head -2 | tail -1

# We just make sure this exists in a harmless way.
config-custom := ~/.config/emacs-custom.el

# helper variables
# find out if we have a .emacs and .emacs.d to worry about.
move-dot-emacs := $(or $(and $(wildcard $(HOME)/.emacs),1),0)
move-dot-emacs.d := $(or $(and $(wildcard $(HOME)/.emacs.d),1),0)

# as-profiles := $(or $(and $(wildcard $(HOME)/.emacs-profiles.el),1),0)
# we only really want to save it if its not a link.
has-profiles := $(shell find ~ -maxdepth 1 -name .emacs-profiles.el -type f )

# Find out if we have installs and display the right stuff.
have-installs = $(shell ls -dfF * | grep '/$$' | grep -v dot-backups | wc -l)
installs-message = "There are $(have-installs) Emacs configurations installed"
please-init = "There are no Emacs configurations\n\
Please 'make install' or 'make init'\n\
if you already have Chemacs."

ifeq ($(have-installs),0)
installs-message := $(please-init)
endif

installs := 'There are no configurations installed.'
ifneq ($(have-installs),0)
installs := $(shell ls -dfF * | grep '/$$' | sed 's:/$$::' | grep -v dot-backups)
endif

# We get our profile brains from here:

include configurations.mk

#############################################################################
# Set up our profile lists from whatever we got.
#############################################################################
configs := $(default-configs) $(optional-configs)
update-configs := $(shell echo $(configs) | sed 's/[a-zA-Z\-]*/&-update /g')
remove-configs := $(shell echo $(configs) | sed 's/[a-zA-Z\-]*/&-remove /g')
remove-default-installs := $(shell echo $(default-configs) | sed 's/[a-zA-Z\-]*/&-remove /g')
remove-optional-installs := $(shell echo $(optional-configs) \
				| sed 's/[a-zA-Z\-]*/&-remove /g')
insert-configs := $(shell echo $(configs) | sed 's/[a-zA-Z\-]*/&-insert /g')

test-sed:
	echo $(configs)
	echo '$(configs)' | sed 's/[a-zA-Z\-]*/&-update /g'

# > make print-update-configs
# update-configs := ericas-update space-update doom-update prelude-update
#      live-update from-hell-update from-scratch-update uncle-daves-update


############################################################
#  Target Rules
############################################################
# Very handy rule to print any make variable.
# make print-VARIABLE
# ie. make print-configs, make print-default-repo
print-%  : ; @echo $* = $($*)

show-%  : ; @echo $* configuration:
	grep '^$*' configurations.mk

# Create a new empty install and boot entry for name.
new-empty-install-%  :
	printf "Creating Empty, vanilla gnu, profile installation: $*\n"
	mkdir -p $*
	printf "Inserting profile entry.\n"
	$(call insert-boot,$*,$*)

# Create a new profile from name and repo. passed on cli.
# make new-config name=foobar repo=https://github.com/ericalinag/ericas-emacs.git
new-config :
	printf "Creating new installation profile definition in configurations.mk\n"
	printf "Using generic install and update rules.\n"
	printf "Edit configurations.mk if you want something else.\n"
	printf "Profile Name: $(name)\n"
	printf "Repository: $(repo)\n"
	sed 's/gnu/$(name)/g' config-template.txt | \
		sed 's{your-repo-url{$(repo){' >> configurations.mk
	echo " " >> configurations.mk

# change the name of the default-configuration-name in configurations.mk
assign-default:
	printf "Assigning $(name) to default in configurations.mk\n"
	sed 's/\(default-configuration-name[ ]*\=\).*/\1 $(name)/g' configurations.mk > configurations.tmp
	mv configurations.tmp configurations.mk

# Another way to assign-default-foo.
assign-default-% :
	printf "Assigning $* to default in configurations.mk\n"
	sed 's/\(default-configuration-name[ ]*\=\).*/\1 $*/g' configurations.mk > configurations.tmp
	mv configurations.tmp configurations.mk

# Add a new profile and install it.
# make install-new name=<your profile name> repo=<your repo url>
install-new:  new-config
	$(MAKE) $(name)

# Assign a new default configuration profile name, reinstall the defaults.
# replace-default name=doom
replace-default:  assign-default
	make reinstall-defaults

# Add a new configuration and reinstall the default profiles with it.
# make install-new-default name=<your profile name> repo=<your repo url>
install-new-default: new-config assign-default
	make reinstall-defaults


$(configs):
	printf "\-----------------------------------------------------\n"

	printf "Adding profile for $@ and $@-server to .emacs-profiles.el\n"
	$(call insert-boot,$@,$@)
	$(call insert-server-boot,$@,$@)

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

# Function to generate a chemacs-profile server entry from a name and an
# installation profile name.
# Server name will be the Install name. - see server-entry-template.txt
make-server-entry = $(shell sed 's/\-NAME\-/$(1)/g' server-entry-template.txt | \
			sed 's/\-INSTALLNAME\-/$(2)/g'   | \
			sed 's:\-PWD\-:$(emacs-home):g')

# Function to generate a chemacs-profile entry from a name and an
# installation profile name. Usually they are the same.
make-boot-entry = $(shell sed 's/\-NAME\-/$(1)/g' boot-entry-template.txt | \
			sed 's/\-INSTALLNAME\-/$(2)/g'   | \
			sed 's:\-PWD\-:$(emacs-home):g')

# # tester.
# # mk-server-entry-foo
# mk-server-entry-% :
# 	echo $*  Making server entry
# 	echo 	'$(call make-server-entry,$*,$*)'

# mk-server-entry-foo profile=stable
mk-server-entry-% :
	echo $*  Making entry
	echo 	'$(call make-server-entry,$*,$(profile))'

# make insert-server-profile name=foo profile=gnu
insert-profile:
	$(call insert-boot,$(name),$(profile))

# make insert-server-profile name=foo profile=gnu
insert-server-profile:
	$(call insert-server-boot,$(name),$(profile))


# # Find -insert-here- and put an entry in.
# # Uncomment any lines beginning with ;;<profile>
insert-boot = \
	$(shell \
		sed '/-INSERT-HERE-/a $(call make-boot-entry,$(1),$(1))' \
		.emacs-profiles.el | \
		sed 's/;;$(1)//' > .tmp-profiles.el   ;  \
		mv .tmp-profiles.el .emacs-profiles.el)	 \
	$(call backup-profile)

# # Find -insert-here- and put an entry in.
# # Uncomment any lines beginning with ;;<profile>
insert-server-boot = \
	$(shell \
	    	sed '/-INSERT-HERE-/a $(call make-server-entry,$(1)-server,$(1))' \
		.emacs-profiles.el | \
		sed 's/;;$(1)//' > .tmp-profiles.el   ;  \
		mv .tmp-profiles.el .emacs-profiles.el)	 \
	$(call backup-profile)

# the old way. oy.
# insert-profile = \
# 	$(shell sed '/-INSERT-HERE-/a \
# 		\\(\"$(1)\" . \
# 		\(\(user-emacs-directory \. \"$(emacs-home)/$(1)\"\)\)\)' \
# 		~/.emacs-profiles.el > .emacs-profiles.el)                \
# 	$(shell sed 's/;;$(1)//' .emacs-profiles.el > ~/.emacs-profiles.el)
#	$(call backup-profile)


# Insert the config into the .emacs-profiles. Just a test really.
$(insert-configs):
	$(eval profile=$(shell echo $@ | sed 's/\-insert$$//g' ))
	printf "Adding profile for $(profile) to .emacs-profiles.el\n"
	$(call insert-boot,$(profile),$(profile))


# We just run the commands we were given for the profile.
# cd to the installation's direcory,
# maybe do a git pull,
# then maybe some emacs command to run an update of packages.
$(update-configs):
	$(eval profile-name=$(shell echo $@ | sed 's/\-update$$//g' ))
	printf "Running update for profile: $(profile-name)\n"
	cd $(profile-name); ($@-pull); $($@-cmd)

$(remove-configs):
	$(eval profile-name=$(shell echo $@ | sed 's/\-remove$$//g' ))
	printf "Removing install: $(profile-name)\n"
	rm -rf $(profile-name)

rm-optional: $(remove-optional-configs)
rm-installs: $(remove-configs)
rm-defaults: $(remove-default-configs)
install-defaults: add-test stable dev
reinstall-defaults: rm-defaults install-defaults

# how to set a variable during rule eval.
test-var-set:
	$(eval target-path=$(shell echo $@ | sed 's/\-.*$$//g' ))
	printf "was: $@ is:  $(target-path)"


# copy the last saved profile to ~/ see above for find-last-backup
restore-last-profiles:
	$(eval last-backup=$(shell $(find-last-backup) ))
	printf Restoring last-backup)
	cp $(last-backup) .emacs-profiles.el

# function to make a timestamped copy of .emacs-profiles.el
backup-profile = \
	echo Backing up .emacs-profiles.el to $(dot-backups), $(seconds-now) \
	cp .emacs-profiles.el $(dot-backups)/.emacs-profiles.el.$(seconds-now)

# function to remove and link to ~/.emacs-profiles.el
link-profiles = \
	printf "Linking .emacs-profiles.el to $(HOME)/.emacs-profiles.el.\n"; \
	rm -f $(HOME)/.emacs-profiles.el 	;		             \
	ln -s $(PWD)/.emacs-profiles.el $(HOME)/.emacs-profiles.el

# Relink the profiles to ~/.emacs-profiles.el
relink-profiles:
	$(call link-profiles)

.PHONY: emacs-profiles.el
# Create a fresh set of profiles and link them to Home.
emacs-profiles.el:
	printf "\n\nCreating a fresh .emacs-profiles.el from original template.\n"
	printf "Setting Paths to here $(PWD).\n\n"
	sed 's:\-PWD\-:$(PWD):' emacs-profiles-orig.el > .emacs-profiles.el
	$(call link-profiles)
	$(call backup-profile)

# mv .emacs-profiles.el $(Dot-backups)/.emacs-profiles.el.$(seconds-now)

install-emacsn:
	printf "\n\nInstalling emacsn to $(emacsn-home)\n"
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
	printf " Has a chemacs profile thats not a link. Saving it away"
	printf "\n\nMoving ~/.emacs-profiles.el to $(dot-backups)/.emacs-profiles.el.$(seconds-now)\n"
	mv ~/.emacs-profiles.el $(dot-backups)/.emacs-profiles.el.$(seconds-now)
endif

# These move .emacs and .emacs.d to .bak.<epoch seconds>
.PHONY: mv.emacs
mv.emacs:
ifneq ($(move-dot-emacs), 0)
	ls -l ~/.emacs
	printf "\n\nMoving ~/.emacs to $(dot-backups)/.emacs.$(seconds-now)\n"
	mv ~/.emacs $(dot-backups)/.emacs.$(seconds-now)
endif

.PHONY: mv.emacs.d
mv.emacs.d:
ifneq ($(move-dot-emacs.d), 0)
	ls -l ~/.emacs.d
	printf "\n\nMoving ~/.emacs.d to $(dot-backups)/.emacs.d.$(seconds-now)\n"
	mv ~/.emacs.d $(dot-backups)/.emacs.d.$(seconds-now)
endif

# Backup all the dot emacs.
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

# Add a test profile. Nothing to do really. Point at an empty emacs.d.
add-test:
	mkdir -p $(emacs-home)/test

# Add a gnu profile. Nothing to do really. Point at an empty emacs.d.
add-gnu: add-test
	mkdir -p $(emacs-home)/gnu

all: install-all

# make sure dot-backups is there.
dot-backups:
	mkdir -p dot-backups

# The minimum, initialize an Emacsn with nothing but gnu and test.
# back up the profiles if they arent a link.
init: dot-backups emacs-profiles.el relink-profiles add-gnu     \
	touch-custom mv.emacs-profiles.el

# prepare and install emacsn, chemacs, chemacs profiles, stable and dev
install-base: init backup-dot-emacs install-emacsn install-chemacs

install: install-base stable dev

# Prepare and install everything we have. I wouldn't advise.
# The install plus: doom, spacemacs, and prelude.
all: install optional-configs

# Clean test out so we can use it as vanilla
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
	printf "\n Creating new emacsn at: $(path)\n"
	git clone $(emacsn-repo) $(path)

show-profiles:
	printf "\nThe current ~/.emacs-profiles:\n"
	printf "========================================\n"
	cat .emacs-profiles.el

show-installs:
	printf "\nInstallations:\n"
	printf "========================================\n"
	echo $(installs)
show-default:
	printf "\nThe default installation:\n"
	printf "========================================\n"
	grep '^default-configuration-name' configurations.mk

show-optional:
	printf "\nAll Optional installations:\n"
	printf "========================================\n"
	printf "$(optional-configs)"

show-available:
	printf "\nUnInstalled, Available installations:\n"
	printf "========================================\n"
	comm -23 <(echo $(configs) | cut -d= -f2 | sed 's/ /\n/g' | sort) \
	<(ls -dfF * | grep '/$$' | sed 's:/$$::' | sort)

	printf "\nSee an install configuration with show-<configuration-name>\n"
	printf "\n	make show-doom \n"

status-header:
	printf "Emacsn: Current Status\n"
	printf "=======================================\n"
	printf $(installs-message)
	printf "\n"

status-end:
	printf "\nUse 'make help' to get help.\n"
	printf "========================================\n"

status: status-header show-default show-installs show-available status-end

help:
	cat help.txt
