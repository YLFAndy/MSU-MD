
    ORG    $3e0b70
START: 

SET_LOOP_OFFSET
    move.w #$1601,($A12010)
    jsr TICK_CLOCK
    rts
SET_CDDA_VOLUME
    move.w #$15B2,($A12010)
    jsr TICK_CLOCK
    rts
    
TOGGLE_PAUSE ;41b72
    bsr.w CHECK_CD_EXIST
    bne.w RETURN_TOGGLE_PAUSE_NOW
    move.b ($ffa00c),D0
    cmp.b ($ffd800),D0
    beq.w RETURN_TO_CALLER_TOGGLE_PAUSE
    move.b D0, ($ffd800)
    move.w $CD54, ($3f7fa)
    cmpi.b #$0,D0
    bne.w PAUSE
    bra.w RESUME
    
PLAY_TRACK ; 41f8a
    bsr.w CHECK_CD_EXIST
    bne.w RETURN_STANDARD_MUSIC
    bsr.w CHECK_CD_READY
    andi.w #$ff,D0
    addq.b #$1,D0 
CHECK_0xC
    cmpi.b #$c,D0
    bne.w CHECK_0x1C
    or.w #$1100,D0
    bra.w PLAY_COMMAND   
CHECK_0x1C
    cmpi.b #$1C,D0
    bne.w CHECK_0x1A
    or.w #$1100,D0
    bra.w PLAY_COMMAND
CHECK_0x1A
    cmpi.b #$1A,D0
    bne.w CHECK_0x13
    or.w #$1100,D0
    bra.w PLAY_COMMAND
CHECK_0x13
    cmpi.b #$13,D0
    bne.w CHECK_0x1
    or.w #$1A00,D0
    move.l #$24b,($A12012)
    bra.w PLAY_COMMAND
CHECK_0x1
    cmpi.b #$1,D0
    bne.w CHECK_0x4
    or.w #$1A00,D0
    move.l #$120,($A12012)
    bra.w PLAY_COMMAND
CHECK_0x4
    cmpi.b #$4,D0
    beq.w PLAY_0x4
    cmpi.b #$5,D0
    bne.w CHECK_0xB
PLAY_0x4
    or.w #$1A00,D0
    move.l #$c18,($A12012)
    bra.w PLAY_COMMAND
CHECK_0xB
    cmpi.b #$b,D0
    bne.w PLAY_LOOP
    bsr.w GET_CURRENT_ROUND
    cmpi.w #$E00,D5
    bne.w CHECK_0xB_2
    moveq #$D,D0
    bra.w PLAY_LOOP
CHECK_0xB_2
    cmpi.w #$E02,D5
    bne.w PLAY_INTRO
    moveq #$11,D0
    bra.w PLAY_LOOP
PLAY_INTRO
    or.w #$1A00,D0
    move.l #$336,($A12012)
    bra.w PLAY_COMMAND
PLAY_LOOP
    or.w #$1200,D0
PLAY_COMMAND
    move.w #$CD54,($3f7fa)
    move.w D0,($A12010)
    jsr TICK_CLOCK
    move.w #$0,($ffa00c)
    jsr $424f8
    jsr $41d2c
    jmp $424f4

PAUSE
    bsr.b CHECK_CD_READY
    move.w #$133C,($A12010)
    bsr.b TICK_CLOCK
    bra.w RETURN_TO_CALLER_TOGGLE_PAUSE
    
RESUME
    bsr.b CHECK_CD_READY
    move.w #$1400,($A12010)
    bsr.b TICK_CLOCK
    bra.w RETURN_TO_CALLER_TOGGLE_PAUSE
    
RETURN_TO_CALLER_TOGGLE_PAUSE
    andi.b #$0,D0
RETURN_TOGGLE_PAUSE_NOW
    btst #$0,$c(A5)
    jmp $41b78

CHECK_CD_EXIST
    cmpi.l #$53454741,($400100)
    rts

CHECK_CD_READY
    tst.b ($A12020)
    bne CHECK_CD_READY
    rts
    
TICK_CLOCK
    addq.b #$1,($A1201F)
    rts
