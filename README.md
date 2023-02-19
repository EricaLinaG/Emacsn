# Emacsn

## A system to enable easy management of multiple emacs configurations.

This is literally just a script and a __Makefile__ to create an easy system of 
installing and managing multiple emacs installations from github. 
The emacs installs just need to work in _.emacs.d_ under normal cirmumstances,
with an _init.el_.

If you ever wanted an easy way to compare Doom to spacemacs, to Prelude, Emacs from
Scratch, Emacs-Live, or any other, Here is an easy path. 

If you have ever ruined your emacs setup and had to go back, or fix it in less than
ideal circumstances, then this could also be your solution to accidental 
emacs startup breakage.

## emacsn
This is a shell script Emacs wrapper, __emacsn__ to make life a little easier.
Because I'm lazy and I forget. It has accumulated features over the years, but
remains a nice wrapper for the emacs and emacsclient command lines.

## The Default Configuration

The default configuration is mine; [Ericas-Emacs](https://github.com/ericalinag/ericas-emacs).
But that can be yours or something else. It is very easy to change at the top of
the _Makefile_.

If your configuration is set up with an init.el and goes in ~/.emacs.d you are golden
and can use yours as the default by visiting and editing this region in the _Makefile_.

    default-emacs-repo := ericalinag/ericas-emacs.git

### 3 profiles for the default configuration

The default configuration gets 3 installs, __stable__, __dev__ and __test__.
test is empty, and therefore vanilla gnu to start with.

There is `make test-install` which will make a test install in the test profile.
This is to make sure what is pushed installs and 
runs cleanly before updating the stable installation with `make stable-update`.

## Easy updates to configurations.

There are make targets to update the installations. They do a `git pull` and
then update packages in each configuration's preferred way.

For example:

```sh
    make <profile-name>-update

    make stable-update
    make doom-update
    make space-update
    
    make uncle-daves~update
```
    

## Quick Guide

This is really pretty simple.

### Emacs-home

In the __Makefile__ _emacs-home_ is set to wherever you clone __Emacsn__ 
to. This is where all of the emacs configurations will be.

I usually `cd` then clone it so my __emacs-home__ will be _~/Emacsn_

  - Step 0: Optional: Fork this repo. 
      You'll probably want to make this your own.

  - Step 1: Get this repo from here or from your fork and `cd` into it.
    I usually just clone it into my Home directory.

```shell
    cd
    git clone https://github.com/EricaLinaG/Emacsn.git 
    cd Emacsn
```

  - Step 2:  Install Chemacs2 as well as the default and gnu profiles.
    ONLY do the install once. The optional configurations can be installed later.

```sh
    make install
```

Or to install Doom emacs and Spacemacs in addition;

```shell
    make install doom space
```

Or to install Everything. _This might take a while, and requires baby sitting._;

```shell
    make install-all 
```

  - Step 3: install optional emacs configurations. 
  `make print-` can tell you what your choices are.
  This can be done at anytime as you go.

```sh
    make print-optional-profiles
    
    make doom space uncle-daves from-scratch prelude live hell
```

At this point you are ready to go. Running emacs will give you your
default __stable__ configuration. you can also specify them specifically
with these variants

    emacs --with-profile dev
    
Or
    
    emacsn -p dev


## What to do next.

Play. learn, explore. :-)

  - Step 4: Optional, Change the git remote for __dev__ to SSH.
      I only do this for _dev_, as its the only one I ever push.
      __dev__ is where I maintain Ericas-Emacs.

```sh
    cd dev
    git remote -v
    git remote set-url origin git@github.com:<your-github>/<your-default-emacs-config>.git
    git remote -v      # just to make sure.
```

  - Step 5: Optional, After pushing changes from __dev__, test your configuration 
  with an install from git.

```sh
    make test-install 
```

  - Step 6: Optional, pull your changes into __stable__ and update the packages.
```sh
    make stable-update
```

Rinse - Repeat.

## Read the Makefile

Its not too hard, and you'll know everything, mostly.
Oh, and take a look at _emacs-profiles-orig.el_. It does have a majority of
the examples from the Chemacs2 readme.

## Emacs configurations

So far they are all from github.  Each one needs to specify its piece of
the github url, the part that follows github.com/. Make does not like __:__
in many places, so we circumvent that by constructing the url.

It should also specify an install and optionally an update command 
and repo-flags as desired for the git clone. 

They can all be seen with `make print-...

```shell
    make print-optional-profiles
    make print-profiles
    make print-default-profiles

    # for the update targets.
    make print-update-profiles
    make print-update-generic-profiles
```

The extra profiles can be installed like so. You may install them
as you go.  Emacsn modifies your __~/.emacs-profiles.el__
as you add new profile installs. 

```shell
    make doom space uncle-daves prelude
```

### Profiles which have an install and/or update functionalities.

Doom and Ericas are the only configurations which provide an install function.

```make
    ericas-repo := ericalinag/ericas-emacs.git
    #  ericas-repo-flags := -b with-helm
    ericas-install-cmd := emacs --script install.el --chdir $(emacs-home)/ericas
    ericas-update-cmd := emacs --script update.el --chdir $(emacs-home)/ericas
