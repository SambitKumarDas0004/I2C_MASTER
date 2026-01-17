//=====================================================
// TEST BENCH
//=====================================================
`timescale 1ns / 1ps

module tb_master;

    reg        clk	   ;
    reg        start   ;
	reg  [7:0] bus_addr_master;
    reg  [7:0] bus_in_master  ;
    wire [7:0] bus_out_master ;

    wire sda;
    wire scl;

    master dut (
        .sda(sda),
        .scl(scl),
        .clk(clk),
        .start(start),
		.bus_addr_master(bus_addr_master),
        .bus_in_master(bus_in_master),
        .bus_out_master(bus_out_master)
    );
    
    pullup(sda);
    pullup(scl);

    //---------------- Clock ----------------
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end
    
    //==================================================================================
    //---------------------- Data Write ------------------------------------------------
    //==================================================================================
    
	//---------------ACK/NACK------------------
    initial begin
    #260              //Addr ACK from slave 260-280
    force sda = 1'b0;
    #20
	release sda;
	#20 #140         //Data ACK from slave 440-460
	force sda = 1'b0;
    #20
	release sda;
	#40 #120            //Repeat Start 620-640
	force sda = 1'b0;
	#20
	release sda;
	#180           //  ACK from slave
	force sda = 1'b0;
	#20
	release sda;
	#160           //  NACK from slave
	force sda = 1'b1;
	#20
	release sda;
	end
	//--------------- Slave Addresses -----------------
	initial begin
	  bus_addr_master <= 8'b01100110; // lsb is r/!w bit
	 #500
	 bus_addr_master <= 8'b01100111;
	end
    //---------------- Data ----------------
    initial begin
        start  = 0;
        bus_in_master = 8'ha6;
        #50
        start  = 1;
        #20 
        start = 0;
        #210
        bus_in_master = 8'hA6;
		#180;
		bus_in_master = 8'h3C;
        #220
        bus_in_master = 8'b10011101;
    end
    //==================================================================================
    //---------------------- Data Read ------------------------------------------------
    //==================================================================================
    initial begin
     #1000
	 bus_addr_master <= 8'b01100111; // lsb is r/!w bit
	end
    
    //---------------- Start ----------------
    initial begin
    #1100
        start  = 0;
        #20;
        start  = 1;
        #20 
        start = 0;
    end
    //-------------- ACK/NACK -----------------
    initial begin
    #1000
    #320
    force sda = 1'b0;#20 // ACK 1320-1340
    force sda = 1'b1;#20 // DATA 1101_0110
    force sda = 1'b1;#20
    force sda = 1'b0;#20
    force sda = 1'b1;#20
    force sda = 1'b0;#20
    force sda = 1'b1;#20
    force sda = 1'b1;#20
                             // from data tranfer state to ack state
    force sda = 1'b0;#20    // from ack to again data tranf
    force sda = 1'b0;#20

    
	release sda;        // stop state
	end
	
    
endmodule
