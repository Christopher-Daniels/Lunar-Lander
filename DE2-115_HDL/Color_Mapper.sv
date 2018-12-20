//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( 
								input logic Clk,
								input logic [31:0] register_file0,
								input logic [31:0] register_file1,
								input logic [31:0] register_file2,
								input logic [31:0] register_file3,
								input logic [31:0] register_file4,
								input logic [31:0] register_file5,
								input logic [31:0] register_file6,
								input logic [31:0] register_file7,
								input logic [31:0] register_file8,
								input logic [31:0] register_file9,
								input logic [31:0] register_file10,
								input logic [31:0] register_file11,
								input logic [31:0] register_file12,
								input logic [31:0] register_file13,
								input logic [31:0] register_file14,
								input logic [31:0] register_file15,

								//input logic [9:0] Ball_X_Pos, Ball_Y_Pos,

								//input logic is_ball,
                       input   logic   [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
							
		logic [9:0] starsx [30];
		logic [9:0] starsy [30];
    
    logic [7:0] Red, Green, Blue;
	 logic [9:0] MOON [640];
	 
	 logic [15:0] X2x_0, X2x_1, X2x_2, X2x_3, X2x_4, X2x_5, X2x_6, X2x_7;
	 logic [15:0] Y2x_0, Y2x_1, Y2x_2, Y2x_3, Y2x_4, Y2x_5, Y2x_6, Y2x_7;
	 logic [3:0] twoTimesCount=0;
	 
	 logic [15:0] X3x_0, X3x_1, X3x_2, X3x_3, X3x_4, X3x_5, X3x_6, X3x_7;
	 logic [15:0] Y3x_0, Y3x_1, Y3x_2, Y3x_3, Y3x_4, Y3x_5, Y3x_6, Y3x_7;
	 logic [3:0] threeTimesCount=0;
	 
	 logic [15:0] X4x_0, X4x_1, X4x_2, X4x_3, X4x_4, X4x_5, X4x_6, X4x_7;
	 logic [15:0] Y4x_0, Y4x_1, Y4x_2, Y4x_3, Y4x_4, Y4x_5, Y4x_6, Y4x_7;
	 logic [3:0] fourTimesCount=0;
	 
	 logic ispixel,ispixel2,ispixel3,ispixel4,ispixel5, ispixel6,ispixel7,ispixel8,
	 ispixel9,ispixel10,ispixel11,ispixel12,ispixel13,ispixel14, ispixel15, ispixel16, ispixel17, ispixel18, ispixel19, ispixel20, ispixel21, ispixel22;
	 
	 logic startpix, ispixelscore, scorepix0, scorepix1, scorepix2, scorepix3;
	 
	 //logic s0, s1, s2, s3;
	 logic x2pix, x3pix, x4pix;
    
	 
	 
	 logic [3:0] alt0, alt1, alt2, alt3, fuel0, fuel1, fuel2, fuel3, hv0, hv1, hv2, hv3, vv0, vv1, vv2, vv3, s0, s1, s2, s3;
	 
	 
	 logic [15:0] alt, fuel, vv = 16'h8901, hv = 16'h2345, score;
	 
	 logic [3:0] rocketangle;
	 
	 logic crash, success;
	 
	 assign crash = (register_file6 == 32'd2)? 1'b1 : 1'b0;
	 assign success = (register_file6 == 32'd3)? 1'b1 : 1'b0;
	 assign score = register_file12[15:0];
	 
	 
	assign hv = register_file0[15:0];
	assign vv = register_file2[15:0];
	 assign fuel = register_file3[15:0];
	 assign alt = register_file11[15:0];
	 
	 
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
	 
	topright inst1 (.DrawX(DrawX), .DrawY(DrawY), .ispixel1(ispixel));
	
	topleft ins1 (.DrawX(DrawX), .DrawY(DrawY), .ispixel1(ispixel14));
	
	start start (.DrawX(DrawX), .DrawY(DrawY), .ispixel1(startpix));
	
	
	crash crashinst(.DrawX(DrawX), .DrawY(DrawY), .crash(crash), .PosX(register_file1[31:16]), .PosY(register_file1[15:0]), .ispixel1(ispixel21));
	success successinst(.DrawX(DrawX), .DrawY(DrawY), .success(success), .ispixel1(ispixel22));
	
	
	numberconverter altnum (.wordin( alt), .m0(alt3), .m1(alt2), .m2(alt1), .m3(alt0) );
	
	numberconverter fuelnum (.wordin( fuel), .m0(fuel3), .m1(fuel2), .m2(fuel1), .m3(fuel0) );

	numberconverter hvnum (.wordin( hv), .m0(hv3), .m1(hv2), .m2(hv1), .m3(hv0) );
	
	numberconverter vvnum (.wordin( vv), .m0(vv3), .m1(vv2), .m2(vv1), .m3(vv0) );
	
	numberconverter scorenum (.wordin(score), .m0(s3), .m1(s2), .m2(s1), .m3(s0) );
	
	
	
	
	rocketsprite  rocket ( .DrawX(DrawX), .DrawY(DrawY), .PosX(register_file1[31:16]), .PosY(register_file1[15:0]), .angle(rocketangle), .thrust(register_file10[0]), .ispixel2(ispixel19));



	
	
	
	score scoreinst(.DrawX(DrawX),  .DrawY(DrawY),. ispixel1(ispixelscore));
	
	

	

   numberdraw in0 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel2), .number(alt0), .order(5'b00000));
	numberdraw in1 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel3), .number(alt1), .order(5'b00001)); 
	numberdraw in2 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel4), .number(alt2), .order(5'b00010)); 
	numberdraw in3 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel5), .number(alt3), .order(5'b00011)); 
	
	numberdraw in4 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel6), .number(hv0), .order(5'b00100));
	numberdraw in5 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel7), .number(hv1), .order(5'b00101)); 
	numberdraw in6 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel8), .number(hv2), .order(5'b00110)); 
	numberdraw in7 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel9), .number(hv3), .order(5'b00111)); 
	
	numberdraw in8 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel10), .number(vv0), .order(5'b01000));
	numberdraw in9 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel11), .number(vv1), .order(5'b01001)); 
	numberdraw in10 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel12), .number(vv2), .order(5'b01010)); 
	numberdraw in11 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel13), .number(vv3), .order(5'b01011)); 
	 
	 
	numberdraw in12 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel15), .number(fuel0), .order(5'b01100));
	numberdraw in13 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel16), .number(fuel1), .order(5'b01101)); 
	numberdraw in14 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel17), .number(fuel2), .order(5'b01110)); 
	numberdraw in15 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(ispixel18), .number(fuel3), .order(5'b01111));
	
	numberdraw in16 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(scorepix0), .number(s0), .order(5'b10000));
	numberdraw in17 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(scorepix1), .number(s1), .order(5'b10001)); 
	numberdraw in18 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(scorepix2), .number(s2), .order(5'b10010)); 
	numberdraw in19 (.DrawX(DrawX), .DrawY(DrawY), .ispixel2(scorepix3), .number(s3), .order(5'b10011));
	 
	 always_ff @ (posedge Clk) begin
        if(register_file8 < 31'd640)
		  begin
				if(twoTimesCount==0) begin
				X2x_0<=0;
				Y2x_0<=0;
				
				X2x_1<=0;
				Y2x_1<=0;
				
				X2x_2<=0;
				Y2x_2<=0;
				
				X2x_3<=0;
				Y2x_3<=0;
				
				X2x_4<=0;
				Y2x_4<=0;
				
				X2x_5<=0;
				Y2x_5<=0;
				
				X2x_6<=0;
				Y2x_6<=0;
				
				X2x_7<=0;
				Y2x_7<=0;
				end
				
				
				if(threeTimesCount==0) begin
				X3x_0<=0;
				Y3x_0<=0;
				
				X3x_1<=0;
				Y3x_1<=0;
				
				X3x_2<=0;
				Y3x_2<=0;
				
				X3x_3<=0;
				Y3x_3<=0;
				
				X3x_4<=0;
				Y3x_4<=0;
				
				X3x_5<=0;
				Y3x_5<=0;
				
				X3x_6<=0;
				Y3x_6<=0;
				
				X3x_7<=0;
				Y3x_7<=0;
				end
				
				
				if(fourTimesCount==0) begin
				X4x_0<=0;
				Y4x_0<=0;
				
				X4x_1<=0;
				Y4x_1<=0;
				
				X4x_2<=0;
				Y4x_2<=0;
				
				X4x_3<=0;
				Y4x_3<=0;
				
				X4x_4<=0;
				Y4x_4<=0;
				
				X4x_5<=0;
				Y4x_5<=0;
				
				X4x_6<=0;
				Y4x_6<=0;
				
				X4x_7<=0;
				Y4x_7<=0;
				end
		  
				if(MOON[register_file8] != register_file7[9:0]) begin
					if(register_file7[15:12]==4'h2 && twoTimesCount < 5'h8)
					begin
						if(twoTimesCount==0) begin
							X2x_0<=register_file8[9:0]+10;
							Y2x_0<=register_file7[9:0]-5;
						end
						if(twoTimesCount==1) begin
							X2x_1<=register_file8[9:0]+10;
							Y2x_1<=register_file7[9:0]-5;
						end
						if(twoTimesCount==2) begin
							X2x_2<=register_file8[9:0]+10;
							Y2x_2<=register_file7[9:0]-5;
						end
						if(twoTimesCount==3) begin
							X2x_3<=register_file8[9:0]+10;
							Y2x_3<=register_file7[9:0]-5;
						end
						if(twoTimesCount==4) begin
							X2x_4<=register_file8[9:0]+10;
							Y2x_4<=register_file7[9:0]-5;
						end
						if(twoTimesCount==5) begin
							X2x_5<=register_file8[9:0]+10;
							Y2x_5<=register_file7[9:0]-5;
						end
						if(twoTimesCount==6) begin
							X2x_6<=register_file8[9:0]+10;
							Y2x_6<=register_file7[9:0]-5;
						end
						if(twoTimesCount==7) begin
							X2x_7<=register_file8[9:0]+10;
							Y2x_7<=register_file7[9:0]-5;
						end
						twoTimesCount<=twoTimesCount+1'b1;
					end
					
					if(register_file7[15:12]==4'h3 && threeTimesCount < 5'h8)
					begin
						if(threeTimesCount==0) begin
							X3x_0<=register_file8[9:0]+9;
							Y3x_0<=register_file7[9:0]-5;
						end
						if(threeTimesCount==1) begin
							X3x_1<=register_file8[9:0]+9;
							Y3x_1<=register_file7[9:0]-5;
						end
						if(threeTimesCount==2) begin
							X3x_2<=register_file8[9:0]+9;
							Y3x_2<=register_file7[9:0]-5;
						end
						if(threeTimesCount==3) begin
							X3x_3<=register_file8[9:0]+9;
							Y3x_3<=register_file7[9:0]-5;
						end
						if(threeTimesCount==4) begin
							X3x_4<=register_file8[9:0]+9;
							Y3x_4<=register_file7[9:0]-5;
						end
						if(threeTimesCount==5) begin
							X3x_5<=register_file8[9:0]+9;
							Y3x_5<=register_file7[9:0]-5;
						end
						if(threeTimesCount==6) begin
							X3x_6<=register_file8[9:0]+9;
							Y3x_6<=register_file7[9:0]-5;
						end
						if(threeTimesCount==7) begin
							X3x_7<=register_file8[9:0]+9;
							Y3x_7<=register_file7[9:0]-5;
						end
						threeTimesCount<=threeTimesCount+1'b1;
					end
					
					
					
					if(register_file7[15:12]==4'h4 && fourTimesCount < 5'h8)
					begin
						if(fourTimesCount==0) begin
							X4x_0<=register_file8[9:0]+6;
							Y4x_0<=register_file7[9:0]-5;
						end
						if(fourTimesCount==1) begin
							X4x_1<=register_file8[9:0]+6;
							Y4x_1<=register_file7[9:0]-5;
						end
						if(fourTimesCount==2) begin
							X4x_2<=register_file8[9:0]+6;
							Y4x_2<=register_file7[9:0]-5;
						end
						if(fourTimesCount==3) begin
							X4x_3<=register_file8[9:0]+6;
							Y4x_3<=register_file7[9:0]-5;
						end
						if(fourTimesCount==4) begin
							X4x_4<=register_file8[9:0]+6;
							Y4x_4<=register_file7[9:0]-5;
						end
						if(fourTimesCount==5) begin
							X4x_5<=register_file8[9:0]+6;
							Y4x_5<=register_file7[9:0]-5;
						end
						if(fourTimesCount==6) begin
							X4x_6<=register_file8[9:0]+6;
							Y4x_6<=register_file7[9:0]-5;
						end
						if(fourTimesCount==7) begin
							X4x_7<=register_file8[9:0]+6;
							Y4x_7<=register_file7[9:0]-5;
						end
						fourTimesCount<=fourTimesCount+1'b1;
					end
					
					//else if(register_file7[15:12]==4'b3);
					//else if(register_file7[15:12]==4'b4);
				end
		  
				MOON[register_file8] <= register_file7[9:0];
			end
			else
			begin
				twoTimesCount<=0;
				threeTimesCount<=0;
				fourTimesCount<=0;
			end
			
			if(register_file13 < 31'd30) begin
				starsx[register_file13] <= register_file14;
				starsy[register_file13] <= register_file15;
			end
    end
	 
	 multipliersprite2x mult2_x
(

   .DrawX(DrawX), .DrawY(DrawY),
	
	.PosX_0(X2x_0), .PosY_0(Y2x_0),
	.PosX_1(X2x_1), .PosY_1(Y2x_1),
	.PosX_2(X2x_2), .PosY_2(Y2x_2),
	.PosX_3(X2x_3), .PosY_3(Y2x_3),
	.PosX_4(X2x_4), .PosY_4(Y2x_4),
	.PosX_5(X2x_5), .PosY_5(Y2x_5),
	.PosX_6(X2x_6), .PosY_6(Y2x_6),
	.PosX_7(X2x_7), .PosY_7(Y2x_7),
	
	.ispixel2(x2pix),
	
	.Clk(Clk)
	
);

multipliersprite3x mult3_x
(

   .DrawX(DrawX), .DrawY(DrawY),
	
	.PosX_0(X3x_0), .PosY_0(Y3x_0),
	.PosX_1(X3x_1), .PosY_1(Y3x_1),
	.PosX_2(X3x_2), .PosY_2(Y3x_2),
	.PosX_3(X3x_3), .PosY_3(Y3x_3),
	.PosX_4(X3x_4), .PosY_4(Y3x_4),
	.PosX_5(X3x_5), .PosY_5(Y3x_5),
	.PosX_6(X3x_6), .PosY_6(Y3x_6),
	.PosX_7(X3x_7), .PosY_7(Y3x_7),
	
	.ispixel2(x3pix),
	.Clk(Clk)
	
);

multipliersprite4x mult4_x
(

   .DrawX(DrawX), .DrawY(DrawY),
	
	.PosX_0(X4x_0), .PosY_0(Y4x_0),
	.PosX_1(X4x_1), .PosY_1(Y4x_1),
	.PosX_2(X4x_2), .PosY_2(Y4x_2),
	.PosX_3(X4x_3), .PosY_3(Y4x_3),
	.PosX_4(X4x_4), .PosY_4(Y4x_4),
	.PosX_5(X4x_5), .PosY_5(Y4x_5),
	.PosX_6(X4x_6), .PosY_6(Y4x_6),
	.PosX_7(X4x_7), .PosY_7(Y4x_7),
	
	.ispixel2(x4pix),
	.Clk(Clk)
	
);
 logic gameover1;
 logic gameoverpix;
 assign gameover1 = (register_file6==31'd4)? 1'b1:1'b0;
 
 logic finalscore0, finalscore1, finalscore2, finalscore3;

gameover	gameov					
(
	.DrawX(DrawX), .DrawY(DrawY),
	
	.gameover(gameover1),
	
	.ispixel1(gameoverpix)
	

);

scorenumber scn0(.DrawX(DrawX), .DrawY(DrawY), .ispixel2(finalscore0), .number(s0), .order(2'b00), .gameover(1)); 
scorenumber scn1(.DrawX(DrawX), .DrawY(DrawY), .ispixel2(finalscore1), .number(s1), .order(2'b01), .gameover(1));
scorenumber scn2(.DrawX(DrawX), .DrawY(DrawY), .ispixel2(finalscore2), .number(s2), .order(2'b10), .gameover(1));
scorenumber scn3(.DrawX(DrawX), .DrawY(DrawY), .ispixel2(finalscore3), .number(s3), .order(2'b11), .gameover(1));

	 
	 logic star;
	 
    // Assign color based on  signal
    always_comb
    begin
			rocketangle=0;
			if(register_file9 >= 0 && register_file9 <= 23)
				rocketangle=4'h0;
			if(register_file9 >= 24 && register_file9 <= 68)
				rocketangle=4'h1;
			if(register_file9 >= 69 && register_file9 <= 113)
				rocketangle=4'h2;
			if(register_file9 >= 114 && register_file9 <= 158)
				rocketangle=4'h3;
			if(register_file9 >= 159 && register_file9 <= 180)
				rocketangle=4'h4;
				
			star=1'b0;
			for(int i = 0; i < 30; i++)
				if(starsx[i]==DrawX && starsy[i]==DrawY)
					star=1'b1;
			
	 
        if(DrawX==0 && MOON[0] == DrawY)
				ispixel20 = 1'b1;
			else if(DrawX != 0 && ((MOON[DrawX] >= DrawY && MOON[DrawX-1] <= DrawY) || (MOON[DrawX] <= DrawY && MOON[DrawX-1] >= DrawY)))
				ispixel20 = 1'b1;
        else
            ispixel20 = 1'b0;
		  
		 if(register_file6 == 32'd0)begin//title screen state
				if(startpix)
				begin
            // White pixel
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
        else 
        begin
            // black
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00 ;
        end
			end
		else if(register_file6 == 32'd4) begin//end screen state
			if(finalscore0 | finalscore1 | finalscore2 | finalscore3 | gameoverpix)begin
				Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end
			else begin
			
				Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00 ;
			end
		end
			//playing state \/
		 else if (ispixel | ispixel2 | ispixel3 |ispixel4 | ispixel5 | ispixel6 | ispixel7 |ispixel8 | ispixel9 |ispixel10 | ispixel11 |ispixel12 | ispixel13 | ispixel14 | ispixel15 |ispixel16 | ispixel17 | ispixel18 | ispixel19 | ispixel20 | ispixel21 | ispixel22 | ispixelscore | scorepix0 | scorepix1 | scorepix2 | scorepix3 | x2pix | x3pix | x4pix|star)
        begin
            // White pixel
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
        else 
        begin
            // black
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'h00 ;
        end
    end 
    
endmodule
