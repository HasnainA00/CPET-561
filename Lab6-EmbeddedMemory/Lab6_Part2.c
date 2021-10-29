//Hasnain AKhtar
//CPET - 561 - lab6 - Part 2
//File: Lab6_Part2.c


/* alt_types.h and sys/alt_irq.h need to be included for the interrupt
  functions
  system.h is necessary for the system constants
  io.h has read and write functions */
  
#include "io.h"
#include <stdio.h>
#include <stdlib.h>
#include "system.h"

//Definitions//
#define KEY0_BASE 0x9000
#define LEDS_BASE 0x9010
#define INFERRED_RAM_BASE 0x0


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
volatile uint8*  key0_ptr              = (uint8*)KEY0_BASE;
uint32* infr_ram_ptr                   = (uint32*)INFERRED_RAM_BASE;
uint16* infr_ram_ptr_sixteen           = (uint16*)INFERRED_RAM_BASE;
uint8*  infr_ram_ptr_eight             = (uint8*)INFERRED_RAM_BASE;

uint32 RampPattern   = 0x12345678;
uint16 testData16Bit = 0x1234;
uint16 testData8Bit  = 0x12;

//functions

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
    }
    else
    {
      *led_ptr = 0x00;
    }
  }
  
  return;
}

//BYTE ACCESSIBLE RAM TEST FUNCTION 16 Bit Half Word
//Parameters: Start Address, Number of Bytes to test, test data to write
void ramtest16Bit(uint16* start_address, int num_bytes, uint32 testData)
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
    }
    else
    {
      *led_ptr = 0x00;
    }
  }

  
  return;
}

//BYTE ACCESSIBLE RAM TEST FUNCTION 8 Bit Word
//Parameters: Start Address, Number of Bytes to test, test data to write
void ramtest8Bit(uint8* start_address, int num_bytes, uint32 testData)
{
  
  for(int i = 0; i < num_bytes; i++)
  {
    *(start_address + i) = testData + 0x01;

  }
  
  for(int j = 0; j < num_bytes; j++)
  {
    if(testData != *(start_address + j))
    {
      *led_ptr = 0xff;
    }
    else
    {
      *led_ptr = 0x00;
    }
  }

  return;
}

int main()
{

  byteAccessibleTest(infr_ram_ptr, 4096, RampPattern);
  ramtest8Bit(infr_ram_ptr_eight, 4096, testData8Bit);
  ramtest16Bit(infr_ram_ptr_sixteen, 4096, testData16Bit);
  
  return 0;
}
