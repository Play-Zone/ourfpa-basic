module top(
	input wire clk,
	input wire reset,
	output wire [7:0] segment,
	output wire [3:0] digit

);

reg [27:0] counter;
reg [15:0] value;

always @(posedge clk) begin

	counter <= counter + 1'b1;
	
	if (counter == 27'd50000000) begin
		value <= value + 1'b1;
		counter <= 0;
	end

	if (reset == 0) begin
		counter <= 0;
		value <= 0;
	end
	
end


segmentDriver inst_segmentDriver(
	.clk(clk),
	.value(value),
	.segment(segment),
	.digit(digit)
);


endmodule


module segmentDriver(
	input wire clk,
	input wire [15:0] value,
	output reg [7:0] segment,
	output reg [3:0] digit
);


reg [3:0] currentValue;
reg [1:0] currentSegment;
reg [15:0] delay;

always @ (posedge clk) begin
	delay <= delay + 1'b1;
	
	if (delay == 0) begin
		currentSegment <= currentSegment + 1'b1;
	end
	
	case (currentSegment)
		3'b000: begin digit <= 4'b1110; currentValue <= value[3:0]; end
		3'b001: begin digit <= 4'b1101; currentValue <= value[7:4]; end
		3'b010: begin digit <= 4'b1011; currentValue <= value[11:8]; end
		3'b011: begin digit <= 4'b0111; currentValue <= value[15:12]; end
	endcase;

	case(currentValue)
		4'b0000: segment = ~8'b00111111; // 0
		4'b0001: segment = ~8'b00000110;	// 1
		4'b0010: segment = ~8'b01011011;	// 2
		4'b0011: segment = ~8'b01001111;	// 3
		4'b0100: segment = ~8'b01100110;	// 4
		4'b0101: segment = ~8'b01101101;	// 5
		4'b0110: segment = ~8'b01111101;	// 6
		4'b0111: segment = ~8'b00000111;	// 7
		4'b1000: segment = ~8'b01111111;	// 8
		4'b1001: segment = ~8'b01100111;	// 9
		4'b1010: segment = ~8'b01110111;	// A 
		4'b1011: segment = ~8'b01111100;	// B
		4'b1100: segment = ~8'b00111001;	// C
		4'b1101: segment = ~8'b01011110;	// D
		4'b1110: segment = ~8'b01111001;	// E
		4'b1111: segment = ~8'b01110001;	// F
	endcase;
end

endmodule
