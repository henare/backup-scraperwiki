Backup ScraperWiki
==================

This is a backup of all my scrapers on ScraperWiki. I made this because
ScraperWiki went down for quite a while the other day and I realised
I've put enough work into my scrapers that it would be a reasonably
significant loss if they just disappeared one day (not that I think the
fine folk at ScraperWiki would let that happen but you never know).

What does it do?
----------------

It downloads the code for all scrapers for a particular user and commits
them onto the master branch of this repository.

First install the Gems using Bundler: `bundle`

You need to set your ScraperWiki username in the `SCRAPERWIKI_USERNAME`
environment variable, e.g. run the script like so
`SCRAPERWIKI_USERNAME=henare bundle exec ./backup_scraperwiki.rb`

There's a separate branch that just has the script so if you'd like your
own copy, you can clone this repository and create a new branch from the
`script_only` branch.
