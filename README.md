# Dotfiles

Hold my dotfiles for easier deployment to new environments


# My Vimrc

## General

This git repository is for storing and backing up my vimrc

## Install

```sh
wget https://raw.githubusercontent.com/chrisdean258/Dotfiles/master/universal/vimrc -O $HOME/.vimrc
```
or
```sh
curl https://raw.githubusercontent.com/chrisdean258/Dotfiles/master/universal/vimrc > $HOME/.vimrc
```

### Install Notes

On first opening up vim [Syntastic for Vim](https://github.com/vim-syntastic/syntastic) will be installed.


## Notes

### CONFIGURATION SETTINGS
Section contains my personal preferences for settings that should be set.

### HIGHLIGHT SETTINGS
Enhances the awesomeness of the elflord colorscheme

### PLUGIN SETTINGS
Since I only use Syntastic this just contains the flags I use when using it.
This changes and contains some weird stuff that has to do with research (mainly the eo stuff).

### UNIVERSAL MAPPINGS
This section contains mappings available in every file opened in vim

**Mapleader is set to space**

**Localmapleader set to backslash**

#### Normal Mode

|          Keys          | Action                                                                             |
|------------------------|------------------------------------------------------------------------------------|
| *j*                    | move visually up                                                                   | 
| *k*                    | move visually down                                                                 | 
| *s*                    | insert single character                                                            | 
| *S*                    | append single character                                                            | 
| *.*                    | remapped to allow for repeatable commands. I am working on removing this necessity | 
| *_*                    | move a line up                                                                     | 
| *-*                    | move a line down                                                                   | 
| *\<leader\>g*          | Indent an entire file                                                              | 
| *\<leader\>f*          | Format an entire file <b> *UNDER DEVELOPMENT\* </b>                                | 
| *\<leader\>o*          | Insert a new line below                                                            | 
| *\<leader\>O*          | Insert a new line above                                                            | 
| *\<Ctrl-l\>*           | Turn off search highlighting and redraw screen                                     | 
| n,N,/,?,#,\*           | Turn on search highlighting and do normal action                                   | 
| *\<Alt-dir\>*          | Jump through error list                                                            | 
| *\<leader\>w*          | Call [wrap function](#wrap-function)                                               | 
| *\<Shift-dir\>*        | change the size of a split                                                         | 
| *\<leader\>h,j,k,l*    | Jump to split directionally                                                        | 
| *\<leader\>\<leader\>* | Jump to next window                                                                |
| *\<Tab\>*              | Go to next tab                                                                     |
| *\<Shift-tab\>*        | Go to previous tab                                                                 |
| *\<leader-tab\>*       | Open new tab                                                                       |
| *\<leader-p\>*         | Paste from system keyboard (follows case)                                          |
| *Y*                    | Yank to the end of the line                                                        |
| *\<localleader\>\\\*   | Comment in or out a line or lines                                                  |

#### Insert mode

|          Keys          | Action                                                                             |
|------------------------|------------------------------------------------------------------------------------|
| *jk*                   | exit insert mode (case insensetive)                                                | 
| *\<Tab\>*              | Tab completions (also popup menu navigation)                                       | 
| *\<Shift-tab\>*        | File name completions (also popup menu navigation)                                 | 
