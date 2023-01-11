# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//hdl/private:constraints.bzl", "HdlConstraintsInfo")
load("//hdl/private:toolchain.bzl", "HdlRuleHelpers")
load("//hdl/private:library.bzl", "default_hdl_library_impl", "get_transitive_srcs")
load("//toolchains/yosys:yosys.bzl", "yosys_synth")

def _ecp5_bitstream(ctx, toolchain):
    synth = ctx.actions.declare_file("{}.yosys.json".format(ctx.attr.name))
    srcs = get_transitive_srcs(ctx.files.srcs, ctx.attr.deps)
    defines = ["-D{}".format(d) for d in ctx.attr.defines]
    yosys_synth(
        ctx,
        toolchain.tools.yosys,
        synth,
        "synth_ecp5",
        ctx.attr.top,
        srcs.to_list(),
        defines + ctx.attr.tool_options.get("yosys", []),
    )

    constraints = ctx.attr.constraints[HdlConstraintsInfo]
    pnr = ctx.actions.declare_file("{}.pnr.asc".format(ctx.attr.name))
    ctx.actions.run(
        outputs = [pnr],
        inputs = [synth, constraints.pinmap] + toolchain.tools.nextpnr.deps,
        arguments = [
            "--{}".format(constraints.device),
            "--package",
            constraints.package,
            "--json",
            synth.path,
            "--lpf",
            constraints.pinmap.path,
            "--textcfg",
            pnr.path,
        ] + ctx.attr.tool_options.get("nextpnr", []),
        executable = toolchain.tools.nextpnr.binary,
        mnemonic = "PlaceAndRoute",
    )

    bit = ctx.actions.declare_file("{}.bit".format(ctx.attr.name))
    svf = ctx.actions.declare_file("{}.svf".format(ctx.attr.name))
    ctx.actions.run(
        outputs = [bit, svf],
        inputs = [pnr] + toolchain.tools.ecppack.deps,
        arguments = [
            "--input",
            pnr.path,
            "--bit",
            bit.path,
            "--svf",
            svf.path,
        ] + ctx.attr.tool_options.get("ecppack", []),
        executable = toolchain.tools.ecppack.binary,
        mnemonic = "PackBitstream",
    )

    return [
        DefaultInfo(files = depset([bit])),
        OutputGroupInfo(
            bitstream = depset([bit]),
            svf = depset([svf]),
            pnr = depset([pnr]),
            synthesis = depset([synth]),
        ),
    ]

def _yosys_ecp5_helper(ctx):
    return [HdlRuleHelpers(
        library = default_hdl_library_impl,
        binary = _ecp5_bitstream,
    )]

yosys_ecp5_helper = rule(
    implementation = _yosys_ecp5_helper,
    provides = [HdlRuleHelpers],
)
