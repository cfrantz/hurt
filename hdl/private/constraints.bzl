# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//hdl/private:toolchain.bzl", "HDL_TOOLCHAIN")

HdlConstraintsInfo = provider("Constraints")

def _hdl_constraints_impl(ctx):
    constraints = {}
    if ctx.attr.device:
        constraints["device"] = ctx.attr.device
    if ctx.attr.package:
        constraints["package"] = ctx.attr.package
    if ctx.attr.pinmap:
        constraints["pinmap"] = ctx.file.pinmap
    return [HdlConstraintsInfo(**constraints)]

hdl_constraints = rule(
    implementation = _hdl_constraints_impl,
    attrs = {
        "device": attr.string(doc = "Name of the target device"),
        "package": attr.string(doc = "Package type of target device"),
        "pinmap": attr.label(allow_single_file = True, doc = "Pinmap/constraints file"),
    },
    toolchains = [HDL_TOOLCHAIN],
    doc = "Constraint specifications for creating a bitstream.  Do not invoke this rule directly - use a target-specific helper macro like `ice40_constraints`.",
)
