class spi_agent extends uvm_agent;
	
	`uvm_component_utils(spi_agent)

	spi_agent_config m_cfg;
    	spi_sequencer seqr;
    	spi_driver drv;
    	spi_monitor mon;

	function new(string name = "spi_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);

    		if (!uvm_config_db#(apb_agent_config)::get(this, "", "spi_agent_cfg", m_cfg))
        		`uvm_fatal(get_full_name(), "Configuration not found")

    		mon = spi_monitor::type_id::create("mon", this);

    		if (m_cfg.is_active == UVM_ACTIVE) 
		begin
        		seqr = spi_sequencer::type_id::create("seqr", this);
        		drv  = spi_driver::type_id::create("drv", this);
    		end
	endfunction

endclass
