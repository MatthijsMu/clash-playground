<!-- omit in toc -->
# Tiny clash playground
This starter project contains a small playground to work with clash

<!-- omit in toc -->
# Table of Contents
- [Building and testing this project](#building-and-testing-this-project)
- [REPL](#repl)

# Working with this project
Start a development shell by invoking:

```
nix-shell
```

To compile the project to VHDL run:

```bash
cabal run clash -- Clash.Playground.TopEntity --vhdl
```

You can find the HDL files in `vhdl/`. The source can be found in `src/Clash/Playground`.

# REPL
To get a repl which allows to dynamically import modules and run and test code use the command:

```
cabal repl
```
