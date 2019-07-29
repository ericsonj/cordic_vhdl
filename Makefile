all: cordic_tb

cordic_tb: Cordic.vhd cordic_iter.vhd Cordic_tb.vhd
	ghdl -a cordic_core.vhd
	ghdl -a Cordic.vhd
	ghdl -a Cordic_tb.vhd
	ghdl -e cordic_tb

cordic_tb.vcd: cordic_tb
	ghdl -r cordic_tb --vcd=cordic_tb.vcd

clean:
	rm -f *.o *.cf cordic_tb *.vcd
