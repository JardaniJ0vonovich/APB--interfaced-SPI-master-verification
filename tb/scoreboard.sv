/*class scoreboard extends uvm_scoreboard;

        `uvm_component_utils(scoreboard)

        uvm_tlm_analysis_fifo #(apb_trans) apb_fifo;
        uvm_tlm_analysis_fifo #(spi_trans) spi_fifo;

        // class-level handles: the covergroups sample these
        apb_trans apb_xtn;
        spi_trans spi_xtn;

        bit [7:0] exp_mosi_q[$];   // APB DR writes  -> expected on MOSI
        bit [7:0] exp_miso_q[$];   // SPI MISO data  -> expected on APB DR read

        int match_cnt, mismatch_cnt;

        covergroup apb_cg;
                option.per_instance = 1;

                APB_WRITE_CP : coverpoint apb_xtn.PWRITE {
                        bins READ  = {0};
                        bins WRITE = {1};
                }

                APB_ADDR_CP : coverpoint apb_xtn.PADDR {
                        bins CR1 = {0};
                        bins CR2 = {1};
                        bins BR  = {2};
                        bins SR  = {3};          // read-only
                        bins DR  = {5};
                }

                APB_WDATA_CP : coverpoint apb_xtn.PWDATA iff (apb_xtn.PWRITE) {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }

                APB_RDATA_CP : coverpoint apb_xtn.PRDATA iff (!apb_xtn.PWRITE) {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }

                APB_PSLVERR_CP : coverpoint apb_xtn.PSLVERR {
                        bins NO_ERR = {0};
                        bins ERR    = {1};
                }

                ADDR_WRITE_CROSS : cross APB_ADDR_CP, APB_WRITE_CP {
                        ignore_bins sr_write = binsof(APB_ADDR_CP.SR) && binsof(APB_WRITE_CP.WRITE);
                }
        endgroup

        covergroup spi_cg;
                option.per_instance = 1;

                MOSI_CP : coverpoint spi_xtn.MOSI_DATA {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }

                MISO_CP : coverpoint spi_xtn.MISO_DATA {
                        bins ZERO     = {8'h00};
                        bins ALL_ONES = {8'hFF};
                        bins RANGE[8] = {[8'h01:8'hFE]};
                }
        endgroup

        function new(string name = "scoreboard", uvm_component parent = null);
                super.new(name, parent);
                apb_fifo = new("apb_fifo", this);
                spi_fifo = new("spi_fifo", this);
                apb_cg = new();
                spi_cg = new();
        endfunction
/*
        task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
                forever 
                begin
                        apb_fifo.get(apb_xtn);

                        apb_cg.sample();

                        compare_data();
                end

                forever 
                begin
                        spi_fifo.get(spi_xtn);
                        
                        `uvm_info("SPI_COV_DEBUG", $sformatf("MOSI=%02h MISO=%02h", spi_xtn.MOSI_DATA, spi_xtn.MISO_DATA), UVM_MEDIUM)

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

        if (apb_xtn.PWDATA == spi_xtn.MOSI_DATA) begin

            match_cnt++;

            `uvm_info("SB_APB",
                "PWDATA and MOSI_DATA matched",
                UVM_MEDIUM)

        end
        else begin

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

        if (apb_xtn.PRDATA == spi_xtn.MISO_DATA) begin

            match_cnt++;

            `uvm_info("SB_SPI",
                "PRDATA and MISO_DATA matched",
                UVM_MEDIUM)

        end
        else begin

            mismatch_cnt++;

            `uvm_error("SB_SPI",
                $sformatf(
                    "PRDATA=0x%02h and MISO_DATA=0x%02h NOT matched",
                    apb_xtn.PRDATA,
                    spi_xtn.MISO_DATA))
        end
    end

endtask
*/

