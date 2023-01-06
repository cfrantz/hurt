# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//verilog/private:toolchain.bzl", "VerilogRuleHelpers")
load("//verilog/private:library.bzl", "default_verilog_library_impl", "get_transitive_srcs")
load("//toolchains/yosys:yosys.bzl", "yosys_synth")

def _ice40_bitstream(ctx, toolchain):
    synth = ctx.actions.declare_file("{}.yosys.json".format(ctx.attr.name))
    srcs = get_transitive_srcs(ctx.files.srcs, ctx.attr.deps)
    defines = ["-D{}".format(d) for d in ctx.attr.defines]
    yosys_synth(
        ctx,
        toolchain.tools.yosys,
        synth,
        "synth_ice40",
        ctx.attr.top,
        srcs.to_list(),
        defines,
    )

    pnr = ctx.actions.declare_file("{}.pnr.asc".format(ctx.attr.name))
    ctx.actions.run(
        outputs = [pnr],
        inputs = [synth, ctx.file.constraints] + toolchain.tools.nextpnr.deps,
        arguments = [
            "--{}".format(ctx.attr.device),
            "--package",
            ctx.attr.package,
            "--json",
            synth.path,
            "--pcf",
            ctx.file.constraints.path,
            "--asc",
            pnr.path,
        ],
        executable = toolchain.tools.nextpnr.binary,
        mnemonic = "PlaceAndRoute",
    )

    bit = ctx.actions.declare_file("{}.bit".format(ctx.attr.name))
    ctx.actions.run(
        outputs = [bit],
        inputs = [pnr] + toolchain.tools.icepack.deps,
        arguments = [
            pnr.path,
            bit.path,
        ],
        executable = toolchain.tools.icepack.binary,
        mnemonic = "PackBitstream",
    )

    return [
        DefaultInfo(files = depset([bit])),
        OutputGroupInfo(
            bitstream = depset([bit]),
            pnr = depset([pnr]),
            synthesis = depset([synth]),
        ),
    ]

def _yosys_ice40_helper(ctx):
    return [VerilogRuleHelpers(
        library = default_verilog_library_impl,
        bitstream = _ice40_bitstream,
    )]

yosys_ice40_helper = rule(
    implementation = _yosys_ice40_helper,
    provides = [VerilogRuleHelpers],
)
