
#include  <WProgram.h>
#include  "chipKITCAN.h"
#include "LED_Driver.h"
#include <DSPI.h>

/* ------------------------------------------------------------ */
/*		Local Type and Constant Definitions		*/
/* ------------------------------------------------------------ */

/* Network Node Addresses
*/
//#define	node1can1	0x101L
#define node2can1	0x201L
#define node1can2	0x102L
#define node2can2	0x202L

#define SYS_FREQ	(80000000L)
#define CAN_BUS_SPEED  250000		// CAN Speed

uint8_t NUM_TLC5974 = 2;

uint8_t data = 72;
uint8_t clock  = 73;
uint8_t latch =  74;
uint8_t oe = -1 ; // set to -1 to not use the enable pin (its optional)

int node1can1 = 0x101;
int RPM = 3000;
int Redline = 5500;
int Shiftline = 4500;
int Yellowline = 3000;
int Greenline = 0;
uint8_t byteTemp = 0;
uint8_t byteIn = 0;


char SerialIn[20];
int red = 0;
int green = 4096;
int blue = 0;
char* CANData;
uint8_t Flashers = 0;



Adafruit_TLC5947 tlc = Adafruit_TLC5947(NUM_TLC5974, clock, data, latch);



/* ------------------------------------------------------------ */
/*		Global Variables				*/
/* ------------------------------------------------------------ */

/* CAN controller interface object instances.
*/
CAN    canMod1(CAN::CAN1);    // this object uses CAN module 1
DSPI0  spi;
CAN::RxMessageBuffer * RXmessage;
/* ------------------------------------------------------------ */
/*		Local Variables					*/
/* ------------------------------------------------------------ */

/* CAN Message Buffers */
uint8_t  CAN1MessageFifoArea[2 * 8 * 16];
static volatile int RPM_Number = 0;
/* These are used as event flags by the interrupt service routines. */
static volatile bool isCAN1MsgReceived = false;


/* ------------------------------------------------------------ */
/*		Forward Declarations				*/
/* ------------------------------------------------------------ */

void initCan1(uint32_t myaddr);
void doCan1Interrupt();
void txCAN1(uint32_t rxnode);
//void rxCAN1(void);
void doCan1Interrupt();

/* ------------------------------------------------------------ */
/*		Procedure Definitions				*/
/* ------------------------------------------------------------ */
/***  setup
**
**  Parameters:
**    none
**
**  Return Value:
**    none
**
**  Errors:
**    none
**
**  Description:
**    Initialize the program for execution. Initialize the
**    CAN controller modules before use. Install the interrupt
**    service routines used to indicate packet reception.
**    Initialize the serial interface to print the activity
**    to the serial monitor.
*/

void
setup() {    

  //| CAN setup
  initCan1(node1can1);   // Init each CAN controller module for use.
  canMod1.attachInterrupt(doCan1Interrupt); //Install the interrupt service routines.

  Serial.begin(9600);   //Set up the serial monitor to show program activity.
  
  //| SPI 
  spi.begin(53);
  spi.setSpeed(250000);
  
  //CANData = "3000";
  //| LED
  tlc.begin();

  if (oe >= 0) {
    pinMode(oe, OUTPUT);
    digitalWrite(oe, LOW);
  }  
}

/* ------------------------------------------------------------ */
/***  loop
**
**  Parameters:
**
**  Return Value:
**
**  Errors:
**
**  Description:
**    Program event loop. This function is called repeatedly forever
**    after setup has been executed. Send a packet from CAN2 to CAN1.
**    Receive the packet on CAN1 and print the result. Send a
**    packet from CAN1 to CAN2. Have CAN2 receive the packet and
**    print the result.
*/
String inString = "";


