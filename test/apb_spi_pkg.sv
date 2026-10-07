package apb_spi_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "apb_trans.sv"
    `include "spi_trans.sv"

    `include "apb_seqs.sv"
    `include "apb_sequencer.sv"
    `include "apb_driver.sv"
    `include "apb_monitor.sv"
    `include "apb_agent_config.sv"
    `include "apb_agent.sv"

    `include "spi_seqs.sv"
    `include "spi_sequencer.sv"
    `include "spi_driver.sv"
    `include "spi_monitor.sv"
    `include "spi_agent_config.sv"
    `include "spi_agent.sv"

    `include "env_config.sv"
    `include "env.sv"

    `include "test.sv"

endpackage
