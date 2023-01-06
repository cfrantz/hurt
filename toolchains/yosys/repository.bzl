# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@hurt//config:repo.bzl", "tools_repository")

def yosyshq_repos():
    tools_repository(
        name = "yosyshq",
        archive = "@hurt//prebuilt:yosyshq-tools.tar.xz",
        strip_prefix = "yosyshq",
        build_file_content = """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "yosys_bin",
    srcs = ["yosys/bin/yosys"],
)

filegroup(
    name = "yosys_files",
    srcs = glob(["yosys/**"]),
)

filegroup(
    name = "nextpnr_ice40",
    srcs = ["nextpnr/bin/nextpnr-ice40"],
)

filegroup(
    name = "icepack_bin",
    srcs = ["icestorm/bin/icepack"],
)

filegroup(
    name = "icestorm_files",
    srcs = glob(["icestorm/**"]),
)
        """,
    )
