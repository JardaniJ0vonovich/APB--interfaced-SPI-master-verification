class test extends uvm_test;

    	`uvm_component_utils(test)

    	env env_h;
    	env_config m_cfg;

    	function new(string name = "test", uvm_component parent = null);
        	super.new(name, parent);
    	endfunction

    	function void build_phase(uvm_phase phase);
        	super.build_phase(phase);

        	m_cfg = env_config::type_id::create("m_cfg");

        	m_cfg.apb_cfg = apb_agent_config::type_id::create("apb_cfg");
        	m_cfg.spi_cfg = spi_agent_config::type_id::create("spi_cfg");

        	m_cfg.apb_cfg.is_active = UVM_ACTIVE;
        	m_cfg.spi_cfg.is_active = UVM_ACTIVE;

        	uvm_config_db#(env_config)::set(this, "env_h", "env_cfg", m_cfg);

        	env_h = env::type_id::create("env_h", this);
    	endfunction
	
	function void end_of_elaboration_phase(uvm_phase phase);
    		super.end_of_elaboration_phase(phase);
    		uvm_top.print_topology();
	endfunction
endclass
