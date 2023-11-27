# IMPORTANT
MiSTer requires an update to the MegaCD core (equal to or newer than 30 Oct, 2023) to play this. The existant underlying MegaDrive code can't handle V30 video mode switching and causes a black screen with music, but no gameplay. This is similar to how the vanilla patch works on the Spiritualized OpenFPGA core.
Again, please ensure you have a build of the MegaCD core from AFTER October 30, 2023. 

# What's new?
I've completely retooled the interface for the MSU-MD driver. It now is smarter about what tracks it plays based on level/scene. 
Additionally I've fixed a sprite bug that was really bothering me. When motorcycles appear on screen with Foot soldiers, their tiles overlap causing a swapping of the tail pipe and the Foot soldiers' hands. This occurs in levels 2 and 6. 
Unfortunately, there are some other graphical bugs in level 6 the original release that I haven't fixed yet (A grenade has no sprite, one of the bike soldiers is covered in pipe pieces). Maybe I will eventually. 

This patch applies directly to SoR2 and includes Savok's latest 1.01 release. 