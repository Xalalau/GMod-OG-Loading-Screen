To upload and update a loading screen addon, we actually need a custom GMad build with a wider files whitelist and SteamCMD to workaround gmpublish restrictions.

As it's a complicated process, I decided to write these instructions down. I hope to help other people to achieve the same result as mine.

Enjoy!

# Compile a custom GMad

If you don't want to create your own binary, I included mine in the "update/bin" folder, so ignore this section entirely.

## To compile GMad:

### Common steps:

1. Clone gmad into the update folder (https://github.com/Facepunch/gmad.git)
1. Clone bootil inside gmad (https://github.com/garrynewman/bootil)
1. Add the following lines to ``gmad/include/AddonWhiteList.h``:
```lua
			"html/*.html",
			"html/*.wav",
			"html/*.png",
			"html/icons/*.png",
```

### On Windows (VS 2017)

1. Copy premake5.lua from this repository https://github.com/AnthonyFuller/gmad and place it next to premake4.lua
1. Change all #include "lib.h" to #include "../include/lib.h" in GMad's src folder files
1. Open a terminal and change the directory to "gmad"
1. Create the solution files running .\premake5 vs2017
1. In VS2017, retarget the solution to the current windows sdk (Right click on the solution and redirect solution)
1. Compile selecting Release
1. The binary will be placed inside the bin folder
		
### On Linux (Ubuntu)

1. sudo apt install premake4
1. open the terminal and cd to gmad/bootil/projects
1. premake4 gmake
1. cd linux/gmake
1. make bootil_static # (The file gmad/bootil/lib/linux/gmake/libbootil_static.a will be compiled)
1. change the directory back to gmad
1. premake4 --outdir="bin/" --bootil_lib="bootil/lib/linux/gmake" --bootil_inc="bootil/include" gmake
1. make GMad
1. The binary will be placed inside the bin folder

# Creating the gma

1. In the terminal, change the directory to our update/bin folder (If you're going to use my binaries)
1. Create the gma with normal gmad commands. E.g.:
```
.\gmad.exe create -folder "E:\Games\SteamLibrary\steamapps\common\GarrysMod\garrysmod\addons\loadingscreen" -out "D:\somefolder\loadingscreen.gma"
```

# Uploading the addon with SteamCMD

1. Download SteamCMD from https://developer.valvesoftware.com/wiki/SteamCMD
1. Open SteamCMD
1. Login with ``login username password``
1. Edit our ``update_ogl.vdf`` file with all the changes and correct directories
1. Upload or update the addon with ``workshop_build_item update_ogl.vdf`` (change the path to update_ogl.vdf)
1. Run ``quit``

That's it!
