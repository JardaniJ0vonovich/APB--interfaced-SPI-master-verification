class scoreboard extends uvm_scoreboard;

    	`uvm_component_utils(scoreboard)

    	uvm_tlm_analysis_fifo #(apb_trans) apb_fifo;
    	uvm_tlm_analysis_fifo #(spi_trans) spi_fifo;

    	apb_trans apb_xtn;
    	spi_trans spi_xtn;

	bit [7:0] expected_mosi_q[$];
        bit [7:0] expected_miso_q[$];

    	function new(string name = "scoreboard", uvm_component parent = null);
        	super.new(name, parent);

        	apb_fifo = new("apb_fifo", this);
        	spi_fifo = new("spi_fifo", this);
		apb_cg = new();
    		spi_cg = new();
    	endfunction
    	
    	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

        task run_phase(uvm_phase phase);

    		fork
        	begin : APB_PROCESS
            		forever 
			begin
                		apb_fifo.get(apb_xtn);
                		apb_cg.sample();

                		if (apb_xtn.PWRITE && (apb_xtn.PADDR == 3'd5)) 
				begin
                    			expected_mosi_q.push_back(apb_xtn.PWDATA);
                		end
            		end
        	end

        	begin : SPI_PROCESS
            		forever 
			begin
                		spi_fifo.get(spi_xtn);
                		spi_cg.sample();

                		if (expected_mosi_q.size() == 0) 
				begin
                    			`uvm_error("SCOREBOARD_APB", "Expected MOSI queue is empty")
                		end
                
				else 
				begin
                    			compare_data_apb( expected_mosi_q.pop_front(), spi_xtn.MOSI_DATA);
                		end

                		if (expected_miso_q.size() == 0) 
				begin
                    			`uvm_error("SCOREBOARD_MISO", "Expected MISO queue is empty")
                		end
                
				else 
				begin
                    			compare_data_miso(expected_miso_q.pop_front(), spi_xtn.MISO_DATA);
                		end
            		end
        	end
    		join

	endtask  

	task compare_data_apb(bit [7:0] expected_mosi, bit [7:0] actual_mosi);

    		$display("----------- SCOREBOARD: MOSI CHECK -----------");

    		if (expected_mosi === actual_mosi) 
		begin
        		`uvm_info("SCOREBOARD_APB", $sformatf("MOSI comparison successful: Expected=%02h Actual=%02h", expected_mosi, actual_mosi), UVM_MEDIUM)
    		end

    		else 
		begin
        		`uvm_error("SCOREBOARD_APB", $sformatf("MOSI mismatch: Expected=%02h Actual=%02h", expected_mosi, actual_mosi))
    		end

	endtask

        task compare_data_spi(bit [7:0] expected_miso,	bit [7:0] actual_miso);

    		if (expected_miso === actual_miso) 
		begin
        		`uvm_info("SCOREBOARD_MISO", $sformatf("MISO PASS: Expected=%02h Actual=%02h", expected_miso, actual_miso), UVM_MEDIUM)
    		end

    		else 
		begin
        		`uvm_error("SCOREBOARD_MISO", $sformatf("MISO FAIL: Expected=%02h Actual=%02h", expected_miso, actual_miso))
    		end

	endtask


	covergroup apb_cg;
		
		APB_PRESETn_CP : coverpoint apb_xtn.PRESETn {bins ZERO = {0}; bins ONE = {1};}

		APB_WRITE_CP: coverpoint apb_xtn.PWRITE { bins READ  = {0}; bins WRITE = {1}; }

		APB_ADDR_CP: coverpoint apb_xtn.PADDR {
        						bins CR1 = {3'd0};
        						bins CR2 = {3'd1};
        						bins BR  = {3'd2};
        						bins DR  = {3'd5};
        					}

    		APB_WDATA_CP: coverpoint apb_xtn.PWDATA iff (apb_xtn.PWRITE) {bins WR_DATA = {[0:255]}

    		APB_RDATA_CP: coverpoint apb_xtn.PRDATA iff (!apb_xtn.PWRITE) {bins RD_DATA {[0:255]};}
                
		APB_PSEL_CP : coverpoint apb_xtn.PSEL {bins ZERO = {0}; bins ONE = {1};}
                
		APB_PENABLE_CP : coverpoint apb_xtn.PENABLE {bins ZERO = {0}; bins ONE = {1};}

    		APB_PREADY_CP : coverpoint apb_xtn.PREADY {bins ZERO = {0}; bins ONE = {1};}

		ADDR_WRITE_CROSS: cross APB_ADDR_CP, APB_WRITE_CP;

	endgroup


	covergroup spi_cg;

    		MOSI_CP: coverpoint spi_xtn.MOSI_DATA { bins MOSIDATA = {[0:255]};}

    		MISO_CP: coverpoint spi_xtn.MISO_DATA { bins MISODATA = {[0:255]};}

	endgroup

endclass
