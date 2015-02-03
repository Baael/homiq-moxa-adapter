# node-red-moxa

**Hacking hermetic home automation system to make it a valid part of IoT...**

##Implementation progress:

* Serial-to-Ethernet Module NE-4110S 
  * [ ] TCP client mode 
  * [ ] Real COM mode 
  * [ ] telnet/ssh restart command
  * [ ] event trapping and notifications

* communication / system
  * [ ] packets decoder
  * [ ] packets encoder
  * [ ] device registration
  * [ ] errors and unknown devices handling

* additional features
  * [ ] mqtt forwarding
  * [ ] redis as device state storage
  * [ ] Digital IO
  * [ ] moxa telnet/ssh settings
  * [ ] auth

* drivers
  * [x] NPort TTY driver update for kernel 3.11 



##What we know now:

Packet structure

>Haddr
>
>```
>SERIAL_ID-DESTINATION-DEVICE_ID
>```

>incoming:
>```
><;DEVICE_ID;VALUE;DESTINATION;0;SEQUENCE_NUMBER;PACKET_TYPE;CRC_FLAG;>\r\n
>```

>outgoing:
>
>```
><;DEVICE_ID;VALUE;0;DESTINATION;SEQUENCE_NUMBER;PACKET_TYPE;CRC_FLAG;>\r\n
>```

* *DEVICE_ID* & *DESTINATION* - translated as ```{DEVICE_ID}-{DESTINATION}``` string and forwarded to serial gateway
* *PACKET_TYPE* - can be _a_ (answer) or _s_ (set)
* *SEQUENCE_NUMBER* - taken from _answer_ packets and incremented by 1,  max 1024
* *CRC_FLAG* - crc81wire based on all values joined together

Known serial numbers
>002J6, 002JE, 002H9, 002H3, 002JH, 002Ie

##Devices
###Serial-to-Ethernet Module NE-4110S 

> http://www.moxa.com/product/NE-4110S.htm

![](http://www.moxa.com/ImgUpload/editor/D1(7).png)


NPort Fixed TTY Driver for Unix
> http://www.moxa.com/support/download.aspx?type=support&id=880

NPort Even More Fixed TTY Driver for Unix (my fixes for kernel 3.11)


Additional links:
> http://www.moxa.ru/forum/index.php?/topic/1732-%D0%BF%D1%80%D0%BE%D1%88%D1%83-%D0%BF%D0%BE%D0%BC%D0%BE%D1%87%D1%8C-%D1%81%D0%BE-%D1%81%D0%B1%D0%BE%D1%80%D0%BA%D0%BE%D0%B9-linux-%D0%B4%D1%80%D0%B0%D0%B9%D0%B2%D0%B5%D1%80%D0%B0-%D0%B4%D0%BB%D1%8F-nport-5150/

