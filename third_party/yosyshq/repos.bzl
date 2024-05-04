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
        commit = "960b42993b2cec64a7d884fa8d0c11b3a864bae2",
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
        commit = "edcafcf085aa0ee65f1cf01dd5f33d877777f911",
        build_file = Label("//third_party/yosyshq:BUILD.nextpnr_src.bazel"),
        recursive_init_submodules = True,
    )

    git_repository(
        name = "icestorm_src",
        remote = "https://github.com/YosysHQ/icestorm.git",
        commit = "1a40ae75d4eebee9cce73a2c4d634fd42ed0110f",
        build_file = Label("//third_party/yosyshq:BUILD.icestorm_src.bazel"),
    )

    git_repository(
        name = "trellis_src",
        remote = "https://github.com/YosysHQ/prjtrellis.git",
        commit = "2dab0095e1a5691855b0955b329cb4946b6a13b8",
        build_file = Label("//third_party/yosyshq:BUILD.trellis_src.bazel"),
        recursive_init_submodules = True,
    )
