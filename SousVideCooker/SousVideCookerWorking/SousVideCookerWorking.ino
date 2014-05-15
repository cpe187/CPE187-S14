#include <SPI.h>
#include <Ethernet.h>

#include <OneWire.h>

#define DEUBG_PRINT
OneWire  ds(3);  // on pin 10 (a 4.7K resistor is necessary)

const int relayPin = 4;

boolean enabled = false;
double currentTemperature;
double desiredTemperature = 135;
unsigned long lastStateChangeTime = 0;

enum { LOWER_TEMPERATURE, TURNED_ON, COOLDOWN, CLOSE_TEMEPRATURE } state = LOWER_TEMPERATURE;

byte mac[] = { 
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192,168,1,177);

EthernetServer server(80);

void setup()
{
  Serial.begin(9600);
  pinMode(relayPin, OUTPUT);
  Ethernet.begin(mac, ip);
  server.begin();
}

void loop()
{
  currentTemperature = getTemp();
  
  debugPrint();
  stateMachine();
  checkEthernet();
}


boolean proccess_line(char *line)
{
  if (strncmp(line, "GET /on", 7) == 0)
  {
    enabled = true;
    return true;
  }
  else if (strncmp(line, "GET /off", 8) == 0)
  {
    enabled = false;
    return true;
  }
  else if (strncmp(line, "GET /temp?val=", 14) == 0)
  {
    int temp = atoi(line+14);
    if (temp < 120)
    {
      desiredTemperature = 120;
    }
    else if (temp > 199)
    {
      desiredTemperature = 199;
    }
    else
    {
      desiredTemperature = temp;
    }
    return true;
  }
  return false;
}
void checkEthernet()
{
  static char buffer[150] = { 0 };
  static int i = 0;
EthernetClient client = server.available();
  if (client) {
    boolean redirect = false;    
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        //Serial.write(c);
        if (c == '\n')
        {
          boolean redir = proccess_line(buffer);
          if (redir == true)
          {
            redirect = true;
          }
          buffer[0] = '\0';
          i=0;
        }
        else
        {
          buffer[i++] = c;
          buffer[i] = '\0';
        }
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        if (c == '\n' && currentLineIsBlank) {
          
          if (redirect)
          {
            client.println("HTTP/1.1 302 Found");
            client.println("Location: /");
          }
          else
          {
            // send a standard http response header
            client.println("HTTP/1.1 200 OK");
            client.println("Content-Type: text/html");
            client.println("Connection: close");  // the connection will be closed after completion of the response
  	  //client.println("Refresh: 5");  // refresh the page automatically every 5 sec
            client.println();
            client.println("<!DOCTYPE HTML>");
            client.println("<html>");
            client.println("<center>");
            client.println("<h1>Sprint 2014 CPE 187 - Sous Vide Cooker</h1>");
            // output the value of each analog input pin
            client.print("Current Temperature: ");
            client.print(currentTemperature);
            client.print("<br/>Desired Temperature: ");
            client.print(desiredTemperature);
            client.print("<br/>");
            client.print("<form name=\"input\" action=\"temp\" method=\"get\">");
            client.print("Set Desired Temperature: <input type=\"number\" name=\"val\" value=\"");
            client.print((int)desiredTemperature);
            client.print("\">");
            client.print("<input type=\"submit\" value=\"Set\">");
            client.print("</form>");
            if (enabled)
              client.print("<a href=\"/off\">Turn Off</a><br/>");
            else
              client.print("<a href=\"/on\">Turn On</a><br/>");
            client.println("</center>");
            client.println("</html>");
          }
          break;
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } 
        else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
  }
}  
  
