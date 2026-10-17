class scoreboard extends uvm_scoreboard;

    	`uvm_component_utils(scoreboard)

    	uvm_tlm_analysis_fifo #(apb_trans) apb_fifo;
    	uvm_tlm_analysis_fifo #(spi_trans) spi_fifo;

    	apb_trans apb_xtn;
    	spi_trans spi_xtn;

    	function new(string name = "scoreboard", uvm_component parent = null);
        	super.new(name, parent);

        	apb_fifo = new("apb_fifo", this);
        	spi_fifo = new("spi_fifo", this);
		apb_cg = new();
    		spi_cg = new();
    	endfunction

	bit [2:0] APB_ADDR;
	bit       APB_WRITE;
	bit [7:0] APB_WDATA;
	bit [7:0] APB_RDATA;
	bit       APB_PREADY;
	bit	  APB_PSEL;
	bit	  APB_PRESETn;
	bit 	  APB_PENABLE;

	covergroup apb_cg;
		
		APB_PRESETn_CP : coverpoint APB_PRESETn {bins ZERO = {0}; bins ONE = {1};}

		APB_WRITE_CP: coverpoint APB_WRITE { bins READ  = {0}; bins WRITE = {1}; }

		APB_ADDR_CP: coverpoint APB_ADDR {
        						bins CR1 = {3'd0};
        						bins CR2 = {3'd1};
        						bins BR  = {3'd2};
        						bins DR  = {3'd5};
        					}

    		APB_WDATA_CP: coverpoint APB_WDATA iff (APB_WRITE) {bins WR_DATA = {[0:255]}

    		APB_RDATA_CP: coverpoint APB_RDATA iff (!APB_WRITE) {bins RD_DATA {[0:255]};}
                
		APB_PSEL_CP : coverpoint APB_PSEL {bins ZERO = {0}; bins ONE = {1};}
                
		APB_PENABLE_CP : coverpoint APB_PENABLE {bins ZERO = {0}; bins ONE = {1};}

    		APB_PREADY_CP : coverpoint APB_PREADY {bins ZERO = {0}; bins ONE = {1};}

		ADDR_WRITE_CROSS: cross APB_ADDR_CP, APB_WRITE_CP;

	endgroup

	bit [7:0] MOSI_DATA;
	bit [7:0] MISO_DATA;

	covergroup spi_cg;

    		MOSI_CP: coverpoint MOSI_DATA { bins MOSIDATA = {[0:255]};}

    		MISO_CP: coverpoint MISO_DATA { bins MISODATA = {[0:255]};}

	endgroup

endclass
