/* Project Climate Control Vent System - Main Unit
 * CSUS - CPE 187 Spring 2014
 *
 * The Climate Control Vent System consists of wireless temperature sensors 
 * and servo motors. Each room will have a temperature sensor and servo motor.
 * The base unit receives sensor reading from the wireless sensor and makes
 * decisons to turn on the servos and control the HVAC.
 *
 * Authors: Logan Odell, 
 */

/* ***************************************************
 * INCLUDES
 * Add any includes to this section
 * ***************************************************/
#include <Servo.h>
/* ***************************************************
 * CONSTANTS
 * Add any constants, defines or macros to this section
 * ***************************************************/
const int ventServoPin = 9;
/* ***************************************************
 * GLOBALS
 * Add any global variables to this section
 * ***************************************************/
Servo ventServo;
int servoPosition = 0;
int desiredTemperature = 75; // in degrees F

 /* Setup function is run once on startup. Use this function to initialize 
 * any variables, pin modes, libraries or make other one-time calls */
void setup()
{
  // Attach the pin to the servo object
  ventServo.attach(ventServoPin);
  // And reset the servo's position
  ventServo.write(servoPosition);
}

/* Loop function is repeated indefinitely. Any code that should continuously
 * be executed, should be place in this function. Avoid using delay calls by
 * using the concepts demonstrated in the BlinkWithoutDelay() example */
void loop()
{
  
}

/* This function needs to be implemented and will turn on or off the HVAC.
 * How do we plan on doing this? */
void setHVAC(int mode)
{
  // TODO: Implement this. Mode should be 0 for off, 1 for cool, 2 for heat.
}