void debugPrint()
{
  static unsigned long lastPrint = millis();
  
  if (millis() - lastPrint > 1000)
  {
    lastPrint = millis();
    Serial.print("Temperature: ");
    Serial.println(currentTemperature);
    Serial.print("State: ");
    if (enabled)
    {
      switch (state)
      {
        case LOWER_TEMPERATURE:
          Serial.println("LOWER_TEMPERATURE");
          break;
        case TURNED_ON:
          Serial.println("TURNED_ON");
          break;
        case COOLDOWN:
          Serial.println("COOLDOWN");
          break;
        case CLOSE_TEMEPRATURE:
          Serial.println("CLOSE_TEMEPRATURE");
          break;
      }
    }
    else
    {
      Serial.println("DISABLED");
    }
  }
}

void stateMachine()
{
  if (enabled)
  {
    switch (state)
    {
      case LOWER_TEMPERATURE:
        digitalWrite(relayPin, HIGH);
        if (currentTemperature + 5 > desiredTemperature)
        {
          state = TURNED_ON;
          Serial.println("Changing to TURNED_ON state");
          lastStateChangeTime = millis();
        }
        break;
      case TURNED_ON:
        digitalWrite(relayPin, HIGH);
        if (millis() - lastStateChangeTime > 20000)
        {
          state=COOLDOWN;
          Serial.println("Changing to COOLDOWN state");
          lastStateChangeTime = millis();
        }
        break;
      case COOLDOWN:
        digitalWrite(relayPin, LOW);
        if (millis() - lastStateChangeTime > 40000)
        {
          state=CLOSE_TEMEPRATURE;
          lastStateChangeTime = millis();
          Serial.println("Changing to CLOSE_TEMPERATURE state");
        }
        break;
      case CLOSE_TEMEPRATURE:
        if (currentTemperature + 5 < desiredTemperature)
        {
          state = LOWER_TEMPERATURE;
          lastStateChangeTime = millis();
          Serial.println("Changing to LOWER_TEMPERATURE state");
        }
        else if (currentTemperature + 2 < desiredTemperature)
        {
          state = TURNED_ON;
          lastStateChangeTime = millis();
          Serial.println("Changing to TURNED_ON state");
        }
        break;
      default:
        break;
    }
  }
  else
  {
    digitalWrite(relayPin, LOW);
  }
}

double getTemp()
{
  byte addr[] = { 0x28, 0x11, 0xC7, 0x89, 0x05, 0x00, 0x00, 0x7E };
  byte i;
  byte present = 0;
  byte type_s = 0;
  byte data[12];
  float celsius, fahrenheit;
  
  if (OneWire::crc8(addr, 7) != addr[7]) {
      return 0;
  }

  ds.reset();
  ds.select(addr);
  ds.write(0x44, 1);        // start conversion, with parasite power on at the end
  
  //delay(1000);     // maybe 750ms is enough, maybe not
  // we might do a ds.depower() here, but the reset will take care of it.
  
  present = ds.reset();
  ds.select(addr);    
  ds.write(0xBE);         // Read Scratchpad

  for ( i = 0; i < 9; i++) {           // we need 9 bytes
    data[i] = ds.read();
  }

  // Convert the data to actual temperature
  // because the result is a 16 bit signed integer, it should
  // be stored to an "int16_t" type, which is always 16 bits
  // even when compiled on a 32 bit processor.
  int16_t raw = (data[1] << 8) | data[0];
  if (type_s) {
    raw = raw << 3; // 9 bit resolution default
    if (data[7] == 0x10) {
      // "count remain" gives full 12 bit resolution
      raw = (raw & 0xFFF0) + 12 - data[6];
    }
  } else {
    byte cfg = (data[4] & 0x60);
    // at lower res, the low bits are undefined, so let's zero them
    if (cfg == 0x00) raw = raw & ~7;  // 9 bit resolution, 93.75 ms
    else if (cfg == 0x20) raw = raw & ~3; // 10 bit res, 187.5 ms
    else if (cfg == 0x40) raw = raw & ~1; // 11 bit res, 375 ms
    //// default is 12 bit resolution, 750 ms conversion time
  }
  celsius = (float)raw / 16.0;
  return celsius * 1.8 + 32.0;
}
