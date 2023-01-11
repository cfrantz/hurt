# A simple 8-bit computer

This demonstration **should not** be considered any sort of example of
best practices for verilog code.  The author is not a digital designer and
this was his first attempt at building anything non-trivial in verilog.

This demonstration **is** an example of structuring a project using
separate modules and tests using the rules provided by the `hurt`
repository.

## The computer

The `machine` is a simple computer based around cpu6502.  This machine
can be synthesized into a Lattice HX8K FPGA using about 1500 logic cells
(approximately 20% of the total).

The computer has 4K of RAM, 4K of ROM and two peripherals: a UART and
a bank of 8 LEDs.  The ROM is the EWOZ monitor, which is a derivative
of the original WOZ monitor included with the Apple 1.

Memory map:

- `$0000` to `$0FFF`: RAM.
- `$C000` to `$C003`: Simple UART fixed at 9600 baud.
- `$C004`: Demo board LEDs.
- `$F000` to `$FFFF`: More RAM and the EWOZ monitor program at `$FC00`.

