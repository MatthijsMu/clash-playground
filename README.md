<!-- omit in toc -->
# Simple Starter Project
This starter project contains the scaffolding needed to integrate Clash with the Nix Stack build system. Read [Simple Starter Project](https://github.com/clash-lang/clash-starters/blob/main/simple/README.md) for more information on the various files.

<!-- omit in toc -->
# Table of Contents
- [Getting this project](#getting-this-project)
- [Building and testing this project](#building-and-testing-this-project)
- [REPL](#repl)
- [Adding custom dependencies / updating nix](#adding-custom-dependencies--updating-nix)

# Building and testing this project
Build the project with:

```bash
nix-build
```

Verilog code will be available under the `result/share/verilog` directory.
Modify the `hdl` variable in `default.nix` to configure whether to generate
SystemVerilog or VHDL.

However development itself is more streamlined by using a Nix shell. Start one
by invoking:

```
nix-shell
```

To compile the project to VHDL run:

```bash
cabal run clash -- Clash.Playground.TopEntity --vhdl
```

You can find the HDL files in `vhdl/`. The source can be found in `src/Example/Project.hs`.

# REPL
To get a repl which allows to dynamically import modules and run and test code use the command:

```
cabal repl
```

# Adding custom dependencies / updating nix
`niv` is available after opening `nix-shell`. See [niv on Hackage](https://hackage.haskell.org/package/niv) for more information.