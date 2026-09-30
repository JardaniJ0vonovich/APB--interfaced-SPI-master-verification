class spi_seqs extends uvm_sequence#(spi_trans);
	
	`uvm_object_utils(spi_seqs)

	function new(string name = "spi_seqs");
		super.new(name);
	endfunction

endclass
