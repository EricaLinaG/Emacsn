
# Emacsn
###    A script and a Makefile to install and manage multiple emacs configurations with Chemacs.

This is literally just a script and a __Makefile__ to create an easy system of 
installing and managing multiple emacs installations from github. 

The shell script Emacs wrapper, __emacsn__ is just to make life a little easier.
Because I'm lazy and I forget. It has accumulated features over the years, but
remains a nice wrapper for the emacs and emacsclient command lines.

The default configuration is mine; [Ericas-Emacs](https://github.com/ericalinag/ericas-emacs).
But that can be yours or something else.

If your configuration is set up with an init.el and goes in ~/.emacs.d you are golden
and can use yours as the default by visiting this in the makefile.

    default-emacs-repo := ericalinag/ericas-emacs.git

The default configuration gets 3 installs, __stable__, __dev__ and __test__.

There is a `make test-install` target to make sure what is pushed installs and 
runs cleanly before updating the stable installation with `make stable-update`.

For the Ericas-Emacs and Doom-Emacs installations there are make targets
to update those installations. 
    `make <stable|dev|test>-update`
    `make doom-update`

Current available installations can be printed with `make print-profiles`:

  - default - Ericas-Emacs -- default/stable, dev, test.
  - gnu     - plain vanilla.
  optional:
  - ericas  - ericas-emacs
  - doom    - doom-emacs
  - space   - spacemacs
  - prelude

There are multiple profiles and servers for the default configuration
as well as servers for doom and spacemacs.

There is a __test__ profile which is used to test the pushed version of 
the default configuration.

## Read the Makefile

Its not too hard, and you'll know everything, mostly.
Oh, and take a look at _emacs-profiles-orig.el_.

## Chemacs

This system uses [Chemacs2](https://github.com/plexus/chemacs2) 
as an _Emacs bootloader_ to allow multiple emacs configurations to exist at once.
Most of the examples from the chemacs doc are incorporated here.

This repo can install the following:
    - Chemacs2  - Our bootloader.
    - __stable__ and __development__ installs of the default configuration.
    - __doom__ For [_doom-emacs](https://github.com/doomemacs), 
    - __space__ For [spacemacs](https://github.com/syl20bnr/spacemacs).
    - __prelude__ For [prelude emacs](https://github.com/bbatsov/prelude).
    - __ericas__ For [ericas-emacs](https://github.com/ericalinag/ericas-emacs).
    gnu and test are a special case and are always added.
    - __gnu__ A blank emacs.d - vanilla gnu emacs. 
    - __test__ Like __gnu__ when clear, but is used to test fresh installs of default.

To see the profile targets that the Makefile knows. 
     `make print-profiles`

On install, the target, `chemacs-profiles` will copy the
current _~/.emacs-profiles.el_. The default profile will be __stable__

When I modify my emacs configuration, I use the _dev_ installation. 
Once _dev_ is pushed to github and I'm happy with it,
I then try it out with `make test-install`.
If that is all good I `make udpate-stable `for new _stable_ installation.

__Test__ is another entry in _~/.emacs-profiles.el_.  The Makefile has 
an _install-test_ rule, which will remove/create/execute __test__ 
with an install from github, it finishes with 

    `emacs -with-profile test --debug-init`.

so that any problems can be managed.

## Emacs-home

In the __Makefile__ _emacs-home_ is set to __~/Emacsn__ this is where 
an _emacsn_ repo like this one will live, and under it will be all of the 
emacs configurations.

The default install will place an __emacsn__ repo in _~/Emacsn_ anyway, go 
with the flow or edit the Makefile and make your own.

## Installation

### Get the makefile or this repo.

    git clone https://github.com/ericalinag/Emacsn.git ~/Emacsn
    cd ~/Emacsn

or really you just need the Makefile, it will create ~/Emacsn for you.

    curl https://github.com/ericalinag/emacsn/master/blob/Makefile > Makefile

Once you are there/have the _Makefile_ install as much as you like.
`make install` will create __stable__ and __dev__ with the default configuration.
As well as empty/vanilla __gnu__ and __test__.

     make install
     make doom
     make space
     make prelude
     make ericas
     
or 
     make install-all

### Make targets.

__make install__ Does the following: 
  - Move _.emacs_ and _.emacs.d_ out of the way if they exist.
  - Install Chemacs2 into ~/.emacs.d
  - Create _.emacs-profiles.el 
    - __gnu__ empty at _~/Emacsn/gnu_.
    - __test__ empty at ~/Emacsn/test
    - __dev__ ericas at ~/Emacsn/dev
        - load packages at __dev__
    - __stable__ ericas at ~/Emacsn/stable
        - load packages at __stable__
  - Copy _.emacs-profiles.el_, to _~/_ with each additional profile.
  
#### install-all

This will add  __doom__, __space__, __ericas__ and __prelude__.

     make install-all

## Running emacs with a profile

   - `emacs --with-profile prelude`

   or similarly:

   - `emacsn -p dev`
    

## Managing elisp development

I use these installs to insure I always have a way to do work if I have
broken anything.  I do my elisp work in dev.  
When dev is working well and everything is pushed
I can test a fresh installation from github with:

    make test-install

if all works well, I can then do this.

    make update-stable 

To do a `git pull` and bring it up to date with _origin/master_. 
Followed by a package update.


### Emacs boot choices

The boot profile choices are defined in __~/.emacs-profiles__,
stable is target of default. 

run emacs with profiles like this:
    emacs --with-profile <profile name>
or
    emacsn -p <profile name>

If this is a minimal install there will be __gnu__ plain vanilla emacs,
__stable__, __dev__ and __test__, stable is the default.
The __test__ profile is initially empty and therefore vanilla gnu.

Emacs profile choices are:
 - stable, default
 - dev
 - doom
 - space
 - prelude
 - gnu - Completely vanilla gnu emacs.
 - test 

 - Named emacs daemons
   - Using stable
     - exwm 
     - mail 
     - common 

   - Using vanilla gnus
     - gnu-server

   - Using doom
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
    
or,  with emacsn

    emacsn -cws exwm
    emacsn -cws mail
    emacsn -cws doom
    
Use an existing emacsclient frame by omitting the `w`:

    emacsn -cs mail

### Running no name daemons

A vanilla, no-name, daemon

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

It runs `mu4e` or my `main-window` function to set up emacs in a 
standard configuration for a project. 
It knows how to run any elisp function on startup, 
it can choose different Chemacs profiles.  Creating multiple daemons
and using them by name is easy.
It's easy to add others. 

Running an emacs daemon for mail looks like this.

    emacsn -e --with-profile mail
    
Creating a new frame with emacsclient looks like this:

    emacsn -ecws mail

The __emacsn__ script has extensive help and a lot of options. It is
simpler than emacs it's self.;


