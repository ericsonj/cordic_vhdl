# How to use

Makefile.old

```
$ make clean
$ make
$ ghdl -r cordic_tb --vcd=cordic_tb.vcd
$ gtkwave cordic_tb.vcd
```

Makefile

```
$ make
$ make gtkwave
```


Reference:
https://github.com/kevinpt/vhdl-extras/blob/master/rtl/extras/cordic.vhdl
