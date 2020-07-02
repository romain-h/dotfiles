# Dotfiles

![](https://i.imgur.com/PC5A6IL.png)

## Installing

I used [GNU Stow](https://www.gnu.org/software/stow/) to manage all symlinks.
Running `./install.sh init` should install everything on macOS.

## Custom scripts

+ `bin/clipper.sh` - `bash` - Use `reattach-to-user-namespace with `pbcopy` on
  macOS and `nc` (port 8377) on Unix.
+ `bin/cluhouse-flow` - `python` - Get Clubhouse in progress card id
+ `bin/cvpn` - `bash` CLI connect to custom VPN on AWS.
+ `bin/npm-which` - `zsh` - Detect local or global binary installed by NPM.
+ `bin/safe-reattach-to-user-namespace` - `bash` Ensure tmux works with
  `reattach-to-user-namespace`.
+ `bin/serve` - `Go` - Serve folder with HTTP auto-reloading [https://github.com/romain-h/serve](https://github.com/romain-h/serve)
+ `bin/shinatra` - `bash` - Simple webserver - `shinatra [port] [response]`
+ `bin/spotify_client` - `bash` - Spotify CLI to list recent device and songs.

