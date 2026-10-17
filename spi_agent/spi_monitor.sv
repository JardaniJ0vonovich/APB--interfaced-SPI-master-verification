class spi_monitor extends uvm_monitor;
        
        `uvm_component_utils(spi_monitor)

	virtual spi_if.spi_mon_mp spi_vif;
	spi_agent_config m_cfg;

	uvm_analysis_port#(spi_trans) ap;
        
        function new(string name = "spi_monitor",uvm_component parent = null);
                super.new(name,parent);
		ap = new("ap",this);
        endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db#(spi_agent_config)::get(this,"","spi_agent_cfg",m_cfg))
			`uvm_fatal("SPI MONITOR","configuration not found")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		spi_vif = m_cfg.spi_vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			collect_data();
		end
	endtask

	task collect_data();
		
		spi_trans xtn;
		
		bit cpol = m_cfg.CR1[3];
		bit cpha = m_cfg.CR1[2];
		bit lsb  = m_cfg.CR1[0];

		wait (spi_vif.SS == 1'b0);

		xtn = spi_trans::type_id::create("xtn");

		for (int i = 0 ; i<8 ; i++)
		begin
			if(cpha == 1'b0)
			begin
				if(cpol == 1'b0)
					@(posedge spi_vif.SCLK);
				else
					@(negedge spi_vif.SCLK);
			end

			else
			begin
				if(cpol == 1'b0)
					@(negedge spi_vif.SCLK);
				else
					@(posedge spi_vif.SCLK);
			end
			
			xtn.MOSI_DATA[lsb ? i : 7-i] = spi_vif.MOSI;
			xtn.MISO_DATA[lsb ? i : 7-i] = spi_vif.MISO;
		end

		ap.write(xtn);

		`uvm_info("SPI_MONITOR", $sformatf("SPI Transfer: MOSI=%02h MISO=%02h CPOL=%0b CPHA=%0b LSBFE=%0b", xtn.MOSI_DATA, xtn.MISO_DATA, cpol, cpha, lsb), UVM_MEDIUM)

	endtask

endclass
