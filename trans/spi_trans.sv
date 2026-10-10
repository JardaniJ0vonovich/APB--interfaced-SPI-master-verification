class spi_trans extends uvm_sequence_item;

    	`uvm_object_utils(spi_trans)

    	bit [7:0] MOSI_DATA;
    	rand bit [7:0] MISO_DATA;

    	function new(string name = "spi_trans");
        	super.new(name);
    	endfunction

endclass