RETURN_STANDARD_MUSIC
    jsr $424f8
    jsr $41d2c
    jmp $41f92
    
    ORG $3e0d50
SET_280_SPRITE ;694
    bsr.w CHECK_ROUND_2
    tst.b D5
    bne.w NORMAL_280
    move.w #$4c00,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$4c000001,(A4)
    bra.w JUMP_BACK_280
NORMAL_280
    move.w #$5000,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$50000001,(A4)
JUMP_BACK_280
    jmp $6a8
    
SET_2D0_SPRITE ;714
    bsr.w CHECK_ROUND_2
    tst.b D5
    bne.w NORMAL_2D0
    move.w #$5700,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$57000001,(A4)
    bra.w JUMP_BACK_2D0
NORMAL_2D0
    move.w #$5a00,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$5a000001,(A4)
JUMP_BACK_2D0
    jmp $728
    
SET_320_SPRITE ;794
    bsr.w CHECK_ROUND_2
    tst.b D5
    bne.w NORMAL_320
    move.w #$6200,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$62000001,(A4)
    bra.w JUMP_BACK_320
NORMAL_320
    move.w #$6400,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$64000001,(A4)
JUMP_BACK_320
    jmp $7a8
    
SET_370_SPRITE ;814
    bsr.w CHECK_ROUND_2
    tst.b D5
    bne.w NORMAL_370
    move.w #$6d00,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$6d000001,(A4)
    bra.w JUMP_BACK_370
NORMAL_370
    move.w #$6e00,(A4)
    move.w #$81,-(SP)
    move.w (SP)+,(A4)
    move.w $fdf6.w,(A4)
    move.l #$6e000001,(A4)
JUMP_BACK_370
    jmp $828
    
SPRITE_OFFFSET_148a2
    move.l A0,D0
    andi.w #$f00,D0
    lsr.w #$8,D0
    add.w D0,D0
    bsr.w CHECK_ROUND_2
    tst.b D5
    bne.w NORMAL_OFFSET_148a2
    or.w SPRITE_TABLE(PC,D0),D1
    move.w D1,($a,A0)
    rts
NORMAL_OFFSET_148a2
    jmp $148ac
    
SPRITE_OFFFSET_23f18
    move.l A2,D1
    andi.w #$f00,D1
    lsr.w #$8,D1
    add.w D1,D1
    bsr.w CHECK_ROUND_2
    tst.b D5
    bne.w NORMAL_OFFSET_23f18
    move.w SPRITE_TABLE(PC,D1),D1
    move.w D1,($a,A2)
    rts
NORMAL_OFFSET_23f18
    jmp $23f22
SPRITE_OFFFSET_2630e
    move.l A2,D1
    andi.w #$f00,D1
    lsr.w #$8,D1
    add.w D1,D1
    bsr.w CHECK_ROUND_2
    tst.b D5
    bne.w NORMAL_OFFSET_2630e
    move.w SPRITE_TABLE(PC,D1),D1
    move.w D1,($a,A2)
    rts
NORMAL_OFFSET_2630e
    jmp $26318
SPRITE_TABLE
    DC.B $0,$0,$4,$10,$2,$60,$2,$b8,$3,$10,$3,$68,$03,$c0
CHECK_ROUND_2
    bsr GET_CURRENT_ROUND
    cmpi.w #$200,D5
    blt.w RETURN_FALSE
    cmpi.w #$207,D5
    bgt.w CHECK_ROUND_6
    moveq.l #$0,D5
    rts
CHECK_ROUND_6
    cmpi.w #$A08,D5
    bne.w RETURN_FALSE
    moveq.l #$0,D5
    rts
RETURN_FALSE
    moveq.l #$1,D5
    rts
GET_CURRENT_ROUND
    moveq.l #$0,D5
    move.w $fc42.w,D5
    lsl.w #$8,D5
    or.w $fc44.w,D5
    rts  

    ORG $3e0f90
    btst #$0,$c00005
    bne SET_PAL
    move.w #$8134,$c00004
    rts
