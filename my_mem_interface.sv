/*INTERFACE*/

`default_nettype none
interface my_mem_interface(input clk);
    logic write;
    logic read;
    logic [7:0] data_in;
    logic [15:0] address;
    logic [8:0] data_out;
    
    //calculating even parity using functions
    function automatic evenparity(input [7:0] data_in);
      evenparity = ^data_in;
    endfunction
/*
    //clocking block to synchronize dut
    clocking mem_clkd@(posedge clk);
        input write, read, data_in, address;
        output data_out;
    endclocking
*/
    // clocking block to synchronize testbench
    clocking mem_clkt@(posedge clk);
        output write, read, data_in, address;
        input data_out;
    endclocking

    //modport instantiation to direct the signals to design file
    modport my_mem(input clk, write, read, data_in, address, output data_out, import evenparity);
    //modport my_mem(clocking mem_clkd, import evenparity);

    //modport instantiation to irect the signals to testbench
    //modport my_mem_pgm(output write, read, data_in, address, input data_out);
    modport my_mem_pgm(clocking mem_clkt);

endinterface