void loop() {
 //txCAN1(0x20);
  //delay(500);
  
if((Serial.available())> 0){
  byteIn = Serial.read(); 
  switch(byteIn){
    case 0x01: 
                byteTemp = Greenline >> 8;
                Serial.write(byteTemp);
                byteTemp = Greenline & 0x000000ff;
                Serial.write(byteTemp);
                break;
    case 0x02: 
                byteTemp = Yellowline >> 8;
                Serial.write(byteTemp);
                byteTemp = Yellowline & 0x000000ff;
                Serial.write(byteTemp);
                break;
     case 0x03: 
                byteTemp = Shiftline >> 8;
                Serial.write(byteTemp);
                byteTemp = Shiftline & 0x000000ff;
                Serial.write(byteTemp);
                break;
     case 0x04: 
                byteTemp = Redline >> 8;
                Serial.write(byteTemp);
                byteTemp = Redline & 0x000000ff;
                Serial.write(byteTemp);
                break;
     case 0x05: 
                Serial.write((byte) 0x00);
                byteTemp = node1can1 & 0x000000ff;
                Serial.write(byteTemp);
                break;
     default:   Serial.write((byte) 0x01);
   }   
}
 /* if (Serial.available() > 0){
    for(int i =0; i <5;i++){
      RPM_Number = Serial.read();
      // convert the incoming byte to a char 
      // and add it to the string:
      inString += (char)RPM_Number; 
    }
  }
    // if you get a newline, print the string,
    // then the string's value:

     rxCAN1(); */
    
//}

  //RPM = ReadInt();
  RPM++;  //MakemRed();
  if (RPM == 10000) RPM = 0;
  
  
  rxCAN1();
  if(CANData != NULL){
  //RPM = atoi(CANData);
  Serial.println("This is RPM: ");
  Serial.println(CANData);
  }
  //Serial.println(CANData);
 // RPM++;
  //if(RPM == 8000) RPM = 0;
  
  LEDColorSet();
  LEDControl(RPM);
  //if(message ->data[0] != NULL);
  //Serial.print(message->data);
}


int ReadInt(){
  int i = 0;
  int IntIn;
  
  if (Serial.available() > 0){
  while (Serial.available() > 0){
    Serial.println("working");
    SerialIn[i] = Serial.read();
    Serial.println(SerialIn);
    i++;
    Serial.println("working");
  }  SerialIn[i] = NULL;
  }
  if (SerialIn[0] != NULL) IntIn = atoi(SerialIn);
  return IntIn;
}

void LEDColorSet(){
 
 if (RPM >=Redline){
   Flashers++;
   if(Flashers == 10) Flashers = 0;
   if(Flashers <= 5){
     red = 1000;
     green = 0;
     blue = 0;
   } else {
     red = 0;
     green = 0;
     blue = 0;
   }
 }else if (RPM >= Shiftline){
   red = 1000;
   green = 0;
   blue = 0;
 } else if(RPM >= .90*Shiftline){
   red = 1000;
   green = 500*((Shiftline - RPM)/(.10*Shiftline)); 
   blue = 0;   
 } else if (RPM >= Yellowline){
   red = 1000;
   green = 500;
   blue = 0;
   }
   else if (RPM >= .90*Yellowline){
     red = 1000*((Yellowline - RPM)/(.10*Yellowline));
     green = 500;
     blue = 0;
   } else {
   red = 0;
   green = 500;
   blue = 0; 
   }  
}


/* ------------------------------------------------------------ */
/*      LED Utility Functions                                   */
/* ------------------------------------------------------------ */

// Fill the dots one after the other with a color
void colorWipe(uint16_t r, uint16_t g, uint16_t b, uint8_t wait) {
  for(uint16_t i=0; i<8*NUM_TLC5974; i++) {
      tlc.setLED(i, r, g, b);
      tlc.write();
      delay(wait);
  }
}

// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycle(uint8_t wait) {
  uint32_t i, j;

  for(j=0; j<4096; j++) { // 1 cycle of all colors on wheel
    for(i=0; i< 8*NUM_TLC5974; i++) {
      Wheel(i, ((i * 4096 / (8*NUM_TLC5974)) + j) & 4095);
    }
    tlc.write();
    delay(wait);
  }
}

