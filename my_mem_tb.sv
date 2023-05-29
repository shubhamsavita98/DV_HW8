/*TESTBENCH*/

program my_mem_pgm(my_mem_interface top_inf);

    import my_mem_package::*;
    
  	parameter SIZE=6;
    //bit clk;
  	int error_count_q = 0;
    int error_count_ck = 0;
    
    //using assertion
    assert property (@(posedge top_inf.clk) !(top_inf.write && top_inf.read))
    else begin
        error_count_ck <= error_count_ck + 1;
        $display("Write and read both are high");
    end
  
  	initial begin
    
    Transaction memst[SIZE], err; //creating handles 
    
    //intializing clk,read and write7
    top_inf.mem_clkt.read<=0; top_inf.mem_clkt.write<=0;
    
    //randomize addresses
    for(int i=0; i<SIZE; i++) begin
      memst[i] = new(); //object creation; creating space in the memory
      $display("Address [%0d] = %0d",i, memst[i].addr_to_read);
    end
    
    //randomize data
    for(int j=0; j<SIZE; j++) begin
      memst[j] = new(); //object creation; creating space in the memory
      $display("Data [%0d] = %0d",j, memst[j].data_to_write);
    end

    //set write to 1 to start writing to memory
    top_inf.mem_clkt.write<=1;

      for (int i = 0; i < 6; i++)
      begin
        top_inf.mem_clkt.address <= memst[i].addr_to_read;
        #20;
        top_inf.mem_clkt.data_in <= memst[i].data_to_write;
        #20;
      end

 //   @(top_inf.mem_clkt.mem_clkd);
    top_inf.mem_clkt.write <= 0;
    
    //data expected
    for(int i=0; i < SIZE; i++) begin
        memst[i].expected_data_read = memst[i].data_to_write;
      end

//  @(top_inf.mem_clkt.mem_clkd)
    top_inf.mem_clkt.read <= 1;

    //compare data out with data read expected
    $display("********* Starting Test*********");
    // data read in reverse order
    for(int i=SIZE-1; i>=0; i--) begin
      //$display("Previous data out: %0d", top_inf.mem_clkt.data_out);
      top_inf.mem_clkt.address <= memst[i].addr_to_read;
      #150;
      $display("Data expected %0d", memst[i].expected_data_read);
      //adding to Queue
      memst[i].actual_data_read = top_inf.mem_clkt.data_out; //adding data to queue
      memst[i].print_data_out(); //print time stamp and data out
      memst[i].checker(); //call checker for comparision ; self checking
    end

    err = new(); //object creation; creating space in the memory
    $display("Total Error Count: %0d\n", err.error);
    $display("*************** End Test *************");
    
    $display("\n********* Traversing Queue *********");
    //traverse actual_data_read queue
    for(int i=0; i<SIZE; i++) begin
      //data_read_queue.push_back(data_out);
      $display("\tactual_data_read[%0d]= %0d",i,memst[i].actual_data_read);
    end
    //assinging read and write to 1 for checker task
    top_inf.read =1; top_inf.write =1;
    $finish;
  end
    //vcd file generation and waveform enablement
    initial begin
      $vcdplusmemon;
      $vcdpluson;
      $dumpfile("dump.vcd");
      $dumpvars;
    end
    
endprogram