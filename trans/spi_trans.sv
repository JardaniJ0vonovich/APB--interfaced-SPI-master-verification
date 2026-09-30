class spi_trans extends uvm_sequence_item;

    	`uvm_object_utils(spi_trans)

    	bit [7:0] data_mosi;
    	rand bit [7:0] data_miso;

    	function new(string name = "spi_trans");
        	super.new(name);
    	endfunction

endclass