// Input a value 0 to 4095 to get a color value.
// The colours are a transition r - g - b - back to r.
void Wheel(uint8_t ledn, uint16_t WheelPos) {
  if(WheelPos < 1365) {
    tlc.setLED(ledn, 3*WheelPos, 4095 - 3*WheelPos, 0);
  } else if(WheelPos < 2731) {
    WheelPos -= 1365;
    tlc.setLED(ledn, 4095 - 3*WheelPos, 0, 3*WheelPos);
  } else {
    WheelPos -= 2731;
    tlc.setLED(ledn, 0, 3*WheelPos, 4095 - 3*WheelPos);
  }
}


void RedToGreen (uint8_t wait){
  uint32_t i, j;
   for(j=0; j<4096; j = j+ 10 ) { // 1 cycle of all colors on wheel
    for(i=0; i< 8*NUM_TLC5974; i++) {
      tlc.setLED(i, 4096-j, j, 0);
    }
    tlc.write();
    delay(wait);
  }
  
}


void GreenToRed (uint8_t wait){
  uint32_t i, j;
   for(j=0; j<4096; j = j+ 10 ) { // 1 cycle of all colors on wheel
    for(i=0; i< 8*NUM_TLC5974; i++) {
      tlc.setLED(i, j, 4096-j, 0);
    }
    tlc.write();
    delay(wait);
  }
  
}

void MakemRed(){
  for(int i=0; i< 8*NUM_TLC5974; i++) {     
      tlc.setLED(i, 100, 0, 0);      
  }  
  tlc.write();  
}


void LEDControl(int RPM){
 
 for(int i=0; i< 8*NUM_TLC5974/2; i++) {
   if (RPM > i * Shiftline/8){
     tlc.setLED(i, red, green, blue);
     tlc.setLED(8*NUM_TLC5974 - i - 1, red, green, blue);
   } else{
     tlc.setLED(i, 0, 0, 0);
     tlc.setLED(8*NUM_TLC5974 - i - 1, 0, 0, 0);
   }
   
    /*if((Redline - RPM) <= Redline/(i+1)){
      	tlc.setLED(i+1, 0, 4096, 0);
      	tlc.setLED(8*NUM_TLC5974 - i, 0, 4096, 0);
    } else{
        tlc.setLED(i, 0, 0, 0);
        tlc.setLED(8*NUM_TLC5974 - i, 0, 0, 0);
    }*/
   
  }  
  tlc.write();
}

/* ------------------------------------------------------------ */
/*      CAN Utility Functions                                   */
/* ------------------------------------------------------------ */
/***  initCan1
**
**  Parameters:
**      myaddr    - network address
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Initialize the CAN controller. See inline comments
**      for description of the process.
*/

