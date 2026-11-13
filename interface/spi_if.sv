interface spi_if(input logic PCLK);

        logic MOSI;
        logic [7:0] MISO;
        logic SCLK;
        logic SS;

        clocking spi_drv_cb @(posedge PCLK);
                output MISO;

                input MOSI;
                input SCLK;
                input SS;
        endclocking

        clocking spi_mon_cb @(posedge PCLK);
                input MOSI;
                input MISO;
                input SCLK;
                input SS;
        endclocking


        modport spi_drv_mp(clocking spi_drv_cb);
        modport spi_mon_mp(clocking spi_mon_cb);

endinterface

