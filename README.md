# evil-fcitx.el
**Fcitx toggling helper for Emacs Evil-Mode**

## Brief

Vim-like modeling editing is awesome, it uses __states__ to provide a large keystroke space(and save your pinky at the same time). However, the aproch is really unfriendly to non-English users who uses an IME, they have to toggle IME again and again when jumping from state to state.

Using fcitx-remote to automatically toggle IME, evil-fcitx could be one more reason for non-English emacs users who uses fcitx IME to taste the power of modeling editing and save their pinky.

Inspired by fcitx.vim, but IME-state is global for now, which means you better back to evil-normal-state before jump to another buffer. To be improved later.

See also [fcitx.vim](http://www.vim.org/scripts/script.php?script_id=3764)

BTW, Evil Mode does implement something like evil-fcitx (read from evil-core.el :func evil-(de)active-input-method). However, it just work for IMEs which are embedded in Emacs, those IME are not widely accept by Emacs users as far as I know.

## Installation

Requirement: Emacs Evil-mode, Fcitx with __fcitx-remote__ cli tool

The easy way: just copy and paste evil-fcitx.el into .emacs file.

The emacs way: 
~~~
(add-to-list 'load-path "path/to/evil-fcitx")
(require 'evil-fcitx)
~~~

## Usage

### Basic:

Just type around, evil-fcitx would be invoked as you enable IME in __insert-state__.

P.S.Type __C-q__(or else in variable __back-to-default-state-key__) when you quit insert state with IME on, and don't want to type English next time you enter insert state.

### Mode-line Indicator:

There is also a Evil-like mode-line indicator that could be manully add by user. Mode-line format is stored in the variable __mode-line-format__, which could be customize by

~~~
M-x customize-apropos RET mode-line-format RET
~~~

You shall see a long list, representing the value of mode-line-format. Adding the variable __IME-state-mode-line-tag__ to somewhere you like, say, next to the evil-mode-line-tag like I did.

~~~
(...... mode-line-position evil-mode-line-tag =>IME-state-mode-line-tag<= ......)
~~~

And that's it.

## TODOs

The script would grow as using it. I wish it could be a Emacs front-end of Fcitx someday.

* State record for every single buffer
* Adding the mode-line indicator automatically
* Support search non-ASCII char/string in normal state. i.e."f 中", "t 文", "/ にほんご"
..* Support more than two languages.
