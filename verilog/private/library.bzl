# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

VerilogSrcs = provider("transitive_sources")

def get_transitive_srcs(srcs, deps):
    return depset(
        srcs,
        transitive = [d[VerilogSrcs].transitive_sources for d in deps],
    )

def default_verilog_library_impl(ctx, toolchain):
    print(toolchain.name)
    tsrcs = get_transitive_srcs(ctx.files.srcs + ctx.files.hdrs, ctx.attr.deps)
    return [
        VerilogSrcs(transitive_sources = tsrcs),
        DefaultInfo(files = tsrcs),
    ]
