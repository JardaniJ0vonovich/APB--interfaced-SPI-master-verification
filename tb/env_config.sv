class env_config extends uvm_object;

    	`uvm_object_utils(env_config)

    	apb_agent_config apb_cfg;
    	spi_agent_config spi_cfg;

    	function new(string name = "env_config");
        	super.new(name);
    	endfunction

endclass
