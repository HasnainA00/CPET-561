//Hasnain AKhtar
//CPET - 561 - lab6 - Part 4
//File: Lab6_Part5.c


/* alt_types.h and sys/alt_irq.h need to be included for the interrupt
  functions
  system.h is necessary for the system constants
  io.h has read and write functions */
  
#include "io.h"
#include <stdio.h>
#include <stdlib.h>
#include "system.h"

//Definitions//
#define KEY1_BASE 0x9000
#define LEDS_BASE 0x9010
#define INFERRED_RAM_BE_0_BASE 0x0


// standard embedded type definitions
typedef   signed char   sint8;              // signed 8 bit values
typedef unsigned char   uint8;              // unsigned 8 bit values
typedef   signed short  sint16;             // signed 16 bit values
typedef unsigned short  uint16;             // unsigned 16 bit values
typedef   signed long   sint32;             // signed 32 bit values
typedef unsigned long   uint32;             // unsigned 32 bit values
typedef         float   real32;             // 32 bit real values

//set up pointers to peripherals

volatile uint8*  led_ptr               = (uint8*)LEDS_BASE;
volatile uint32* key1_ptr              = (uint32*)KEY1_BASE;
uint32* infr_ram_ptr                   = (uint32*)INFERRED_RAM_BE_0_BASE;
uint16* infr_ram_ptr_sixteen           = (uint16*)INFERRED_RAM_BE_0_BASE;
uint8*  infr_ram_ptr_eight             = (uint8*)INFERRED_RAM_BE_0_BASE;

uint32 RampPattern   = 0x12345678;
uint32 testData32Bit = 0xABCDEF90;
uint16 testData16Bit = 0x1234;
uint8 testData8Bit  = 0x00;

//functions

//Key0_Function
void keyOne_isr()
{
  *(key1_ptr + 2) = 0x00; //Clear Bit Mask Interrupt.
  *(key1_ptr + 3) = 0x00; //Clear Edge Capture Interrupt.
  
  unsigned char current_val;
  int chk = 1;
  printf("---------------------------------RAM TEST DONE------------------------------------");
  
  while(1)
  {
    chk = 1;
    for(long i = 0; i <= 999999; i++);
    while(chk == 1)
    {
      current_val = *led_ptr; /* read the leds */
      if(current_val == 0x00)
        current_val = 0xff;
      else
        current_val = 0x00;
    
      *led_ptr = current_val;  /* change the display */
      chk = 0;
    }
  }

  return;
}
//BYTE ACCESSIBLE RAM TEST FUNCTION
//Parameters: Start Address, Number of Bytes to test, test data to write
void byteAccessibleTest(uint32* start_address, int num_bytes, uint32 testData)
{
  
  for(int i = 0; i < num_bytes; i++)
  {
    *(start_address + i) = testData;

  }
  for(int j = 0; j < num_bytes; j++)
  {
	  if(testData != *(start_address + j))
	  {
		  *led_ptr = 0xff;
		  printf("Error: ");
		  printf("Address : %u, Read: %u, Expected: %u\n", ((long unsigned int)(start_address + j)), ((long unsigned int)*(start_address + j)), testData);
	  }
	  else
	  {
		  *led_ptr = 0x00;
	  }
	  *led_ptr = 0x00; //Clr leds
  }


  
  return;
}

//BYTE ACCESSIBLE RAM TEST FUNCTION 16 Bit Half Word
//Parameters: Start Address, Number of Bytes to test, test data to write
void ramtest16Bit(uint16* start_address, int num_bytes, uint16 testData)
{
  
  for(int i = 0; i < num_bytes; i++)
  {
    *(start_address + i) = testData;

  }
  for(int j = 0; j < num_bytes; j++)
  {
	  if(testData != *(start_address + j))
	  {
		  *led_ptr = 0xff;printf("Error: ");
		  printf("Address : %u, Read: %u, Expected: %u\n", ((short unsigned int)(start_address + j)), ((short unsigned int)*(start_address + j)), testData);
	  }
	  else
	  {
		  *led_ptr = 0x00;
	  }
	  *led_ptr = 0x00;  //Clr leds
  }



  
  return;
}

//BYTE ACCESSIBLE RAM TEST FUNCTION 8 Bit Word
//Parameters: Start Address, Number of Bytes to test, test data to write
void ramtest8Bit(uint8* start_address, int num_bytes, uint8 testData)
{
  
  for(int i = 0; i < num_bytes; i++)
  {
    *(start_address + i) = testData;

  }
  for(int j = 0; j < num_bytes; j++)
  {
	  if(testData != *(start_address + j))
	  {
		  *led_ptr = 0xff;
		  printf("Error: ");
		  printf("Address : %u, Read: %u, Expected: %u\n", ((unsigned char)(start_address + j)), ((unsigned char)*(start_address + j)), testData);
	  }
	  else
	  {
		  *led_ptr = 0x00;
	  }
	  *led_ptr = 0x00; //Clr leds
  }



  return;
}

int main()
{
  *(key1_ptr + 2) = 0x1;     //InterruptMask KEY1
  *(key1_ptr + 3) = 0x1;     //Edge Capture KEY1
  alt_ic_isr_register(KEY1_IRQ_INTERRUPT_CONTROLLER_ID,KEY1_IRQ,keyOne_isr,0,0);

  while(1)
  {
    byteAccessibleTest(infr_ram_ptr, 4096, testData32Bit);
    ramtest16Bit(infr_ram_ptr_sixteen, 4096, testData16Bit);
    ramtest8Bit(infr_ram_ptr_eight, 4096, testData8Bit);
    byteAccessibleTest(infr_ram_ptr, 4096, RampPattern);
  }
  
  return 0;
}
