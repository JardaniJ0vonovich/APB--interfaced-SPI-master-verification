class spi_driver extends uvm_driver#(spi_trans);
	
	`uvm_component_utils(spi_driver)

	spi_agent_config m_cfg;
	virtual spi_if.spi_drv_mp spi_vif;

	function new(string name = "spi_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(spi_agent_config)::get(this,"","spi_agent_cfg",m_cfg))
			`uvm_fatal("SPI DRIVER", "get not working")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		spi_vif = m_cfg.spi_vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask

	task send_to_dut(spi_trans xtn);

    		bit cpol = m_cfg.CR1[3];
    		bit cpha = m_cfg.CR1[2];
    		bit lsb  = m_cfg.CR1[0];

    		wait(spi_vif.SS == 1'b0);

    		if (cpha == 1'b0)
        		spi_vif.spi_drv_cb.MISO <= xtn.MISO_DATA[lsb ? 0 : 7];


    		for (int i = (cpha ? 0:1) ; i < 8; i++) 
		begin
			if (cpol ^ cpha)
                	        @(posedge spi_vif.SCLK);
	                else
        	                @(negedge spi_vif.SCLK);

            		spi_vif.spi_drv_cb.MISO <= xtn.MISO_DATA[lsb ? i : (7-i)];
    		end

	endtask

endclass
