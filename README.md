<!-- omit in toc -->
# Tiny clash playground
This starter project contains a small playground to work with clash

<!-- omit in toc -->
# Table of Contents
- [Building and testing this project](#building-and-testing-this-project)
- [REPL](#repl)

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
