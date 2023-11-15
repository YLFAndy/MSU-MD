# MSU-MD-DRV Update

I was unable go get what I needed out of the stock MSU-MD driver by Krikzz. Unfortunately it was missing a few key pieces, at least on MiSTer (possibly due to the implementation of the CD subsystem there).
Primarily, the Communication Registers on the MegaCD 68K side were not getting updated with track info. Normally, on real hardware, those registers are updated with an offset for playing tracks so you can quickly calculate where you are on the CD. But for some reason, there are no writebacks happening on MiSTer.
Because of this, knowing when a track is no longer playing wasn't possible - as far as I know. There's a good chance I just don't know something. The gate array is basically entirely blank on MiSTer, whereas on a real system it's constantly being updated. Owing to this, I added a comm register toward the end of the list (0xA1202C) in the driver.
This adds a tiny bit of extra size, so only use it if you need it. 

## ASM implementation

**cmpi.b #$0x4, $A1202C**

This will set the status register to Z if playing and will clear Z if not, and you can branch accordingly.