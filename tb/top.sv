module top;
	`include "uvm_macros.svh"

	import uvm_pkg::*;
	import apb_spi_pkg::*;

	bit PCLK = 0;
	always #5 PCLK = ~ PCLK;

	apb_if apb_vif(PCLK);
	spi_if spi_vif(PCLK);

    	initial 
	begin
		uvm_config_db#(virtual apb_if)::set(null,"*","apb_vif",apb_vif);
                uvm_config_db#(virtual spi_if)::set(null,"*","spi_vif",spi_vif);
        	run_test("test");
    	end

endmodule
