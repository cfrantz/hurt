# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

ALLOWED_VERILOG_EXTENSIONS = ["v", "sv"]

def yosys_synth(ctx, tool, outfile, target, top, srcs, extra_args):
    srcpaths = [src.path for src in srcs if src.extension in ALLOWED_VERILOG_EXTENSIONS]
    command = target + " -top " + top + " -json " + outfile.path
    ctx.actions.run(
        outputs = [outfile],
        inputs = srcs + tool.deps,
        arguments = ["-p", command] + extra_args + srcpaths,
        executable = tool.binary,
        mnemonic = "YoSys",
    )
