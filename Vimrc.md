My Vimrc
========

General
-------

This git repository is for storing and backing up my vimrc

Install
-------

```sh
wget https://raw.githubusercontent.com/chrisdean258/vimrc/master/vimrc -O $HOME/.vimrc
```

### Install Notes

On first opening up vim [Syntastic for Vim](https://github.com/vim-syntastic/syntastic) will be installed.
An [auto-update script](https://github.com/chrisdean258/vimrc/blob/master/fetch_vimrc.sh) will also be installed.
Code for this is embedded in the vimrc. The update script will run approximately every 7 days (only when you open vim).
It can be found at $HOME/.vim/auto\_update/fetch\_vimrc.sh


Notes
-----

### NORMAL CONFIGURATION SETTINGS
This section contains what I consider to be some of the most modified areas of vim settings. This area will not change frequently so the auto update script should be very stable in this area.

### UNIVERSAL CONFIGURATION SETTINGS
This section contains more settings but I cannot gaurantee they will be as stable ar Normal Configuration.
- Includes syntastic sourcing and installation as well as various settings for it.
- Includes some higlight settings used later on

### UNIVERSAL MAPPINGS
This section contains mappings available in every file opened in vim

- Mapleader is set to space
- Localmapleader set to backslash

#### Insert Mode
- jk set to a version of escape
  - Actually a function because it makes more sense
  - Also Jk and JK
- \<S-tab\> (shift-tab) filename autocomplete

#### Normal Mode
- s to insert single character
- S (capital S) to append single character
- j and k set to viually move by line rather than by absolute line
- \- (minus) moves a line down
- _ (underscore) moves a line up
- \<leader\>g Indent an entire file
- \<leader\>ev edit vimrc file
- \<leader\>sv source vimrc file
- \<leader\>s% source current file (useful for vim development)
- \<leader\>o add line below
- \<leader\>O (capital O) add line above
- \<c-l\> (control-l) revomes higlight and reloads buffer

##### Wrapping
- Section under continuing development
