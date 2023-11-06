# XGM Player Layout

Caller Target: 0x00XXXXZZ

## Entry Points

### Driver Load 0xXXXXNN
This should be placed at the head of the driver and called into from the address 0x05, with a callback to whatever was in that address previously. For this, we'll assume the standard 0x200 program start.
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`movea.l #0x0, SP`|`2E 78 00 00`|Zeroes out the stack pointer|
|`jsr #$0x00XXXXMM`|`4E B9 00 XX XX MM`|Jumps to the MSU driver initialization head|
|`tst.b D0`|`4A 00`|Check that D0 is 0 (CD driver loaded)|
|`bne.b 0xD`|`66 0D`|Branch to return if there's no MegaCD hardware|
|`jsr #$0x00XXXXAA`|`4E B9 00 XX XX AA`|Wait for MegaCD Ready|
|`move.l #0x1601, $0xA12010`|`33 FC 16 01 00 A1 20 10`|Send the No Seek command to MegaCD|
|`jsr 0x00XXXXBB`|`4E B9 00 XX XX BB`|Tick the command clock|
|`jmp 0x00000200`|`4E F9 00 00 02 00`|Jump back to program load (may not be 0x200, check your rom header!)|

### Wait for MegaCD Ready 0xXXXXAA
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`tst.b $0xA12020`|`4A 39 00 A1 20 20`|Check the status of the MegaCD hardware (True if 0)|
|`bne.b`|`66 F8`|If not equal to 0, repeat check (wait for ready)|
|`rts`|`4E 75`|Return|

### Tick MCD Command Clock 0xXXXXBB
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`addq.b #$0x1, $0xA1201F`|`52 39 00 A1 20 1F`|Add one to the command clock counter for MegaCD|
|`rts`|`4E 75`|Return|

### Restore Stack and Registers 0xXXXXCC
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`movem.l A6/A3-A2/D4-D0`|`4C DF FC 1F`|Restore the registers from before the call *TODO:Trim to necessary*|
|`lea (0xFC,SP),SP`|`4F EF 00 FC`|Restore the stack pointer to the pre-call position *TODO:Update with math for current SP*|
|`rts`|`4E 75`|Return|

### Play No Loop 
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`clr.l D0`|`42 80`|Zero out register D0 to be used later|
|`ori.w #$0x1100, D0`|`80 7C 11 00`|Or the play command *11* with D0|
|`jsr #$0x00XXXXDD`|`4E B9 00 XX XX DD`|Jump to the absolute location of the main player entry point| 
|`rts`|`4E 75`|Return to external caller|

### Play Loop 
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`clr.l D0`|`42 80`|Zero out register D0 to be used later|
|`ori.w #$0x1200, D0`|`80 7C 12 00`|Or the loop command *12* with D0|
|`jsr #$0x00XXXXDD`|`4E B9 00 XX XX DD`|Jump to the absolute location of the main player entry point|
|`rts`|`4E 75`|Return|

### Play Loop Offset
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`clr.l D0`|`42 80`|Zero out register D0.l to be used later|
|`ori.w #$0x1A00, D0`|`80 7C 1A 00`|Or the play loop offset command *1A* with D0 **NOTE** this takes an additional argument|
|`jsr #$0x00XXXXDD`|`4E B9 00 XX XX DD`|Jump to the absolute location of the main player entry point|
|`rts`|`4E 75`|Return|