SET_PAL
    move.w #$813c,$c00004
    rts
    
    ORG $3e0fc0  ;167ca
    move.w #$8760,$fc12.w
    subq.w #$1,D2
    beq.w CD_MENU
    move.w #$a760,$fc12.w
CD_MENU
    bsr.l CHECK_CD_EXIST
    bne.w EXIT_CD_MENU
    lea CD_MENU_DATA(PC),A0
    jsr $1d88
    lea $c00000.l,A1
    move.l CD_MENU_LAYOUT_DATA(PC), $4(A1)
    lea CD_MENU_OPTIONS(PC),A0
    move.w $fd00.w,D0
    lsl.w #$2,D0
    lea (A0,D0),A0
    ;bsr.w CD_MENU_SET_VOL
    nop
    nop
    lea (A0),A0
    jsr $1d92
EXIT_CD_MENU
    move.w #$8760,$fc12.w
    subq.w #$1,D2
    beq EXIT_MENU
    move.w #$a760,$fc12.w    
EXIT_MENU
    jmp $167da
    
CD_MENU_SET_VOL
    ;lsr.w #$2,D0
    nop
    move.b CD_MENU_VALUES(PC,D0),D0
    andi.w #$00FF,D0
    ori.w #$1500,D0
    bsr.l CHECK_CD_READY
    move.w D0,($A12010)
    bsr.l TICK_CLOCK
    rts

INIT_CD_VOL_DATA ;40E
    move.w #$4,$fd04.w
    bsr.l CHECK_CD_EXIST
    bne INIT_RETURN
    move.w #$7,$fd00.w
INIT_RETURN
    jmp $414

CD_MENU_DATA
    DC.B $4A,$18,$00,$03,$20,$20,'CD VOL.',$00
CD_MENU_LAYOUT_DATA
    DC.B $4A,$2C,$00,$03
CD_MENU_OPTIONS
    DC.W '00',$0,'01',$0,'02',$0,'03',$0,'04',$0,'05',$0,'06',$0,'07',$0,'08',$0,'09',$0,'10',$0
CD_MENU_VALUES
    DC.B $00,$19,$32,$4c,$65,$7F,$99,$b2,$cc,$e5,$ff,$00
    
SKIP_HIDDEN_MENU_DOWN ;16282
    cmpi.w #$7,$a900.w
    bne.b SKIP_JUMP_DOWN
    bsr.l CHECK_CD_EXIST
    beq.b SKIP_JUMP_DOWN
    jmp $1626c
    
SKIP_JUMP_DOWN
    jmp $162b4
    
SKIP_HIDDEN_MENU_UP ;1624e
    cmpi.w #$7,$a900.w
    bne.b SKIP_JUMP_UP
    bsr.l CHECK_CD_EXIST
    beq.b SKIP_JUMP_UP
    jmp $1623c
    
SKIP_JUMP_UP
    jmp $162b4

INCREASE_VOLUME
    addq.w #$1,$fd00.w
    cmpi.w #$A,$fd00.w
    bls.w JUMP_VOLUME
    clr.w $fd00.w
    bra.w JUMP_VOLUME
DECREASE_VOLUME
    subq.w #$1,$fd00.w
    bpl.w JUMP_VOLUME
    move.w #$A,$fd00.w
    bra.w JUMP_VOLUME

JUMP_VOLUME
    jmp $162b4
    
MENU_HANDLER ;16292
    move.w $a900.w,D0
    add.w D0,D0
    cmpi.b #$E,D0
    blt.b MENU_HANDLER_JUMP
    beq.b TOGGLE_CD_VOLUME_MENU
    jmp $1658c
MENU_HANDLER_JUMP
    jmp $16298
TOGGLE_CD_VOLUME_MENU
    move.b $fc09.w,D0
    or.b $fc0b.w,D0
    btst.l #$3,D0
    bne.b INCREASE_VOLUME
    btst.l #$4,D0
    bne.b DECREASE_VOLUME
    btst.l #$5,D0
    bne.b INCREASE_VOLUME
    btst #$2,D0
    bne.b DECREASE_VOLUME
    move.w $fd00.w,D0
    bsr.l CD_MENU_SET_VOL
    rts
    
    
    
    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
