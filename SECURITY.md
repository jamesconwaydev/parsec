# Security

## Reporting a problem

Please don't open a public issue. Report it privately instead: on the
repository's "Security" tab, choose "Report a vulnerability", or go
straight to
[the form](https://github.com/parsec-html/parsec/security/advisories/new).
Tell me what you found, how to reproduce it, and what an attacker could do
with it. The input that triggers it is the most useful thing you can send.

You'll hear back within a week. Once there's a fix, it ships with an
advisory crediting you, unless you'd rather not be named.

## What counts

Parsec reads HTML that nobody vouches for. Anything that lets that HTML,
or a selector, do more than produce a tree is in scope. For example:

- input that makes the parser read or write memory it shouldn't, through
  `unsafe` code or otherwise;
- input that crashes it: a panic, a stack overflow, an abort;
- input that hangs it, or makes it take time or memory far out of
  proportion to its size, which is a denial of service for anyone parsing
  pages from the web;
- a selector or DOM edit that does any of the above.

Output that differs from what a browser builds, with nothing worse, is a
bug rather than a security problem. Please open an ordinary issue for it.

## Supported versions

There's no release yet, so for now fixes go to `main`. Once there is one,
fixes go into the newest minor release. Until Parsec reaches 1.0, older
releases don't get backports.
