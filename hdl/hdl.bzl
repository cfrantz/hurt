# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//verilog/private:library.bzl", "VerilogSrcs")
load("//verilog/private:constraints.bzl", "VerilogConstraintsInfo")
load("//verilog/private:toolchain.bzl", "VERILOG_TOOLCHAIN")
load("//util:transition.bzl", "platform_transition")

def _verilog_library_impl(ctx):
    tc = ctx.toolchains[VERILOG_TOOLCHAIN]

    # This will usually be //verilog/private/library.bzl%default_verilog_library_impl.
    return tc.helper.library(ctx, tc)

verilog_library = rule(
    implementation = _verilog_library_impl,
    attrs = {
        "hdrs": attr.label_list(allow_files = True, doc = "Verilog header files"),
        "srcs": attr.label_list(allow_files = True, doc = "Verilog source files"),
        "deps": attr.label_list(providers = [VerilogSrcs], doc = "Additional verilog library dependencies"),
    },
    toolchains = [VERILOG_TOOLCHAIN],
)

def _verilog_binary_impl(ctx):
    tc = ctx.toolchains[VERILOG_TOOLCHAIN]

    # This will usually be the toolchain-provided bitstream flow, such as
    # //toolchains/yosys/ice40/implementation.bzl%_ice40_bitstream.
    return tc.helper.bitstream(ctx, tc)

verilog_binary = rule(
    implementation = _verilog_binary_impl,
    attrs = {
        "top": attr.string(mandatory = True, doc = "Name of the top module"),
        "srcs": attr.label_list(allow_files = True, doc = "Verilog source files"),
        "deps": attr.label_list(providers = [VerilogSrcs], doc = "Additional verilog library dependencies"),
        "defines": attr.string_list(doc = "Defines"),
        "constraints": attr.label(mandatory = True, providers = [VerilogConstraintsInfo], doc = "Constraints"),
        "platform": attr.string(doc = "Target platform"),
        "tool_options": attr.string_list_dict(doc = "Per-tool options for the synthesis flow"),
        "_allowlist_function_transition": attr.label(default = "@bazel_tools//tools/allowlists/function_transition_allowlist"),
    },
    cfg = platform_transition,
    toolchains = [VERILOG_TOOLCHAIN],
)