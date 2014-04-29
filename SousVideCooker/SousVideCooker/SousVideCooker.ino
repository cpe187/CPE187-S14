/* Project Sous Vide
 * CSUS - CPE 187 Spring 2014
 *
 * The Sous Vide cooker heats a water bath to a specific temperature in order to
 * cook food. This sketch handles reading the temperature, calculating the PID
 * output based on the current temperature and the target temperature.
 */
 
/* ***************************************************
 * INCLUDES
 * Add any includes to this section
 * ***************************************************/
 
/* ***************************************************
 * CONSTANTS
 * Add any constants, defines or macros to this section
 * ***************************************************/
 
// digital pin to control the water heater pin
const int waterHeaterPin = 5;

/* ***************************************************
 * GLOBALS
 * Add any global variables to this section
 * ***************************************************/
float targetTemperature = 130; // in degrees farhenheit
float currentTemperature = 0; // in degrees farhenheit
boolean enabled = false; // determines whether the device is on
int waterHeaterState = LOW; // set by the PID, turns the water heater on/off
 
/* Setup function is run once on startup. Use this function to initialize 
 * any variables, pin modes, libraries or make other one-time calls */
void setup()
{
  // waterHeaterPin set to OUTPUT
  pinMode(waterHeaterPin, OUTPUT);
}

/* Loop function is repeated indefinitely. Any code that should continuously
 * be executed, should be place in this function. Avoid using delay calls by
 * using the concepts demonstrated in the BlinkWithoutDelay() example */
void loop()
{
  /* Check Interface Commands
   * This section should handle any incoming commands from the user interface. It
   * should report currentTemperature and handle changes to the targetTemperature
   * and enabled variables.
   */
   
  /* Measure Temperature
   * This section should handle measuring the water temperature into currentTemperature.
   */
  
  /* PID Calculations
   * This section should handle making PID calculations. Inputs should be 
   * currentTemperature, and targetTemperature. Output should be waterHeaterState.
   */
   
  // If enabled, set the state of the water heater based on the PID output
  if (enabled)
  {
    digitalWrite(waterHeaterPin, waterHeaterState);
  }
  // Otherwise, turn the water heater off
  else
  {
    digitalWrite(waterHeaterPin, LOW);
  }
}
