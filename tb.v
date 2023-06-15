`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb;

    reg start, enc_dec, reset, clock;
    reg [63:0] data_i;
    reg [255:0] key_i;
    wire busy, ready;
    wire [63:0] data_o;

  localparam PERIOD_100MHZ = 8;  

  initial
  begin
    clock = 1'b1;
    forever #(PERIOD_100MHZ/2) clock = ~clock;
  end

  initial
  begin
    reset = 1'b1;
    #30;
    reset = 1'b0;
    start  = 1'b0;
    enc_dec  = 1'b1;
    data_i = 64'hA5A5A5A501234567;
    key_i = 256'hDEADBEEF0123456789ABCDEFDEADBEEFDEADBEEF0123456789ABCDEFDEADBEEF;
    #8;
    start  = 1'b1;
    #20;
    start  = 1'b0;
    //#1000;
    //enc_dec  = 1'b0;
   // data_i = 64'h272612A5EE5D03AD;
    //start  = 1'b1;
   // #10;
   // start  = 1'b0;
    #1000;
  end

  criptografia_GOST DUT(.clock(clock), .reset(reset), .start(start), .enc_dec(enc_dec), .data_i(data_i), .key_i(key_i), .data_o(data_o), .busy_o(busy), .ready_o(ready));

endmodule 