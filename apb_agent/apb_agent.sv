class apb_agent extends uvm_agent;
	
	`uvm_component_utils(apb_agent)

	apb_agent_config m_cfg;
    	apb_sequencer seqr;
    	apb_driver drv;
    	apb_monitor mon;

	function new(string name = "apb_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);

    		if (!uvm_config_db#(apb_agent_config)::get(this, "", "apb_agent_cfg", m_cfg))
        		`uvm_fatal(get_full_name(), "Configuration not found")

    		mon = apb_monitor::type_id::create("mon", this);

    		if (m_cfg.is_active == UVM_ACTIVE) 
		begin
        		seqr = apb_sequencer::type_id::create("seqr", this);
        		drv  = apb_driver::type_id::create("drv", this);
    		end
	endfunction

endclass
