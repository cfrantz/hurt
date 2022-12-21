# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def yosyshq_src_repos():
    http_archive(
        name = "yosys_src",
        url = "https://github.com/YosysHQ/yosys/archive/refs/tags/yosys-0.24.tar.gz",
        sha256 = "6a00b60e2d6bc8df0db1e66aa27af42a0694121cfcd6a3cf6f39c9329ed91263",
        strip_prefix = "yosys-yosys-0.24",
        build_file = Label("//third_party/yosyshq:BUILD.yosys_src.bazel"),
    )
    #new_git_repository(
    #    name = "yosys_src",
    #    remote = "https://github.com/YosysHQ/yosys.git",
    #    tag = "yosys-0.24",
    #    #commit = "480e3a236fd3244b63af20633502b57586c3125e",
    #    build_file = Label("//third_party/yosys:BUILD.yosys_src.bazel"),
    #)

    new_git_repository(
        name = "nextpnr_src",
        remote = "https://github.com/YosysHQ/nextpnr.git",
        commit = "3ea3a931ca2b9b7228bf241a3fd6cbf861e40696",
        build_file = Label("//third_party/yosyshq:BUILD.nextpnr_src.bazel"),
    )

    new_git_repository(
        name = "icestorm_src",
        remote = "https://github.com/YosysHQ/icestorm.git",
        commit = "a545498d6fd0a28a006976293917115037d4628c",
        build_file = Label("//third_party/yosyshq:BUILD.icestorm_src.bazel"),
    )

    new_git_repository(
        name = "trellis_src",
        remote = "https://github.com/YosysHQ/prjtrellis.git",
        commit = "35f5affe10a2995bdace49e23fcbafb5723c5347",
        build_file = Label("//third_party/yosyshq:BUILD.trellis_src.bazel"),
    )