/*apb_trans apb_queue[$];
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


class scoreboard extends uvm_scoreboard;
        `uvm_component_utils(scoreboard)
        uvm_tlm_analysis_fifo #(apb_xtn) fifo_apb;
        uvm_tlm_analysis_fifo #(spi_xtn) fifo_spi;

//      spi_reg_block spi_reg_blk;
        uvm_status_e status;

        env_config m_cfg;

        apb_xtn apb_xtnh;
        spi_xtn spi_xtnh;

        apb_xtn apb_cov;
        spi_xtn spi_cov;

        bit reset_case;
        bit[1:0] low_pwr_case;

        bit[7:0] cntr_reg1,cntr_reg2,baud_reg,status_reg,data_reg;

        int unsigned total_comparisons;
        int unsigned passed_comparisons;
        int unsigned failed_comparisons;


        extern function new(string name ="scoreboard", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task compare_data();
        extern task compare_data1();
        extern function void report_phase(uvm_phase phase);


        covergroup write_cov;
                option.per_instance =1;
                 RESET:coverpoint apb_cov.PRESETn{bins rst={0,1};}
                 ADDR:coverpoint apb_cov.PADDR{bins addr[]={0,1,2,3,5};}
                 SELX:coverpoint apb_cov.PSEL{bins sel={0,1};}
                 ENABLE:coverpoint apb_cov.PENABLE{bins enb={0,1};}
                 WRITE:coverpoint apb_cov.PWRITE{bins write ={0,1};}
                 READY:coverpoint apb_cov.PREADY{bins ready={0,1};}
                 ERROR:coverpoint apb_cov.PSLVERR{bins err={0,1};}
                 WDATA:coverpoint apb_cov.PWDATA{bins low={[8'h00:8'hff]};}
                 RDATA:coverpoint apb_cov.PRDATA{bins low={[8'h00:8'hff]};}
                 selx_enable:cross SELX,ENABLE;
                 sel_enable_read:cross SELX,ENABLE,READY;
        endgroup

        covergroup read_cov;
        option.per_instance=1;
        SLAVE_SELECT:coverpoint spi_cov.ss{bins ss1={0,1};}
        MISO_DATA   :coverpoint spi_cov.miso{bins low={[8'h00:8'hff]};}
        MOSI_DATA   :coverpoint spi_cov.mosi{bins low={[8'h00:8'hff]};}
        SPI_INTER_REQ:coverpoint spi_cov.spi_inpt_req{bins inpt ={0,1};}
        endgroup



endclass

function scoreboard :: new(string name ="scoreboard", uvm_component parent);
        super.new(name,parent);
        write_cov = new();
        read_cov = new();

        total_comparisons = 0;
        passed_comparisons = 0;
        failed_comparisons = 0;
endfunction


function void scoreboard :: build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db #(env_config) :: get(this,"","env_config",m_cfg);

        if(!uvm_config_db #(bit) :: get(this,"","bit_reset",reset_case))
                `uvm_info(get_type_name(),"unable to get the reset bit",UVM_LOW);
        if(!uvm_config_db #(bit[1:0]) :: get(this,"","bit[1:0]",low_pwr_case))
                `uvm_info (get_type_name(),"unable to get the low power case bits",UVM_LOW);

        fifo_apb = new("fifo_apb",this);
        fifo_spi = new("fifo_spi",this);

endfunction

function void scoreboard :: connect_phase(uvm_phase phase);
        super.connect_phase(phase);
//      spi_reg_blk = m_cfg.spi_reg_blk;
endfunction



task scoreboard :: run_phase(uvm_phase phase);
        fork begin
                forever begin
                $display("i am in scoreboard run_phase");
                        fifo_apb.get(apb_xtnh);
//                      apb_xtnh.print();
                `uvm_info(get_type_name(),$sformatf("the APB transaction from scoreboard is \n %s",apb_xtnh.sprint()), UVM_LOW)
                        apb_cov = apb_xtnh;
                        write_cov.sample();

                        compare_data1();
                end
        end
        begin
                forever begin
                        fifo_spi.get(spi_xtnh);
                        $display("after getting the spi_xtn in scoreboard");
                //      spi_xtnh.print();
                `uvm_info(get_type_name(),$sformatf("the SPI transaction from scoreboard is \n %s",spi_xtnh.sprint()), UVM_LOW)
                        spi_cov = spi_xtnh;
                        read_cov.sample();

                        compare_data();
                end
        end
        join
endtask



task scoreboard :: compare_data();
        //comparision logic to verify the write operation

        wait(apb_xtnh != null);
        wait(spi_xtnh != null);
        if(apb_xtnh.PWRITE && apb_xtnh.PADDR == 3'b101) begin
                if(apb_xtnh.PWDATA == spi_xtnh.mosi) begin
                        `uvm_info(get_type_name(),"write operation success", UVM_LOW);
                end
                else
                        `uvm_info(get_type_name(),"write operation error",UVM_LOW);
        end
endtask

task scoreboard :: compare_data1();
        //comparision logic to veriy
        //      1.reset condition
        //      2.reading operation
        //      3.low power mode 

        if(reset_case) begin
        /*      this.spi_reg_blk.cntr_reg1.read(status, cntr_reg1 ,.path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map) );
                this.spi_reg_blk.cntr_reg2.read(status, cntr_reg2 ,.path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map) );
                this.spi_reg_blk.baud_reg.read(status, baud_reg ,.path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map) );
                this.spi_reg_blk.status_reg.read(status, status_reg ,.path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map) );
                this.spi_reg_blk.data_reg.read(status, data_reg ,.path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map) );
*/

                //without RAL ----------------------------------
                if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b000))
                        cntr_reg1 = apb_xtnh.PRDATA;
                if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b001))
                        cntr_reg2 = apb_xtnh.PRDATA;

                if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b010))
                        baud_reg = apb_xtnh.PRDATA;

                if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b011))
                        status_reg = apb_xtnh.PRDATA;

                if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b101))
                        data_reg = apb_xtnh.PRDATA;





                $display("i am in scoreboard for checking reset case");
                if((cntr_reg1 == 8'b0000_0100) && (cntr_reg2 == 8'b0000_0000) && (baud_reg == 8'b0000_0000) && (status_reg == 8'h20) && (data_reg == 8'h00)) begin
                //      passed_comparisons++;
                        `uvm_info(get_type_name(),"reset test case is success",UVM_LOW);
                end
                else begin
                //      failed_comparisons++;
                        `uvm_error(get_type_name(),"error at reset test case");
                end
        //      total_comparisons++;
        end


        else if(low_pwr_case == 2'b01) begin
                if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b101)) begin
                        total_comparisons++;
                //      this.spi_reg_blk.data_reg.read(status,data_reg, .path(UVM_BACKDOOR), .map(spi_reg_blk.spi_reg_map));
                        if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b101))
                //      if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b101)
                                data_reg = apb_xtnh.PRDATA;

                        if(apb_xtnh.PRDATA == data_reg) begin
                                passed_comparisons++;
                                `uvm_info(get_type_name(),"low power case working fine",UVM_LOW);
                        end
                        else begin
                                failed_comparisons++;
                                `uvm_info(get_type_name(),"failed to verify the low power case",UVM_LOW);
                        end
                end
        end



        else begin
                if((!apb_xtnh.PWRITE) && (apb_xtnh.PADDR == 3'b101)) begin
                        wait(spi_xtnh != null);
                //      wait(apb_xtnh.PRDATA != 0);
                        if(apb_xtnh.PRDATA == spi_xtnh.miso) begin
                                passed_comparisons++;
                                `uvm_info(get_type_name(),"read operation success",UVM_LOW);
                        end
                        else  begin
                                failed_comparisons++;
                                `uvm_error(get_type_name(),"read operation failure");
                        end
                        total_comparisons++;

                end
        end

endtask


function void scoreboard::report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info(get_type_name(),
              "==========================================",UVM_NONE);

        `uvm_info(get_type_name()," APB-SPI SCOREBOARD REPORT",UVM_NONE);

        `uvm_info(get_type_name(),"==========================================",UVM_NONE);

        `uvm_info(get_type_name(), $sformatf("Total Comparisons  : %0d", total_comparisons), UVM_NONE);

        `uvm_info(get_type_name(), $sformatf("Passed Comparisons : %0d", passed_comparisons), UVM_NONE);

        `uvm_info(get_type_name(), $sformatf("Failed Comparisons : %0d", failed_comparisons), UVM_NONE);

        `uvm_info(get_type_name(), "==========================================", UVM_NONE);

        if(failed_comparisons == 0 && total_comparisons > 0) begin

                `uvm_info(get_type_name(), "FINAL RESULT: TEST PASSED", UVM_NONE);
         end
        else begin

                `uvm_error(get_type_name(), "FINAL RESULT: TEST FAILED");

        end

        `uvm_info(get_type_name(), "==========================================", UVM_NONE);

endfunction
