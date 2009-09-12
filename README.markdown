Genki
=====

Genki is a fork of [Enki](http://github.com/xaviershay/enki), a Ruby on Rails blogging app for the fashionable developer.

Preferences are for the masses. Any real coder knows the easiest and best way to customize something is by _hacking code_. Because you want your blog to be you, not bog standard install #4958 with 20 posts per page instead of 15. For this you need a _clean, simple, easy to understand code base_ that stays out of your way. No liquid drops and templates hindering your path, no ugly PHP stylings burning your eyeballs.


Quick Start
===========

    git clone git://github.com/nathanhoad/genki.git genki
    cd genki
    git checkout -b myblog # Create a new work branch
    cp config/database.example.yml config/database.yml
    # Edit config/enki.yml and config/database.yml to taste
    
    # Next step needs libxml2 and libxslt1 and their headers
    # On Debian-based systems: apt-get install libxml2-dev libxslt1-dev
    # On Mac OS X: no action required
    
    rake db:migrate
    rake spec
    ./script/server
    # Load http://localhost:3000/admin in your browser

Or for bonus points, fork [Genki at github](http://github.com/nathanhoad/genki/tree/master and clone that instead)


More info
=========

Genki is a compact, easily extendable base for your blog. It does this by being highly opinionated, for example:

 * Public facing views should adhere to standards (XHTML, Atom)
 * /yyyy/mm/dd/post-title is a good URL for your posts
 * Live comment preview should be provided by default
 * Google does search better than you or I
 * You don't need a plugin system when you've got decent source control
 * If you're not using OpenID you're a chump
 * Hacking code is the easiest way to customize something


How it differs from Mephisto
============================

Mephisto is feature packed and quite customizable. It can however be daunting trying to find your way around the code, which isn’t so good if you’re trying to hack in your own features. Enki strips out a lot of the features that you probably don’t need (multiple authors and liquid templates, for example), and focuses on keeping a tight code base that is easy to comprehend and extend.

If you’re converting from Mephisto, be sure to have a look at [Xavier Shay's enki-translator](http://github.com/xaviershay/enki-translator/tree/master).


How it differs from SimpleLog
=============================

Genki embodies much of the philosophy of SimpleLog, but does so in a style that is much more consistent with Rails best practices, making it easier to understand and hack the code.


Contributors, these guys rock
=============================

    git log | grep Author | sort | uniq


License
=======

GPL - See LICENSE

Admin design heavily inspired by [Habari](http://www.habariproject.org/en/).
