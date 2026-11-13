class apb_trans extends uvm_sequence_item;

        `uvm_object_utils(apb_trans)

        rand bit PRESETn ;
        rand bit [2:0] PADDR;
        rand bit PWRITE;
        rand bit [7:0] PWDATA;

        bit [7:0] PRDATA;
        bit PSLVERR;
        bit PREADY;
        bit PSEL;
        bit PENABLE;

        //constraint rst  { soft PRESETn == 1'b1; }

        constraint rst dist { PRESETn == 1'b0 := 10, PRESETn == 1'b1 := 90; }

        constraint valid_addr { 
                if (PWRITE == 1'b1)
                { 
                        PADDR inside { 0, 1, 2, 5 }; 
                }
                else
                {
                        PADDR inside { 0, 1, 2, 3, 5 }; 
                }                
        }

        function new(string name = "apb_trans");
                super.new(name);
        endfunction

endclass
