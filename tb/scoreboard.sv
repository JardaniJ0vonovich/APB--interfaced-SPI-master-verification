class scoreboard extends uvm_scoreboard;

        `uvm_component_utils(scoreboard)

        uvm_tlm_analysis_fifo #(apb_trans) apb_fifo;
        uvm_tlm_analysis_fifo #(spi_trans) spi_fifo;

        // class-level handles: the covergroups sample these
        apb_trans apb_xtn;
        spi_trans spi_xtn;

        apb_trans apb_cov;
        spi_trans spi_cov;


        //bit [7:0] exp_mosi_q[$];   // APB DR writes  -> expected on MOSI
        //bit [7:0] exp_miso_q[$];   // SPI MISO data  -> expected on APB DR read

        int match_cnt, mismatch_cnt;

        covergroup apb_cg;
                option.per_instance = 1;

                APB_WRITE_CP : coverpoint apb_cov.PWRITE {
                        bins READ  = {0};
                        bins WRITE = {1};
                }

                APB_ADDR_CP : coverpoint apb_cov.PADDR {
                        bins CR1 = {0};
                        bins CR2 = {1};
                        bins BR  = {2};
                        bins SR  = {3};          // read-only
                        bins DR  = {5};
                }

                APB_WDATA_CP : coverpoint apb_cov.PWDATA iff (apb_cov.PWRITE) {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }

                APB_RDATA_CP : coverpoint apb_cov.PRDATA iff (!apb_cov.PWRITE) {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }

                APB_PSLVERR_CP : coverpoint apb_cov.PSLVERR {
                        bins NO_ERR = {0};
                        bins ERR    = {1};
                }

                ADDR_WRITE_CROSS : cross APB_ADDR_CP, APB_WRITE_CP {
                        ignore_bins sr_write = binsof(APB_ADDR_CP.SR) && binsof(APB_WRITE_CP.WRITE);
                }
        endgroup

        covergroup spi_cg;
                option.per_instance = 1;

                MOSI_CP : coverpoint spi_cov.MOSI_DATA {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }

                MISO_CP : coverpoint spi_cov.MISO_DATA {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }
        endgroup

        function new(string name = "scoreboard", uvm_component parent = null);
                super.new(name, parent);                
                apb_cg = new();
                spi_cg = new();
        endfunction


        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                apb_fifo = new("apb_fifo", this);
                spi_fifo = new("spi_fifo", this);
        endfunction


        task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
                forever 
                begin
                        apb_fifo.get(apb_xtn);

                        apb_cov = apb_xtn;  // save for coverage sampling

                        apb_cg.sample();

                        compare_data();
                end

                forever 
                begin
                        spi_fifo.get(spi_xtn);

                        spi_cov = spi_xtn;  // save for coverage sampling

                        //`uvm_info("SPI_COV_DEBUG", $sformatf("MOSI=%02h MISO=%02h", spi_xtn.MOSI_DATA, spi_xtn.MISO_DATA), UVM_MEDIUM)

                        spi_cg.sample();

                        compare_data();
                end
        join
        endtask

        task compare_data();

                wait(apb_xtn != null);
                wait(spi_xtn != null);

                // APB WRITE to Data Register
                if (apb_xtn.PWRITE == 1'b1 &&
                        apb_xtn.PADDR == 3'd5) begin

                        if (apb_xtn.PWDATA == spi_xtn.MOSI_DATA) 
                        begin
                                match_cnt++;
                                `uvm_info("SB_APB",
                                        "PWDATA and MOSI_DATA matched",
                                        UVM_MEDIUM)
                        end

                        else 
                        begin
                                mismatch_cnt++;

                                `uvm_error("SB_APB",
                                        $sformatf(
                                        "PWDATA=0x%02h and MOSI_DATA=0x%02h NOT matched",
                                        apb_xtn.PWDATA,
                                        spi_xtn.MOSI_DATA))
                        end
                end

                // APB READ from Data Register
                else if (apb_xtn.PWRITE == 1'b0 &&
                        apb_xtn.PADDR == 3'd5) begin

                        if (apb_xtn.PRDATA == spi_xtn.MISO_DATA) 
                        begin
                                match_cnt++;

                                `uvm_info("SB_SPI",
                                        "PRDATA and MISO_DATA matched",
                                        UVM_MEDIUM)
                        end

                        else 
                        begin
                                mismatch_cnt++;

                                `uvm_error("SB_SPI",
                                        $sformatf(
                                        "PRDATA=0x%02h and MISO_DATA=0x%02h NOT matched",
                                        apb_xtn.PRDATA,
                                        spi_xtn.MISO_DATA))
                        end
                end

        endtask


/* 
apb_trans apb_queue[$];
spi_trans spi_queue[$];

task run_phase(uvm_phase phase);

//    apb_trans apb_xtn;
//    spi_trans spi_xtn;

    apb_trans apb_cmp_xtn;
    spi_trans spi_cmp_xtn;

    super.run_phase(phase);

    fork
        // APB collection
        forever begin
            apb_fifo.get(apb_xtn);

            apb_cg.sample();

            if (apb_xtn.PADDR == 3'd5)
                apb_queue.push_back(apb_xtn);
        end

        // SPI collection
        forever begin
            spi_fifo.get(spi_xtn);

            `uvm_info("SPI_COV_DEBUG",
                $sformatf("MOSI=%02h MISO=%02h",
                spi_xtn.MOSI_DATA, spi_xtn.MISO_DATA),
                UVM_MEDIUM)

            spi_cg.sample();

            spi_queue.push_back(spi_xtn);
        end

        // Comparison
        forever begin
            wait(apb_queue.size() > 0 &&
                 spi_queue.size() > 0);

            apb_cmp_xtn = apb_queue.pop_front();
            spi_cmp_xtn = spi_queue.pop_front();

            if (apb_cmp_xtn.PWRITE) begin

                if (apb_cmp_xtn.PWDATA == spi_cmp_xtn.MOSI_DATA) begin
                    match_cnt++;
                    `uvm_info("SB_APB",
                        "PWDATA and MOSI_DATA matched",
                        UVM_MEDIUM)
                end
                else begin
                    mismatch_cnt++;
                    `uvm_error("SB_APB",
                        $sformatf("PWDATA=%02h MOSI=%02h",
                        apb_cmp_xtn.PWDATA,
                        spi_cmp_xtn.MOSI_DATA))
                end
            end
            else begin

                if (apb_cmp_xtn.PRDATA == spi_cmp_xtn.MISO_DATA) begin
                    match_cnt++;
                    `uvm_info("SB_SPI",
                        "PRDATA and MISO_DATA matched",
                        UVM_MEDIUM)
                end
                else begin
                    mismatch_cnt++;
                    `uvm_error("SB_SPI",
                        $sformatf("PRDATA=%02h MISO=%02h",
                        apb_cmp_xtn.PRDATA,
                        spi_cmp_xtn.MISO_DATA))
                end
            end
        end
    join
endtask

        function void report_phase(uvm_phase phase);
                `uvm_info("SB_REPORT", $sformatf("Matches=%0d Mismatches=%0d", match_cnt, mismatch_cnt), UVM_NONE)
        endfunction

endclass
*/