void initCan1(uint32_t myaddr) {
  CAN::BIT_CONFIG canBitConfig;

  /* Step 1: Switch the CAN module
   * ON and switch it to Configuration
   * mode. Wait till the switch is 
   * complete */

  canMod1.enableModule(true);

  canMod1.setOperatingMode(CAN::CONFIGURATION);
  
  while(canMod1.getOperatingMode() != CAN::CONFIGURATION);			

  /* Step 2: Configure the CAN Module Clock. The
   * CAN::BIT_CONFIG data structure is used
   * for this purpose. The propagation, 
   * phase segment 1 and phase segment 2
   * are configured to have 3TQ. The CANSetSpeed()
   * function sets the baud. */
	
  canBitConfig.phaseSeg2Tq            = CAN::BIT_3TQ;
  canBitConfig.phaseSeg1Tq            = CAN::BIT_3TQ;
  canBitConfig.propagationSegTq       = CAN::BIT_3TQ;
  canBitConfig.phaseSeg2TimeSelect    = CAN::TRUE;
  canBitConfig.sample3Time            = CAN::TRUE;
  canBitConfig.syncJumpWidth          = CAN::BIT_2TQ;

  canMod1.setSpeed(&canBitConfig,SYS_FREQ,CAN_BUS_SPEED);

  /* Step 3: Assign the buffer area to the
   * CAN module.
   */ 
  /* Note the size of each Channel area.
   * It is 2 (Channels) * 8 (Messages Buffers) 
   * 16 (bytes/per message buffer) bytes. Each 
   * CAN module should have its own message 
   * area. */
   
  canMod1.assignMemoryBuffer(CAN1MessageFifoArea,2 * 8 * 16);	

  /* Step 4: Configure channel 0 for TX and size of
   * 8 message buffers with RTR disabled and low medium
   * priority. Configure channel 1 for RX and size
   * of 8 message buffers and receive the full message.
   */

  canMod1.configureChannelForTx(CAN::CHANNEL0,8,CAN::TX_RTR_DISABLED,CAN::LOW_MEDIUM_PRIORITY);
  canMod1.configureChannelForRx(CAN::CHANNEL1,8,CAN::RX_FULL_RECEIVE);
	
  /* Step 5: Configure filters and mask. Configure
   * filter 0 to accept SID messages with ID 0x200.
   * Configure filter mask 0 to compare all the ID
   * bits and to filter by the ID type specified in
   * the filter configuration. Filter 0 accepted 
   * messages are stored in channel 1.  */

  canMod1.configureFilter      (CAN::FILTER0, myaddr, CAN::SID);    
  canMod1.configureFilterMask  (CAN::FILTER_MASK0, 0xFFF, CAN::SID, CAN::FILTER_MASK_IDE_TYPE);
  canMod1.linkFilterToChannel  (CAN::FILTER0, CAN::FILTER_MASK0, CAN::CHANNEL1); 
  canMod1.enableFilter         (CAN::FILTER0, true);
	
  /* Step 6: Enable interrupt and events. Enable the receive
   * channel not empty event (channel event) and the receive
   * channel event (module event).
   * The interrrupt peripheral library is used to enable
   * the CAN interrupt to the CPU. */

  canMod1.enableChannelEvent(CAN::CHANNEL1, CAN::RX_CHANNEL_NOT_EMPTY, true);
  canMod1.enableModuleEvent(CAN::RX_EVENT, true);

  /* Step 7: Switch the CAN mode
   * to normal mode. */

  canMod1.setOperatingMode(CAN::NORMAL_OPERATION);
  while(canMod1.getOperatingMode() != CAN::NORMAL_OPERATION);			
  
}

/* ------------------------------------------------------------ */
/***  txCAN1
**
**  Parameters:
**      rxnode    - address of network node to receive the packet
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Initialize a packet buffer with the packet header and the
**      packet payload. The payload in this case is a single
**      ASCII character (0x31 = '1'). Transmit the packet.
*/

void txCAN1(uint32_t rxnode) {
  
  CAN::TxMessageBuffer * message;
  //Serial.println("Trying to send can message... Bad dog!");
  message = canMod1.getTxMessageBuffer(CAN::CHANNEL0);

  if (message != NULL) {
    // clear buffer
    message->messageWord[0] = 0;
    message->messageWord[1] = 0;
    message->messageWord[2] = 0;
    message->messageWord[3] = 0;

    message->msgSID.SID   = rxnode;	//receiving node		
    message->msgEID.IDE   = 0;			
    message->msgEID.DLC   = 1;			
    message->data[0]      = 0x31;
    message->data[1]      = 0x31;
    message->data[2]      = 0x32;
    message->data[3]      = 0x33;
    message->data[4]      = 0x34;
    message->data[5]      = 0x35;
    message->data[6]      = 0x36;
    message->data[7]      = 0x37;

    /* This function lets the CAN module
     * know that the message processing is done
     * and message is ready to be processed. */
     
     canMod1.updateChannel(CAN::CHANNEL0);

    /* Direct the CAN module to flush the
     * TX channel. This will send any pending
     * message in the TX channel. */

    canMod1.flushTxChannel(CAN::CHANNEL0);
  }	
}

