export DESIGN_NICKNAME = cm0ikmcu
export DESIGN_NAME = CORTEXM0
export PLATFORM    = asap7

export VERILOG_FILES = $(sort $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core/*.v) $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/dap/*.v) $(wildcard $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/*.v))
export VERILOG_INCLUDE_DIRS = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/core \
								$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/dap \
								$(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/ualdis
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export ABC_AREA = 1

export DIE_AREA    = 0 0 11000 10000
export CORE_AREA   = 10.07 11.2 1090 990

#export CORE_UTILIZATION = 100
export SYNTH_MEMORY_MAX_BITS = 16000000

export PLACE_DENSITY_LB_ADDON = 0.2

export REMOVE_ABC_BUFFERS = 1
