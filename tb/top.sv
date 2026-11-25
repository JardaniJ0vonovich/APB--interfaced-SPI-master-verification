module top;

        import uvm_pkg::*;
        import apb_spi_pkg::*;
        bit clock;

        always #5 clock = ~clock;

                apb_intf apb_if(clock);
                spi_intf spi_if(clock);

        top_module dut (
                .PCLK                  (clock),
                .PRESET_n              (apb_if.PRESETn),

                .PADDR_i               (apb_if.PADDR),
                .PWRITE_i              (apb_if.PWRITE),
                .PSEL_i                (apb_if.PSEL),
                .PENABLE_i             (apb_if.PENABLE),
                .PWDATA_i              (apb_if.PWDATA),

                .PRDATA_o              (apb_if.PRDATA),
                .PREADY_o              (apb_if.PREADY),
                .PSLVERR_o              (apb_if.PSLVERR),

                .spi_interrupt_request_o(spi_if.spi_inpt_req),

                .ss                    (spi_if.ss),
                .sclk_o                (spi_if.sclk),
                .miso_i                (spi_if.miso),
                .mosi_o                (spi_if.mosi)
            );

        // initial begin
        //         apb_vif.PRESETn = 1'b0;
        //         #20;
        //         apb_vif.PRESETn = 1'b1;
        // end

        initial begin



                uvm_config_db #(virtual apb_intf) :: set(null,"*","apb_intf",apb_if);
                uvm_config_db #(virtual spi_intf) :: set(null,"*","spi_intf",spi_if);


                run_test();
        end
endmodule