### Main Player 0xXXXXDD
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`lea (-$fc,A7), A7`|`4F EF FF 04`|Move the stack pointer up the stack 0xFC steps, the top of the stack|
|`movem.l D0-D4/A2-A3/A6, -(A7)|`48 E7 F8 32`|Move the values of existing registers onto the top of the stack *TODO:Trim to necessary*|
|`move.w ($120,A7), D1`|`11 17 01 18`|Get the value from 0x120 bytes into the stack (We moved the stack pointer ahead 0xFC steps, plus the long lengths of 8 registers, or 0x20 bytes. The track number lives on the stack at FFFFFF77, 118 words down from the current stack pointer)|
|`cmpi.b #0x14, D1`|`0C 01 00 14`|Check the track against 0x14 (this sets Not Equal and Carry flag, Carry set means it's less than)|
|`blt.b #0x0E`|`6D 0E`|Branch over the return call, otherwise hand back to the player.|
|`jsr 0xXXXXCC`|`4E B9 00 XX XX CC`|Jump to Restore Stack and Registers|
|`rts`|`4E 75`|Return to caller|
|`cmpi.l #0x53454741, $400100.l`|`0C B9 53 45 47 41 00 40 01 00`|Check for MegaCD (allows cart to be played without CD) by looking for 'SEGA' in address 0x400100|
|`beq.b #0xF`|`67 0F`|Branch ahead 0xF if CD present
|`jsr 0xXXXXCC`|`4E B9 00 XX XX CC`|Jump to Restore Stack and Registers|
|`jmp #$0x00XXXXZZ`|`4E F9 00 XX XX ZZ`|Jump to the existing player since there's no CD|
|`clr.l D3`|`42 83`|Zero out D3|
|`ori.l #0xA12010,D3`|`0A 83 00 A1 20 10`|Put the command address in D3|
|`lea D3,A2`|`45 C3`|Put the address into A2|
|`ori.w D1,D0`|`80 01`|Or the play command and track number into D0.| 
|`addi.b #0x1,D0`|`06 00 00 01`|Add one to the track since track lists are not zero based|
|`cmpi.w #0x1A00, D0`|`0C 43 1A 00`|Check to see if the track is play looped with offset (special handling)|
|`beq.b #0x20`|`67 20`|Branch ahead to Loop with Offset Handler| 
|`jsr #$0x00XXXXAA`|`4E B9 00 XX XX AA`|Wait for MegaCD Ready|
|`move.l D0, (A2)`|`24 83`|Send the play track command and track number to the MegaCD command register|
|`jsr #$0x00XXXXBB`|`4E B9 00 XX XX BB`|Tick the command clock|
|`jsr #$0x00XXXXCC`|`4E B9 00 XX XX CC`|Restore the stack and registers|
|`rts`|`4E 75`|Return to caller|

### Loop With Offset Handler
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|Switch based on track number - varies by game. Offsets are in sectors. Each second is 75 sectors. The following entries are for Darius as an example|
|`lsl.l #0x08, D0`|`E1 88`| Left shift D0 command 1 byte.|
|`cmpi.b #0x09,D1`|`0C 01 00 09`|Compare the track number to 0x09 (10th track)|
|`bne.b #0x6`|`66 06`|Branch ahead 6 to next check if not equal|
|`ori.b #0xC6,D0`|`00 00 00 C6`|Puts C6 sectors (2.634 seconds) into the offset argument for Track 9|
|`bra.b #0xD7`|`60 D7`|Branch back 0xD7 to player|
|`cmpi.b #0x07, D0`|`0C 01 00 07`|Compare the track number to 0x07 (8th track)|
|`ori.b #0x07,D0`|`00 00 00 07`|Puts 7 sectors (.081 seconds) into the offset argument for Track 7|
|`bra.b #0xED`|`60 ED`|Branch back 0xED to cascade branch to player|
|`bra.b #0xFD`|`60 FD`|Branch back with 00 in offset if no track found|

### Pause Playback Entry 0x00XXXXEE
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`jsr #$0x00XXXXAA`|`4E B9 00 XX XX AA`|Wait for MegaCD|
|`move.w #0x1300, $0x00A12010`|`33 FC 13 00 00 A1 20 10`|Send pause command to MegaCD|
|`jsr #$0x00XXXXBB`|`4E B9 00 XX XX BB`|Tick the command clock|
|`rts`|`4E 75`|Return|

### Resume Playback Entry 0x00XXXXEE
| ASM Command | 68K Hex Code | Description |
| --- | --- | --- |
|`jsr #$0x00XXXXAA`|`4E B9 00 XX XX AA`|Wait for MegaCD|
|`move.w #0x1400, $0x00A12010`|`33 FC 14 00 00 A1 20 10`|Send pause command to MegaCD|
|`jsr #$0x00XXXXBB`|`4E B9 00 XX XX BB`|Tick the command clock|
|`rts`|`4E 75`|Return|


