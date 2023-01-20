# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//hdl/private:library.bzl", "HdlSourceInfo")
load("//hdl/private:constraints.bzl", "HdlConstraintsInfo")
load("//hdl/private:toolchain.bzl", "HDL_TOOLCHAIN")
load("//util:transition.bzl", "platform_transition")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "CPP_TOOLCHAIN_TYPE")

def _hdl_library_impl(ctx):
    tc = ctx.toolchains[HDL_TOOLCHAIN]

    # This will usually be //hdl/private/library.bzl%default_hdl_library_impl.
    return tc.helper.library(ctx, tc)

hdl_library = rule(
    implementation = _hdl_library_impl,
    attrs = {
        "hdrs": attr.label_list(allow_files = True, doc = "Hdl header files"),
        "srcs": attr.label_list(allow_files = True, doc = "Hdl source files"),
        "deps": attr.label_list(providers = [HdlSourceInfo], doc = "Additional hdl library dependencies"),
    },
    toolchains = [HDL_TOOLCHAIN],
)

def _hdl_binary_impl(ctx):
    tc = ctx.toolchains[HDL_TOOLCHAIN]

    # This will usually be the toolchain-provided bitstream flow, such as
    # //toolchains/yosys/ice40/implementation.bzl%_ice40_bitstream.
    return tc.helper.binary(ctx, tc)

hdl_binary = rule(
    implementation = _hdl_binary_impl,
    attrs = {
        "top": attr.string(mandatory = True, doc = "Name of the top module"),
        "srcs": attr.label_list(allow_files = True, doc = "Hdl source files"),
        "deps": attr.label_list(providers = [HdlSourceInfo], doc = "Additional hdl library dependencies"),
        "defines": attr.string_list(doc = "Defines"),
        "constraints": attr.label(mandatory = True, providers = [HdlConstraintsInfo], doc = "Constraints"),
        "platform": attr.string(doc = "Target platform"),
        "tool_options": attr.string_list_dict(doc = "Per-tool options for the synthesis flow"),
        "_allowlist_function_transition": attr.label(default = "@bazel_tools//tools/allowlists/function_transition_allowlist"),
    },
    cfg = platform_transition,
    fragments = ["cpp"],
    toolchains = [
        config_common.toolchain_type(HDL_TOOLCHAIN, mandatory = True),
        # Some of the simulators (verilator) require local tools like `make`
        # and the C compiler.
        config_common.toolchain_type(CPP_TOOLCHAIN_TYPE, mandatory = False),
        config_common.toolchain_type("@rules_foreign_cc//toolchains:make_toolchain", mandatory = False),
        config_common.toolchain_type("@rules_foreign_cc//foreign_cc/private/framework:shell_toolchain", mandatory = False),
    ],
)
