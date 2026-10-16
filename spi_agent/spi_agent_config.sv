class spi_agent_config extends uvm_object;

    	`uvm_object_utils(spi_agent_config)

	uvm_active_passive_enum is_active;

	bit [7:0] CR1;

    	virtual spi_if spi_vif;
    	
    	function new(string name = "spi_agent_config");
        	super.new(name);
    	endfunction

endclass
