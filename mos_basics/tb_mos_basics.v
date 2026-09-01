module cmos_inverter(in, out);
  input in;
  output out;
  supply1 vdd;
  supply0 gnd;

  pmos p1(out, vdd, in);
  nmos n1(out, gnd, in);
endmodule

module tb_mos_basics;
  integer i, j, k;
  reg[0:0] state[0:3];
  reg p_drain, p_gate;
  wire p_source;

  pmos p1(p_source, p_drain, p_gate);
  reg n_drain, n_gate;
  wire n_source;
  nmos n1(n_source, n_drain, n_gate);

  reg c_data, c_ncontrol, c_pcontrol;
  wire c_out;
  cmos c1(c_out, c_data, c_ncontrol, c_pcontrol);

  reg i_in;
  wire i_out;
  cmos_inverter i1(i_in, i_out);

  initial begin
    state[0] = 1'b0;
    state[1] = 1'b1;
    state[2] = 1'bx;
    state[3] = 1'bz;

    // PMOS Primitive
    $display("PMOS Primitive");
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        p_drain = state[i];
        p_gate = state[j];
        #10;
        $display("drain=%b gate=%b source=%b", p_drain, p_gate, p_source);
        end
    end
    $display("");

    // NMOS Primitive
    $display("NMOS Primitive");
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        n_drain = state[i];
        n_gate = state[j];
        #10;
        $display("drain=%b gate=%b source=%b", n_drain, n_gate, n_source);
      end
    end
    $display("");

    // CMOS Primitive
    $display("CMOS Primitive");
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        for (k = 0; k < 4; k = k + 1) begin
          c_data = state[i];
          c_ncontrol = state[j];
          c_pcontrol = state[k];
          #10;
          $display("data=%b ncontrol=%b pcontrol=%b out=%b", c_data, c_ncontrol, c_pcontrol, c_out);
        end
      end
    end
    $display("");

    // CMOS Inverter
    $display("CMOS Inverter");
    for (i = 0; i < 4; i = i + 1) begin
      i_in = state[i];
      #10;
      $display("in=%b out=%b", i_in, i_out);
    end
    $display("");

    $finish;
  end
  
endmodule
