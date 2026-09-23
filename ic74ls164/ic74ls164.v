module d_flip_flop(
	input wire D,
	input wire CLK,
	input wire CLR_N,
	output reg Q
);
	always @(posedge CLK or negedge CLR_N) begin
		if (!CLR_N) Q <= 1'b0;
		else Q <= D;
	end
endmodule

module ic74ls164 (
	input wire A, 
	input wire B,
	input wire CLK,
	input wire CLR_N,
	output wire QA, QB, QC, QD, QE, QF, QG, QH
);
	wire SI = A & B;  // serial in
	d_flip_flop ff_A(SI, CLK, CLR_N, QA);
	d_flip_flop ff_B(QA, CLK, CLR_N, QB);
	d_flip_flop ff_C(QB, CLK, CLR_N, QC);
	d_flip_flop ff_D(QC, CLK, CLR_N, QD);
	d_flip_flop ff_E(QD, CLK, CLR_N, QE);
	d_flip_flop ff_F(QE, CLK, CLR_N, QF);
	d_flip_flop ff_G(QF, CLK, CLR_N, QG);
	d_flip_flop ff_H(QG, CLK, CLR_N, QH);
endmodule

module ic74ls164_tb;
	reg A, B, CLK, CLR_N;
    wire QA, QB, QC, QD, QE, QF, QG, QH;
    wire [7:0] Q = {QH, QG, QF, QE, QD, QC, QB, QA};
    ic74ls164 dut(A, B, CLK, CLR_N, QA, QB, QC, QD,
		QE, QF, QG, QH);
		
    initial CLK = 0;
    always #5 CLK = ~CLK;
 
    initial begin
        A = 0; B = 0; CLR_N = 0;
        @(posedge CLK); #1;
        $display("t=%0t Q=%b", $time, Q);
 
        CLR_N = 1;
        A = 1; B = 1;
        @(posedge CLK); #1;
        $display("t=%0t Q=%b", $time, Q);
 
        A = 0; B = 1;
        @(posedge CLK); #1;
        $display("t=%0t Q=%b", $time, Q);
 
        A = 1; B = 1;
        @(posedge CLK); #1;
        $display("t=%0t Q=%b", $time, Q);
 
        A = 1; B = 0;
        @(posedge CLK); #1;
        $display("t=%0t Q=%b", $time, Q);
 
        CLR_N = 0;
        @(posedge CLK); #1;
        $display("t=%0t Q=%b", $time, Q);
 
        $finish;
    end
endmodule