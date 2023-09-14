# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

load("//hdl/private:toolchain.bzl", "HdlRuleHelpers")
load("//hdl/private:constraints.bzl", "HdlConstraintsInfo")
load("//hdl/private:library.bzl", "default_hdl_library_impl", "get_transitive_srcs")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")
load("@rules_foreign_cc//foreign_cc/private:make_env_vars.bzl", "get_make_env_vars")
load(
    "@rules_foreign_cc//foreign_cc/private:cc_toolchain_util.bzl",
    "get_flags_info",
    "get_tools_info",
)
load(
    "@rules_foreign_cc//foreign_cc/private/framework:helpers.bzl",
    "convert_shell_script",
    "script_extension",
    "shebang",
)
load("@rules_foreign_cc//toolchains/native_tools:tool_access.bzl", "get_make_data")

DEFAULT_VERILATOR_ARGS = ["--cc", "--exe", "--build", "-j"]

def _verilator_script(ctx, make):
    flags = get_flags_info(ctx)
    tools = get_tools_info(ctx)

    env = get_make_env_vars(
        workspace_name = ctx.workspace_name,
        tools = tools,
        flags = flags,
        user_vars = {},
        deps = [],
        inputs = struct(
            libs = [],
            include_dirs = [],
            headers = [],
        ),
    )

    script_lines = [
        "export EXT_BUILD_ROOT=##pwd##",
        "export VERILATOR_ROOT=${EXT_BUILD_ROOT}/external/verilator",
        "export VPATH=${EXT_BUILD_ROOT}",
        "export MAKE={}".format(make.env["MAKE"]),
        env + " ${VERILATOR_ROOT}/bin/verilator \"$@\"",
    ]

    script = ctx.actions.declare_file("verilate_{}{}".format(ctx.attr.name, script_extension(ctx)))
    ctx.actions.write(
        output = script,
        content = "\n".join([
            shebang(ctx),
            convert_shell_script(ctx, script_lines),
            "",
        ]),
        is_executable = True,
    )
    return script

def _verilator_binary(ctx, toolchain):
    make = get_make_data(ctx)
    cc = find_cpp_toolchain(ctx)

    srcs = get_transitive_srcs(ctx.files.srcs, ctx.attr.deps)
    srcfiles = srcs.to_list()
    constraints = ctx.attr.constraints[HdlConstraintsInfo]

    out_dir = ctx.actions.declare_directory("{}.verilated".format(ctx.attr.name))
    verilator_args = ctx.attr.tool_options.get("verilator", DEFAULT_VERILATOR_ARGS)
    outputs = [out_dir]
    args = []
    args.extend(ctx.attr.tool_options.get("verilator", DEFAULT_VERILATOR_ARGS))
    args.extend(["--Mdir", out_dir.path])
    args.extend(["-D{}".format(d) for d in ctx.attr.defines])

    groups = {}
    if "--main" in verilator_args or "--exe" in verilator_args:
        simulator = ctx.attr.tool_options.get("simulator", ["{name}"])
        simulator = simulator[0].format(name = ctx.attr.name)
        out = ctx.actions.declare_file(simulator)
        outputs.append(out)
        args.extend(["-o", "../{}".format(simulator)])
        groups["binary"] = depset([out])
        cc_info = []
    else:
        simulator = ctx.attr.tool_options.get("simulator", ["V{name}__ALL.a"])
        simulator = simulator[0].format(name = ctx.attr.name)
        out = ctx.actions.declare_file("{}/{}".format(out_dir.basename, simulator))
        outputs.append(out)
        groups["library"] = depset([out])

        compilation_info = cc_common.create_compilation_context(
            headers = depset([out_dir]),
            system_includes = depset([out_dir.path]),
            includes = depset([]),
            quote_includes = depset([]),
        )
        features = cc_common.configure_features(
            ctx = ctx,
            cc_toolchain = cc,
            requested_features = ctx.features,
            unsupported_features = ctx.disabled_features + [
                "fdo_instrument",
                "fdo_optimize",
                "layering_check",
                "module_maps",
                "thin_lto",
            ],
        )
        linking_info = cc_common.create_linking_context(
            linker_inputs = depset(direct = [
                cc_common.create_linker_input(
                    owner = ctx.label,
                    libraries = depset(direct = [cc_common.create_library_to_link(
                        actions = ctx.actions,
                        feature_configuration = features,
                        cc_toolchain = cc,
                        static_library = out,
                    )]),
                ),
            ]),
        )
        cc_info = [CcInfo(
            compilation_context = compilation_info,
            linking_context = linking_info,
        )]

    args.extend([src.path for src in srcfiles])
    build_script = _verilator_script(ctx, make)
    ctx.actions.run(
        outputs = outputs,
        inputs = srcs,
        tools = depset(
            [build_script] +
            cc.all_files.to_list() +
            toolchain.tools.verilator_bin.deps,
            transitive = [dep.files for dep in make.deps],
        ),
        executable = build_script,
        arguments = args,
        mnemonic = "Verilator",
    )

    groups["gen_dir"] = depset([out_dir])
    groups["build_script"] = depset([build_script])

    return [
        DefaultInfo(files = depset([out])),
        OutputGroupInfo(**groups),
    ] + cc_info

def _verilator_helper(ctx):
    return [HdlRuleHelpers(
        library = default_hdl_library_impl,
        binary = _verilator_binary,
    )]

verilator_helper = rule(
    implementation = _verilator_helper,
    provides = [HdlRuleHelpers],
)
