// LED Driver ---------------------------------------------------------------

#ifndef _ADAFRUIT_TLC5947_H
#define _ADAFRUIT_TLC5947_H

class Adafruit_TLC5947 {
 public:
  Adafruit_TLC5947(uint8_t n, uint8_t c, uint8_t d, uint8_t l);

  boolean begin(void);

  void setPWM(uint8_t chan, uint16_t pwm);
  void setLED(uint8_t lednum, uint16_t r, uint16_t g, uint16_t b);
  void write(void);

 private:
  uint16_t *pwmbuffer;

  uint8_t numdrivers, _clk, _dat, _lat;

};
#endif

Adafruit_TLC5947::Adafruit_TLC5947(uint8_t n, uint8_t c, uint8_t d, uint8_t l) {
  numdrivers = n;
  _clk = c;
  _dat = d;
  _lat = l;

  pwmbuffer = (uint16_t *)calloc(2, 24*n);
}

void Adafruit_TLC5947::write(void) {
  digitalWrite(_lat, LOW);
  // 24 channels per TLC5974
  for (int8_t c=24*numdrivers - 1; c >= 0 ; c--) {
    // 12 bits per channel, send MSB first
    for (int8_t b=11; b>=0; b--) {
      digitalWrite(_clk, LOW);
      
      if (pwmbuffer[c] & (1 << b))  
        digitalWrite(_dat, HIGH);
      else
        digitalWrite(_dat, LOW);

      digitalWrite(_clk, HIGH);
    }
  }
  digitalWrite(_clk, LOW);
  
  digitalWrite(_lat, HIGH);  
  digitalWrite(_lat, LOW);
}

void Adafruit_TLC5947::setPWM(uint8_t chan, uint16_t pwm) {
  if (pwm > 4095) pwm = 4095;
  if (chan > 24*numdrivers) return;
  pwmbuffer[chan] = pwm;  
}

void Adafruit_TLC5947::setLED(uint8_t lednum, uint16_t r, uint16_t g, uint16_t b) {
  setPWM(lednum*3, r);
  setPWM(lednum*3+1, g);
  setPWM(lednum*3+2, b);
}

boolean Adafruit_TLC5947::begin() {
  if (!pwmbuffer) return false;

  pinMode(_clk, OUTPUT);
  pinMode(_dat, OUTPUT);
  pinMode(_lat, OUTPUT);
  digitalWrite(_lat, LOW);

  return true;
}