```

Like most emacs configurations Spacemacs just installs everything when it 
runs the first time. But it does have an internal lisp function we can use 
to do an update.

```make
    space-repo := syl20bnr/spacemacs.git
    space-install-cmd := emacs --with-profile space
    space-update-el := '((lambda ()\
                          (shell-command "git pull origin HEAD")\
                          (configuration-layer/update-packages)\
                          (save-buffers-kill-terminal t)))'
    space-update-cmd := emacs -nw --with-profile space \
                      --eval $(space-update-el) --chdir $(emacs-home)/space
```

Doom has hybrid shell/elisp scripts to run for install and update.
```make
    doom-repo := hlissner/doom-emacs.git
    doom-install-cmd := $(emacs-home)/doom/bin/doom install
    doom-update-cmd := $(emacs-home)/doom/bin/doom update
```

### Profiles with no install function

These profiles just run emacs the first time to install all of
their packages. So the install command amounts to one of these.

```sh
    emacsn -p <profile-name>

    # or

    emacs --with-profile <profile-name>
```


### The generic update rule

For configurations with no update function. (Most of them)

Only Doom, Ericas and Spacemacs provide an update mechanism.
The rest can use this generic update rule.

There is a `generic-update.el` that can be used to do updates 
on configurations without special functionality for that.
It is a simplification of the __update.el__ from Ericas emacs.
It does a `git pull origin HEAD`, updates all packages 
and then exits.

These configurations usually do not have an install function 
either so on install we just run them like so. 
They download and install all their packages. 
We can check for errors, then `C-x C-c` so that 
the `make` can continue.

Their install command is usually this.
```make
    emacs --with-profile <profile-name>
```

Uncle Daves Emacs, Prelude, from hell, and from scratch 
can use the generic update rule. From scratch and hell
both update automatically and do not use packages, 
So the update packages doesn't do/hurt anything.
The update rule will still update the code base from github.

```make
uncle-daves-repo := daedreth/UncleDavesEmacs.git
uncle-daves-install-cmd := emacs --with-profile uncle-daves
```
Profile targets that use the generic update rule go into
the `update-generic-profiles` list.

__Note: The names in update-generic-profiles use `~` to delimit
between the name and _update_.__

I am not sure I like this, but it enables us to use the generic
update and not specify an update command for every configuration.
And the __~__ allows us to have easy to read names with __-__ in them.
Its only like this for the generic update profiles.

So they look like this.

    uncle-daves~update
    prelude~update
    hell~update
    from-scratch~update
    
This is simply to accommodate profile names with __-__ in them.

Using them looks like this.

```shell
    make uncle-daves~update
