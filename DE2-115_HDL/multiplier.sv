module multipliersprite2x
(

   input logic [9:0] DrawX, DrawY,
	
	input logic [15:0] PosX_0, PosX_1, PosX_2, PosX_3, PosX_4, PosX_5, PosX_6, PosX_7, 
	input logic [15:0] PosY_0, PosY_1, PosY_2, PosY_3, PosY_4, PosY_5, PosY_6, PosY_7, 
	

	input logic Clk,
	
	
	output logic ispixel2
	
);

logic [31:0]count_reg = 0;
logic on_off = 0;

always_ff @(posedge Clk) begin
	if(count_reg > 32'd50000000)
	begin
		count_reg<=0;
		if(on_off)
			on_off=0;
		else
			on_off=1;
	end
	else
		count_reg<=count_reg+1;
end


reg message [168:0] =
'{
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 
0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 
0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 
0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

};


always_comb 
begin

if(on_off) begin

if( DrawX > (PosX_0 - 7) && DrawX < (PosX_0 + 7) && DrawY > (PosY_0 - 7)   && DrawY < (PosY_0 + 7)  && message[ ((13-(DrawY-(PosY_0 - 7))) * 13  ) + (13-(DrawX-(PosX_0
 - 7))) ] == 1)
	ispixel2 = 1;


	

