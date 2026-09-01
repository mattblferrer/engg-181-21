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

  reg p_data, p_control;
  wire p_out;
  pmos p1(p_out, p_data, p_control);

  reg n_data, n_control;
  wire n_out;
  nmos n1(n_out, n_data, n_control);

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
        p_data = state[i];
        p_control = state[j];
        #10;
        $display("data=%b control=%b out=%b", p_data, p_control, p_out);
        end
    end
    $display("");

    // NMOS Primitive
    $display("NMOS Primitive");
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        n_data = state[i];
        n_control = state[j];
        #10;
        $display("data=%b control=%b out=%b", n_data, n_control, n_out);
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
