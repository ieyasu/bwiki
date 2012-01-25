BWiki -- a simple 'opinionated' wiki suiting my druthers
========================================================

BWiki, short for Bishop's Wiki, is a simple wiki which meets my needs.  It uses Markdown with Textile-inspired table syntax for markup and Git for version control.  Pages are auto-linked with 'WikiWords' as in the [original wiki](http://c2.com/cgi/wiki).  Limited page customization is provided for.

Installation
------------

Running
-------

Customization
-------------

Page Linking
------------

By default, bwiki uses WikiWords (roughly, spaceless CamelCase phrases) to automatically link wiki pages.  Plurals are detected with simple rules and de-pluralized.  For flexibility, will use Gollum-style page links:

    [[My Page]]

Which will link to the "My-Page" wiki page.  Spaces and slashes will be replaced with dashes.  To override the link text, use the syntax:

    [[Link Text|My Page]]

This syntax, being explicit will not get de-pluralized.
