class env_config extends uvm_object;

    	`uvm_object_utils(env_config)

    	apb_agent_config apb_cfg;
    	spi_agent_config spi_cfg;

	virtual apb_if apb_vif ;
	virtual spi_if spi_vif ;

	int no_of_apb_agents ;
	int no_of_spi_agents ;
	

	bit has_scoreboard;

    	function new(string name = "env_config");
        	super.new(name);
    	endfunction

endclass
