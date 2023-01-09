# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

def _platform_transition_impl(settings, attr):
    # If `platform` isn't set in the rule, do not modify the `platforms` flag.
    if not attr.platform:
        return {}
    return {"//command_line_option:platforms": attr.platform}

platform_transition = transition(
    implementation = _platform_transition_impl,
    inputs = [],
    outputs = ["//command_line_option:platforms"],
)
