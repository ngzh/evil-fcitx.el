# evil-fcitx.el
**Fcitx toggle helper for Emacs Evil-Mode**

## brief

Vim-like modeling editing is awesome, it uses *states* to provide a large keystroke space(and save your pinky at the same time). However, the aproch is really unfriendly to non-English users who uses an IME, they have to toggle IME again and again when jumping from state to state.

Using fcitx-remote to automatically toggle IME, evil-fcitx could be one more reason for non-English emacs users who uses fcitx IME to taste the power of modeling editing and save their pinky.

Inspired by fcitx.vim, but IME-state is global for now, which means you better back to evil-normal-state before jump to another buffer. To be improved later.

See also fcitx.vim: http://www.vim.org/scripts/script.php?script_id=3764

## installation

The easy way: just copy and paste evil-fcitx.el into .emacs file.

The emacs way: 
~~~
(add-to-list 'load-path "path/to/evil-fcitx")
(require 'evil-fcitx)
~~~

## usage

Just type around, evil-fcitx would be invoked as you enable IME in *insert-state*. Type *C-q*(or else in variable *back-to-default-state-key*) when you want to get rid of evil-fcitx.

## TODOs

The script would grow as using it. I wish it could be a Emacs front-end of Fcitx someday.

* State record for every single buffer
* Support search command in normal state. i.e."f 中", "t 文", "/ にほんご"
//* Support user to jump between more than two languages.