Synesthesia
===========

This is a website revolving around a function that converts user-provided images into piano compositions.

Installing
==========

Mac OS X:

To set up the site, first make sure you have Homebrew installed:

```
> ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
```

Then download the fluid soundfont and copy it to the shared directory. If you have wget, you can skip the first line.

```
> brew install wget
> brew install imagemagick
> brew install lame
> brew install fluidsynth
```

Then clone into the git repository, and migrate/seed the database, and start the server:

```
> git clone https://github.com/thinkpad20/synesthesia.git
> cd synesthesia
> bundle install
> rake db:migrate
> rake db:seed
> rails s
```

Then go to `localhost:3000` in your browser, and enjoy!

Ubuntu:

The instructions are largely the same as above. However, instead of calls to `brew`, you can install everything you need with the following command:

```
sudo apt-get install git build-essential git-core curl nodejs libmagickcore-dev libmagickwand-dev libpq-dev fluidsynth lame imagemagick 
```

Next, clone into the repository and follow the same steps.
