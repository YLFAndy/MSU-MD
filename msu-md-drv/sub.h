/* 
 * File:   sub.h
 * Author: igor
 *
 * Created on June 30, 2020, 7:50 PM
 */

#ifndef SUB_H
#define	SUB_H


#define u8      unsigned char
#define u16     unsigned short
#define u32     unsigned long

#define vu8      volatile unsigned char
#define vu16     volatile unsigned short
#define vu32     volatile unsigned long

#define LEDS_R          0x01
#define LEDS_G          0x02
#define RST_RES0        0x01

#define CDD_CTRL_DTS    0x01
#define CDD_CTRL_DRS    0x02
#define CDD_CTRL_HOCK   0x04


#define CDD_CMD_NOP     0x00
#define CDD_CMD_STOP    0x01
#define CDD_CMD_TOC     0x02
#define CDD_CMD_PLAY    0x03
#define CDD_CMD_SEEK    0x04
#define CDD_CMD_PAUSE   0x06
#define CDD_CMD_RESUME  0x07

#define TOC_ABS_POS     0x000000
#define TOC_REL_POS     0x010000
#define TOC_TRACK       0x020000
#define TOC_CDLEN       0x030000
#define TOC_TRNUM       0x040000
#define TOC_TRADDR      0x050000

#define MAIN_CMD        0x00
#define MAIN_ARG        0x01
#define MAIN_ARG32      0x02
#define MAIN_CMD_CK     0x0F

#define SUB_STAT        0x00
#define SUB_STAT_PLAYING 0x0E

#define MAIN_CMD_PLAY   0x11    //paly and stop int the end
#define MAIN_CMD_PLAYLP 0x12    //paly and loop
#define MAIN_CMD_PAUSE  0x13    //pause
#define MAIN_CMD_RESUME 0x14    //resume
#define MAIN_CMD_VOL    0x15    //cdda volume
#define MAIN_CMD_NOSEEK 0x16    //turn off seek tile emulation. 0=emu-on(default), 1=emu-off
#define MAIN_CMD_PLAYOF 0x1A    //play cdda track and loop from specified sector offset

#define SUB_STAT_READY  0x00
#define SUB_STAT_INIT   0x01
#define SUB_STAT_BUSY   0x02
#define STATUS_PLAYING  0x04

#define VOL_MAX         0x4000

typedef struct {
    vu8 LEDS; //FF8000 VER/LED
    vu8 RST;  //FF8001 //A12001  RESET
    vu8 MEM_WP; //FF8002 //A12002 MEMORY WRITE PROTECT
    vu8 MEMMOD;  //FF8003 //A12003 MEMORY MODE
    vu8 CDC_MOD;  //FF8004 CDC MODE
    vu8 CDC_RADDR; //FF8005 CDC REGISTER ADDRESS
    vu8 unused0; //FF8006 UNUSED NIBBLE
    vu8 CDC_RDATA; //FF8007 CDC REGISTER DATA
    vu16 CDC_HDATA; //FF8008 - FF8009 //A12008-A12009 CDC HOST DATA
    vu16 CDC_DADDR; //FF800A - FF800B CDC DMA ADDRESS
    vu16 SWATCH; //FF800C - FF800D // A1200C - A1200D STOPWATCH
    vu8 COMF_MAIN; //FF800E //A1200E COMMUNICATION FLAG (Writeable from main cpu)
    vu8 COMF_SUB; //FF800F //A1200F  COMMUNICATION FLAG (Writeable from SubCPU)
    vu8 CMD_MAIN[16]; //FF8010 - FF801E(RO) //A12010 - A1201E (RW) Communication Status MainCPU 
    vu8 CMD_SUB[16]; //FF8020 - FF802E (RW)// A12020 - A1202E (RO) Communication Status SubCPU
    vu8 unused1; //FF802F UNUSED NIBBLE
    vu8 TIMER;
    vu8 unused2;
    vu8 IEMASK;
    vu16 CD_FADER;
    vu16 CDD_CTRL;
    vu16 CDD_STAT[5];
    vu16 CDD_CMD[5];
} McdRegs;

typedef struct {
    u8 cmd;
    u8 u0;
    u8 arg[6];
    u8 u1;
    u8 crc;
} CddCmd;

typedef struct {
    u16 vol;
    u32 cdd_cmd_arg;
    u8 cdd_cmd_code;
    vu8 cdd_cmd_exec;
    vu8 irq_ctr;
    u8 track;
    u8 loop_mode;
    u32 loop_offset;
} McdState;

typedef struct {
    u32 tracks_num;
    u32 total_len;
    u32 track_addr[100 + 1];
} Toc;

#endif	/* SUB_H */

