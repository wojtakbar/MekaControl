# MekaControl
CC: Tweaked programs for managing a full Mekanism Fission Reactor setup (including boiler, turbine, and induction matrix) with emergency switches to scram the reactor if something is going wrong.

# Installation
There aint a pastebin link, if you dont use vscode cc:t extension, then just copy [oneliner](./mekacontrol-oneline.lua) (it's less reliable), type `edit mekacontrol.lua` and past code, ctrl - save - run. Suggesting making startup.lua with `shell.run("mekacontrol.lua")`. Or `wget` [shortened version](https://raw.githubusercontent.com/wojtakbar/MekaControl/refs/heads/main/mekacontrol-shortened.lua) (it's more reliable) and edit startup.lua.

# Credit
Some code in the startup script was copied from ShaeTsuPog's popular bigger reactor control script, because it served this purpose well. Shoutout to him and his amazing reactor control script.
