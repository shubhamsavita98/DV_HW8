`default_nettype none

  module my_mem(my_mem_interface.my_mem top_inf);
   // Declare a 9-bit associative array using the logic data type
   //typedef bit[15:0] halfword;
   logic [8:0] mem_array[int];
   //int func_result;
   
   always @(posedge top_inf.clk) begin
      if (top_inf.write) begin
        mem_array[top_inf.address] = {top_inf.evenparity(top_inf.data_in), top_inf.data_in};
        //mem_array[dut.address] = {func_result, dut.data_in};
    end
      else if (top_inf.read)
        //top_inf.data_out = #75 mem_array[top_inf.address];
        top_inf.data_out = mem_array[top_inf.address];
   end
endmodule