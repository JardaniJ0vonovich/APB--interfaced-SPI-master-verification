class apb_seqs extends uvm_sequence#(apb_trans);
	
	`uvm_object_utils(apb_seqs)

	function new(string name = "apb_seqs");
		super.new(name);
	endfunction

endclass
