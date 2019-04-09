 /*

	module to control screen
		

Ball pos
Game state	 ___________
player pos	|Draw Player|
			|Draw Ball	| VGA
	------->|			|----->
			|			|
			|___________|

*/


module vga(
	clk, 
	reset,
	player_y_pos,
	vga_h_sync, 
	vga_v_sync, 
	vga_r, 
	vga_g, 
	vga_b, 
	);

input clk;
input reset;
input player_y_pos;

output vga_h_sync;
output vga_v_sync;

reg vga_r;
reg vga_g;
reg vga_b;

wire inDisplayArea;
wire [9:0] CounterX;
wire [9:0] CounterY;

hvsync_generator syncgen(
	.clk(clk), 
	.reset(reset),
	.vga_h_sync(vga_h_sync), 
	.vga_v_sync(vga_v_sync), 
	.inDisplayArea(inDisplayArea), 
	.CounterX(CounterX), 
	.CounterY(CounterY)
	);

wire R = (
	((CounterX >= 40) && (CounterX <= 80) || //Draw a virtical bar on the sides
		((CounterX>=560) && (CounterX <= 600))

	);



wire G = R;
wire B = R;

always @(posedge clk)
begin
	vga_r <= R & inDisplayArea;
	vga_g <= G & inDisplayArea;
	vga_b <= B & inDisplayArea;
end