# I2C_MASTER
Master block of an I2C bus 

This project implements an I2C (Inter-Integrated Circuit) Master Controller, designed in 
Verilog HDL and taken through a complete RTL-to-GDS physical design flow. The design follows
the I2C protocol specification, supporting address transmission, data transfer, acknowledgment
handling, repeated start, and stop conditions using open-drain SDA and SCL lines.

The objective of this project is to demonstrate protocol-aware RTL design, finite state machine (FSM)
implementation, clock-domain handling, and ASIC physical design best practices using industry-standard EDA tools.




![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/035022812bc331aca3dd630181e2cf94d7321e03/i2c_master_sim_waveform.jpg)
This waveform shows the functionality of the master. When start pulse is applied, present state will change from IDEAL to START also sda and scl goes slow. Then the next state will be address transfer state. Master controller will send serial address to sda from msb to lsb. Lsb determines the read or write operation. For read lsb must be 1 and for write lsb must be 0. Then next state will be acknowledgement state. If sda is 0 then master will continue data transaction, and stops the transaction if sda is 1. upto 1000ns it is data write and from 1000ns to 2000ns it is read operation.



![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/7b9284aedcbfcc8c0cf88a59c957c2bc8d02bb83/i2c_master_schematic.jpg)



![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/main/i2c_master_fp.jpg)



![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/2699a358453e5218bf67b6156ca4c94988db2426/i2c_master_powplan.jpg)




![Alt Text](https://github.com/SambitKumarDas0004/I2C_MASTER/blob/main/i2c_master_route.jpg)





![Alt Text](cc)




![Alt Text](cc)





![Alt Text](cc)





![Alt Text](cc)