else if( DrawX > (PosX_1 - 7) && DrawX < (PosX_1 + 7) && DrawY > (PosY_1 - 7)   && DrawY < (PosY_1 + 7)  && message[ ((13-(DrawY-(PosY_1 - 7))) * 13  ) + (13-(DrawX-(PosX_1
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_2 - 7) && DrawX < (PosX_2 + 7) && DrawY > (PosY_2 - 7)   && DrawY < (PosY_2 + 7)  && message[ ((13-(DrawY-(PosY_2 - 7))) * 13  ) + (13-(DrawX-(PosX_2
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_3 - 7) && DrawX < (PosX_3 + 7) && DrawY > (PosY_3 - 7)   && DrawY < (PosY_3 + 7)  && message[ ((13-(DrawY-(PosY_3 - 7))) * 13  ) + (13-(DrawX-(PosX_3
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_4 - 7) && DrawX < (PosX_4 + 7) && DrawY > (PosY_4 - 7)   && DrawY < (PosY_4 + 7)  && message[ ((13-(DrawY-(PosY_4 - 7))) * 13  ) + (13-(DrawX-(PosX_4
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_5 - 7) && DrawX < (PosX_5 + 7) && DrawY > (PosY_5 - 7)   && DrawY < (PosY_5 + 7)  && message[ ((13-(DrawY-(PosY_5 - 7))) * 13  ) + (13-(DrawX-(PosX_5
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_6 - 7) && DrawX < (PosX_6 + 7) && DrawY > (PosY_6 - 7)   && DrawY < (PosY_6 + 7)  && message[ ((13-(DrawY-(PosY_6 - 7))) * 13  ) + (13-(DrawX-(PosX_6
 - 7))) ] == 1)
	ispixel2 = 1;
	
	

else if( DrawX > (PosX_7 - 7) && DrawX < (PosX_7 + 7) && DrawY > (PosY_7 - 7)   && DrawY < (PosY_7 + 7)  && message[ ((13-(DrawY-(PosY_7 - 7))) * 13  ) + (13-(DrawX-(PosX_7
 - 7))) ] == 1)
	ispixel2 = 1;
else
	ispixel2 = 0;
	
end

else
	ispixel2=0;
end

endmodule

module multipliersprite3x
(

   input logic [9:0] DrawX, DrawY,
	
	input logic [15:0] PosX_0, PosX_1, PosX_2, PosX_3, PosX_4, PosX_5, PosX_6, PosX_7, 
	input logic [15:0] PosY_0, PosY_1, PosY_2, PosY_3, PosY_4, PosY_5, PosY_6, PosY_7, 
	

	input logic Clk,
	
	
	output logic ispixel2
	
);


logic [31:0]count_reg = 0;
logic on_off = 0;

always_ff @(posedge Clk) begin
	if(count_reg > 32'd50000000)
	begin
		count_reg<=0;
		if(on_off)
			on_off=0;
		else
			on_off=1;
	end
	else
		count_reg<=count_reg+1;
end


reg message [168:0] =
'{
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 
0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 
0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

};


always_comb 
begin

if(on_off) begin

if( DrawX > (PosX_0 - 7) && DrawX < (PosX_0 + 7) && DrawY > (PosY_0 - 7)   && DrawY < (PosY_0 + 7)  && message[ ((13-(DrawY-(PosY_0 - 7))) * 13  ) + (13-(DrawX-(PosX_0
 - 7))) ] == 1)
	ispixel2 = 1;


	

else if( DrawX > (PosX_1 - 7) && DrawX < (PosX_1 + 7) && DrawY > (PosY_1 - 7)   && DrawY < (PosY_1 + 7)  && message[ ((13-(DrawY-(PosY_1 - 7))) * 13  ) + (13-(DrawX-(PosX_1
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_2 - 7) && DrawX < (PosX_2 + 7) && DrawY > (PosY_2 - 7)   && DrawY < (PosY_2 + 7)  && message[ ((13-(DrawY-(PosY_2 - 7))) * 13  ) + (13-(DrawX-(PosX_2
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_3 - 7) && DrawX < (PosX_3 + 7) && DrawY > (PosY_3 - 7)   && DrawY < (PosY_3 + 7)  && message[ ((13-(DrawY-(PosY_3 - 7))) * 13  ) + (13-(DrawX-(PosX_3
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_4 - 7) && DrawX < (PosX_4 + 7) && DrawY > (PosY_4 - 7)   && DrawY < (PosY_4 + 7)  && message[ ((13-(DrawY-(PosY_4 - 7))) * 13  ) + (13-(DrawX-(PosX_4
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_5 - 7) && DrawX < (PosX_5 + 7) && DrawY > (PosY_5 - 7)   && DrawY < (PosY_5 + 7)  && message[ ((13-(DrawY-(PosY_5 - 7))) * 13  ) + (13-(DrawX-(PosX_5
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_6 - 7) && DrawX < (PosX_6 + 7) && DrawY > (PosY_6 - 7)   && DrawY < (PosY_6 + 7)  && message[ ((13-(DrawY-(PosY_6 - 7))) * 13  ) + (13-(DrawX-(PosX_6
 - 7))) ] == 1)
	ispixel2 = 1;
	
	

else if( DrawX > (PosX_7 - 7) && DrawX < (PosX_7 + 7) && DrawY > (PosY_7 - 7)   && DrawY < (PosY_7 + 7)  && message[ ((13-(DrawY-(PosY_7 - 7))) * 13  ) + (13-(DrawX-(PosX_7
 - 7))) ] == 1)
	ispixel2 = 1;
else
	ispixel2 = 0;
	
end
else ispixel2=0;
end


endmodule


module multipliersprite4x
(

   input logic [9:0] DrawX, DrawY,
	
	input logic [15:0] PosX_0, PosX_1, PosX_2, PosX_3, PosX_4, PosX_5, PosX_6, PosX_7, 
	input logic [15:0] PosY_0, PosY_1, PosY_2, PosY_3, PosY_4, PosY_5, PosY_6, PosY_7, 
	

	input logic Clk,
	
	
	output logic ispixel2
	
);

logic [31:0]count_reg = 0;
logic on_off = 0;

always_ff @(posedge Clk) begin
	if(count_reg > 32'd50000000)
	begin
		count_reg<=0;
		if(on_off)
			on_off=0;
		else
			on_off=1;
	end
	else
		count_reg<=count_reg+1;
end

reg message [168:0] =
'{
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 
0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 
0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 
0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 
0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

};


always_comb 
begin

if(on_off) begin

if( DrawX > (PosX_0 - 7) && DrawX < (PosX_0 + 7) && DrawY > (PosY_0 - 7)   && DrawY < (PosY_0 + 7)  && message[ ((13-(DrawY-(PosY_0 - 7))) * 13  ) + (13-(DrawX-(PosX_0
 - 7))) ] == 1)
	ispixel2 = 1;


	

else if( DrawX > (PosX_1 - 7) && DrawX < (PosX_1 + 7) && DrawY > (PosY_1 - 7)   && DrawY < (PosY_1 + 7)  && message[ ((13-(DrawY-(PosY_1 - 7))) * 13  ) + (13-(DrawX-(PosX_1
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_2 - 7) && DrawX < (PosX_2 + 7) && DrawY > (PosY_2 - 7)   && DrawY < (PosY_2 + 7)  && message[ ((13-(DrawY-(PosY_2 - 7))) * 13  ) + (13-(DrawX-(PosX_2
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_3 - 7) && DrawX < (PosX_3 + 7) && DrawY > (PosY_3 - 7)   && DrawY < (PosY_3 + 7)  && message[ ((13-(DrawY-(PosY_3 - 7))) * 13  ) + (13-(DrawX-(PosX_3
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_4 - 7) && DrawX < (PosX_4 + 7) && DrawY > (PosY_4 - 7)   && DrawY < (PosY_4 + 7)  && message[ ((13-(DrawY-(PosY_4 - 7))) * 13  ) + (13-(DrawX-(PosX_4
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_5 - 7) && DrawX < (PosX_5 + 7) && DrawY > (PosY_5 - 7)   && DrawY < (PosY_5 + 7)  && message[ ((13-(DrawY-(PosY_5 - 7))) * 13  ) + (13-(DrawX-(PosX_5
 - 7))) ] == 1)
	ispixel2 = 1;
	

else if( DrawX > (PosX_6 - 7) && DrawX < (PosX_6 + 7) && DrawY > (PosY_6 - 7)   && DrawY < (PosY_6 + 7)  && message[ ((13-(DrawY-(PosY_6 - 7))) * 13  ) + (13-(DrawX-(PosX_6
 - 7))) ] == 1)
	ispixel2 = 1;
	
	

else if( DrawX > (PosX_7 - 7) && DrawX < (PosX_7 + 7) && DrawY > (PosY_7 - 7)   && DrawY < (PosY_7 + 7)  && message[ ((13-(DrawY-(PosY_7 - 7))) * 13  ) + (13-(DrawX-(PosX_7
 - 7))) ] == 1)
	ispixel2 = 1;
else
	ispixel2 = 0;
	
end
else
	ispixel2=0;
end


endmodule
		
	
	
		

