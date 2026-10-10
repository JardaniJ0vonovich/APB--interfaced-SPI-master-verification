class apb_seqs extends uvm_sequence#(apb_trans);
	
	`uvm_object_utils(apb_seqs)

	function new(string name = "apb_seqs");
		super.new(name);
	endfunction

endclass

/////////////////////////////////////
//4 modes with LSB first
////////////////////////////////////

class cpol0_cpha0_lsb extends apb_seqs;

    	`uvm_object_utils(cpol0_cpha0_lsb)

    	function new(string name = "cpol0_cpha0_lsb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00010001;});
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        
        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

       
        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

    	endtask

endclass

class cpol0_cpha1_lsb extends apb_seqs;

    	`uvm_object_utils(cpol0_cpha1_lsb)

    	function new(string name = "cpol0_cpha1_lsb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00010101; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);
    	endtask

endclass


class cpol1_cpha0_lsb extends apb_seqs;

    	`uvm_object_utils(cpol1_cpha0_lsb)

    	function new(string name = "cpol1_cpha0_lsb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00011001; });
        	finish_item(req);

       	 	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
       	 	finish_item(req);

    	endtask

endclass


class cpol1_cpha1_lsb extends apb_seqs;

    	`uvm_object_utils(cpol1_cpha1_lsb)

    	function new(string name = "cpol1_cpha1_lsb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00011101; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

    	endtask

endclass

////////////////////////////////////////////////////////////////////////
//4 modes with msb first
////////////////////////////////////////////////////////////////////////

class cpol0_cpha0_msb extends apb_seqs;

    	`uvm_object_utils(cpol0_cpha0_msb)

    	function new(string name = "cpol0_cpha0_msb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00010000; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

    	endtask

endclass


class cpol0_cpha1_msb extends apb_seqs;

    	`uvm_object_utils(cpol0_cpha1_msb)

    	function new(string name = "cpol0_cpha1_msb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00010100; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

    	endtask

endclass


class cpol1_cpha0_msb extends apb_seqs;

    	`uvm_object_utils(cpol1_cpha0_msb)

    	function new(string name = "cpol1_cpha0_msb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00011000; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

    	endtask

endclass


class cpol1_cpha1_msb extends apb_seqs;

    	`uvm_object_utils(cpol1_cpha1_msb)

    	function new(string name = "cpol1_cpha1_msb");
        	super.new(name);
    	endfunction

    	task body;
        	req = apb_trans::type_id::create("req");

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd0; PWRITE == 1'b1; PWDATA == 8'b00011100; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd2; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

        	start_item(req);
        	assert(req.randomize() with { PADDR  == 3'd5; PWRITE == 1'b1; PWDATA == 8'd0; });
        	finish_item(req);

    	endtask

endclass

////////////////////////////////////////////////////
//reset mode
////////////////////////////////////////////////////

class reset extends apb_seqs;
        `uvm_object_utils(reset)

        function new(string name = "reset");
                super.new(name);
        endfunction

        task body;
                req = apb_trans::type_id::create("req");

                begin
                        start_item(req);
                        assert(req.randomize() with {PRESETn == 1'b0;});
                        finish_item(req);
                end
	endtask
endclass
////////////////////////////////////////////////////////
//low power mode
////////////////////////////////////////////////////////



class low_power extends apb_seqs;
        `uvm_object_utils(low_power)

        function new(string name = "low_power");
                super.new(name);
        endfunction

        task body;
                req = apb_trans::type_id::create("req");

                begin
                        start_item(req);
                         assert(req.randomize() with { PADDR  == 3'd1; PWRITE == 1'b1; PWDATA == 8'b00000010; });
                        finish_item(req);
                end
endclass
