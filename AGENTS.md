# Project Agents.md Guide

This is a [MoonBit](https://docs.moonbitlang.com) project.

You can browse and install extra skills here:
<https://github.com/moonbitlang/skills>

## Project Structure

- MoonBit packages are organized per directory; each directory contains a
  `moon.pkg` file listing its dependencies. Each package has its files and
  blackbox test files (ending in `_test.mbt`) and whitebox test files (ending in
  `_wbtest.mbt`).

- In the toplevel directory, there is a `moon.mod` file listing module
  metadata.

## Coding convention

- MoonBit code is organized in block style, each block is separated by `///|`,
  the order of each block is irrelevant. In some refactorings, you can process
  block by block independently.

- Try to keep deprecated blocks in file called `deprecated.mbt` in each
  directory.

## Tooling

- `moon fmt` is used to format your code properly.

- `moon ide` provides project navigation helpers like `peek-def`, `outline`, and
  `find-references`. See $moonbit-agent-guide for details.

- `moon info` is used to update the generated interface of the package, each
  package has a generated interface file `.mbti`, it is a brief formal
  description of the package. If nothing in `.mbti` changes, this means your
  change does not bring the visible changes to the external package users, it is
  typically a safe refactoring.

- In the last step, run `moon info && moon fmt` to update the interface and
  format the code. Check the diffs of `.mbti` file to see if the changes are
  expected.

- Run `moon test` to check tests pass. MoonBit supports snapshot testing; when
  changes affect outputs, run `moon test --update` to refresh snapshots.

- Prefer `assert_eq` or `assert_true(pattern is Pattern(...))` for results that
  are stable or very unlikely to change. For snapshot tests that record
  structured debugging output, derive `Debug` and use `debug_inspect`, rather
  than deriving `Show` for debugging. For solid, well-defined results (e.g.
  scientific computations), prefer assertion tests. You can use
  `moon coverage analyze > uncovered.log` to see which parts of your code are
  not covered by tests.

## This project

This package is a port of the Rust crate [`fluent-uri`] (revision `76e10ae`).
When changing parsing, normalization or reference resolution, keep the port
faithful to it: `README.mbt.md` lists the deliberate deviations, and anything
not listed there is a bug.

[`fluent-uri`]: https://github.com/yescallop/fluent-uri-rs

- `conformance_test.mbt` is **generated** — never edit it by hand. It records
  what the reference implementation does with a corpus of inputs, and
  `conformance_runner_test.mbt` replays that corpus against this port.
  Regenerate it with
  `cargo run --release --manifest-path tools/oracle/Cargo.toml -- --out conformance_test.mbt`,
  and fuzz against the oracle by generating a much larger suite with a fresh
  `--seed` (see the Testing section of `README.mbt.md`).

- The two dump functions in `conformance_runner_test.mbt` must keep rendering
  exactly what `tools/oracle/src/main.rs` renders in Rust, or the comparison
  becomes meaningless.

- `gen_test.mbt` holds the seeded generators for the property-based tests in
  `property_test.mbt`. Prefer adding a property there over adding one more
  example-based test when the invariant is general.
