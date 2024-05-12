# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//hdl/private:constraints.bzl", "hdl_constraints")

def ice40_constraints(name, device, package, pcf):
    hdl_constraints(
        name = name,
        device = device,
        package = package,
        pinmap = pcf,
        target_compatible_with = ["@hurt//fpga/lattice:ice40"],
    )

def ecp5_constraints(name, device, package, lpf):
    hdl_constraints(
        name = name,
        device = device,
        package = package,
        pinmap = lpf,
        target_compatible_with = ["@hurt//fpga/lattice:ecp5"],
    )
