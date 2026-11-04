<h1 align="center">
  <img src="assets/parsec-header.svg" alt="Parsec" width="100%">
</h1>

An HTML parser in Rust that reads pages the way a browser does, finds what
you're after with CSS selectors, and lets you change the tree and write it
back out.

If you use Lexbor today, directly or through selectolax, PHP's `Dom\HTMLDocument`,
nokolexbor or lazy_html, Parsec is being built for you. Lexbor is fast and
follows the spec. What we want to add is everything people keep asking it
for: positions on nodes, a worst case that stays linear, documents you can
share across threads, XPath, selectors that match everything a static page
can decide, and no use-after-free bugs, because the parser is memory-safe
Rust.

Parsec isn't released yet. This page says what works today and what's on
the way, and the line between the two is kept sharp.

## What works today

```rust
use parsec::css::SelectorList;

let doc = parsec::parse("<ul><li class=hit>one<li>two</ul>", false);
let hits = SelectorList::parse("li.hit").unwrap().select(&doc, doc.root());
assert_eq!(doc.text(hits[0]), "one");
```

- **The HTML Standard's tokenizer and tree builder.** It passes all 7,045
  html5lib tokenizer tests and every web-platform-tests tree-construction
  case that doesn't need JavaScript, run with scripting on and with it off.
  `cargo test` runs both suites; the WPT files are pinned in
  `crates/parsec/tests/tree-construction`.
- **Fragments** parsed in the context of any element, the way `innerHTML`
  is, SVG and MathML included.
- **CSS selectors, Level 4**: `:has()`, `:is()`, `:where()`, `:not()` with
  lists, `:nth-child(… of S)`, `:scope`, attribute flags, and the form states
  (`:checked`, `:disabled`, `:required` and friends).
- **A tree you can edit**: create, insert, move and remove nodes, set and
  rename attributes, then serialize as `innerHTML`, `outerHTML` or text.
- **Limits you choose**: a time budget per parse and a cap on input size.
  Inputs built to be slow, like thousands of nested formatting elements,
  take time in proportion to their length.
- **One dependency** (`memchr`) and one `unsafe` block, with its reasoning
  written beside it.

Speed: Parsec's parser is the one inside
[Netweir](https://github.com/netweir/netweir), whose published benchmark
pulls every price, title and link from a generated shop page in 3.0 ms
where selectolax (Lexbor) takes 5.7 ms, and 31 ms against 64 ms at 10 MB.
That run includes Python and the queries, so it isn't a parser-only number.
A head-to-head harness against Lexbor's own C, in one process, on the same
corpus, is the first thing on the [roadmap](ROADMAP.md), and its numbers
will replace this paragraph.

## What's coming

The [roadmap](ROADMAP.md) has the order. In short, Parsec is set to cover
every module Lexbor has, and then go past it:

| | Lexbor | Parsec |
|---|---|---|
| HTML parsing, fragments | yes | yes |
| Bytes in, encoding sniffed | yes | planned |
| Chunked input | yes | planned |
| Parse errors with line and column | pointers only | planned |
| Source positions on nodes and attributes | no | planned |
| Linear worst case | no ([#340](https://github.com/lexbor/lexbor/issues/340)) | yes |
| Thread-safe documents | no | planned, checked at compile time |
| `:scope`, `:lang()`, `:dir()`, `:valid` and other static pseudo-classes | parsed, never match | `:scope` yes, the rest planned |
| XPath | no | planned |
| WHATWG Encoding, 40 encodings | yes | planned |
| WHATWG URL | yes | planned, with WPT pass counts published |
| CSS parser and CSSOM | yes | planned, with `var()`, media queries and computed values |
| C API | yes | planned, with prebuilt libraries for Linux, macOS and Windows |
| Python, WebAssembly | through bindings | planned, built here |

Every "yes" in the Parsec column is something `cargo test` checks. A
"planned" becomes a "yes" only when it ships.

## Using it

Parsec isn't on crates.io yet. To try it from git:

```toml
[dependencies]
parsec-html = { git = "https://github.com/parsec-html/parsec" }
```

The package is `parsec-html` and the crate you `use` is `parsec`.

The [wiki](https://github.com/parsec-html/parsec/wiki) is where the
documentation lives: how parsing works, every option, the selector list,
and a guide for moving from Lexbor.

## Working on it

```sh
git clone --recurse-submodules https://github.com/parsec-html/parsec
cd parsec
cargo test
```

The parser core is shared with Netweir, so changes to `crates/parsec` start
there. [CONTRIBUTING.md](CONTRIBUTING.md) explains how that works and how
to get a change in. Questions go to
[Discussions](https://github.com/parsec-html/parsec/discussions), bugs to
[Issues](https://github.com/parsec-html/parsec/issues).

## Licence

Apache-2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).
