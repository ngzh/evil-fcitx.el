# evil-fcitx.el
### Fcitx toggle helper for Emacs Evil-Mode

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