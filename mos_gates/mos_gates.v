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

module mos_gates;
  integer a, b;
  reg in1, in2;
  wire nand_out, nor_out, and_out, or_out;
  nand_mos u_nand(in1, in2, nand_out);
  nor_mos u_nor(in1, in2, nor_out);
  and_mos u_and(in1, in2, and_out);
  or_mos u_or(in1, in2, or_out);

  initial begin
    for (a = 0; a < 2; a = a + 1) begin
      for (b = 0; b < 2; b = b + 1) begin
        in1 = a;
        in2 = b;
        $display("A=%b B=%b NAND=%b NOR=%b AND=%b OR=%b", a, b, nand_out, nor_out, and_out, or_out);
        #10;
      end
    end
  end
endmodule
