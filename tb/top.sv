module top;

        `include "uvm_macros.svh"
        import uvm_pkg::*;
        import apb_spi_pkg::*;

        bit PCLK;
        always #5 PCLK = ~PCLK;

        apb_if apb_vif(PCLK);
        spi_if spi_vif(PCLK);

        top_module dut (
                .PCLK                  (PCLK),
                .PRESET_n              (apb_vif.PRESETn),

                .PADDR_i               (apb_vif.PADDR),
                .PWRITE_i              (apb_vif.PWRITE),
                .PSEL_i                (apb_vif.PSEL),
                .PENABLE_i             (apb_vif.PENABLE),
                .PWDATA_i              (apb_vif.PWDATA),

                .PRDATA_o              (apb_vif.PRDATA),
                .PREADY_o              (apb_vif.PREADY),
                .PSLVERR_o              (apb_vif.PSLVERR),

                .spi_interrupt_request_o(spi_vif.spi_inpt_req),

                .ss                    (spi_vif.SS),
                .sclk_o                (spi_vif.SCLK),
                .miso_i                (spi_vif.MISO),
                .mosi_o                (spi_vif.MOSI)
            );

        // initial begin
        //         apb_vif.PRESETn = 1'b0;
        //         #20;
        //         apb_vif.PRESETn = 1'b1;
        // end

        initial begin
                uvm_config_db#(virtual apb_if)::set(null, "*", "apb_vif", apb_vif);

                uvm_config_db#(virtual spi_if)::set(null, "*", "spi_vif", spi_vif);

                run_test();
        end

endmodule

