# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

HDL_TOOLCHAIN = "@hurt//hdl:toolchain"

HdlRuleHelpers = provider(fields = ["binary", "library"])

HdlToolInfo = provider(fields = ["name", "binary", "deps"])
HdlToolsInfo = provider()

def _hdl_tool_impl(ctx):
    return [HdlToolInfo(
        name = ctx.attr.name,
        binary = ctx.file.binary,
        deps = ctx.files.deps,
    )]

hdl_tool = rule(
    implementation = _hdl_tool_impl,
    attrs = {
        "binary": attr.label(allow_single_file = True, doc = "The binary of this tool"),
        "deps": attr.label_list(allow_files = True, doc = "The file dependencies needed to run the binary"),
    },
)

def _hdl_toolchain_impl(ctx):
    tool_providers = [t[HdlToolInfo] for t in ctx.attr.tools]
    tools = {t.name: t for t in tool_providers}
    tools = HdlToolsInfo(**tools)

    return [platform_common.ToolchainInfo(
        name = ctx.label.name,
        helper = ctx.attr.helper[HdlRuleHelpers],
        tools = tools,
    )]

hdl_toolchain = rule(
    implementation = _hdl_toolchain_impl,
    attrs = {
        "helper": attr.label(providers = [HdlRuleHelpers], doc = "Per-toolchain helper routines", mandatory = True),
        "tools": attr.label_list(
            providers = [HdlToolInfo],
            doc = "Mapping of tool binaries to their high-level tool name",
        ),
    },
    doc = "Defines a hdl toolchain",
    provides = [platform_common.ToolchainInfo],
)
