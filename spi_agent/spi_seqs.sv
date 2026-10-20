class spi_seqs extends uvm_sequence#(spi_trans);
	
	`uvm_object_utils(spi_seqs)

	function new(string name = "spi_seqs");
		super.new(name);
	endfunction

	task body():
		req = spi_trans::type_id::create("req");
		begin
                        start_item(req);
                        assert(req.randomize());
                        finish_item(req);
                end
        endtask
endclass
