export COCOTB_REDUCED_LOG_FMT
export PYTHONPATH:=$(realpath tests):$(PYTHONPATH)

LANG=vhdl
SIM=ghdl

VHDL_SOURCES= $(PWD)/cordic_core.vhd $(PWD)/cordic.vhd

TOPLEVEL=cordic

SIM_ARGS= --wave=fsm_cmd.ghw
MODULE ?= test

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.inc
include $(COCOTB)/Makefile.sim

GTK_SAVEFILE := $(wildcard sim_build/*.gtkw)

gtkwave:
	gtkwave sim_build/fsm_cmd.ghw $(GTK_SAVEFILE)
