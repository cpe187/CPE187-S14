CAN Tachometer Windows Application
===

Application to configure CAN Tachometer for Hornet Racing.

Sachleen Sandhu

CPE 187 - Embedded Processor System Design

[California State University, Sacramento][1]

---

    Message format for reading data from device:
    [identifier]
    
    Identifier   Setting destination
    0x01         Green tachometer setting
    0x02         Yellow tachometer setting
    0x03         Red tachometer setting
    0x04         Flashing red tachometer setting
    0x05         CAN address


    Message format for writing data to device:
    [identifier][upper byte][lower byte]

    Identifier   Setting destination
    0x81         Green tachometer setting
    0x82         Yellow tachometer setting
    0x83         Red tachometer setting
    0x84         Flashing red tachometer setting
    0x85         CAN address


  [1]: http://csus.edu
