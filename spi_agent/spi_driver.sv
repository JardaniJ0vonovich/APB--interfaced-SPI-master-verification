class spi_driver extends uvm_driver#(spi_trans);
	
	`uvm_component_utils(spi_driver)

	function new(string name = "spi_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass
