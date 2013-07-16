Nifty Templates
===============

A collection of templates to DRY up your Rails project creation.

## Description

Nifty Templates is a recipe collection for developers who prefer building and maintaining their own library of Rails templates. It's based on the awesome [RailsWizard](http://railswizard.org/) which you should definitely check out first if you're new to Rails templates and/or just want to get started quickly.

The [default template](default.rb) installs gems that I rarely start a Rails project without, so if you find some of your favorites there, the recipes could be a nice foundation for you to build upon. I created Nifty Templates to achieve two things in particular, so check if these sound like benefits to you:

* Install [Spork](https://github.com/sporkrb/spork) and other [Guards](https://github.com/guard/guard/wiki/List-of-available-Guards) without manually fiddling around with `Guardfile` and `spec_helper.rb`
* Have a nice, readable `Gemfile` with gem groups so that instead of

    ```ruby
    gem "some_gem", ">= 1.2", :group => :development
    gem "another_gem", :group => :development
    ```

  you'll see

    ```ruby
    group :development do
      gem 'some_gem', '>= 1.2'
      gem 'another_gem'
    end
    ```

## Requirements

Depending on the recipes you intend to use, you may need to have these installed (some commands are OS X specific):

    gem install request-log-analyzer reek
    gem install powder && powder install
    brew install graphviz imagemagick phantomjs

Here we used [Homebrew](http://mxcl.github.io/homebrew/) but any package manager will do.

Nifty Templates have been successfully tested with the following setup:

* __Ruby:__ 2.0.0, 1.9.3
* __Rails:__ 3.2.13, 3.2.11
* __Mac OS X__: 10.6.8
* __Growl:__ 1.2.2
* __Heroku stack:__ Cedar

If you're having problems, first check that your database is up and running. Secondly, if you use [Growl](http://growl.info/) and your version differs from mine, you'll need to edit the recipe accordingly (I had to lock the gem version on my system).

## Installation

You can use the repo directly or clone it locally:

    git clone https://github.com/kimlindholm/nifty-templates.git

## Usage

1. Edit [default.rb](default.rb) by first commenting out all recipes and add the ones you need. I suggest testing step 3 after each added recipe.

2. Inside the same file, edit preferences (see below) to match your system and personal likings.

3. Create a new Rails app inside your project directory using the default template:

    ```
    rails new <app_name> -T -m nifty-templates/default.rb
    ```

    (Option -T skips creating unnecessary Test::Unit files)

4. You can apply recipes to an existing project as well. Inside your app directory:

    ```
    rake rails:template LOCATION=../nifty-templates/utilities.rb
    ```

    If you get error _"Could not find gem..."_, try running ``bundle install``.

### Preferences

* __database__: ``"postgresql"``, ``"oracle"``, ``"mysql"``, ``"sqlite3"``, ``"frontbase"`` or ``"ibm_db"``
* __create_database__: Create database automatically? ``true`` or ``false``
* __unicorn_workers__: The amount of Unicorn worker processes, 2-4 are sensible defaults
* __ruby_version__: If you're using RVM and want to force a specific Ruby version, define it here
* __gemset__: If you're using RVM and want to force a specific gemset, define it here
* __doorcode__: 3-6 digit PIN code to protect your app in production or staging, default is __*12345*__
* __heroku_name__: App name in Heroku, default value attaches a random number, e.g. ``my-new-app-259``
* __heroku_ruby_version__: Instruct Heroku to use a specific Ruby version
* __heroku_staging__: Create a staging deployment, e.g. ``my-new-app-259-staging``? ``true`` or ``false``

Don't worry about options you don't need, simply omit a recipe and related preferences will be ignored.

## Workflow with Default Template

Here's my workflow on OS X using Pow and Heroku.

1. From a terminal, change to your project directory.

2. Assuming app name __MyNewApp__, create a new project:

    ```
    rails new my-new-app -T -m nifty-templates/default.rb
    ```

3. Change to your app directory and start Guard: ``bundle exec guard``.

4. Command ``rake app:browser`` opens all project tabs in default browser (OS X only):
    * ``http://my-new-app.dev`` (Application)
    * ``http://my-new-app.dev/coverage`` (Test coverage)
    * ``http://my-new-app.dev/brakeman`` (Security report)
    * ``http://my-new-app.dev:3500`` (JavaScript tests)
    * ``http://my-new-app.dev/metrics`` (Rails Best Practices report)
    * ``http://my-new-app.dev/performance.html`` (Request-log-analyzer report)
    * ``http://my-new-app.dev/__rack_bug__/bookmarklet.html`` (Toggle Rack::Bug diagnostics)
    * ``http://doc.dev:8000/docs/frames/`` (YARD documentation)

5. Two of the tabs are initially empty. Create a Rails Best Practices report with ``rake app:metrics`` and Request-log-analyzer report with ``rake app:performance``.

6. Run ``reek app lib`` to find any code smells that require refactoring.

7. Once you have added some models, ``rake erd`` creates an Entity-Relationship Diagram, __ERD.pdf__.

8. Push changes to Heroku with ``rake [production|staging] deploy``, type ``heroku open`` and enter the PIN code you set in preferences.
