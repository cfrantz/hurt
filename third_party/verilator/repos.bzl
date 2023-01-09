# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def verilator_src_repos():
    http_archive(
        name = "verilator_src",
        url = "https://github.com/verilator/verilator/archive/refs/tags/v5.004.tar.gz",
        sha256 = "7d193a09eebefdbec8defaabfc125663f10cf6ab0963ccbefdfe704a8a4784d2",
        strip_prefix = "verilator-5.004",
        build_file = Label("//third_party/verilator:BUILD.verilator_src.bazel"),
    )
