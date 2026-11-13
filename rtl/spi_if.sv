interface spi_if(input bit PCLK);

        logic MOSI;
        logic MISO;
        logic SCLK;
        logic SS;
        logic spi_inpt_req;

        clocking spi_drv_cb @(posedge PCLK);
                default input #1 output #1;                
                output MISO;
                input MOSI;
                input SCLK;
                input SS;
                input spi_inpt_req;
        endclocking

        clocking spi_mon_cb @(posedge PCLK);                
                default input #1 output #1;
                input MOSI;
                input MISO;
                input SCLK;
                input SS;
                input spi_inpt_req;
        endclocking


        modport spi_drv_mp(clocking spi_drv_cb);
        modport spi_mon_mp(clocking spi_mon_cb);

endinterface

