class env extends uvm_env;

    	`uvm_component_utils(env)

    	env_config m_cfg;

    	apb_agent apb_agt;
    	spi_agent spi_agt;

    	function new(string name = "env", uvm_component parent = null);
        	super.new(name, parent);
    	endfunction

    	function void build_phase(uvm_phase phase);
        	super.build_phase(phase);

        	if (!uvm_config_db#(env_config)::get(this, "", "env_cfg", m_cfg))
            		`uvm_fatal(get_full_name(), "Configuration not found")

        	uvm_config_db#(apb_agent_config)::set(this, "apb_agt", "apb_agent_cfg", m_cfg.apb_cfg);

        	uvm_config_db#(spi_agent_config)::set(this, "spi_agt", "spi_agent_cfg", m_cfg.spi_cfg);

        	apb_agt = apb_agent::type_id::create("apb_agt", this);
        	spi_agt = spi_agent::type_id::create("spi_agt", this);
    	endfunction

endclass
