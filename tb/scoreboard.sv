class scoreboard extends uvm_scoreboard;

    	`uvm_component_utils(scoreboard)

    	uvm_tlm_analysis_fifo #(apb_trans) apb_fifo;
    	uvm_tlm_analysis_fifo #(spi_trans) spi_fifo;

	apb_trans apb_xtn;
	spi_trans spi_xtn;

	bit [7:0] exp_mosi_q[$];   // APB DR writes  -> expected on MOSI
	bit [7:0] exp_miso_q[$];   // SPI MISO data  -> expected on APB DR read

	int match_cnt, mismatch_cnt;

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
			check_apb();
			check_spi();
		join
	endtask

	task check_apb();
		bit [7:0] exp_rdata;

		forever 
		begin
			apb_fifo.get(apb_xtn);
			apb_cg.sample();

			if (apb_xtn.PADDR == 3'd5)
			begin
				if (apb_xtn.PWRITE) 
				begin
					exp_mosi_q.push_back(apb_xtn.PWDATA[7:0]);
					`uvm_info("SB_APB", $sformatf("DR write 0x%02h queued for MOSI check", apb_xtn.PWDATA[7:0]), UVM_HIGH)
				end
				else 
				begin
					if (exp_miso_q.size() == 0) 
					begin
						`uvm_error("SB_APB", $sformatf("DR read 0x%02h but no SPI MISO data was captured", apb_xtn.PRDATA[7:0]))
						mismatch_cnt++;
					end
					else 
					begin
						exp_rdata = exp_miso_q.pop_front();
						if (apb_xtn.PRDATA[7:0] === exp_rdata) 
						begin
							match_cnt++;
							`uvm_info("SB_APB", $sformatf("DR read MATCH: PRDATA=0x%02h MISO=0x%02h", apb_xtn.PRDATA[7:0], exp_rdata), UVM_MEDIUM)
						end

						else 
						begin
							mismatch_cnt++;
							`uvm_error("SB_APB", $sformatf("DR read MISMATCH: PRDATA=0x%02h expected(MISO)=0x%02h", apb_xtn.PRDATA[7:0], exp_rdata))
						end
					end
				end
			end
		end
	endtask

	task check_spi();
		bit [7:0] exp_mosi;

		forever 
		begin
			spi_fifo.get(spi_xtn);
			spi_cg.sample();

			if (exp_mosi_q.size() == 0) 
			begin
				`uvm_error("SB_SPI", $sformatf("SPI transfer MOSI=0x%02h seen with no APB DR write pending", spi_xtn.MOSI_DATA))
				mismatch_cnt++;
			end
			else 
			begin
				exp_mosi = exp_mosi_q.pop_front();
				if (spi_xtn.MOSI_DATA === exp_mosi) 
				begin
					match_cnt++;
					`uvm_info("SB_SPI", $sformatf("MOSI MATCH: MOSI=0x%02h APB_WDATA=0x%02h", spi_xtn.MOSI_DATA, exp_mosi), UVM_MEDIUM)
				end
				else 
				begin
					mismatch_cnt++;
					`uvm_error("SB_SPI", $sformatf("MOSI MISMATCH: MOSI=0x%02h expected(APB WDATA)=0x%02h", spi_xtn.MOSI_DATA, exp_mosi))
				end
			end

			exp_miso_q.push_back(spi_xtn.MISO_DATA);
		end
	endtask


	covergroup apb_cg;
		
		APB_PRESETn_CP : coverpoint apb_xtn.PRESETn {bins ZERO = {0}; bins ONE = {1};}

		APB_WRITE_CP: coverpoint apb_xtn.PWRITE { bins READ  = {0}; bins WRITE = {1}; }

		APB_ADDR_CP: coverpoint apb_xtn.PADDR {
        						bins CR1 = {3'd0};
        						bins CR2 = {3'd1};
        						bins BR  = {3'd2};
							bins SR  = {3'd3};
        						bins DR  = {3'd5};
        					}

    		APB_WDATA_CP: coverpoint apb_xtn.PWDATA iff (apb_xtn.PWRITE) {bins WR_DATA = {[0:255]};}

    		APB_RDATA_CP: coverpoint apb_xtn.PRDATA iff (!apb_xtn.PWRITE) {bins RD_DATA = {[0:255]};}
                
		APB_PSEL_CP : coverpoint apb_xtn.PSEL {bins ZERO = {0}; bins ONE = {1};}
                
		APB_PENABLE_CP : coverpoint apb_xtn.PENABLE {bins ZERO = {0}; bins ONE = {1};}

    		APB_PREADY_CP : coverpoint apb_xtn.PREADY {bins ZERO = {0}; bins ONE = {1};}

		ADDR_WRITE_CROSS: cross APB_ADDR_CP, APB_WRITE_CP{ignore_bins sr_write = binsof(APB_ADDR_CP.SR) && binsof(APB_WRITE_CP.WRITE);}

	endgroup


	covergroup spi_cg;

    		MOSI_CP: coverpoint spi_xtn.MOSI_DATA { bins MOSIDATA = {[0:255]};}

    		MISO_CP: coverpoint spi_xtn.MISO_DATA { bins MISODATA = {[0:255]};}

	endgroup

endclass
