# Emacsn

## A system for managing multiple Emacs configurations.

This is just some __Makefile__, a script and some elisp to create an easy system of 
installing and managing multiple emacs installations from github. 
This system uses [Chemacs2](https://github.com/plexus/chemacs2) for its Emacs
boot loader. I recommend at least reading through it's __Readme__ even though Emacsn
takes care of everything, you'll want to know eventually.

The Emacs configuration installs that Chemacs likes need to work in _.emacs.d_ under 
normal circumstances, with an _init.el_. Most configurations do this.

### Why

It just grew organically over time. Have a need, fill a need.

If you ever wanted an easy way to compare Doom to spacemacs, to Prelude, Emacs from
Scratch, Emacs-Live, or any other, Here is an easy path. 

If you have ever ruined your emacs setup and had to go back, or fix it in less than
ideal circumstances, then this could also be your solution to accidental 
emacs startup breakage. 

You just want to try out a feature without breaking your daily driver.

It also installs your emacs for you.

## emacsn
This is a shell script Emacs wrapper, __emacsn__ to make life a little easier.
Because I'm lazy and I forget. It has accumulated features over the years, 
and gives me control over my emacs cli.

## The Default Configuration

The default configuration is mine; [Ericas-Emacs](https://github.com/ericalinag/ericas-emacs).
But that can be yours or something else. It is very easy to change at the top of
the 
[_profiles.mk_](https://github.com/EricaLinaG/Emacsn/blob/main/profiles.mk)
makefile where all the profile definitions live.

If your configuration is set up with an init.el and goes in ~/.emacs.d you are golden
and can use yours as the default by visiting 
[this region](https://github.com/EricaLinaG/Emacsn/blob/main/profiles.mk)
 in _profiles.mk_. Once you have a profile using it for the default is as easy 
 as this.

    default-profile-name := ericas

### 3 profiles for the default configuration

The default configuration gets 3 installs, __stable__, __dev__ and __test__.
test is empty, and therefore vanilla gnu to start with.

There is `make test-install` which will make a test install in the test profile.
This is to make sure what is pushed installs and 
runs cleanly before updating the stable installation with `make stable-update`.

## Easy updates to configurations.

There are make targets to update the installations. They might do a `git pull` and
then update packages in each configuration's preferred way.

For example:

```sh
    make stable-update
```
    
## Super Quick Guide
It really is mostly a Makefile.

### `make help`

###  git clone ... /Emacsn.git;   cd Emacsn;   make install; 

  - `emacs --with-profile <gnu|stable|dev|test|...>`
  
### Get the Status and see some things.
  - `make status`
  - `make show-profiles`
  - `M-x describe-variable chemacs-profiles`
  - `cat ~/.emacs-profiles.el`
  - `cat ./emacs-profiles-orig.el`
  - `make print-optional-profiles`

After that you may do:
  - `make space doom from-hell`
    - `emacsn -p <doom|space|gnu|stable|dev|...>`
  - Do not do: `emacs --with-profile from-hell` How bad could it be?

Do try:
  - `make test-install`
  - `make stable-update`
  - `make from-hell-remove`

Add your emacs repo to __profiles.mk__, make it the default. __Then;__
  - `make dev-remove stable-remove test-remove add-test dev stable`
  or `make rm-default-profiles install-default-profiles`
  - Have fun.

## A Quick Guide.

In the __Makefile__ _emacs-home_ is set to wherever you clone __Emacsn__ 
to. This is where all of the emacs configurations will be.

I usually `cd` then clone it so my __emacs-home__ will be _~/Emacsn_

Get this repo from here or from your fork and `cd` into it.
I usually just clone it into my home directory.

```shell
    cd
    git clone https://github.com/EricaLinaG/Emacsn.git 
    cd Emacsn
```

Install Chemacs2 as well as the default and gnu profiles.
    The optional configurations can be installed later.

```sh
    make install
```

`make status` is a nice report of things in Emacsn.

Install optional Emacs configurations. 
Maybe install Doom-emacs, Spacemacs and Emacs-from-scratch
```sh
    make doom space from-scratch
```

At this point you are ready to go. Running Emacs will give you your
default __stable__ configuration. you can also specify them specifically


    emacs --with-profile dev
    
Or
    
    emacsn -p dev


## What to do next.

### Get the status of Emacsn.

    `make status`
    `make show-profiles`
    `make help`

### profiles.mk
Look at 
    [_profiles.mk_](https://github.com/EricaLinaG/Emacsn/blob/main/profiles.mk)
    and add your own emacs config into the mix. Directions are at the top of the makefile .
### Incorporate your Emacs configuration as the default.
    - Visit _profiles.mk_
    - Add your Emacs profile definition to it. 
    - Set it to the default 
    - Reinstall the default profiles with yours. 
    `make reinstall-default-profiles`

### See how profile entries are made.
  - Look at _~/.emacs-profiles.el_ 
  - Compare that to _Emacsn/emacs-profiles-orig.el_.
    Persistent profile definitions live there so you have them with every install
    of Emacsn.

### Change the git remote for __dev__ to SSH.
      I only do this for __dev__, as its the only one I ever push.
      __dev__ is where I maintain Ericas-Emacs.

```sh
    cd dev
    git remote -v
    git remote set-url origin git@github.com:<your-github>/<your-default-emacs-config>.git
    git remote -v      # just to make sure.
```

### Create a workflow

After pushing changes from __dev__, test your configuration with an install from git.

```sh
    make test-install 
```

If that all works well pull your changes into __stable__ and update the packages.

```sh
    make stable-update
```

### Read some docs.
  - Read up on [Chemacs2](https://github.com/plexus/chemacs2) 
  and whichever Emacs configurations you wish to use. Each has 
  instruction you will want to know. Entire wikis exist.
## When an Emacs distro is no longer useful/interesting

  - Step 7: Optional, remove stuff.

```sh
    make from-hell-remove

    make rm-all-optional

    make rm-all-profiles
```

But you can just do an `rm -rf ...` if you want.
Don't forget to edit your _~/.emacs-profiles.el_

Rinse - Repeat, Have fun.


## Emacs configurations

These are defined in
 [_profiles.mk_](https://github.com/EricaLinaG/Emacsn/blob/main/profiles.mk).
 This is loaded by the main _Makefile_
 
Here is the template the makefile provides.

### The Template

 Copy this down to the bottom.
 Change all the 'gnus' to your profile name and fill in your repo url.

 The rest will satisfy your needs If;
  -  You are happy with just running emacs once for the 
     initial package load on install.
  -  You would like update to 'git pull origin', and then do 
     install-packages for all-selected-packages.


```make
# # Gnu
# # Gnu Emacs is free, have fun.
# default-profiles += gnu
# gnu-repo         = $(git-hub)/your-acct/your-repo.git
# gnu-repo-flags   =
# gnu-install-cmd  = $(emacs-nw-profile) gnu $(kill-emacs)
# gnu-update-pull  = $(git-pull)
# gnu-update-cmd   = $(generic-update-cmd)
```

### Some Examples

They are all about the same and I hope they just make sense.
Here is the one for __Prelude__.

```make
    optional-profiles   += prelude
    prelude-repo        = $(git-hub)bbatsov/prelude.git
    prelude-repo-flags  =
    prelude-install-cmd = $(emacs-nw-profile) prelude $(kill-emacs)
    prelude-update-pull = $(git-pull)
    prelude-update-cmd  = $(generic-update-cmd)
```

  - It first adds itself to the list of optional-profiles.
  - Then we define the github uri.
  - Define any clone flags so we can get branches if we like.
  - The install command to let the emacs install get all of it's packages
  - The pull command, Usually, its either __$(no-pull)__ or __$(git-pull)__
    which is __true__ and __git pull origin__ respectively.
  - The update command to let emacs update its packages.
    The update-cmd can be __$(no-update)__, __$(generic-update-cmd)__ 
    or another update command.

The list of available profiles can all be seen with `make print-...`
Or `make status` which tells all.

```shell
    make status

    make print-profiles
    make print-optional-profiles
    make print-default-profiles	

    # for the update targets.
    make print-update-profiles
```

The extra profiles can be installed like so. You may install them
as you go.  Emacsn modifies your __~/.emacs-profiles.el__
as you add new profile installs. 

```shell
    make doom 

    # or whatever
    make doom space uncle-daves prelude
```

### Profiles which have an install and/or update functionalities.

Doom and Ericas are the only configurations which provide an install function.
It does make things all a little bit nicer. They can interact as needed and exit
when done. We do our best for the rest.

```make
    optional-profiles  = ericas
    ericas-repo        = $(git-hub)/ericalinag/ericas-emacs.git
    ericas-repo-flags  =
    ericas-install-cmd = emacs --script install.el
    ericas-update-pull = $(git-pull)
    ericas-update-cmd  = emacs --script update.el
```

Like most emacs configurations Spacemacs just installs everything when it 
runs the first time. But it does have an internal lisp function we can use 
to do an update. In both cases we run in terminal mode, trust it all went well 
and save and kill terminal at the end, __$(kill-emacs)__.

```make
    optional-profiles += space
    space-repo        = $(git-hub)/syl20bnr/spacemacs.git
    space-repo-flags  =
    space-install-cmd = $(emacs-nw-profile) space $(kill-emacs)
    space-update-pull = $(git-pull)
    space-update-el   = '((lambda ()\
                            (configuration-layer/update-packages)\
			                (save-buffers-kill-terminal t)))'

    space-update-cmd  = $(emacs-nw-profile) space \
                            --eval $(space-update-el)
```


Doom has hybrid shell/elisp scripts to run for install and update.
It doesn't want us to pull for it. Use __$(no-pull)__ to indicate that.

```make
    optional-profiles += doom
    doom-repo         = $(git-hub)/hlissner/doom-emacs.git
    doom-repo-flags   =
    doom-install-cmd  = $(emacs-home)/doom/bin/doom install
    doom-update-pull  = $(no-pull)
    doom-update-cmd   = $(emacs-home)/doom/bin/doom update
```

### Profiles with no install function

These profiles just run emacs the first time to install all of
their packages. So the install command amounts to one of these.
Run in window mode or terminal mode.

```sh
    emacsn -p <profile-name>

    emacs --with-profile <profile-name>

    # or in terminal.

    emacsn -tp <profile-name>
    
    emacs -nw --with-profile <profile-name>
```


### The generic update rule

For configurations with no update function. (Most of them)

So far, only Doom, Ericas and Spacemacs provide an update mechanism.
The rest can use this generic update rule.

There is a `generic-update.el` that can be used to do updates 
on configurations without special functionality for that.
It is a simplification of the __update.el__ from Ericas emacs.
It installs/updates all selected packages and then exits.
It assumes packages are installed in _elpa_.

These configurations usually do not have an install function 
either so on install we just run them. 
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

Package update can be turned off with the value `$(no-update)`

```make
# Uncle Daves Emacs
optional-profiles       += uncle-daves
uncle-daves-repo        = $(git-hub)/daedreth/UncleDavesEmacs.git
uncle-daves-repo-flags  =
uncle-daves-install-cmd = $(emacs-nw-profile) uncle-daves $(kill-emacs)
uncle-daves-update-pull = $(git-pull)
uncle-daves-update-cmd  = $(generic-update-cmd)
```

    
### Summary
To add a new profile to
 [_profiles.mk_](https://github.com/EricaLinaG/Emacsn/blob/main/profiles.mk)
is easy, copy the template and fill in the blanks.

Adding it to the optional-profiles gives it all the make targets
it needs for installation, update, and removal.

The profile's install command is frequently just to run emacs with that profile.
Exceptions are Doom Emacs, and Ericas-Emacs.

The update changes directories to the installation, maybe does a git pull,
and maybe runs emacs to update its packages.
The generic-update-cmd works for most configurations, it simply gets 
emacs packages to install-selected.

The _<profile-name>-repo-flags_ allow for creating profiles based 
on different branches in the same repo.

## Chemacs

This system uses [Chemacs2](https://github.com/plexus/chemacs2) 
as an _Emacs boot loader_ to allow multiple emacs configurations to exist at once.
Most of the examples from the Chemacs doc are incorporated here.
Chemacs2 is installed directly into _~/.emacs.d_, if there is already one
it will be moved out of the way first.

### Persistent profile definitions

When a profile is installed it will automatically
add in any pre-defined server profiles or alternative invocations which apply.
_Make uncomments lines beginning with `;;<profile>` from .emacs-profiles.el._

Modify _~/.emacs-profiles.el_ to add new ones or change their names.

Persist them by putting them back into 
[emacs-profiles-orig.el](https://github.com/EricaLinaG/Emacsn/blob/main/emacs-profiles-orig.el). This file is the basis for the next install of Emacsn.

### Emacs Boot entries and installations.

#### How to see what is there.

Be in the Emacsn directory for most of these.

#### See it with make

  - `make status`
  - `make show-profiles`

#### See it all your way

The current profile choices can be seen with either of these.
  - `M-x describe-variable chemacs-profiles`
  - `cat ~/.emacs-profiles.el`
  - `make show-profiles`

Current installations can be seen with this.
  - `ls -dfF Emacsn/* | grep '/$'`
  - `make show-installs`
  
The current default profile can be seen with this.
    `grep '^default-profile-name' profiles.mk`
  - `make show-default`
    
Possible installations are known by make.
    `make print-optional-profiles`
  - `make show-optional`

#### Our possible Emacs boot choices 

See the commands above for your current reality.

_Note: additional profile entries fall under the installed profile they reference._

  - Default Install Profile
    - __stable__ and 
      - __default__ 
        - Servers
          - __exwm__
          - __mail__
          - __common__
    - __dev__ are the default repo. 
    [ericas-emacs](https://github.com/ericalinag/ericas-emacs)
    - __test__ is for testing default.
  - Gnu profile is an empty install.
    - __gnu__ 
      - __gnu-server__

  - Optional Profiles
    - __doom__ is [doom-emacs](https://github.com/doomemacs), 
      - __doomdir__ is __doom__ with a profile directory.
      - __doom-server__
    - __space__ is [spacemacs](https://github.com/syl20bnr/spacemacs).
      - __spacemacs__ is __space__ with a profile directory.
    - __prelude__ is [prelude emacs](https://github.com/bbatsov/prelude).
    - __ericas__ is [ericas-emacs](https://github.com/ericalinag/ericas-emacs).
    - __live__ is [emacs-live](https://github.com/overtone/emacs-live).
    - __from-scratch__ is [emacs-from-scratch](https://github.com/daviwil/emacs-from-scratch).
    - __from-hell__ is [emacs-from-hell](https://github.com/daviwil/emacs-from-hell).
    - __uncle-daves__ is [Uncle Daves Emacs](https://github.com/daedreth/UncleDavesEmacs.git).

Run emacs with profiles like this:

    `emacs --with-profile <profile name>`
or
    `emacsn -p <profile name>`

## Managing elisp development

I use the __dev__, __test__ and __stable__ profile/installs to insure 
I always have a way to do work if I have broken anything.  

I do my elisp work in __dev__.  
The __test__ profile comes into play when __dev__ is working well 
and everything is pushed.

Testing a fresh install.   

    make test-install

will Remove, Install/create, and Execute __test__ with a fresh install from github, 
it finishes with; 

    `emacs -with-profile test --debug-init`.

if all works well, I can then do this to update my __stable__ install.

    make stable-update

## Running Emacs

Running `emacs` will use __default__ which is also __stable__ but can be redirected 
to the __dev__ profile, for instance, with

    emacs --with-profile dev

or with emacsn

    emacsn -p dev

### Running emacs client to a server

If you've got a named server running you can connect to it like this.
There are so many choices in how to do this. They all work just fine.
Chemacs and emacsn really simplify running Emacs servers and connecting 
with them.

Create a new frame, connect to the socket and use vanilla emacs as fallback

    emacsclient -c -s exwm -a emacs
    emacsclient -c -s mail -a emacs
    emacsclient -c -s doom -a emacs
    
or,  with emacsn, which will fail if there is no server. - my preference.
This will just use the default profile. Add -p to specify an other.

    emacsn -cws exwm
    emacsn -cws mail
    emacsn -cws doom
    
Use an existing emacsclient frame by omitting the `w`:

    emacsn -cs mail

### Running named daemons

Some Chemacs profiles are servers, we dont have to do anything to make them
start except invoke them.

    emacs --with-profile exwm 
    emacs --with-profile gnu-server
    emacs --with-profile doom-server
or

    emacsn -p exwm
    emacsn -p gnu-server
    emacsn -p doom-server

#### Named daemons with emacsn

Using the default emacs as a server can be done like this.

    emacsn -s exwm
    emacsn -s mail

Connect emacsclint in a new frame/window with:

    emacsn -cws mail

### Running no name daemons

A vanilla, no-name, daemon - the old fashioned way, not the Chemacs way.

    emacs --daemon &
or
    emacsn -d

Doom emacs daemon with the regular doom profile.

    emacs --with-profile doom --daemon &
or
    emacsn -dp doom
    

## The emacsn script

There have already been a number of examples of emacsn usage so you
are probably getting the idea. Its a very old script, and works well.
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

It knows how to run any elisp function on startup, 
it runs `mu4e` or my `main-window` function to set up emacs in a 
standard configuration for a project. 
It can also choose different Chemacs profiles. 
Creating multiple daemons and using them by name is easy.
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

The __emacsn__ script has extensive help and a lot of options. 


## Summary

I hope that this is a useful project for folks. It has changed the way
I manage my emacs installs, and it has given me an easy way to
explore other Emacs configurations which is an amazingly good
way to find new features and ways of doing things.

I am open to PRs, so if you have something you'd like to add or
suggest, please do.
