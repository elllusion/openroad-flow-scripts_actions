export DESIGN_NICKNAME = cm0ikmcu
export DESIGN_NAME = CM0IKMCU
export PLATFORM    = sky130hd

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/*.v) $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/dap/*.v) $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core \
								$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/dap \
								$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ualdis
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION = 1000
export PLACE_DENSITY_LB_ADDON = 0.2

export REMOVE_ABC_BUFFERS = 1
