[//]: #(README.md)


## TODO
### NixOS configuration
- Set default apps for different file types (including EDITOR).
- Fix in NixOS kitty's exit confirmation on Super+X.
- Automate NixOS garbage collector to run once per week, maybe on sundays.
- Set NixOS config for GSR replay to run as script, only when games are running. I have OBS for normal recordings.
- Add automatic SSH key generation for github, making Dotfiles then pull via SSH.
- Find a way to make VSCodium compatible with Jupyter Notebooks.
- Try to make ge-proton-bin be installed directly with steam, avoiding protonup-qt. This can be achieved by testing games on the newest proton GE, instead of 9-24.
- (Maybe) Add keyring to insert github SSH once per session.
- (Linux 7.2) Setup webcam.

### Dotfiles
- Use toml's meta name as entry name in quickshell theme listview.
- Configure Hyprland dotfiles in such a way that you don't have to rewrite a whole block just for one setting.
- Add orbit menu for favourite apps.
- Add yazi bookmarks (or the equivalent goto).
- Compact launcher and new topbar into single transforming bubbles.
- Make lock screen (not login, lock).
- Fix control center 1st app always opening on Workspace 1.
- Implement secondary actions on launcher (right-click/shitf+Enter), like desktop files provide.

---

## Game launch options
### Geometry Dash
`WINEDLLOVERRIDES="xinput1_4=n,b" %command%`

### Rocket League
`WINEDLLOVERRIDES="winmm=n,b" __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia gamemoderun %command% -NoIPv6`

### The Witcher 3
`__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only PROTON_ENABLE_WAYLAND=1 DXVK_ASYNC=1 PROTON_ENABLE_NGX_UPDATER=1 gamemoderun %command% --launcher-skip`
