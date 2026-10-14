class apb_monitor extends uvm_monitor;
        
        `uvm_component_utils(apb_monitor)

	virtual apb_if.apb_mon_mp apb_vif;
	apb_agent_config m_cfg;

	uvm_analysis_port #(apb_trans) ap;
        
        function new(string name = "apb_monitor",uvm_component parent = null);
                super.new(name,parent);
		ap = new("ap",this);
        endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_cfg",m_cfg))
			`uvm_fatal(get_full_name(),"configuration not found")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		apb_vif = m_cfg.apb_vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			collect_data();
		end
	endtask

	task collect_data;
		apb_trans xtn;

		xtn = apb_trans::type_id::create("xtn");

		do begin
			@(apb_vif.apb_mon_cb);
		end
		while(!(apb_vif.apb_mon_cb.PENABLE && apb_vif.apb_mon_cb.PREADY));

		xtn.PRESETn = apb_vif.apb_mon_cb.PRESETn;
		xtn.PADDR   = apb_vif.apb_mon_cb.PADDR;
		xtn.PWRITE  = apb_vif.apb_mon_cb.PWRITE;
		xtn.PSEL    = apb_vif.apb_mon_cb.PSEL;
		xtn.PENABLE = apb_vif.apb_mon_cb.PENABLE;

		if(apb_vif.apb_mon_cb.PWRITE)
			xtn.PWDATA = apb_vif.apb_mon_cb.PWDATA;
		else
			xtn.PRDATA  = apb_vif.apb_mon_cb.PRDATA;	

		xtn.PREADY  = apb_vif.apb_mon_cb.PREADY;
		xtn.PSLVERR = apb_vif.apb_mon_cb.PSLVERR;

		ap.write(xtn);

            	`uvm_info("APB_MONITOR", $sformatf("APB Transfer: ADDR=%0h WRITE=%0b WDATA=%0h RDATA=%0h PSLVERR=%0b", xtn.PADDR, xtn.PWRITE, xtn.PWDATA, xtn.PRDATA, xtn.PSLVERR), UVM_MEDIUM)

	endtask

endclass

