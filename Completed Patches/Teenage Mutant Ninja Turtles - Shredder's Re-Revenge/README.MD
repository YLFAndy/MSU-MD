# BUG FIXES
	+ Fixed a hardcoded PAL flag in a couple of VDP calls (caused the core to not run on Spiritualized FPGA/MiSTer MegaCD/a few others). Now a PAL check is done and the VDP PAL flag is not set unless the system is PAL.
	+ Fixed a sprite overrun causing motorcycle sprites to overwrite other sprites on screen (hand flicker/tail pipe flicker)
# NEW FEATURES
	+ CD audio with an accompanying BIN/CUE file (based on the cue file in the repository...any CD with a matching track number will work, however offsets are hard coded for MSU-MD so they will not match up unless you edit your tracks)
	+ CD audio bypass - Play on any console and get the original music if there is no CD-ROM hardware
	+ CD Audio Volume setting in Options menu (only appears if CD hardware is detected)
	+ Level Select\* added back to Options menu
	
	
	\* The level select loader does not work well on non-0 levels (5-2 / 7-2 etc). Some graphics won't load and the call to play music doesn't work on stage 5 if you don't start on 5-0. 
	