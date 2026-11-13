class apb_driver extends uvm_driver#(apb_trans);

        `uvm_component_utils(apb_driver)

        virtual apb_if.apb_drv_mp apb_vif;
        apb_agent_config m_cfg;

        localparam int PREADY_TIMEOUT = 1000;

        function new(string name = "apb_driver", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if (!uvm_config_db#(apb_agent_config)::get(this, "", "apb_agent_cfg", m_cfg))
                        `uvm_fatal(get_full_name(), "get is not working")
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                apb_vif = m_cfg.apb_vif;
        endfunction

        task run_phase(uvm_phase phase);
                apb_vif.apb_drv_cb.PRESETn <= 1'b0;
                @(apb_vif.apb_drv_cb)
                apb_vif.apb_drv_cb.PRESETn <= 1'b1;

                forever begin
                        seq_item_port.get_next_item(req);
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
        endtask

        task send_to_dut(apb_trans xtn);
                @(apb_vif.apb_drv_cb);
                apb_vif.apb_drv_cb.PSEL    <= 1'b1;
                apb_vif.apb_drv_cb.PENABLE <= 1'b0;
                apb_vif.apb_drv_cb.PADDR   <= xtn.PADDR;
                apb_vif.apb_drv_cb.PWRITE  <= xtn.PWRITE;
                if(xtn.PWRITE == 1'b1)
                        apb_vif.apb_drv_cb.PWDATA  <= xtn.PWDATA;

                @(apb_vif.apb_drv_cb);
                apb_vif.apb_drv_cb.PENABLE <= 1'b1;
                apb_vif.apb_drv_cb.PSEL    <= 1'b1;

                wait (apb_vif.apb_drv_cb.PREADY == 1'b1);

                if(xtn.PWRITE == 1'b0)
                        xtn.PRDATA  = apb_vif.apb_drv_cb.PRDATA;

                @(apb_vif.apb_drv_cb);

                apb_vif.apb_drv_cb.PSEL    <= 1'b0;
                apb_vif.apb_drv_cb.PENABLE <= 1'b0;

                `uvm_info("APB_DRIVER",$sformatf("APB DRIVER LOGIC \n %s",xtn.sprint()),UVM_MEDIUM);
        endtask

endclass
