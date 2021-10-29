# ---------------------------------------------------------------
# Author: Hasnain Akhtar
#         CPET-561-01
# ---------------------------------------------------------------

.text

# define a macro to move a 32 bit address to a register

.macro MOVIA reg, addr
  movhi \reg, %hi(\addr)
  ori \reg, \reg, %lo(\addr)
.endm

# define constants
.equ Switches,     0x11020    #Switches base address from system.h file
.equ PushButtons,  0x11010    #Push Buttons base address from system.h file
.equ HexDisplay,   0x11000    #Hex Display base address from system.h file

.global main
#Define the main program
main: 
  movia r2, Switches
  movia r3, PushButtons
  movia r4, HexDisplay
  movia r8, LISTVECTOR #points to the first number in the list.
  movia r9, N
  movia r10, 2         #Bit masking for PushButtons(Key1)
  movia r11, 1         #SW High
  movia r12, 24        #Highest Hex Value(9)
  movia r13, 64        #Lowest Hex Value(0)
  ldw r9, 0(r9)        #counter for loop iterations
  ldbio r7, 0(r8)        #Defaul Hex Value load from the list
  stbio r7, 0(r4)        #Default Hex Value store(0)
  
loop:
  ldbio r5, 0(r2)        #load switches
  ldbio r6, 0(r3)        #load pushbuttons(KEY)
  ldbio r14, 0(r2)         #SW1 (For Bonus Wraparound)
  andi r6, r6, 2         #Bit mask key1
  andi r5, r5, 1         #Bit mask sw0
  andi r14, r14, 2       #Bit mask sw1(For Bonus Wraparound)
  beq r6, r0, subroutine #go to subroutine if key1 is pressed(active low)
  br    loop
  
  
subroutine:
  beq r5, r11, count_up_intermittent   #go to count up loop if switch is high
  beq r5, r0, count_down_intermittent #go to count down loop if switch is low
  br    subroutine
  
  
count_up_intermittent:
  ldbio r6, 0(r3)           #updated pushbuttons value
  andi r6, r6, 2            #Bit mask key1
  beq r6, r10, count_up     #go to count up loop when switch is released
br    count_up_intermittent
  
  
count_down_intermittent:
  ldbio r6, 0(r3)             #updated pushbuttons value
  andi r6, r6, 2              #Bit mask key1
  beq r6, r10, count_down     #go to count down loop when switch is released
br    count_down_intermittent
  
  
count_up:
  beq r7, r12, check_wrap_up  #go to wrapcheck if highest number reached.
  addi r8, r8, 4              #else increment the counter
br    update_disp
  
count_down:
  beq r7, r13, check_wrap_down  #Go to wrapcheck if lowest number reached
  subi r8, r8, 4                #else decrement the counter
br    update_disp

update_disp:
  ldbio r7, 0(r8)        #Updated Hex Value load from the list
  stbio r7, 0(r4)        #Updated Hex Value store
br    loop


#---------------------------Wraparound Code----------------------------
check_wrap_up:
  beq r14, r10, wrap_up_disp  #check if sw1 is high sw1(bonus part switch)
br    loop

check_wrap_down:
  beq r14, r10, wrap_down_disp  #check if sw1 is high sw1(bonus part switch)
br    loop

wrap_up_disp:
  subi r8, r8, 36        #point to first number
  ldbio r7, 0(r8)        #Updated Hex Value load from the list(9)
  stbio r7, 0(r4)        #Updated Hex Value store
br    loop

wrap_down_disp:
  addi r8, r8, 36              #point to last number
  ldbio r7, 0(r8)        #Updated Hex Value load from the list(9)
  stbio r7, 0(r4)        #Updated Hex Value store
br    loop
#-----------------------------------------------------------------------
DOT_PRODUCT:  .skip 4        #memory skip
N:           .word 10        #number of elements in the list
LISTVECTOR:  .word 64, 121, 36, 48, 25, 18, 2, 120, 0, 24   #List for Hex Display(0 to 9).
