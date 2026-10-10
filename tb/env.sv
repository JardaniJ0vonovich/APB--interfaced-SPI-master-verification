class env extends uvm_env;

    	`uvm_component_utils(env)

    	env_config m_cfg;

    	apb_agent apb_agt[];
    	spi_agent spi_agt[];

    	function new(string name = "env", uvm_component parent = null);
        	super.new(name, parent);
    	endfunction

    	function void build_phase(uvm_phase phase);
        	super.build_phase(phase);

        	if (!uvm_config_db#(env_config)::get(this, "", "env_cfg", m_cfg))
            		`uvm_fatal(get_full_name(), "Configuration not found")
		
		apb_agt = new[m_cfg.no_of_apb_agents];
		spi_agt = new[m_cfg.no_of_spi_agents];

		foreach (apb_agt[i])
		begin
			uvm_config_db#(apb_agent_config)::set(this, $sformatf("apb_agt[%0d]", i), "apb_agent_cfg", m_cfg.apb_cfg);
			apb_agt[i] = apb_agent::type_id::create($sformatf("apb_agt[%0d]",i),this);
		end

		foreach(spi_agt[i])
		begin
			uvm_config_db#(spi_agent_config)::set(this, $sformatf("spi_agt[%0d]", i), "spi_agent_cfg", m_cfg.spi_cfg);
			spi_agt[i] = spi_agent::type_id::create($sformatf("spi_agt[%0d]",i), this);
		end
    	endfunction

endclass
