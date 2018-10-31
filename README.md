# Dotfiles
Hold my dotfiles for easier deployment to new environments


## My Vimrc

### General

This git repository is for storing and backing up my vimrc

### Install

```sh
wget https://raw.githubusercontent.com/chrisdean258/Dotfiles/master/universal/vimrc -O $HOME/.vimrc
```

#### Install Notes

On first opening up vim [Syntastic for Vim](https://github.com/vim-syntastic/syntastic) will be installed.


### Notes

#### CONFIGURATION SETTINGS
Section contains my personal preferences for settings that should be set.

#### HIGHLIGHT SETTINGS
Enhances the awesomeness of the elflord colorscheme

#### PLUGIN SETTINGS
Since I only use Syntastic this just contains the flags I use when using it.
This changes and contains some weird stuff that has to do with research (mainly the eo stuff).

#### UNIVERSAL MAPPINGS
This section contains mappings available in every file opened in vim

**Mapleader is set to space**
**Localmapleader set to backslash**

##### Normal Mode
- *j* move visually up
- *k* move visually down
- *jk* exit insert mode (case insensetive)
- *s* insert single character
- *S* append single character
- *.* remapped to allow for repeatable commands. I am working on removing this necessity
- *_* move a line up
- *-* move a line down
- *\<leader\>g* Indent an entire file
- *\<leader\>f* Format an entire file ** \*UNDER DEVELOPMENT\* **
- *\<leader\>o* Insert a new line below
- *\<leader\>O* Insert a new line above
- *\<C-l\>* Turn off search highlighting and redraw screen
- n,N,/,?,#.\* Turn on search highlighting and do normal action
- *\<Alt-dir\>* Jump through error list
- *\<leader\>w* Call [wrap function](#wrap-function)
- *\<shift-dir\>* change the size of a split


##### Normal Mode
- s to insert single character
- S (capital S) to append single character
- j and k set to viually move by line rather than by absolute line
- \- (minus) moves a line down
- _ (underscore) moves a line up
- \<leader\>ev edit vimrc file
- \<leader\>sv source vimrc file
- \<leader\>s% source current file (useful for vim development)
- \<leader\>o add line below
- \<leader\>O (capital O) add line above
- \<c-l\> (control-l) revomes higlight and reloads buffer

##### Wrapping
- Section under continuing development
