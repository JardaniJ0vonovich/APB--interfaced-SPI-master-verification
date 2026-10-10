class apb_trans extends uvm_sequence_item;

    	`uvm_object_utils(apb_trans)

    	rand bit PRESETn;
    	rand bit [2:0] PADDR;
    	rand bit PWRITE;
    	rand bit [7:0] PWDATA;

    	bit [7:0] PRDATA;
    	bit PSLVERR;
    	bit PREADY;
    	bit PSEL;
    	bit PENABLE;

    	function new(string name = "apb_trans");
        	super.new(name);
    	endfunction

endclass
