class apb_driver extends uvm_driver#(apb_trans);
	
	`uvm_component_utils(apb_driver)

	virtual apb_if.apb_drv_mp apb_vif;

	apb_agent_config m_cfg;

	function new(string name = "apb_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if (!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_cfg",m_cfg))
			`uvm_fatal(get_full_name(),"get is not working")
	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		apb_vif = m_cfg.apb_vif;
	endfunction


	task run_phase(uvm_phase phase);
		
		forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask

	task send_to_dut(apb_trans xtn);

    		@(apb_vif.apb_drv_cb);

    		apb_vif.apb_drv_cb.PSEL    <= 1'b1;
    		apb_vif.apb_drv_cb.PENABLE <= 1'b0;
    		apb_vif.apb_drv_cb.PADDR   <= xtn.PADDR;
    		apb_vif.apb_drv_cb.PWRITE  <= xtn.PWRITE;

    		apb_vif.apb_drv_cb.PWDATA <= xtn.PWDATA;

    		@(apb_vif.apb_drv_cb);

    		apb_vif.apb_drv_cb.PENABLE <= 1'b1;

    		do begin
        		@(apb_vif.apb_drv_cb);
    		end
		while (apb_vif.apb_drv_cb.PREADY !== 1'b1);

    		xtn.PRDATA  = apb_vif.apb_drv_cb.PRDATA;
    		xtn.PREADY  = apb_vif.apb_drv_cb.PREADY;
    		xtn.PSLVERR = apb_vif.apb_drv_cb.PSLVERR;

    		apb_vif.apb_drv_cb.PSEL    <= 1'b0;
    		apb_vif.apb_drv_cb.PENABLE <= 1'b0;

	endtask

endclass
