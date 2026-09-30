class apb_trans extends uvm_sequence_item;

	`uvm_object_utils(apb_trans)

  	rand bit [2:0] paddr;
  	rand bit pwrite;
  	rand bit [7:0] pwdata;
	bit [7:0] prdata;
	bit pslverr;
	bit pready;


  	function new(string name = "apb_trans");
    		super.new(name);
  	endfunction


endclass
