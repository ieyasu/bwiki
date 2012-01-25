Features
--------

- c2.com style WikiWords to name pages
  - need to handle (de-)pluralization properly
- markdown + textile-inspired table syntax
- search
- diff
- view old version
- edit
- link backs
- preview
- delete page
- view deleted
- undelete
- image upload
- \[...\] for TeX syntax math
- http:// and ftp:// URLs get auto-linked
- auto-generated table of contents
- git as page storage
- customizable with default header/footer/sidebar/style files

Gollum: https://github.com/github/gollum


Page Linking
------------

By default, bwiki uses WikiWords (roughly, spaceless CamelCase phrases) to automatically link wiki pages.  Plurals are detected with simple rules and de-pluralized.  For flexibility, will use Gollum-style page links:

    [[My Page]]

Which will link to the "My-Page" wiki page.  Spaces and slashes will be replaced with dashes.  To override the link text, use the syntax:

    [[Link Text|My Page]]

This syntax, being explicit will not get de-pluralized.


Git Repository Structure
------------------------

