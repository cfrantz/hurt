# HURT
HDL Unified Repository of Tools

## TODO

- Think about platforms constraints.  Currently, I'm using the chip as
  a platform constrained to a family (e.g. `hx8k` is a member of the `ice40`
  family).  A platform probably should be a specific implementation
  containing a certain chip, e.g. the Axelsys HX8K EVB or the Lattice ECP5
  EVB.
- s/VerilogSrcs/VerilogFileInfo/
- Think about constraints for generating a bitstream (e.g. chip, package, pinmap).
- What do do with `verilog_bitstream`:
  - Rename? `verilog_binary`, `verilog_synth`?
  - Add a platform transition?  Realistic to expect a single rule to emit
    "bitstreams" for several platforms (ice40, ecp5, verilator)?
  - Refactor implementations to always use a tcl script.  Provide a default
    script to take the place of the current `command`.
- Add verilator
- Add verible, esp for "lint" and "format"
- Add a `verilog_test` rule.  Initial backends: verilator, iverilog.

