Synesthesia
===========

This is a website revolving around a function that converts user-provided images into piano compositions.

Installing
==========

To set up the site, first make sure you have Homebrew installed:

```
> ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
```

Then download the fluid soundfont and copy it to the shared directory. If you have wget, you can skip the first line.

```
> brew install wget
> wget http://www.musescore.org/download/fluid-soundfont.tar.gz
> tar -xzf fluid-soundfont.tar.gz
> sudo mkdir /usr/share/sounds/sf2
> sudo mv fluid-soundfond.tar.gz /usr/share/sounds/sf2
```

Then clone into the git repository, and migrate/seed the database, and start the server:

```
> git clone https://github.com/thinkpad20/synesthesia.git
> cd synesthesia
> rake db:migrate
> rake db:seed
> rails s
```

Then go to `localhost:3000` in your browser, and enjoy!
