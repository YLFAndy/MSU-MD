# MSU-MD Patch Project
Learn more about the MSU-MD driver and project here: https://github.com/krikzz/msu-md

The goal of this repository is to allow users to provide feedback on WIP MSU-MD patches I'm currently working on.

## What is MSU-MD?
MSU-MD is a Mode 1 driver implementation for Sega MegaDrive created by krikzz, originally for use with Everdrive Pro.
The format is backwards compatible with real hardware and is adjacent to MD+, an implementation with FPGA and emulation in mind.
MSU-MD is highly portable and is available on a number of platforms without special hardware. 

## But...Why? \</reynolds\>
This all basically came about because I wanted to use CD music with the absoultely **excellent** Shredder's Re-Revenge patch from Savok. My primary method for gaming is the MiSTer FPGA which does not currently support MD+. 
Owing to this, I began exploring what it took to create a soundpack and implement the driver in the existing game. I did so with fairly decent success and decided to keep going. Nobody else seems to be doing much in the space.

## OK, but...WHY?
Look, I'm not a smart man, ok?

## How do I use these?
First you need to acquire a sound pack. I don't, won't, and can't distribute them. In that order. I only distribute stuff that's legal to distribute. So rom patches and cue files. You're on your own for the actual music. But, you know, search engines exist. 
Next, you need to apply the patch (either IPS or BPS, depending on how I felt that day). I use the online patcher at romhacking.net personally. 
Lastly, and this is the part that can really trip a person up, you need to format the layout of the files in a way that works for your player of choice. Some examples:

### MiSTer FPGA
/games/MegaCD/\<FolderName\></br>
	\-\> \<bin file\></br>
	\-\> \<cue file\></br>
	\-\> cart.rom (rename the patched file)</br>
		
### GenesisPlus/Everdrive
\<GamesFolder\>/\<FolderName\></br>
	 \-\>NameOfGame.bin</br>
	 \-\>NameOfGame.cue</br>
	 \-\>NameOfGame.md</br>
		 
		 
There are probably a thousand other emulators and that support this, but those are the basics. 

## More Info
You can find a ton more info and talk to people working on packs and hacks at https://www.zeldix.net/f66-md-and-msu-md-hacks-database

## This game is buggy. It sucks. You suck.
Yeah. 

Anyway, file an issue and I'll take a look. I can't really fix existing game issues, but if it was introduced by the patch I'll look into it. The WIP patches are likely to change frequently and without notice. Bug reports are appreciated and will be ignored promptly. 
