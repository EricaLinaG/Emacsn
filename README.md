# Emacsn

## A system for managing multiple Emacs configurations.

This is just some __Makefile__, a script and some elisp to create an easy system of 
installing and managing multiple emacs installations from github. 
This system uses [Chemacs2](https://github.com/plexus/chemacs2) for its Emacs
boot loader. I recommend at least reading through it's __Readme__ even though Emacsn
takes care of everything, you'll want to know eventually.

Chemacs likes Emacs configurations which install in _.emacs.d_ and use an _init.el_.
Most configurations do this.

### Why

This just grew organically over time out of the _Makefile_ I used
to install my Emacs configuration. 

Have a need, fill a need, scratch an itch, sure would be nice if..., have some fun.

That's how atrocities in __Make__ are born.


Try out other Emacs configurations safely and easily.

If you have ever ruined your emacs setup and had to go back, or fix it in less than
ideal circumstances, then this could also be your solution to accidental 
emacs startup breakage. 

You just want to try out a feature without breaking your daily driver.

It also installs your emacs for you. As well as anyone else's.

It makes your Chemacs profiles for you.  It snapshots them. You can edit them,
you'll have to actually. So far its only additive.

Your custom profiles can be persisted for subsequent installs.

All the data/code is template driven and easy to change. 

It maintains a library of installable Emacs configurations.

Adds a regular and server entry for each installed configuration.

Its super easy to make a new profile/configuration entry out of some new repo you found.

Makes a dev and stable install for the default configuration.

Provides a test profile and commands to do fresh test installs.

The default profiles, `dev, stable, test`, can be easily reassigned 
and rebuilt with any configuration.

Each installation automatically gets two boot profiles. <name> and <name>-server.

### emacsn - the script

This is a shell script I have had for many years which just serves to give 
a little bit of ease to the emacs command line interface.

### The Default Configuration

The default configuration is mine; [Ericas-Emacs](https://github.com/ericalinag/ericas-emacs).
If your configuration is set up with an init.el and goes in ~/.emacs.d you are golden
and can use yours as the default with `make install-new-default ...`

### 3 profiles for the default configuration

The default configuration gets 3 installs, __stable__, __dev__ and __test__.
test is empty, and therefore vanilla gnu to start with.

There is `make test-install` which will make a fresh test install in the test profile.
This is to make sure what is pushed installs and 
runs cleanly before updating the stable installation with `make stable-update`.

## Backups
__Chemacs2__ uses a file _~/.emacs-profiles.el_ to find out what it can boot 
emacs into. Each Emacsn keeps its own _.emacs-profiles.el_ and creates a link
to _~/.emacs-profiles.el_.

Each time Emacsn it changes the _.emacs-profiles.el_ file it
makes a timestamped copy of _.emacs-profiles.el_ in _dot-backups/_ 

You may choose to git ignore the _dot-backups/_ folder, or keep it backed up 
to git. Your choice.

In a similar way, on install, _~/.emacs_, _~/.emacs.d_ and ~/.emacs-profiles.el, if
it is a file, will be timestamped and copied to that Emacsn's _dot-backups/_ folder.

## Super Quick Guide
It really is mostly a Makefile.


###  git clone ... /Emacsn.git;   cd Emacsn;    

    - `git clone https://gitub.com/EricaLinaG/Emacsn.git`
    - `cd Emacsn`
    - `make help` Get help

    - `make status` The current Emacsn status.

If your emacs setup works in .emacs.d with an init.el you are
probably good to go with setting your default to that. 

If you want to make your emacs the default now do these two things.

  - `make install-base status`
  - `make install-new-default name=my-profile-name repo=The-url-to-my-emacs-repo`

You can also assign any of the installable configs as default.

    `make assign-default name=doom`
    `make install-defaults`

otherwise do `make install`.

#### Try it out
  - `emacs`
  - `emacs --with-profile dev`
  
#### Add a new repo for now or later.

You can add yours or any emacs repo as an install profile at any time.
Then install it later.

  - `make new-config name=my-profile-name repo=The-url-to-my-emacs-repo`
  - `make my-profile-name` - to install it.

You can add a profile and install it all at once with this.

  
  - `make install-new name=my-profile-name repo=The-url-to-my-emacs-repo`
  
### Get the Status and see some things.
  - `make status`
  - `make show-profiles`
  - `make show-doom`
  - `make help`
  - `M-x describe-variable chemacs-profiles`
  - `cat .emacs-profiles.el`
  - `cat ./emacs-profiles-template.el`
  - `make print-optional-configs`

After that you may wish to do:
  - `make space doom from-hell`
    - `emacsn -p doom`
  - Do not do: `emacs --with-profile from-hell` How bad could it be?

Do try:
  - `make test-install`
  - `make stable-update`
  - `make from-hell-remove`

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

### Installing the base and default profiles.

There are a few paths to take here. Install the basic stuff which will
give you Ericas-Emacs as the default emacs, or if your emacs install
has an init.el and normally lives in .emacs.d you can set it to the 
default now. Or Use one of the other available configurations as default.

#### Choice 1:  Take whatever is there
Install the base as well as the default profiles. It can all be changed later
with `install-new-default`.

    `make install status`

#### Choice 2: Make your emacs the default.

  - `make install-base status`
  - `make install-new-default name=my-profile-name repo=The-url-to-my-emacs-repo`
    - This can be broken into steps if you wish.
      - `make new-config name=my-profile-name repo=The-url-to-my-emacs-repo`
        - Optionally edit the new profile entry in _configurations.mk_.
      - `make assign-default name=my-profile-name`
      - `make reinstall-defaults`

#### Choice 3: Change to another config for the default.

      - `make assign-default name=from-scratch`
      - `make install-defaults`
      or if you already have some default installs.
      - `make reinstall-defaults`

### Get the status of Emacsn.

    `make status`
    `make show-profiles`
    `make help`

    `make status` is a nice report of things in Emacsn.

Install optional Emacs configurations. 
Maybe install Doom-emacs, Spacemacs and Emacs-from-scratch

    `make doom space from-scratch`

At this point you are ready to go. Running Emacs will give you your
default __stable__ configuration. You can also specify them specifically

    emacs --with-profile dev
    
Or
    
    emacsn -p dev

## Removing installations

  - Step 7: Optional, remove stuff.

```sh
    make from-hell-remove

    make rm-optional

    make rm-defaults

    make rm-installs
```

But you can just do an `rm -rf ...` if you want.
Don't forget to edit your _.emacs-profiles.el_

Rinse - Repeat, Have fun.


## Multiple Emacsn

I'm not sure this is useful, but it was part of the evolution and I needed it 
to test all of this. So here it is.

The command `make new-emacsn path=...` will create a fresh Emacsn at path.  

    - `make new-emacsn path=../new-place`
    - `cd ../new-place`

For multiple Emacsn to work together it is not necessary to do another install. 
It is only necessary for the Emacsn to re-link to your ~/.emacs-profiles.el in order to
work. `init` creates an Emacsn with nothing but a vanilla __gnu__ profile, 
along with __test__ but without his friends __dev__ and __stable__.

    `make init` 

This will also initialize a new .emacs-profiles.el and link it.

Each Emacsn keeps its Chemacs profiles locally and links _~/.emacs-profiles.el_ to
the one located here. This makes it super easy to switch to a different Emacsn.
When you are ready `make relink-profiles` re-links the current Emacsn. 

    `make relink-profiles`
    
    
## Emacs configurations

These are defined in
 [_configurations.mk_](https://github.com/EricaLinaG/Emacsn/blob/main/configurations.mk).
 This is loaded by the main _Makefile_
 
There is a target rule to help with making new configurations. It does assume
basic generic functionality, but that is usually enough.

      `make new-config name=my-profile-name repo=The-url-to-my-emacs-repo`
      `make status`

Here is the template the makefile provides.

### The Template

The template used by `make new-config` is _config-template.txt_
and it's profile name is gnu and it looks like this.


```make
## gnu
optional-configs += gnu
gnu-repo         = your-repo-url
gnu-repo-flags   =
gnu-install-cmd  = $(emacs-nw-profile) gnu $(kill-emacs)
gnu-update-pull  = $(git-pull)
gnu-update-cmd   = $(generic-update-cmd)
## gnu
```

This profile definition is the most common so far. I am
not sure it is a 100% fit always, but it seems pretty good
and at least harmless. 

  - The install does a git clone your-repo-url
    - Runs emacs -nw with the __gnu__ profile 
      - while giving it the function call for it to kill its self.
  - The update changes directories to the configuration and then;
    - does a _$(git-pull)_ ie. `git pull origin`
    - then it does `generic-update` which runs an elisp script to update packages.

### Some Examples

They are all about the same and I hope they just make sense.
Here is the one for __Prelude__.

After doing a `make status` you might be curious what all those are.
You can see them like this. `make show-<profile>` ie.

`make show-prelude`

```make
    optional-configs    += prelude
    prelude-repo        = $(git-hub)bbatsov/prelude.git
    prelude-repo-flags  =
    prelude-install-cmd = $(emacs-nw-profile) prelude $(kill-emacs)
    prelude-update-pull = $(git-pull)
    prelude-update-cmd  = $(generic-update-cmd)
```

  - It first adds itself to the list of optional-configs.
  - Then we define the github uri.
  - Define any clone flags so we can get branches if we like.
  - The install command to let the emacs install get all of it's packages
  - The pull command, Usually, its either __$(no-pull)__ or __$(git-pull)__
    which is __true__ and __git pull origin__ respectively.
  - The update command to let emacs update its packages.
    The update-cmd can be __$(no-update)__, __$(generic-update-cmd)__ 
    or another update command.

The extra configs/profiles can be installed like so. You may install them and 
remove them, and add to them as you like. 

```shell
    make doom 

    # or whatever
    make doom space uncle-daves prelude
```

Emacsn modifies  __.emacs-profiles.el__
as you add new profile installs. Your profiles in ~/.emacs-profiles is
a link to the one here.

Note: _Emacsn is additive, so you can end up with duplicated
definitions which need to be cleaned up.
The most recent are at the top. Its generally only slightly annoying._


### Profiles which have an install and/or update functionalities.

Doom and Ericas are the only configurations which provide an install function.
It does make things all a little bit nicer. They can interact as needed and exit
when done. We do our best for the rest. Somehow it does feel right to just say
hey! you over there, install all your stuff, put it over there, turn out the 
lights when your done. ok ?

```make
    optional-configs   = ericas
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
    optional-configs  += space
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
    optional-configs  += doom
    doom-repo         = $(git-hub)/hlissner/doom-emacs.git
    doom-repo-flags   =
    doom-install-cmd  = $(emacs-home)/doom/bin/doom install
    doom-update-pull  = $(no-pull)
    doom-update-cmd   = $(emacs-home)/doom/bin/doom update
```

### Configurations with no install function

These configurations just run emacs the first time to install all of
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
It installs/updates all-selected-packages and then exits.
It assumes packages are installed in _elpa_.

These configurations usually do not have an install function 
either so on install we just run them. 
They download and install all their packages. If we want them to
wait for us, we leave off the __$(kill-emacs)__.

Their install command is usually this, add -nw if you want in terminal.

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
optional-configs        += uncle-daves
uncle-daves-repo        = $(git-hub)/daedreth/UncleDavesEmacs.git
uncle-daves-repo-flags  =
uncle-daves-install-cmd = $(emacs-nw-profile) uncle-daves $(kill-emacs)
uncle-daves-update-pull = $(git-pull)
uncle-daves-update-cmd  = $(generic-update-cmd)
```

    
### Summary
To add a new profile to
 [_configurations.mk_](https://github.com/EricaLinaG/Emacsn/blob/main/configurations.mk)
is easy, `make new-config name=some-name repo=some-repo`.
To add it and install it do this;

`make install-new name=some-name repo=some-repo`.

Adding it to the optional-configs  gives it all the make targets
it needs for installation, update, and removal.

The profile's install command is frequently just to run emacs with that profile.
Exceptions are Doom Emacs, and Ericas-Emacs.

The update changes directories to the installation, maybe does a `git pull`,
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

#### Profiles and Configs.

Chemacs calls it's boot entries '_profiles_'. I call the record which defines 
a profile a '_config_'. There is a direct relationship between the two. Installing
a configuration will result in a _profile_ entry of the same name. So profile-name can
also be the name of a configuration, but not necessarily.

There are always at least two profiles for each installed configuration. One as 
the name of the configuration the other as configuration-name_-server_ 

### Persistent profile definitions

When a profile is installed it will automatically
add in any pre-defined server profiles or alternative invocations which apply.

_Emacsn_ uncomments lines beginning with `;;<profile>` from .emacs-profiles.el._
This allows more complex profiles to be persistent across installs by
adding them to the _emacs-profiles-template.el_.
With the proper comment prefix the profile will install its self.
Emacsn does also create a server profile entry for each installation.

Persist your code by putting them back into 
[emacs-profiles-template.el](https://github.com/EricaLinaG/Emacsn/blob/main/emacs-profiles-template.el). This file is the basis for the next fresh install of Emacsn.

Modify _.emacs-profiles.el_ to add new ones or change their names.

You can of course just check your _.emacs-profiles.el_ in with everything else.
That does get tricky if you have more than one Emacsn.

### Emacs Boot entries and installations.

For each installation profile installed there are two chemacs entries made,
one as the name given, and another with a _-server_ prefix, which is a server.

#### How to see what is there.

  - `make status`
  - `make show-profiles`
  
Their definitions can be seen with show-<name>
  - `make show-<config-name>`

#### Adding new boot profile entries

It is very easy to add new entries which point at other installations,
although I'm not sure why you would.

    - make insert-profile name=foo profile=stable
    - make insert-server-profile name=foo-server profile=stable

#### Emacs boot choices 

See the commands above for your current reality.

Each installation automatically has 2 profiles. One to run straight
emacs the other to run it as a server. Its server socket name will 
be the same name as the configuration.

_Note: additional profile entries fall under the installed profile they reference._

  - Default Install Profile
    - __stable__ 
    - __default__ 
      - Servers
        - __stable-server__
        - __exwm__
        - __mail__
        - __common__
    - __dev__ 
      - __dev-server__
    [ericas-emacs](https://github.com/ericalinag/ericas-emacs)
    - __test__ 
      - __test-server__
    
  - Gnu profile is an empty install.
    - __gnu__ 
      - __gnu-server__

  - Optional Profiles
    - __doom__ is [doom-emacs](https://github.com/doomemacs), 
      - __doomdir__ is __doom__ with a profile directory.
      - __doomdir-server__
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
