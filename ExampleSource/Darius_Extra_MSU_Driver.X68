*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $2b0c70
START:                 

*5bf7e Play
*If found jmp 5c1e2, else jmp 5bf7e
SET_LOOP_DELAY
    jsr PRESERVE_REGISTERS
    jsr WAIT_FOR_READY
    move.w #$1601, (A2)
    jsr TICK_COMMAND_CLOCK
    jsr RESTORE_REGISTERS
    rts
    
SET_CDDA_VOLUME
    jsr PRESERVE_REGISTERS
    jsr WAIT_FOR_READY
    move.w #$15B0, (A2)
    jsr TICK_COMMAND_CLOCK
    jsr RESTORE_REGISTERS
    rts

STOP_PLAYBACK
    jsr PRESERVE_REGISTERS
    move.w SR,D0
    jsr CHECK_MEGACD_EXIST
    bne.b RETURN_STOP_NOW
    clr.w (A2)
    jsr PAUSE_MEGACD
RETURN_STOP_NOW
    move.w D0,SR
    jsr RESTORE_REGISTERS
    jsr $667c2
    rts
    
    
PAUSE_PLAYBACK_GAME
    jsr PRESERVE_REGISTERS
    move.w SR,D0
    jsr CHECK_MEGACD_EXIST
    bne RETURN_PAUSE_NOW
    move.b #$25,D2
    jsr PAUSE_MEGACD
RETURN_PAUSE_NOW
    move.w D0,SR
    jsr RESTORE_REGISTERS
    jsr $58952
    rts
    
RESUME_PLAYBACK_GAME
    jsr PRESERVE_REGISTERS
    move.w SR,D0
    jsr CHECK_MEGACD_EXIST
    bne RETURN_RESUME_NOW
    jsr RESUME_MEGACD
RETURN_RESUME_NOW
    move.w D0,SR
    jsr RESTORE_REGISTERS
    jsr $587cc
    rts

PLAY_SINGLE
    jsr PRESERVE_REGISTERS
    clr.l D2
    clr.l D3
    ori.w #$1100,D2
    bra.w PLAY
  
PLAY_LOOP
    jsr PRESERVE_REGISTERS
    clr.l D2
    clr.l D3
    ori.w #$1200,D2
    bra.w PLAY

PAUSE_MUSIC_PLAYER
    jsr PRESERVE_REGISTERS
    move.w SR,D0
    jsr CHECK_MEGACD_EXIST
    bne RETURN_PAUSE_PLAYER_NOW
    move.b #$25,D2
    jsr PAUSE_MEGACD
RETURN_PAUSE_PLAYER_NOW
    move.w D0,SR
    jsr RESTORE_REGISTERS
    jsr $4ffe4
    rts

RESUME_MUSIC_PLAYER
    jsr PRESERVE_REGISTERS
    move.w SR,D0
    jsr CHECK_MEGACD_EXIST
    bne RETURN_RESUME_PLAYER_NOW
    jsr RESUME_MEGACD
RETURN_RESUME_PLAYER_NOW
    move.w D0,SR
    jsr RESTORE_REGISTERS
    jsr $59e30
    rts


PLAY
    move.w SR,D0
    jsr CHECK_MEGACD_EXIST
    bne.b RETURN_NOW
    cmpi.b #$14,D1
    blt.b TEST_PLAYABLE_TRUE
RETURN_NOW
    move.w D0,SR
    jmp $5bf7e
TEST_PLAYABLE_TRUE
    addq.b #$1,D1
    cmpi.w #$1200,D2
    beq.w LOOP_OFFSET_HANDLER
CONTINUE_PLAYER
    or.b D1,D2
    jsr WAIT_FOR_READY
    move.w D2,(A2)
    move.w D3,(A3)
    jsr TICK_COMMAND_CLOCK
    move.w D0,SR
    jsr RESTORE_REGISTERS
    jmp $5c1e2
    
LOOP_OFFSET_HANDLER
    cmpi.b #$9,D1
    bne.b CHECK_2
    move.w #$1A00,D2
    move.l #$C3,D3
    bra.b CONTINUE_PLAYER
CHECK_2
    cmpi.b #$7,D1
    bne.b CHECK_3
    move.w #$1A00,D2
    move.l #$7,D3
    bra.b CONTINUE_PLAYER
CHECK_3
    bra.b CONTINUE_PLAYER
    
CHECK_MEGACD_EXIST
    cmpi.l #$53454741,$400100
    rts
PAUSE_MEGACD
    jsr WAIT_FOR_READY
    move.w #$1300,D1
    or.b D2,D1
    move.w D1,(A2)
    jsr TICK_COMMAND_CLOCK
    rts
    
RESUME_MEGACD
    jsr WAIT_FOR_READY
    move.w #$1400,(A2)
    jsr TICK_COMMAND_CLOCK
    rts
        
WAIT_FOR_READY
    tst.b (A5)
    bne.b WAIT_FOR_READY
    rts
TICK_COMMAND_CLOCK
    addq.b #$1,(A4)
    rts
    
SET_MEGACD_IO_ADDRESSES
    move.l #$00a12010,A2  ;Command Address
    move.l #$00a12012,A3  ;Command Argument 2
    move.l #$00a1201f,A4  ;Command Clock
    move.l #$00a12020,A5  ;MegaCD Memory Space for presence check
    rts
    
PRESERVE_REGISTERS
    lea (SP),A0
    lea (-$fc,SP),SP
    movem.l A6-A2/D5-D0,-(SP)
    lea (A0),SP
    lea (-$fc,SP),A0
    clr.l D0  ;Track Number
    clr.l D1  ;Command
    clr.l D2  ;Command Arg 1
    clr.l D3  ;Command Arg 2
    clr.l D4  ;MegaCD Present
    clr.l D5  ;Volume
    move.w ($A,A7),D1 ;Get the track number from the stack
    jsr SET_MEGACD_IO_ADDRESSES
    rts

RESTORE_REGISTERS
    movem.l (-$2c,A0),D0-D5/A2-A6
    rts
    END START





    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