/* ------------------------------------------------------------ */
/***  rxCAN1
**
**  Parameters:
**        none
**
**  Return Value:
**        none
**
**  Errors:
**        none
**
**  Description:
**      Check to see if a packet has been received. If so, read
**      the packet and print the packet payload to the serial
**      monitor.
*/

void rxCAN1() {
  
 
  //Serial.println("Trying to read the buffer...");
  if (isCAN1MsgReceived == false) { 
    /* CAN2 did not receive any message
     * so exit the function. Note that the
     * isCAN2MsgReceived flag is updated 
     * by the CAN2 ISR. */
    return;
  } //Serial.println("Yeah it read it alright");
	
  /* Message was received. Reset isCAN2MsgReceived flag
   * to catch the next message. */

  isCAN1MsgReceived = false;	
	
  RXmessage = canMod1.getRxMessage(CAN::CHANNEL1);

  /* Print the first byte of the packet payload area
   * as an ASCII character on the serial monitor. */
   
  //Serial.print(byte(message->data[0]));
  CANData = (char*) RXmessage->data;
  Serial.print(CANData);
  if(CANData != NULL) Serial.println("Shit's not null dude");
  
  if(CANData == NULL) Serial.println("Null?"); 

  /* Call the CAN::updateChannel() function to let
   * the CAN module know that the message processing
   * is done. Enable the event so that the CAN module
   * generates an interrupt when the event occurs.*/

  canMod1.updateChannel(CAN::CHANNEL1);
  canMod1.enableChannelEvent(CAN::CHANNEL1, CAN::RX_CHANNEL_NOT_EMPTY, true);

}

/* ------------------------------------------------------------ */
/*        Interrupt Handler Functions                           */
/* ------------------------------------------------------------ */
/***  doCan1Interrupt
**
**  Parameters:
**      none
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Interrupt service routine to handle interrupt level
**      events for CAN module 1.
*/

void doCan1Interrupt() {
  /* This is the CAN1 Interrupt Handler.
   * This is not the actual Interrupt Service Routine,
   * but is the user interrupt handler installed by
   * CAN::attachInterrupt. This is called by the ISR.
   * Note that there are many events in the CAN1 module
   * that can cause this interrupt. These events are 
   * enabled by the CAN::enableModuleEvent() function.
   * In this example, only the CAN::RX_EVENT is enabled. */


  /* Check if the source of the interrupt is CAN::RX_EVENT. 
   * This is redundant  since only this event is enabled
   * in this example but this shows one scheme for handling
   * interrupts. */

  if ((canMod1.getModuleEvent() & CAN::RX_EVENT) != 0) {
		
    /* Within this, you can check which event caused the 
     * interrupt by using the CAN::getPendingEventCode() function
     * to get a code representing the highest priority active
     * event.*/ 
		
    if(canMod1.getPendingEventCode() == CAN::CHANNEL1_EVENT) {
      /* This means that channel 1 caused the event.
       * The CAN::RX_CHANNEL_NOT_EMPTY event is persistent. You
       * could either read the channel in the ISR
       * to clear the event condition or as done 
       * here, disable the event source, and set
       * an application flag to indicate that a message
       * has been received. The event can be
       * enabled by the application when it has processed
       * one message.
       *
       * Note that leaving the event enabled would
       * cause the CPU to keep executing the ISR since
       * the CAN::RX_CHANNEL_NOT_EMPTY event is persistent (unless
       * the not empty condition is cleared.) 
       * */
			
      canMod1.enableChannelEvent(CAN::CHANNEL1, CAN::RX_CHANNEL_NOT_EMPTY, false);
      isCAN1MsgReceived = true;	
    }
  }

  /* The CAN1 Interrupt flag is cleared by the interrupt service routine
   * after this function returns. This will succeed because the event
   * that caused this interrupt to occur (CAN::RX_CHANNEL_NOT_EMPTY) is disabled.
   * The ISR's attempt to clear the CAN1 interrupt flag would fail if the
   * CAN::RX_CHANNEL_NOT_EMPTY event were still enabled because the base event
   * is still present. In this case, another interrupt would occur immediately */ 
	
}
