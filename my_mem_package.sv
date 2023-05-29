// package block

package my_mem_package;

	class Transaction;

	rand bit [15:0] addr_to_read; //16 bits of address
        rand bit [8:0] data_to_write; //9 bits of data
        bit [8:0] expected_data_read; //expected data read
        bit [8:0] actual_data_read; //actual data read(data from data_out)
        static int error; //static class variable error

        //deep copy function
        function Transaction deepCopy();
        	Transaction copy;
        	copy = new();
        	copy.addr_to_read = addr_to_read;
        	copy.data_to_write = data_to_write;
        	copy.expected_data_read = expected_data_read;
        	copy.actual_data_read = actual_data_read;
        	copy.error = error;
        	return copy;
        endfunction

        //custom constructor
        function new();
        	addr_to_read = $random; //assign a random value to address
        	data_to_write = $random; //assign a random value to data_in
        endfunction

        function void print_data_out();
        	$display("Time: %0t,  Data Out: %0d", $time, actual_data_read);
        endfunction

        static function void printError();
        	$display("Time: %0t, Error: %0d", $time, error);
        endfunction 

        function void checker();
        	if(expected_data_read === actual_data_read)
        		$display("Data Matched");
        	else begin
        		error++;
                        printError();
        	end
        endfunction
	endclass

endpackage