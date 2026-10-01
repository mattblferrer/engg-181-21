module sr_latch(input En, input S, input R, output Q);
    wire w1, w2, w3, w4;
    assign Q = w3;
    nand na1(w1, En, S);
    nand na2(w2, En, R);
    nand na3(w3, w1, w4);
    nand na4(w4, w2, w3);
endmodule

module d_latch(input En, input D, output Q);
    wire w1;
    not n1(w1, D);
    sr_latch sr(En, D, w1, Q);
endmodule

module d_flipflop(input CLK, input D, output Q);
    wire CLK_n, master_Q;
    not n1(CLK_n, CLK);
    d_latch dl(CLK_n, D, master_Q);
    d_latch d2(CLK, master_Q, Q);
endmodule

module latches_flipflops(input CLK, input D, output Q_sr, output Q_dl, output Q_ff);
    wire En_sr, S, R, En_dl;
    assign En_sr = CLK;
    assign S = D;
    assign R = ~D;
    assign En_dl = CLK;

    sr_latch u_sr(En_sr, S, R, Q_sr);
    d_latch u_dl(En_dl, D, Q_dl);
    d_flipflop u_ff(CLK, D, Q_ff);
endmodule

module tb_latches_flipflops;
    reg  En_sr, S, R, En_dl, D_dl, CLK, D_ff;
    wire Q_sr, Q_dl, Q_ff;

    sr_latch u_sr(En_sr, S, R, Q_sr);
    d_latch u_dl(En_dl, D_dl, Q_dl);
    d_flipflop u_ff(CLK, D_ff, Q_ff);

    initial begin
        // SR latch
        $display("\nSR latch");
        $display("  En S  R | Q");
        $display("  --------+---");
        En_sr = 0; S = 0; R = 0; #50;

        En_sr = 1; S = 0; R = 1; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 1; S = 0; R = 0; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 1; S = 1; R = 0; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 1; S = 0; R = 0; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 0; S = 0; R = 1; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 0; S = 1; R = 0; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 1; S = 0; R = 1; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 0; S = 1; R = 0; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 0; S = 0; R = 0; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);
        En_sr = 1; S = 1; R = 1; #50; 
        $display("  %b  %b  %b | %b", En_sr, S, R, Q_sr);

        // D latch
        $display("\nD latch");
        $display("  En D | Q");
        $display("  -----+---");
        En_dl = 0; D_dl = 0; #50;

        En_dl = 1; D_dl = 1; #50; 
        $display("  %b  %b | %b", En_dl, D_dl, Q_dl);
        En_dl = 0; D_dl = 0; #50; 
        $display("  %b  %b | %b", En_dl, D_dl, Q_dl);
        En_dl = 0; D_dl = 1; #50; 
        $display("  %b  %b | %b", En_dl, D_dl, Q_dl);
        En_dl = 1; D_dl = 0; #50; 
        $display("  %b  %b | %b", En_dl, D_dl, Q_dl);
        En_dl = 0; D_dl = 1; #50; 
        $display("  %b  %b | %b", En_dl, D_dl, Q_dl);
        En_dl = 0; D_dl = 0; #50; 
        $display("  %b  %b | %b", En_dl, D_dl, Q_dl);
        En_dl = 1; D_dl = 1; #50; 
        $display("  %b  %b | %b", En_dl, D_dl, Q_dl);

        // D flipflop
        $display("\nD flipflop");
        $display("  CLK D | Q");
        $display("  ------+---");
        CLK = 0; D_ff = 0; #50;

        D_ff = 1; #2; CLK = 1; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);  
        D_ff = 1; #2; CLK = 0; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);
        D_ff = 0; #2; CLK = 0; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);
        D_ff = 0; #2; CLK = 1; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);
        D_ff = 1; #2; CLK = 1; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);
        D_ff = 1; #2; CLK = 0; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);
        D_ff = 1; #2; CLK = 1; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);
        D_ff = 0; #2; CLK = 0; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);
        D_ff = 0; #2; CLK = 1; #30; $display("  %b   %b | %b", CLK, D_ff, Q_ff);

        $display("");
        $finish;
    end
endmodule