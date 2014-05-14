CAN Tachometer Windows Application
===

Application to configure CAN Tachometer for Hornet Racing.

Sachleen Sandhu

CPE 187 - Embedded Processor System Design

[California State University, Sacramento][1]

---

The application connects to a COM port with 9600/8-N-1 settings. After connecting to the device, it will send a read command for each registers.

Reading data

    Message format: [identifier]
    Response: [upper byte][lower byte]
    
    Identifier   Setting destination
    0x01         Green tachometer setting
    0x02         Yellow tachometer setting
    0x03         Red tachometer setting
    0x04         Flashing red tachometer setting
    0x05         CAN address

Writing Data

    Message format: [identifier][upper byte][lower byte]
    Response: none

    Identifier   Setting destination
    0x81         Green tachometer setting
    0x82         Yellow tachometer setting
    0x83         Red tachometer setting
    0x84         Flashing red tachometer setting
    0x85         CAN address


  [1]: http://csus.edu
