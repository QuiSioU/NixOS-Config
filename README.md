[//]: #(README.md)


### Notes
- At the beginning, SSH should be set manually, then clone the NixOS-Config via SSH, and then let rebuild clone Dotfiles via SSH too.

---

## TODO
### NixOS configuration
- Set up UEFI control without Win11 (and set battery limit to 80/85%)
- Set NixOS config for GSR replay to run as script only when games are running (OBS for normal recordings).
- Find a way to make VSCodium compatible with Jupyter Notebooks.
- (Maybe) Add keyring to insert github SSH once per session.
- (Linux 7.2) Setup webcam.

### Dotfiles
- Make workspace topbar part.
- Make connections and system topbar part.
- Replace EWW's user menu with hardware usage (by adding stuff to main pill in topbar).
- Fix visual bugs in launcher and carousel display.
- Improve lock screen visuals.
- Fix control center 1st app always opening on Workspace 1.
- Implement secondary actions on launcher (right-click/shitf+Enter) and QuickApps, like desktop files provide.
- Optmize code for speed and resource consumption.

---

## Game launch options
### Geometry Dash
**GE-Proton9-24**\
`WINEDLLOVERRIDES="xinput1_4=n,b" %command%`

### Rocket League
**GE-Proton9-24**\
`WINEDLLOVERRIDES="winmm=n,b" __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia gamemoderun %command% -NoIPv6`

### The Witcher 3
**GE-Proton10-28** (latest)\
`__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only PROTON_ENABLE_WAYLAND=1 DXVK_ASYNC=1 PROTON_ENABLE_NGX_UPDATER=1 gamemoderun %command%`

### God of War
**GE-Proton10-28** (latest)\
`__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only PROTON_ENABLE_WAYLAND=1 PROTON_ENABLE_NGX_UPDATER=1 gamemoderun %command%`
