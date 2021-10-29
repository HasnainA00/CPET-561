//Hasnain AKhtar
//CPET - 561 - lab3
//File: part_1_Polling_Interrupt.c


/* alt_types.h and sys/alt_irq.h need to be included for the interrupt
  functions
  system.h is necessary for the system constants
  io.h has read and write functions */
#include "io.h"
#include <stdio.h>
#include "system.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

// create standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

//set up pointers to peripherals

volatile uint32* timer_ptr   = (uint32*)TIMER_0_BASE;
volatile uint8* led_ptr      = (uint8*)LEDS_BASE;
volatile uint8* key_ptr      = (uint8*)PUSHBUTTONS_BASE;
volatile uint8* switches_ptr = (uint8*)SWITCHES_BASE;
volatile uint8* hex0_ptr     = (uint8*)HEX0_BASE;

int main(void)
{
/*****************************************************************************/
/* Main Program                                                              */
volatile uint8 push_btn_read;
volatile uint8 switches_read;
uint8 list[10] = {64, 121, 36, 48, 25, 18, 2, 120, 0, 24}; //Hex Display List(0 - 9)
uint8 pos = 0;
uint8 check = 1;
*hex0_ptr = *(list + pos); //Displays 0 at startup

  while(1)
  {
    check = 1;
    push_btn_read = *key_ptr;             //Reads the push buttons
    switches_read = *switches_ptr;        //Reads the switches
    push_btn_read = push_btn_read & 0x02; //Mask Key1
    switches_read = switches_read & 0x01; //Mask SW0
    while(push_btn_read == 0)
      while(check == 1)
      {
        push_btn_read = *key_ptr;             //Reads the push buttons
        switches_read = *switches_ptr;        //Reads the switches

        push_btn_read = push_btn_read & 0x02; //Mask Key1
        switches_read = switches_read & 0x01; //Mask SW0
        
        //---------------------Sub Conditions------------------------------
        //when push button is released and sw0 is high
        while((push_btn_read == 2) && (switches_read == 1) && (check == 1))
        {
        //*******************Out of bounds condition check*****************
          if(*hex0_ptr == list[9])
            check = 0;  //triggers exit loop condition early to prevent out
                        //of bounds
          else
          {
            pos = pos + 1;              //increments the position
            *hex0_ptr = *(list + pos);  //stores next list value to hex0
            check = 0;                  //triggers exit loop condition            
          }
        }
        //when push button is released and sw0 is low
        while((push_btn_read == 2) && (switches_read == 0) && (check == 1))
        {
        //*******************Out of bounds condition check*****************
          if(*hex0_ptr == list[0])
            check = 0;  //triggers exit loop condition early to prevent out
                        //of bounds
          else
          {
            pos = pos - 1;              //decrements the position
            *hex0_ptr = *(list + pos);  //stores previous list value to hex0
            check = 0;                  //triggers exit loop condition
          }
        }
        //-----------------------------------------------------------------
      }
  }
  return 0;
}
