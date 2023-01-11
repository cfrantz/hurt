# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VERILOG_TOOLCHAIN = "@hurt//verilog:toolchain"

VerilogRuleHelpers = provider(fields = ["bitstream", "library"])

VerilogToolInfo = provider(fields = ["name", "binary", "deps"])
VerilogToolsInfo = provider()

def _verilog_tool_impl(ctx):
    return [VerilogToolInfo(
        name = ctx.attr.name,
        binary = ctx.file.binary,
        deps = ctx.files.deps,
    )]

verilog_tool = rule(
    implementation = _verilog_tool_impl,
    attrs = {
        "binary": attr.label(allow_single_file = True, doc = "The binary of this tool"),
        "deps": attr.label_list(allow_files = True, doc = "The file dependencies needed to run the binary"),
    },
)

def _verilog_toolchain_impl(ctx):
    tool_providers = [t[VerilogToolInfo] for t in ctx.attr.tools]
    tools = {t.name: t for t in tool_providers}
    tools = VerilogToolsInfo(**tools)

    return [platform_common.ToolchainInfo(
        name = ctx.label.name,
        helper = ctx.attr.helper[VerilogRuleHelpers],
        tools = tools,
    )]

verilog_toolchain = rule(
    implementation = _verilog_toolchain_impl,
    attrs = {
        "helper": attr.label(providers = [VerilogRuleHelpers], doc = "Per-toolchain helper routines", mandatory = True),
        "tools": attr.label_list(
            providers = [VerilogToolInfo],
            doc = "Mapping of tool binaries to their high-level tool name",
        ),
    },
    doc = "Defines a verilog toolchain",
    provides = [platform_common.ToolchainInfo],
)
