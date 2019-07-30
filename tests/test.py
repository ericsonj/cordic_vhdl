import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer

@cocotb.coroutine
def reset(dut):
    dut.en_i <= 0
    dut.rst <= 1
    dut.x_i <= 0
    dut.y_i <= 1000
    dut.z_i <= 0
    yield Timer(15, units='ns')
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_cordic(dut):
    cocotb.fork(Clock(dut.clk, 1, units='ns').start())
    yield reset(dut)
    dut.en_i <= 1
    yield Timer(99, units='ns')
    yield RisingEdge(dut.clk)
    dut.en_i <= 0
    dut.rst <= 1
    for _ in range(10):
        yield RisingEdge(dut.clk)
