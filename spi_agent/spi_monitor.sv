class spi_monitor extends uvm_monitor;
        
        `uvm_component_utils(spi_monitor)
        
        function new(string name = "spi_monitor",uvm_component parent = null);
                super.new(name,parent);
        endfunction
        
endclass

