# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//verilog/private:toolchain.bzl", "VERILOG_TOOLCHAIN")

VerilogConstraintsInfo = provider("Constraints")

def _verilog_constraints_impl(ctx):
    constraints = {}
    if ctx.attr.device:
        constraints["device"] = ctx.attr.device
    if ctx.attr.package:
        constraints["package"] = ctx.attr.package
    if ctx.attr.pinmap:
        constraints["pinmap"] = ctx.file.pinmap
    return [VerilogConstraintsInfo(**constraints)]

verilog_constraints = rule(
    implementation = _verilog_constraints_impl,
    attrs = {
        "device": attr.string(doc = "Name of the target device"),
        "package": attr.string(doc = "Package type of target device"),
        "pinmap": attr.label(allow_single_file = True, doc = "Pinmap/constraints file"),
    },
    toolchains = [VERILOG_TOOLCHAIN],
    doc = "Constraint specifications for creating a bitstream.  Do not invoke this rule directly - use a target-specific helper macro like `ice40_constraints`.",
)
