

#include "sys.h"

u16 msu_drv();
vu16 *mcd_cmd = (vu16 *) MCD_CMD;
vu32 *mcd_arg = (vu32 *) MCD_ARG;
vu8 *mcd_cmd_ck = (vu8 *) MCD_CMD_CK;
vu8 *mcd_stat = (vu8 *) MCD_STAT;
vu8 *mcd_stat0 = (vu8 *) MCD_STAT_0;
vu16* mcd_stat1 = (vu16*)MCD_STAT_1;
vu32 *mcd_stat2 = (vu32 *) MCD_STAT_2;
vu32 *mcd_stat3 = (vu32 *) MCD_STAT_3;
vu32 *mcd_stat4 = (vu32 *) MCD_STAT_4;
int main() {

    u8 loop = 1;
    u8 volume = 0xFF;
    u8 track = 1;
    u16 play_cmd;
    u16 resp;
    u8 seek_delay_off = 0;
    u8 loop_offset = 0;
    u16 scr_refresh_cnt = 0; 

    sysInit();
    gSetColor(0x00, 0x000);
    gSetColor(0x0f, 0xfff);

    gCleanPlan();
    gConsPrint("           MSU-MD SAMPLE DEMO           ");
    gConsPrint("----------------------------------------");
    gConsPrint("");

    gConsPrint("load driver...");
    resp = msu_drv();
    if (resp) {
        gAppendString("err");
        gConsPrint("MCD hardware not detected");
        while (1);
    }
    gAppendString("ok");
    gConsPrint("init driver..");
    while (*mcd_stat != 1);
    gAppendString(".");
    while (*mcd_stat == 1); //wait till sub cpu finis initialization
    gAppendString("ok");


    while (1) {
        gSetXY(0, 6);
        gConsPrint("track:        ");
        gAppendNum(track);
        gAppendString("   ");
        gConsPrint("loop:         ");
        gAppendString(loop ? "ON " : "OFF");
        gConsPrint("seek delay:   ");
        gAppendString(seek_delay_off ? "OFF" : "ON ");
        gConsPrint("loop offset:  ");
        gAppendString(loop_offset == 0 ? "OFF" : "ON ");
        gConsPrint("Screen Refresh Count: ");
        gAppendNum(scr_refresh_cnt);
        gSetXY(0, G_SCREEN_H - 12);
        gConsPrint("0xA12010 Status: ");
        gAppendHex16(*mcd_cmd);
        gConsPrint("0xA12012 Status: ");
        gAppendHex32(*mcd_arg);
        gConsPrint("0xA1201F Status: ");
        gAppendHex8(*mcd_cmd_ck);
        gConsPrint("0xA120XX Status: ");
        gAppendHex8(*mcd_stat);
        gAppendHex8(*mcd_stat0);
        gAppendHex16(*mcd_stat1);
        gAppendHex32(*mcd_stat2);
        gConsPrint("                 ");
        gAppendHex32(*mcd_stat3);
        gAppendHex32(*mcd_stat4);
        gConsPrint("SWITCH TRACK (LEFT/RIGHT)");
        gConsPrint("CHANGE LOOP MODE (START)");
        gConsPrint("PALY(A) PAUSE(B) RESUME(C)");
        gConsPrint("SEEK DELAY (UP)");
        gConsPrint("LOOP OFFSET (DOWN)");

        u16 joy = sysJoyRead();

        play_cmd = loop ? (loop_offset ? 0x1A00 : 0x1200) : 0x1100;

        if (joy == JOY_L && track > 1) {
            track--;
        }

        if (joy == JOY_R && track < 99) {
            track++;
        }

        if (joy == JOY_A) {
            *mcd_cmd = play_cmd | track;
            *mcd_arg = 330; //loop offset (12 sec in this sample). Used only for cmd 0x1A00
            *mcd_cmd_ck = *mcd_cmd_ck + 1;
        }

        if (joy == JOY_B) {
            *mcd_cmd = 0x1300 | 75; //one sec fading
            *mcd_cmd_ck = *mcd_cmd_ck + 1;
        }

        if (joy == JOY_C) {
            *mcd_cmd = 0x1400;
            *mcd_cmd_ck = *mcd_cmd_ck + 1;
        }

        if (joy == JOY_STA) {
            loop ^= 1;
        }

        if (joy == JOY_X) {
            if (volume > 0xA)
            {
                volume = volume - 10;
            }
            else
            {
                volume = 0xFF;
            }
            *mcd_cmd = 0x1500 | volume;
            *mcd_cmd_ck = *mcd_cmd_ck + 1;
        }

        if (joy == JOY_U) {

            //seek_delay_off ^= 1; //0=delay on (default), 1=delay off

            //*mcd_cmd = 0x1600 | (seek_delay_off & 1);
            //*mcd_cmd_ck = *mcd_cmd_ck + 1;
            if (volume > 0xA)
            {
                volume = volume - 10;
            }
            else
            {
                volume = 0xFF;
            }
            *mcd_cmd = 0x1500 | volume;
            *mcd_cmd_ck = *mcd_cmd_ck + 1;
        }

        if (joy == JOY_D) {
            loop_offset ^= 1;
        }
        scr_refresh_cnt++;
        gVsync();
    }

    return 0;
}
