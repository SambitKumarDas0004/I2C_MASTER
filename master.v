//DESIGN       : I2C PROTOCOL
//SERIAL CLOCK : SDA
//SERIAL DATA  : SCL
//BLOCKS       : MASTER

// MASTER : INOUT SDA, INOUT SCL
`timescale 1ns / 1ps
module master(
              sda ,
			  scl ,
			  clk ,
			  start,
			  bus_addr_master,
			  bus_in_master,
			  bus_out_master );
			  
			  inout    	    sda		; 	//Bi-directional open-drain pull up wire
			  inout             scl		; 	//Bi-directional open-drain pull up wire
			  
			  input             clk;
			  input 	    start;
			  input      [7:0]  bus_addr_master;    //Address of slave
			  input      [7:0]  bus_in_master;      //Data to be sent
			  
			  output reg [7:0]  bus_out_master;     //To store data from slave
			  
				 reg  ctrl_sda	;               // To control sda
				
			         reg  scl_out	;               //will be used as clock
				 wire  scl_out2	;               //for driving scl
				
			  
	assign sda = (ctrl_sda==1'b1) ? 1'b0 : 1'bz  ;          //sda will be released if ctrl is high
    
	
	
	
	
	reg    [3:0]   bit_count;	// To count 8 clock pulse then change state
			
	parameter [3:0]	IDEAL 		= 4'd0,
			START		= 4'd1,
			ADDRESS_OUT     = 4'd2,
			ACK1            = 4'd3,
			DATA_OUT	= 4'd4,
			ACK2            = 4'd5,
			DATA_IN         = 4'd6,
			ACK3            = 4'd7,
			STOP 		= 4'd8,
			RPT_START       = 4'd9;
			
	reg       [3:0] next_state, present_state;

	//initializing registers					
	initial begin
        ctrl_sda        = 1'b0;
        scl_out         = 1'b1;
        bit_count       = 4'd0;
        present_state   = IDEAL;
        next_state      = IDEAL;
        bus_out_master  = 8'd0;
    end
						
		//generation of scl
		always@(posedge clk) begin
		     scl_out = ~scl_out;    
		end
                     assign scl_out2 = (present_state!=IDEAL)? scl_out :1'b1; 
                     assign scl = scl_out2;
		

               //function of state registers
		always@(negedge scl_out) begin
			 present_state = next_state	; 
		end
            
		
		//operation of states    
		always@(negedge scl_out) begin
		ctrl_sda   = 1'b0;
		    case(present_state) 
                    //if start goes hign next state will be START
			    IDEAL 	      : begin
			                                     
			                                  if(start==1'b1) begin
								next_state = START;
							  end	
						end

                   //next state will be ADDRESS_OUT
	 	   //pulls sda low
			    START             : begin
				                                next_state = ADDRESS_OUT;
								ctrl_sda   = 1'b1;
								bit_count  = 4'd0;
						end
	
                  //send address of slave from MSB to LSB
                  //when bit count is 7, next state is ACK1
                            ADDRESS_OUT       : begin
                                                    
							  if(bit_count<4'd7) begin
								ctrl_sda   = ~bus_addr_master[7-bit_count];
								bit_count  = bit_count +1'b1;
							  end else if(bit_count==4'd7) begin
									ctrl_sda   = ~bus_addr_master[0];
									next_state = ACK1;
							  end		
						end	
                            
                  //if sda is low then slave acknowledged the address otherwise nest state is STOP
                  //bus_addr_master[0]=1 => data read
                  //bus_addr_master[0]=0 => data write       
			    ACK1	      : begin
			                                        bit_count  = 4'd0;
								ctrl_sda   = 1'b0;
							  if(sda == 1'b0) begin
								if(bus_addr_master[0]) begin
									next_state = DATA_IN;
								end else 
									next_state = DATA_OUT;
							  end else if(sda == 1'b1) begin
									next_state = STOP;
			                                  end    
						 end	
				
		 //writes 8-bit serial data on sda
                            DATA_OUT          :  begin
				                          if(bit_count<4'd7) begin
									ctrl_sda   = ~bus_in_master[7-bit_count];
									bit_count  = bit_count + 1'b1;
							  end else if(bit_count==4'd7) begin
									ctrl_sda   = ~bus_in_master[0];
									next_state = ACK2;
			                                  end    
						end

                //releases sda and read for acknowledgement from slave
                //1'b1, next_state<=STOP
                //otherwise, if the lsb of address is unchanged again data write
                //otherwise next_state is RPT_START so that data can be read
			    ACK2              : begin
				                                        ctrl_sda   = 1'b0;
				                                        bit_count = 4'd0;
								if(sda) begin
									 next_state = STOP;
								end else if(bus_addr_master[0]==1'b0) begin//if still write
									next_state = DATA_OUT;
								end else  //if read is do be performed
									next_state = RPT_START;
			                                                bit_count  = 4'd0;
						end

              //reads 8-bit serial data from slave slave
		            DATA_IN           : begin
								if(bit_count < 4'd7) begin
									bus_out_master[7-bit_count] = sda;
									bit_count = bit_count + 1'b1;
								end else if(bit_count==4'd7) begin
									bus_out_master[0] = sda;
									next_state = ACK3;
			                                        end    
                                                end

	     //if want to receive data then, sda=0 or sda = 1 to stop
             //if lsb of address bit changes then next state will be RPT_START
		            ACK3              : begin
									ctrl_sda   = 1'b1;
			                                                bit_count=4'd0;
			                                        if(sda) begin
									next_state = STOP;
								end else if(bus_addr_master[0]==1'b1) begin//if still write
									next_state = DATA_OUT;
								end else  //if read is do be performed
									next_state = RPT_START;
			                                                bit_count  = 4'd0;	  
						end

	   //next state will be IDEAL state
                            STOP              : begin
                                                        next_state = IDEAL;
                                                        ctrl_sda   = 1'b0;
						end	

          //next state will be ADDRESS_OUT
		            RPT_START         : begin
				                         next_state = ADDRESS_OUT;
				                         ctrl_sda   = 1'b0;
				                                        
						end
         //default state
                            default           : begin           
                                                        next_state  = IDEAL;
			                        end          							   
			endcase
		end		
endmodule												

