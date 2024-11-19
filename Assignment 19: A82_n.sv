// Code your testbench here
// or browse Examples

class transaction;
 
  bit [7:0] addr = 7'h12;
  bit [3:0] data = 4'h4;
  bit we = 1'b1;
  bit rst = 1'b0;
 
endclass




class generator;

  transaction t;
  mailbox #(transaction) mbx;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task main();

     t = new();
     //assert(t.randomize) else $display("Randomization Failed");
    $display("[GEN] : DATA SENT : addr, data, we, rst: %0d | %0d | %0d | %0d", t.addr, t.data, t.we, t.rst);
     mbx.put(t);
     #10;

  endtask

endclass

class driver;

  transaction dc;
  mailbox #(transaction) mbx;

  function new(mailbox #(transaction) mbx);
    this.mbx = mbx;
  endfunction

  task main();

      mbx.get(dc);
      $display("[DRV] : DATA RCVD : addr, data, we, rst: %0d | %0d | %0d | %0d", dc.addr, dc.data, dc.we, dc.rst);

  endtask

endclass


module tb;

  generator g;
  driver d;
  mailbox #(transaction) mbx;

  initial begin
    mbx = new();
    g = new(mbx);
    d = new(mbx);

    fork
      g.main();
      d.main();
    join

  end
  

endmodule

//
