# Makefile to install and maintain chemacs2 and a
# few emacs configurations.
#
# The default emacs install is mine.  Ericas-emacs.
# It can be easily changed to be yours.
#
# There will be a stable and dev install of the default,
# There is also a test install which defaults to vanilla gnu
# when not in use. It can be used to test a fresh install
# with make test-install.
#
# There is also a vanilla gnu install, as well as
# doom, spacemacs and prelude if you want them.
#
# There are also daemon profiles for exwm, mail, common,
# and doom servers.

# where emacs installations will live.
emacs-home := ~/Emacs

# where to put emacsn helper script
emacsn-home := ~/bin

# we just make sure this exists.
config-custom := ~/.config/emacs-custom.el

# this repo actually.
emacsn := ericalinag/emacsn.git

# emacs installation repos
default-emacs-repo := ericalinag/ericas-emacs.git
dev-repo := $(default-emacs-repo)
stable-repo := $(default-emacs-repo)
test-repo := $(default-emacs-repo)

# we can use the plain vanilla emacs to load our packages.
# We just have to be where we want them.

# ericas-emacs has install.el and update.el which can be run like this
# we just need to add the final install folder name.
default-install-cmd-pre := emacs --with-profile gnu --script install.el --chdir $(emacs-home)
default-update-cmd-pre := emacs --with-profile gnu --script update.el --chdir $(emacs-home)

dev-install-cmd := $(default-install-cmd-pre)/dev
dev-update-cmd := $(default-update-cmd-pre)/dev

test-install-cmd := $(default-install-cmd-pre)/test
test-update-cmd := $(default-update-cmd-pre)/test

stable-install-cmd := $(default-install-cmd-pre)/stable
stable-update-cmd := $(default-update-cmd-pre)/stable

# make it easy to keep ericas-emacs, if the default changes.
ericas-repo := ericalinag/ericas-emacs.git
ericas-install-cmd := emacs --with-profile gnu --script install.el --chdir $(emacs-home)/ericas
ericas-update-cmd := emacs --with-profile gnu --script update.el --chdir $(emacs-home)/ericas

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

# find out if we have a .emacs and .emacs.d to worry about.
move-dot-emacs := $(or $(and $(wildcard $(HOME)/.emacs),1),0)
move-dot-emacs.d := $(or $(and $(wildcard $(HOME)/.emacs.d),1),0)
# so we can have uniquely named backups. being lazy.
seconds-now := $(date +%s)

# test if target replaces inside a variable name. It does.
testit-repo := someplace-far-far-away
testit:
	printf "$($@-repo)"

# diagnostic rule.
# make print-VARIABLE ie. make print-profiles
print-%  : ; @echo $* = $($*)

# profiles that can be installed, and updated.
#    we dont actually install gnu because there isnt anything to do.
#    we do the same with test initially, - its a placeholder for when
#    we get around to testing our recently pushed changes.
profiles := gnu stable dev test doom space prelude ericas

# profile targets, and a generic rule
# add them into .emacs-profiles.el.
# clone them to their target directory.
# do what we can to get them to do their initial load.
$(profiles):
	printf "Adding profile for $@\n\n"
	sed 's/;;$@//' .emacs-profiles.el > tmp
	mv tmp .emacs-profiles.el
	printf "cloning repo for $@\n\n"
	git clone https://github.com/$($@-repo) $(emacs-home)/$@
	printf "Running install for $@\n\n"
	printf "Exit with C-x C-c as needed when done\n\n"
	$($@-install-cmd)


update-targets := dev-update stable-update test-update space-update doom-update prelude-update
$(update-targets):
	printf "Running update for profile: $@\n\n"
	$($@-cmd)

# is there a better way? I hope so.
.PHONY: mu4e
mu4e: mbsync
	cp -r ~/.cache/yay/mu-git/src/mu/mu4e $(HOME)/elisp/extensions/

.PHONY: mbsync
mbsync:
	ln -s $(PWD)/mbsyncrc $(HOME)/.mbsyncrc

clean-links:
	rm $(HOME)/.mbsyncrc

# copy .emacs-profiles.el to ~/
.PHONY: chemacs-profiles
chemacs-profiles:
	cat .emacs-profiles.el
	printf "\n\n\n"
	cp .emacs-profiles.el ~/

install-emacsn:
	mkdir -p $(emacsn-home)
	cp emacsn $(emacsn-home)

touch-custom:
	touch $(config-custom)

mk-emacs-home: touch-custom
	printf "Creating Emacs Home: $(emacs-home)\n"
	git clone $(emacsn) $(emacs-home)
	mkdir -p $(emacs-home)

# These move .emacs and .emacs.d to .bak.<epoch seconds>
.PHONY: mv.emacs
mv.emacs:
ifneq ($(move-dot-emacs), 0)
	ls -l ~/.emacs
	printf "Moving ~/.emacs to .bak.xxxx\n"
	mv ~/.emacs ~/.emacs.bak.$(seconds-now)
endif

.PHONY: mv.emacs.d
mv.emacs.d:
ifneq ($(move-dot-emacs.d), 0)
	ls -l ~/.emacs.d
	printf "Moving ~/emacs.d to .bak.xxxxx\n"
	mv ~/.emacs.d ~/.emacs.d.bak.$(seconds-now)
endif

# move with preserve dot emacs.
.PHONY: backup-dot-emacs
backup-dot-emacs:  mv.emacs.d mv.emacs

# scorch dot emacs.
remove-dot-emacs:
	printf "Removing ~/.emacs and ~/.emacs.d\n\n"
	rm -rf ~/.emacs.d
	rm -f ~/.emacs

# Chemacs goes in emacs.d
install-chemacs:
	printf "Cloning chemacs into ~/.emacs.d\n\n"
	git clone https://github.com/plexus/chemacs2.git ~/.emacs.d

# Add a gnu profile. Nothing to do really. Point at an empty emacs.d.
add-gnu: gnu
	mkdir -p $(emacs-home)/gnu
	mkdir -p $(emacs-home)/test

all: mu4e install-all

# not sure about mu4e installation at this point. I think it just works now.
# I need to test that.

# prepare for install
#  move ~/.emacs, ~/.emacs.d, mkdir emacs home.
prepare-install: backup-dot-emacs mk-emacs-home

# prepare and install emacsn, chemacs, chemacs profiles, stable and dev
# This includes gnu and test profiles which are vanilla gnu emacs
install: prepare-install install-emacsn add-gnu\
	install-chemacs stable dev chemacs-profiles

# prepare and install everything we have.
# the install plus: doom, spacemacs, and prelude.
install-all: install test space prelude doom chemacs-profiles

# make targets for managing the testing a fresh install.
# Nuke it so we can clone a new one.
remove-test:
	printf "Removing the test install\n"
	rm -f $(emacs-home)/test

# clean it out so we can still use it as vanilla
clean-test:
	printf "Cleaning out the test install\n"
	rm -f $(emacs-home)/test/*

# Remove the current test, and test a fresh install from github.
test-install: remove-test test
	emacs --with-profile test --debug-init
