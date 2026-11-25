package apb_spi_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Transaction classes
    `include "apb_trans.sv"
    `include "spi_trans.sv"

    // Configuration classes
    `include "apb_agent_config.sv"
    `include "spi_agent_config.sv"
    `include "env_config.sv"

    // APB Agent
    `include "apb_seqs.sv"
    `include "apb_sequencer.sv"
    `include "apb_driver.sv"
    `include "apb_monitor.sv"
    `include "apb_agent.sv"
    `include "apb_agent_top.sv"

    // SPI Agent
    `include "spi_seqs.sv"
    `include "spi_sequencer.sv"
    `include "spi_driver.sv"
    `include "spi_monitor.sv"
    `include "spi_agent.sv"
    `include "spi_agent_top.sv"

    // Environment
    `include "virtual_sequencer.sv"
    `include "virtual_sequence.sv"
    `include "scoreboard.sv"
    `include "env.sv"

    // Test
    `include "test.sv"

endpackage

