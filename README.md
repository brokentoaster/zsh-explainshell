# zsh-explainshell
A Zsh plugin to look up the current cmd line on [explainshell.com](explain.com). 
Uses [lynx](https://lynx.browser.org/) to extract a plain text version of website response.

## Example
[![asciicast](https://asciinema.org/a/BpbD8MZ99PWCE8nQvClUzURXa.svg)](https://asciinema.org/a/BpbD8MZ99PWCE8nQvClUzURXa)

## Current key bindings are as follows

<kbd>CTRL</kbd> + <kbd>E</kbd> , <kbd>CTRL</kbd> + <kbd>E</kbd> ( *E*xplain *E*xplain )
: explain you current command in the current terminal

<kbd>CTRL</kbd> + <kbd>E</kbd> , <kbd>CTRL</kbd> + <kbd>W</kbd> ( *E*xplain in *W*indow )
: explain your current command line in a new tmux split

<kbd>CTRL</kbd> + <kbd>E</kbd> , <kbd>CTRL</kbd> + <kbd>M</kbd> ( *E*xplain just show the *M*anual )
: take the first command on your cuerrent command line and look it up in the standard man files

<kbd>CTRL</kbd> + <kbd>E</kbd> , <kbd>CTRL</kbd> + <kbd>F</kbd> ( *E*xplain in a browser like *F*irefox )
: open the relavent explainshell link for your command line in the systems web browser

Thanks to [explainshell](https://explainshell.com/about) for existing
