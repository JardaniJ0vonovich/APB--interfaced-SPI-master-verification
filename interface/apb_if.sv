interface apb_if(input logic PCLK);

    	logic PRESETn;
    	logic [2:0] PADDR;
    	logic       PWRITE;
    	logic       PSEL;
    	logic       PENABLE;
    	logic [7:0] PWDATA;
    	logic [7:0] PRDATA;
    	logic       PREADY;
	logic       PSLVERR;

	clocking apb_drv_cb @(posedge PCLK);
        	//default input #1 output #0;

        	output PRESETn;
        	output PADDR;
        	output PWRITE;
        	output PSEL;
        	output PENABLE;
        	output PWDATA;

        	input PRDATA;
        	input PREADY;
        	input PSLVERR;
    	endclocking

	clocking apb_mon_cb @(posedge PCLK);
    		input PRESETn;
    		input PADDR;
    		input PWRITE;
    		input PSEL;
    		input PENABLE;
    		input PWDATA;
    		input PRDATA;
    		input PREADY;
    		input PSLVERR;
	endclocking

	modport apb_drv_mp(clocking apb_drv_cb);
	modport apb_mon_mp(clocking apb_mon_cb);

endinterface
