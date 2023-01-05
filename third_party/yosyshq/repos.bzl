# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def yosyshq_src_repos():
    # TODO(cfrantz): My fork of yosys adds `abc` as a git submodule so that the
    # yosys build won't have to manually clone `abc` which would normally be
    # forbidden inside the bazel sandbox.  Upstream this change to yosyshq and
    # then use the upstream repo.
    git_repository(
        name = "yosys_src",
        remote = "https://github.com/cfrantz/yosys.git",
        commit = "90f5d3648d53d442445da6e7251e4435ea59818b",
        build_file = Label("//third_party/yosyshq:BUILD.yosys_src.bazel"),
        recursive_init_submodules = True,
        patches = [
            Label("//third_party/yosyshq/patches:yosys-abc-redact.patch"),
        ],
        patch_args = ["-p1"],
    )

    git_repository(
        name = "nextpnr_src",
        remote = "https://github.com/YosysHQ/nextpnr.git",
        commit = "3ea3a931ca2b9b7228bf241a3fd6cbf861e40696",
        build_file = Label("//third_party/yosyshq:BUILD.nextpnr_src.bazel"),
        recursive_init_submodules = True,
    )

    git_repository(
        name = "icestorm_src",
        remote = "https://github.com/YosysHQ/icestorm.git",
        commit = "a545498d6fd0a28a006976293917115037d4628c",
        build_file = Label("//third_party/yosyshq:BUILD.icestorm_src.bazel"),
    )

    git_repository(
        name = "trellis_src",
        remote = "https://github.com/YosysHQ/prjtrellis.git",
        commit = "35f5affe10a2995bdace49e23fcbafb5723c5347",
        build_file = Label("//third_party/yosyshq:BUILD.trellis_src.bazel"),
        recursive_init_submodules = True,
    )
