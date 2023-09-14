# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@hurt//config:repo.bzl", "tools_repository")

def verilator_repos():
    tools_repository(
        name = "verilator",
        archive = "@hurt//prebuilt:verilator-binaries.tar.xz",
        #url = "https://github.com/cfrantz/hurt/releases/download/v0.0.1/verilator-binaries.tar.xz",
        #sha256 = "4417bdd5dfb26b0cbaa5ecb983d27e555dd393987415df04c497aca14f262866",
        strip_prefix = "verilator",
        build_file_content = """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "verilator_bin",
    srcs = ["bin/verilator"],
)

filegroup(
    name = "verilator_files",
    srcs = glob(
        ["**"],
        exclude = [
            "share/man/**",
            "share/pkgconfig/**",
            "share/verilator/examples/**",
        ],
    ),
)

cc_library(
    name = "includes",
    includes = [
        "include",
        "include/vltstd",
    ],
    defines = [
        "FST_CONFIG_INCLUDE=<gtkwave/fst_config.h>",
    ],
    hdrs = glob([
        "include/*.h",
        "include/gtkwave/*.h",
        "include/gtkwave/*.c",
        "include/vltstd/*.h",
    ]),
    srcs = glob([
        "include/*.cpp",
    ]),
)
""",
    )
