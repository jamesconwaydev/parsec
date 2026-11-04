# Roadmap

Parsec has one aim: to be the parser you'd pick over Lexbor on every count
that matters to you. That means faster on the same pages, measured in one
process against Lexbor's own C; at least as conformant on every public test
suite; memory-safe; and pleasant to use from Rust, C, Python and the
browser.

Here's the order we're working in. Each milestone has an issue list on
GitHub, and nothing moves from "planned" to "done" in the README until it
ships with its tests.

## M0. Foundations

The repository, CI on Linux, macOS and Windows, the shared parser core and
the check that keeps it in step with Netweir, fuzzing, the wiki, and this
roadmap.

## M1. Proof

Before Parsec claims to be faster than Lexbor, there'll be a harness that
shows it: Lexbor built from a pinned release, html5ever, and Parsec, parsing
the same pages in one process. The results, with method and machine, go on
the wiki and replace the borrowed numbers in the README. The conformance
runners for everything that exists publish their counts the same way.

## M2. HTML, past Lexbor

- Bytes in, with the encoding sniffed from the BOM and `<meta>`, as browsers
  do, and the html5lib encoding tests passing.
- Chunked input that builds exactly the tree whole input does.
- Parse errors with their spec names, line and column.
- Source positions on every node and attribute.
- The pretty-printing and html5lib serializer formats, with the html5lib
  serializer tests.
- A depth limit alongside the time budget.
- Documents that are `Send` and `Sync`, enforced at compile time.
- Node handles that can tell when the node they named was removed.

## M3. Selectors that match what a page can decide

- `:lang()`, `:dir()`, `:default`, `:indeterminate`, `:valid`, `:invalid`,
  `:in-range`, `:out-of-range`, `:defined` and `:blank`.
- `:target` and `:local-link`, given a URL.
- `:nth-col()`, `:nth-last-col()` and the column combinator.
- Namespace prefixes.
- Specificity, lazy queries that stop at the first match, and the
  web-platform-tests selector cases that don't need layout.

## M4. Every way in

- A C API with a generated header, pkg-config and CMake files, and
  prebuilt libraries for Linux, macOS and Windows on x86-64 and ARM.
- A guide for moving from Lexbor, call by call.
- Python wheels, including free-threaded builds.
- WebAssembly for npm.

## M5. Encoding

The WHATWG Encoding Standard's 40 encodings, decoding and encoding,
streaming into the parser, with the web-platform-tests encoding cases in
CI.

## M6. URL

WHATWG URL, `URLSearchParams`, IDNA, Punycode and Unicode normalization,
with the web-platform-tests URL pass counts published. Then a benchmark
against Lexbor's URL parser and Ada.

## M7. CSS

The CSS Syntax parser, passing `css-parsing-tests` with positions on every
rule. Then the CSS Object Model, every property in the spec's index,
custom properties and `var()`, `calc()`, media queries evaluated against an
environment you give it, and computed values with inheritance.

## M8. XPath

XPath 1.0 over Parsec's tree, shared with Netweir.

## 0.1.0

The first release goes to crates.io, PyPI and npm as `parsec-html` once
M1 to M4 are done and the benchmarks show Parsec ahead on every page in the
corpus.
