module cmos_inverter(in, out);
  input in;
  output out;
  supply1 vdd;
  supply0 gnd;

  pmos p1(out, vdd, in);
  nmos n1(out, gnd, in);
endmodule

module nand_mos(in1, in2, out);
  input in1, in2;
  output out;
  supply1 vdd;
  supply0 gnd;
  wire w1;

  pmos p1(out, vdd, in1);
  pmos p2(out, vdd, in2);
  nmos n1(w1, gnd, in1);
  nmos n2(out, w1, in2);
endmodule

module nor_mos(in1, in2, out);
  input in1, in2;
  output out;
  supply1 vdd;
  supply0 gnd;
  wire w1;

  pmos p1(w1, vdd, in1);
  pmos p2(out, w1, in2);
  nmos n1(out, gnd, in1);
  nmos n2(out, gnd, in2);
endmodule

module and_mos(in1, in2, out);
  input in1, in2;
  output out;
  wire nand_out;

  nand_mos u_nand(in1, in2, nand_out);
  cmos_inverter u_inv(nand_out, out);
endmodule

module or_mos(in1, in2, out);
  input in1, in2;
  output out;
  wire nor_out;

  nor_mos u_nor(in1, in2, nor_out);
  cmos_inverter u_inv(nor_out, out);
endmodule

module mux_1bit_mos(in0, in1, sel, out);
  input in0, in1, sel;
  output out;
  wire sel_n, t0, t1;

  cmos_inverter u_inv_sel(sel, sel_n);
  and_mos u_and0(in0, sel_n, t0);   // in0 selected when sel=0
  and_mos u_and1(in1, sel, t1);     // in1 selected when sel=1
  or_mos u_or(t0, t1, out);
endmodule

module mux_2bit_mos(in0, in1, in2, in3, sel, out);
  input in0, in1, in2, in3;
  input [1:0] sel;
  output out;
  wire m0, m1;

  mux_1bit_mos u_m0(in0, in1, sel[0], m0);
  mux_1bit_mos u_m1(in2, in3, sel[0], m1);
  mux_1bit_mos u_mf(m0,  m1,  sel[1], out); // final select
endmodule

module decoder_2bit_mos(in, out);
  input [1:0] in;
  output [3:0] out;
  wire a_n, b_n;

  cmos_inverter u_inv0(in[0], a_n);
  cmos_inverter u_inv1(in[1], b_n);

  and_mos u_out0(a_n,   b_n,   out[0]); // ~A~B
  and_mos u_out1(in[0], b_n,   out[1]); // A~B
  and_mos u_out2(a_n,   in[1], out[2]); // ~AB
  and_mos u_out3(in[0], in[1], out[3]); // AB
endmodule

module mos_mux_decoder;
  // 1-bit MUX 
  reg in0_1bit, in1_1bit, sel_1bit;
  wire out_1bit;
 
  mux_1bit_mos u_mux_1bit(
    .in0(in0_1bit),
    .in1(in1_1bit),
    .sel(sel_1bit),
    .out(out_1bit)
  );

  // 2-bit MUX
  reg in0_2bit, in1_2bit, in2_2bit, in3_2bit;
  reg [1:0] sel_2bit;
  wire out_2bit;
 
  mux_2bit_mos u_mux_2bit(
    .in0(in0_2bit),
    .in1(in1_2bit),
    .in2(in2_2bit),
    .in3(in3_2bit),
    .sel(sel_2bit),
    .out(out_2bit)
  );

  // 2-input Decoder
  reg [1:0] dec_in;
  wire [3:0] dec_out;
 
  decoder_2bit_mos u_decoder(
    .in(dec_in),
    .out(dec_out)
  );

  integer i;
  initial begin
    for (i = 0; i < 8; i = i + 1) begin
      {in0_1bit, in1_1bit, sel_1bit} = i[2:0];
      #10;
      $display("1-bit MUX: in0=%b in1=%b sel=%b out=%b", in0_1bit, in1_1bit, sel_1bit, out_1bit);
    end
    for (i = 0; i < 64; i = i + 1) begin
      {in3_2bit, in2_2bit, in1_2bit, in0_2bit, sel_2bit} = i[5:0];
      #10;
      $display("2-bit MUX: in0=%b in1=%b in2=%b in3=%b sel=%b out=%b", in0_2bit, in1_2bit, in2_2bit, in3_2bit, sel_2bit, out_2bit);
    end
    for (i = 0; i < 4; i = i + 1) begin
      dec_in = i[1:0];
      #10;
      $display("2-input Decoder: in=%b out=%b", dec_in, dec_out);
    end
    $finish;
  end
endmodule