```
    
### Summary
To add a new configuration repo, just define the repo's uri, 
and add an install command. Define an update command or put it in the 
`update-generic-profiles` list to use the generic update command.

The install command is frequently just to run emacs with that profile.
Exceptions are Doom Emacs, and Ericas-Emacs.

The update is not absolutely needed. It is a convenience.
But if it has special accommodations like Doom or Ericas, or less so 
like Spacemacs those needs can be met.

The _<profile-name>-repo-flags_ allow for creating profiles based 
on different branches in the same repo.

## Chemacs

This system uses [Chemacs2](https://github.com/plexus/chemacs2) 
as an _Emacs bootloader_ to allow multiple emacs configurations to exist at once.
Most of the examples from the chemacs doc are incorporated here.

This repo can install the following:
    - __Chemacs2__  - Our bootloader.

  - Flavors of Emacs
    Current available installations can be printed with `make print-profiles`:
      - __default__ is the same as __stable__
      - __stable__ and __dev__ and __test__ are 
      [ericas-emacs](https://github.com/ericalinag/ericas-emacs)
      as the default configuration.
      - __doom__ is [_doom-emacs](https://github.com/doomemacs), 
      - __space__ is [spacemacs](https://github.com/syl20bnr/spacemacs).
      - __prelude__ is [prelude emacs](https://github.com/bbatsov/prelude).
      - __ericas__ is [ericas-emacs](https://github.com/ericalinag/ericas-emacs).
      - __live__ is [emacs-live](https://github.com/overtone/emacs-live).
      - __from-scratch__ is [emacs-from-scratch](https://github.com/daviwil/emacs-from-scratch).
      - __hell__ is [emacs-from-hell](https://github.com/daviwil/emacs-from-hell).
      - __uncle-daves__ is [Uncle Daves Emacs](https://github.com/daedreth/UncleDavesEmacs.git).

    - gnu and test are a special case and are always added.
      - __gnu__ A blank emacs.d - vanilla gnu emacs. 
      - __test__ is like __gnu__ when clear, but is used to test fresh installs of default.

In addition to the actual installed profiles there are server
profiles which use them. See __~/.emacs-profiles.el__ for full details

Server profiles are:
  - Stable
    - exwm
    - mail
    - common
  - Doom
    - doom-server
  - Vanilla gnu
    - gnu-server

(provide '.emacs-profiles.el)
;;; emacs-profiles-orig.el ends here

There is a __test__ profile which is used to test the pushed version of 
the default configuration.

When I modify my emacs configuration, I use the _dev_ installation. 
Once _dev_ is pushed to github and I'm happy with it,
I then try it out with `make test-install`.
If that is all good I `make stable-update `for new _stable_ installation.

__Test__ is another entry in _~/.emacs-profiles.el_.  The Makefile has 
an _install-test_ rule, which will remove/create/execute __test__ 
with an install from github, it finishes with 

    `emacs -with-profile test --debug-init`.

so that any first run problems can be managed.

     
## Managing elisp development

I use these installs to insure I always have a way to do work if I have
broken anything.  I do my elisp work in dev.  
When dev is working well and everything is pushed
I can test a fresh installation from github with:

    make test-install

This will install and run emacs --debug-init on a fresh install from git.
if all works well, I can then do this to update my stable install.

    make stable-update

This does a `git pull` to bring it up to date with _origin HEAD_. 
Followed by a package update.

__Note: this might not work properly for configurations on branches.__


### Emacs boot choices

The boot profile choices are defined in __~/.emacs-profiles__,
stable is the target of default. 

run emacs with profiles like this:
    emacs --with-profile <profile name>
or
    emacsn -p <profile name>

If this is a minimal install there will be __gnu__ plain vanilla emacs,
__stable__, __dev__ and __test__, stable is the default.
The __test__ profile is initially empty and therefore vanilla gnu.

Emacs profile choices are:
 - Emacs instances
   - stable, default
   - dev
   - test 
   - gnu - Completely vanilla gnu emacs.

   - Optional installs
     - ericas
     - doom
     - space
     - prelude
     - hell
     - from-scratch
     - uncle-daves

 - Named emacs daemons
   - Using stable
     - exwm 
     - mail 
     - common 

   - Using vanilla gnus
     - gnu-server

   - If doom is installed
     - doom-server
 
Emacs will default to __stable__ but can be redirected with

    emacs --with-profile dev

or 

    emacsn -p dev

### Running emacs client to a server

Create a new frame, connect to the socket and use vanilla emacs as fallback

    emacsclient -c -s exwm -a emacs
    emacsclient -c -s mail -a emacs
    emacsclient -c -s doom -a emacs
    
or,  with emacsn, which will fail if there is no server. - my preference.

    emacsn -cws exwm
    emacsn -cws mail
    emacsn -cws doom
    
Use an existing emacsclient frame by omitting the `w`:

    emacsn -cs mail

### Running no name daemons

A vanilla, no-name, daemon - the old fashioned way, not the Chemacs way.

    emacs --daemon &
or
    emacsn -d

Doom emacs daemon

    emacs --with-profile doom --daemon &
or
    emacsn -dp doom
    

## The emacsn script

I run emacs a few different ways. I use named daemons for some things.
its nice to have so clients can be used for mu4e and Exwm.

Chemacs handles some of the same things, but they seem to work well together.

To facilitate the emacs commandline
I have a wrapper for emacs in my ~/bin directory.  `emacsn`.
It is a simple CLI that does all of those things. 

`emacsn -h`  will give extensive help with examples.

### emacs daemons, clients, exwm, mu4e

Emacsn has nice controls for creating and using named and unamed daemons
with Emacs and Emacsclient. It also makes it easy to run elisp functions
which is leveraged by other options like -e to create an emacs invocation for
mu4e which runs as emacsclient and connects to a named daemon.

It runs `mu4e` or my `main-window` function to set up emacs in a 
standard configuration for a project. 
It knows how to run any elisp function on startup, 
it can choose different Chemacs profiles.  Creating multiple daemons
and using them by name is easy.
It's easy to add others. 

Both of these commands result in the same thing, they both
use the __stable__ profile.
They set the title, run mu4e, and set the server name to mail.
but one uses the mail server profile from Chemacs, the other
uses cli options to create a named mail server.  

Running a named emacs daemon for mail with Chemacs looks like this.
This will run the mail server entry in __~/.emacs-profiles__.

    emacsn -ep mail

Using the default Chemacs profile it is like this.

    emacsn -es mail 
    
Creating a new frame to connect to the server 
using the usual emacsclient looks like this:

    emacsn -ecws mail

The __emacsn__ script has extensive help and a lot of options. It is
simpler than emacs it's self.;

Future emacsn enhancements:

I'm feeling the need to add --chdir and --script options to __emacsn__
that could make life a little easier. And I need to look at Chemacs
to see why it looses its mind with some emacs options.

# Summary

I hope that this is a useful project for folks. It has changed the way
I manage my emacs installs, and it has given me an easy way to
explore other Emacs configurations which is an amazingly good
way to find new features and ways of doing things.

I am open to PRs, so if you have something you'd like to add or
suggest, please do.
