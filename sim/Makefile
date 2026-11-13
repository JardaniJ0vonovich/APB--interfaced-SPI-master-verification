#Makefile for UVM Testbench - APB_based_SPI_Project  (Verilator-only version)
#Same targets as the Questa/VCS Makefile: help clean sv_cmp run_test..run_test9 view_wave1..10 regress report cov
#Run it from the same directory as before (sim/), so the ../rtl ../tb ../test paths still work.

SHELL := /bin/bash
.SHELLFLAGS := -eo pipefail -c

# Folder that contains src/uvm_pkg.sv (Accellera UVM source tree). Verilator has no built-in UVM.
UVM_HOME ?= $(HOME)/uvm/1800.2-2020.3.2
UVM_PKG   = $(UVM_HOME)/src/uvm_pkg.sv 

# 1 = dump FST waveforms (needs +wave plusarg, handled below), 0 = no waves
WAVES ?= 1
SEED  ?= $(shell date +%s)

TOP    = top
BUILD  = obj_dir
SIM    = $(BUILD)/V$(TOP)

RTL    = ../rtl/*
SVTB1  = ../tb/top.sv
INC    = +incdir+../tb +incdir+../test +incdir+../apb_agent +incdir+../spi_agent #+incdir+../ral_control
SVTB2  = ../test/apb_spi_pkg.sv
DEPS   = $(wildcard ../rtl/* ../tb/* ../test/* ../apb_agent/* ../spi_agent/*)

VFLAGS = --binary --timing --assert --coverage --trace-fst --timescale 1ns/1ps \
         --top-module $(TOP) --Mdir $(BUILD) -j 0 \
         -Wno-fatal -Wno-lint -Wno-style +define+UVM_NO_DPI +incdir+$(UVM_HOME)/src

WAVE_SRC = $(BUILD)/wave_dump.sv
ifeq ($(WAVES),1)
EXTRA_SRCS = $(WAVE_SRC)
endif

help:
	echo =============================================================================================================
	echo "! USAGE   	--  make target                  								!"
	echo "! clean   	=>  clean the earlier log and intermediate files.  						!"
	echo "! sv_cmp    	=>  Compile the code with Verilator (UVM_HOME must point to the UVM source).   		!"
	echo "! run_test	=>  reset sequence										!" 
	echo "! run_test1	=>  cpol=1, cphase=1, lsbfe=1									!" 
	echo "! run_test2	=>  cpol=1, cphase=0, lsbfe=1									!"
	echo "! run_test3	=>  cpol=0, cphase=1, lsbfe=1									!" 
	echo "! run_test4	=>  cpol=0, cphase=0, lsbfe=1									!" 
	echo "! run_test5	=>  cpol=1, cphase=1, lsbfe=0									!" 
	echo "! run_test6	=>  cpol=1, cphase=0, lsbfe=0									!"
	echo "! run_test7	=>  cpol=0, cphase=1, lsbfe=0									!" 
	echo "! run_test8	=>  cpol=0, cphase=0, lsbfe=0									!" 
	echo "! run_test9	=>  low power mode								!" 
	echo "! view_wave1 .. view_wave10 =>  open the FST waveform of the matching test in gtkwave		!" 
	echo "! regress    =>  clean, compile and run all testcases in batch mode.		    				!"
	echo "! report     =>  merge coverage of all testcases (line/toggle) and convert to html if genhtml exists.	!"
	echo "! cov        =>  To open merged coverage report in html format.							!"
	echo "! Variables  =>  UVM_HOME=<path>  SEED=<n>  WAVES=0|1							!"
	echo ====================================================================================================================

# ----------------------------- Verilator Specific Targets -------------------------------#

# generated helper: dumps all signals to the file given by +wave=<file> (bound into the top module)
$(WAVE_SRC):
	mkdir -p $(BUILD)
	printf '%s\n' 'module wave_dump;' '  string f;' '  initial if ($$value$$plusargs("wave=%s", f)) begin $$dumpfile(f); $$dumpvars; end' 'endmodule' 'bind $(TOP) wave_dump u_wave_dump();' > $@

sv_cmp: $(SIM)

$(SIM): $(DEPS) $(EXTRA_SRCS)
	test -f $(UVM_PKG) || { echo "ERROR: $(UVM_PKG) not found. Set UVM_HOME=<path to uvm src parent>"; exit 1; }
	verilator $(VFLAGS) $(UVM_PKG) $(RTL) $(INC) $(SVTB2) $(SVTB1) $(EXTRA_SRCS)

# $(1)=target suffix ("" or 1..9)  $(2)=index for log/wave/cov names  $(3)=UVM test name  $(4)=extra prerequisite (clean for run_test)
define RUN_RULE
run_test$(1): $(4) $$(SIM)
	mkdir -p logs waves cov
	$$(SIM) +UVM_TESTNAME=$(3) +verilator+seed+$$(SEED) +verilator+rand+reset+2 \
	    +wave=waves/wave_file$(2).fst +verilator+coverage+file+cov/mem_cov$(2).dat \
	    2>&1 | tee logs/test$(2).log

view_wave$(2):
	gtkwave waves/wave_file$(2).fst &
endef

$(eval $(call RUN_RULE,,1,reset_test,clean))
$(eval $(call RUN_RULE,1,2,cpol1_cpha1_lsb_test))
$(eval $(call RUN_RULE,2,3,cpol1_cpha0_lsb_test))
$(eval $(call RUN_RULE,3,4,cpol0_cpha1_lsb_test))
$(eval $(call RUN_RULE,4,5,cpol0_cpha0_lsb_test))
$(eval $(call RUN_RULE,5,6,cpol1_cpha1_msb_test))
$(eval $(call RUN_RULE,6,7,cpol1_cpha0_msb_test))
$(eval $(call RUN_RULE,7,8,cpol0_cpha1_msb_test))
$(eval $(call RUN_RULE,8,9,cpol0_cpha0_msb_test))
$(eval $(call RUN_RULE,9,10,low_power_test))

report:
	ls cov/mem_cov*.dat >/dev/null 2>&1 || { echo "No cov/mem_cov*.dat found. Run the tests first."; exit 1; }
	verilator_coverage --write cov/mem_cov.dat cov/mem_cov[0-9]*.dat
	verilator_coverage --annotate cov/annotated cov/mem_cov.dat
	if command -v genhtml >/dev/null 2>&1; then \
	    verilator_coverage --write-info cov/mem_cov.info cov/mem_cov.dat; \
	    genhtml cov/mem_cov.info -o covhtmlreport; \
	else echo "genhtml (lcov) not found: text report is in cov/annotated"; fi

regress: clean
	$(MAKE) sv_cmp
	for t in run_test run_test1 run_test2 run_test3 run_test4 run_test5 run_test6 run_test7 run_test8 run_test9; do $(MAKE) $$t || exit 1; done
	$(MAKE) report
	$(MAKE) cov
	echo "---- regression summary ----"
	grep -H -E "UVM_ERROR :|UVM_FATAL :" logs/*.log || true

cov:
	if [ -f covhtmlreport/index.html ]; then firefox covhtmlreport/index.html & \
	else echo "No html report. Text coverage is in cov/annotated (run 'make report')."; fi

clean:
	rm -rf $(BUILD) logs waves cov covhtmlreport *log*

.PHONY: help sv_cmp report regress cov clean run_test run_test1 run_test2 run_test3 run_test4 run_test5 run_test6 run_test7 run_test8 run_test9

# ----------------------------- End of Verilator Specific Targets -------------------------------#