# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@hurt//config:repo.bzl", "tools_repository")

def yosyshq_repos():
    tools_repository(
        name = "yosyshq",
        #archive = "@hurt//prebuilt:yosyshq-tools.tar.xz",
        url = "https://github.com/cfrantz/hurt/releases/download/v0.0.1/yosyshq-tools.tar.xz",
        sha256 = "4417bdd5dfb26b0cbaa5ecb983d27e555dd393987415df04c497aca14f262866",
        strip_prefix = "yosyshq",
        build_file_content = """
package(default_visibility = ["//visibility:public"])

############################################################
# Yosys
############################################################
filegroup(
    name = "yosys_bin",
    srcs = ["yosys/bin/yosys"],
)

filegroup(
    name = "yosys_files",
    srcs = glob(["yosys/**"]),
)

############################################################
# Lattice ICE40 support
############################################################
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

############################################################
# Lattice ECP5 support
############################################################
filegroup(
    name = "nextpnr_ecp5",
    srcs = ["nextpnr/bin/nextpnr-ecp5"],
)

filegroup(
    name = "ecppack_bin",
    srcs = ["trellis/bin/ecppack"],
)

filegroup(
    name = "ecp5_files",
    srcs = glob(["trellis/**"]),
)
""",
    )
