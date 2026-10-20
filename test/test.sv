class test extends uvm_test;

    	`uvm_component_utils(test)

    	env env_h;
    	env_config m_cfg;

	bit [7:0] cr1_value ;

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

		m_cfg.no_of_apb_agents = 1;
		m_cfg.no_of_spi_agents = 1;

		m_cfg.spi_cfg.CR1 = cr1_value;

		if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", m_cfg.apb_vif))
            		`uvm_fatal("TEST", "APB virtual interface not found")

		if (!uvm_config_db#(virtual spi_if)::get(this, "", "spi_vif", m_cfg.spi_vif))
            		`uvm_fatal("TEST", "SPI virtual interface not found")

		m_cfg.apb_cfg.apb_vif = m_cfg.apb_vif;
        	m_cfg.spi_cfg.spi_vif = m_cfg.spi_vif;

        	uvm_config_db#(env_config)::set(this, "env_h", "env_cfg", m_cfg);

        	env_h = env::type_id::create("env_h", this);
    	endfunction
	
	function void end_of_elaboration_phase(uvm_phase phase);
    		super.end_of_elaboration_phase(phase);
    		uvm_top.print_topology();
	endfunction
endclass

class cpol0_cpha0_lsb_test extends test;
	`uvm_component_utils(cpol0_cpha0_lsb_test)
	
	function new(string name = "cpol0_cpha0_lsb_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		cr1_value = 8'b0001_0001;
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
    		cpol0_cpha0_lsb seq;

    		phase.raise_objection(this);

    		seq = cpol0_cpha0_lsb::type_id::create("seq");
    		seq.start(env_h.apb_agt[0].seqr);

    		phase.drop_objection(this);
	endtask
endclass

class cpol0_cpha1_lsb_test extends test;
        `uvm_component_utils(cpol0_cpha1_lsb_test)

        function new(string name = "cpol0_cpha1_lsb_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_0101;
                super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                cpol0_cpha1_lsb seq;

                phase.raise_objection(this);

                seq = cpol0_cpha1_lsb::type_id::create("seq");
                seq.start(env_h.apb_agt[0].seqr);

                phase.drop_objection(this);
        endtask
endclass

class cpol1_cpha0_lsb_test extends test;
        `uvm_component_utils(cpol1_cpha0_lsb_test)

        function new(string name = "cpol1_cpha0_lsb_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_1001;
                super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                cpol1_cpha0_lsb seq;

                phase.raise_objection(this);

                seq = cpol1_cpha0_lsb::type_id::create("seq");
                seq.start(env_h.apb_agt[0].seqr);

                phase.drop_objection(this);
        endtask
endclass

class cpol1_cpha1_lsb_test extends test;
        `uvm_component_utils(cpol1_cpha1_lsb_test)

        function new(string name = "cpol1_cpha1_lsb_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_1101;
                super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                cpol1_cpha1_lsb seq;

                phase.raise_objection(this);

                seq = cpol1_cpha1_lsb::type_id::create("seq");
                seq.start(env_h.apb_agt[0].seqr);

                phase.drop_objection(this);
        endtask
endclass

class cpol0_cpha0_msb_test extends test;
        `uvm_component_utils(cpol0_cpha0_msb_test)
        
        function new(string name = "cpol0_cpha0_msb_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_0000;
                super.build_phase(phase);
        endfunction
        
        task run_phase(uvm_phase phase);
                cpol0_cpha0_msb seq;

                phase.raise_objection(this);

                seq = cpol0_cpha0_msb::type_id::create("seq");
                seq.start(env_h.apb_agt[0].seqr);

                phase.drop_objection(this);
        endtask
endclass


class cpol0_cpha1_msb_test extends test;
        `uvm_component_utils(cpol0_cpha1_msb_test)

        function new(string name = "cpol0_cpha1_msb_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_0100;
                super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                cpol0_cpha1_msb seq;

                phase.raise_objection(this);

                seq = cpol0_cpha1_msb::type_id::create("seq");
                seq.start(env_h.apb_agt[0].seqr);

                phase.drop_objection(this);
        endtask
endclass

class cpol1_cpha0_msb_test extends test;
        `uvm_component_utils(cpol1_cpha0_msb_test)

        function new(string name = "cpol1_cpha0_msb_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_1000;
                super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                cpol1_cpha0_msb seq;

                phase.raise_objection(this);

                seq = cpol1_cpha0_msb::type_id::create("seq");
                seq.start(env_h.apb_agt[0].seqr);

                phase.drop_objection(this);
        endtask
endclass

class cpol1_cpha1_msb_test extends test;
        `uvm_component_utils(cpol1_cpha1_msb_test)

        function new(string name = "cpol1_cpha1_msb_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_1100;
                super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                cpol1_cpha1_msb seq;

                phase.raise_objection(this);

                seq = cpol1_cpha1_msb::type_id::create("seq");
                seq.start(env_h.apb_agt[0].seqr);

                phase.drop_objection(this);
        endtask
endclass


class reset_test extends test;

    	`uvm_component_utils(reset_test)

    	function new(string name = "reset_test", uvm_component parent = null);
        	super.new(name, parent);
    	endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_0000;
                super.build_phase(phase);
        endfunction

    	task run_phase(uvm_phase phase);
        	reset reset_seq;

        	phase.raise_objection(this);

        	reset_seq = reset::type_id::create("reset_seq");
        	reset_seq.start(env_h.apb_agt[0].seqr);

        	phase.drop_objection(this);
    	endtask

endclass

class low_power_test extends test;

    	`uvm_component_utils(low_power_test)

    	function new(string name = "low_power_test", uvm_component parent = null);
        	super.new(name, parent);
    	endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_0000;
                super.build_phase(phase);
        endfunction

    	task run_phase(uvm_phase phase);
        	low_power low_power_seq;

        	phase.raise_objection(this);

        	low_power_seq = low_power::type_id::create("low_power_seq");
        	low_power_seq.start(env_h.apb_agt[0].seqr);

        	phase.drop_objection(this);
    	endtask

endclass

class spi_test extends test;

    	`uvm_component_utils(spi_test)

    	function new(string name = "spi_test", uvm_component parent = null);
        	super.new(name, parent);
    	endfunction

	function void build_phase(uvm_phase phase);
                cr1_value = 8'b0001_0000;
                super.build_phase(phase);
        endfunction

    	task run_phase(uvm_phase phase);
 
 	      	spi_seqs spi_seq;

        	phase.raise_objection(this);

        	spi_seq = spi_seqs::type_id::create("spi_seq");

	        spi_seq.start(env_h.spi_agt[0].seqr);

        	phase.drop_objection(this);
    	endtask
endclass
