# marianoguerra/uri

A generic URI/IRI handling library for MoonBit, compliant with [RFC 3986] and
[RFC 3987].

This is a port of the Rust crate [`fluent-uri`] (revision `76e10ae`, the
development version that follows 0.4.1), by Scallop Ye, which is MIT licensed.
The parsing, normalization and resolution algorithms follow it closely, and a
generated conformance test suite keeps the two in step; see
[Conformance testing](#conformance-testing).

[RFC 3986]: https://datatracker.ietf.org/doc/html/rfc3986
[RFC 3987]: https://datatracker.ietf.org/doc/html/rfc3987
[`fluent-uri`]: https://crates.io/crates/fluent-uri

## Installation

    moon add marianoguerra/uri

Then import the package in the `moon.pkg` of the package that uses it:

```
import {
  "marianoguerra/uri",
  // Only needed to name an encoder or a table, see Packages below.
  "marianoguerra/uri/enc",
}
```

Every backend is supported: the test suite runs on `wasm`, `wasm-gc`, `js` and
`native`.

## Terminology

A *URI reference* is either a *URI* or a *relative reference*. If it starts
with a *scheme* (like `http`, `ftp` or `mailto`) followed by a colon, it is a
URI; `http://example.com/` and `mailto:user@example.com` are URIs. Otherwise it
is a relative reference; `//example.org/`, `/index.html`, `../`, `foo`, `?bar`
and `#baz` are relative references.

An *IRI* (reference) is an internationalized URI (reference), which may contain
non-ASCII characters.

The four types [`Uri`](#uri), [`UriRef`](#uriref), `Iri` and `IriRef` cover
these four combinations. They share the same API; the reference types have an
optional scheme, and the IRI types allow non-ASCII characters.

## Parsing

Parsing splits a string into its components. Every component is a field, so no
accessor call is needed to reach one:

```mbt check
///|
test "parsing" {
  let uri = @uri.Uri::parse(
    "foo://user@example.com:8042/over/there?name=ferret#nose",
  )
  assert_eq(uri.scheme, @uri.Scheme::new_or_panic("foo"))
  let auth = uri.authority.unwrap()
  assert_eq(auth.userinfo.unwrap().as_str(), "user")
  assert_eq(auth.host, "example.com")
  assert_eq(auth.port.unwrap().as_str(), "8042")
  assert_eq(uri.path.as_str(), "/over/there")
  assert_eq(uri.query.unwrap().as_str(), "name=ferret")
  assert_eq(uri.fragment.unwrap().as_str(), "nose")
}
```

A parsed host tells an IP address apart from a registered name:

```mbt check
///|
test "hosts" {
  let uri = @uri.Uri::parse("foo://127.0.0.1")
  assert_true(uri.authority.unwrap().host_parsed is Ipv4(_))
  let uri = @uri.Uri::parse("foo://[::1]")
  assert_true(
    uri.authority.unwrap().host_parsed is Ipv6(addr) &&
    addr == @uri.ipv6_localhost,
  )
  let uri = @uri.Uri::parse("foo://localhost")
  assert_true(
    uri.authority.unwrap().host_parsed is RegName(name) &&
    name.as_str() == "localhost",
  )
}
```

Parsing raises a [`ParseError`](#parseerror) that says where and why it failed:

```mbt check
///|
test "parse errors" {
  try @uri.Uri::parse("foo bar") catch {
    e => {
      assert_eq(e.index(), 3)
      inspect(e, content="unexpected character or end of input at index 3")
    }
  } noraise {
    _ => fail("expected a parse error")
  }
}
```

## Percent-encoding

Components are exposed as [`EStr`] values, which are strings known to be
properly percent-encoded for their component. The type parameter names the
*encoder*, which carries the table of byte patterns the component allows.

Always **split before decoding**: decoding first would let the data be mistaken
for delimiters.

```mbt check
///|
test "decoding a query string" {
  let query = @uri.UriRef::parse(
    "?name=%E5%BC%A0%E4%B8%89&speech=%C2%A1Ol%C3%A9%21",
  ).query.unwrap()
  let map : Map[String, String] = Map([])
  for pair in query.split('&') {
    let (k, v) = pair.split_once('=').unwrap()
    map[k.decode_to_string_lossy()] = v.decode_to_string_lossy()
  }
  assert_eq(map["name"], "张三")
  assert_eq(map["speech"], "¡Olé!")
}
```

Percent-encoding goes the other way, through an [`EString`] buffer. Encode data
with a *data* table (`@enc.table_data` or `@enc.table_idata`), never with the
table of the component itself, or delimiters in the data would survive
unencoded:

```mbt check
///|
test "encoding a query string" {
  let buf : @uri.EString[@enc.Query] = @uri.EString::new()
  for pair in [("name", "张三"), ("speech", "¡Olé!")] {
    let (k, v) = pair
    if !buf.is_empty() {
      buf.push('&')
    }
    buf.encode(k, table=@enc.table_data)
    buf.push('=')
    buf.encode(v, table=@enc.table_data)
  }
  let uri_ref = @uri.UriRef::build(path=@uri.EStr::empty(), query=buf.to_estr())
  inspect(uri_ref, content="?name=%E5%BC%A0%E4%B8%89&speech=%C2%A1Ol%C3%A9%21")
}
```

## Building

Components are passed as labeled arguments, in any order; the optional ones may
be left out. Building fails when the components could not be put back together
unambiguously:

```mbt check
///|
test "building" {
  let uri = @uri.Uri::build(
    scheme=@uri.Scheme::new_or_panic("foo"),
    authority=@uri.Authority::make(
      host=RegName(@uri.EStr::new_or_panic("example.com")),
      port=@uri.EStr::new_or_panic("8042"),
    ),
    path=@uri.EStr::new_or_panic("/over/there"),
  )
  inspect(uri, content="foo://example.com:8042/over/there")

  // A relative reference whose first segment contains a colon would be
  // mistaken for a scheme.
  try @uri.UriRef::build(path=@uri.EStr::new_or_panic("foo:bar")) catch {
    e => assert_eq(e, @uri.FirstPathSegmentContainsColon)
  } noraise {
    _ => fail("expected the build to fail")
  }
}
```

## Reference resolution

```mbt check
///|
test "resolution" {
  let base = @uri.Uri::parse("http://example.com/foo/bar")
  inspect(
    @uri.UriRef::parse("baz").resolve_against(base),
    content="http://example.com/foo/baz",
  )
  inspect(
    @uri.UriRef::parse("../baz").resolve_against(base),
    content="http://example.com/baz",
  )
  inspect(
    @uri.UriRef::parse("?baz").resolve_against(base),
    content="http://example.com/foo/bar?baz",
  )
}
```

By default a `".."` segment that escapes the root of the base is dropped, as
RFC 3986 prescribes. Pass `allow_path_underflow=false` to reject it instead:

```mbt check
///|
test "resolution underflow" {
  let base = @uri.Uri::parse("http://example.com/foo/bar")
  let r = @uri.UriRef::parse("../../baz")
  inspect(r.resolve_against(base), content="http://example.com/baz")
  try r.resolve_against(base, allow_path_underflow=false) catch {
    e => assert_eq(e, @uri.PathUnderflow)
  } noraise {
    _ => fail("expected an underflow")
  }
}
```

## Normalization

Normalization lowercases the scheme and the host, decodes percent-encoded
octets that stand for unreserved characters, uppercases the octets it keeps,
removes dot segments from an absolute path, and rewrites an IPv6 address in its
canonical form:

```mbt check
///|
test "normalization" {
  let uri = @uri.Uri::parse("eXAMPLE://a/./b/../b/%63/%7bfoo%7d")
  inspect(uri.normalize(), content="example://a/b/c/%7Bfoo%7D")

  // A scheme's default port is only removed if you say what it is.
  let uri = @uri.Uri::parse("http://example.com:80/")
  inspect(uri.normalize(), content="http://example.com:80/")
  inspect(
    uri.normalize(default_port=scheme => {
      if scheme is "http" {
        Some(80)
      } else {
        None
      }
    }),
    content="http://example.com/",
  )
}
```

## Converting between the four types

`to_*` methods convert the contents, and never fail:

```mbt check
///|
test "widening and encoding" {
  let uri = @uri.Uri::parse("http://example.com/")
  inspect(uri.to_uri_ref(), content="http://example.com/")
  // An IRI becomes a URI by percent-encoding its non-ASCII characters.
  let iri = @uri.Iri::parse("http://www.example.org/résumé.html")
  inspect(iri.to_uri(), content="http://www.example.org/r%C3%A9sum%C3%A9.html")
}
```

`as_*` methods keep the contents and only retype the value, so they fail when
the value does not meet the narrower type's requirements:

```mbt check
///|
test "narrowing" {
  let uri_ref = @uri.UriRef::parse("http://example.com/")
  inspect(uri_ref.as_uri(), content="http://example.com/")
  let relative = @uri.UriRef::parse("relative/ref")
  try relative.as_uri() catch {
    e => assert_eq(e, @uri.NoScheme)
  } noraise {
    _ => fail("expected the conversion to fail")
  }
  let iri = @uri.Iri::parse("http://例え.jp/")
  try iri.as_uri() catch {
    e => assert_eq(e, @uri.NotAscii(index=7))
  } noraise {
    _ => fail("expected the conversion to fail")
  }
}
```

## Packages

- `marianoguerra/uri` holds the URI/IRI types, their components, and the
  percent-encoded string types `EStr` and `EString`.
- `marianoguerra/uri/enc` holds the byte pattern `Table`s of RFC 3986/3987, the
  `Encoder` trait, and the encoder markers (`Path`, `Query`, `RegName`, …) that
  parameterize `EStr`. You only need to import it to name an encoder or a
  table.

## Differences from `fluent-uri`

The algorithms are ported as they are; the API is not, because Rust's and
MoonBit's idioms differ.

- **No borrowed/owned split.** `fluent-uri` has `Uri<&str>` and `Uri<String>`
  to let a parsed URI borrow its input. MoonBit strings are garbage collected,
  so there is a single `Uri`.
- **Components are fields, not accessors.** Parsing decomposes eagerly into
  read-only fields, and the textual form is kept in `text`.
- **Labeled arguments instead of a typestate builder.** `Uri::build` takes the
  components as labeled arguments, which enforces the same "set each component
  at most once, in order" discipline without the typestate machinery. The
  ordering constraints that the typestates encode are checked when building.
- **`raise` instead of `Result`.** Fallible operations raise MoonBit errors.
- **Indexes count UTF-16 code units,** since that is how MoonBit strings are
  indexed, whereas `fluent-uri` counts UTF-8 bytes. For ASCII input the two
  agree.
- **The index of a malformed percent-encoded octet is measured from the start
  of the component being read,** exactly as the reference implementation does,
  so it can point before the offending octet. The conformance suite pins this
  behavior.
- **IP addresses have their own types.** `Ipv4Addr` and `Ipv6Addr` are provided
  by this package rather than by the standard library, and `Ipv6Addr` formats
  itself in the canonical form of [RFC 5952].
- **No `socket_addrs` and no `serde`.** Name resolution and serialization
  frameworks are out of scope.

[RFC 5952]: https://datatracker.ietf.org/doc/html/rfc5952

## Testing

    moon test              # unit, ported, property and conformance tests
    moon coverage analyze  # coverage report

The suite has four layers:

1. **Ported tests.** `parse_test.mbt`, `parse_ip_test.mbt`, `normalize_test.mbt`,
   `resolve_test.mbt` and `convert_test.mbt` are translations of the
   corresponding files in `fluent-uri`'s `tests/` directory, plus
   `estr_test.mbt`, `build_test.mbt` and `misc_test.mbt` for the rest of the
   API.
2. **Documentation tests.** Every public function documents itself with a
   `mbt check` example that `moon test` runs.
3. **Property-based tests.** `property_test.mbt` replays the properties of
   `fluent-uri`'s fuzz targets against seeded generators (`gen_test.mbt`):
   parsing decomposes losslessly, normalization is stable and idempotent,
   resolution commutes with normalization, percent-encoding round-trips, the
   three decoding methods agree, and IPv6 addresses survive their canonical
   form.
4. **Conformance testing.** See below.

### Conformance testing

`tools/oracle` is a Rust program that links against `fluent-uri` itself. It
generates URI/IRI inputs, records what the reference implementation does with
each of them, and writes `conformance_test.mbt`, which replays the same inputs
against this port. Any divergence in parsing, in the decomposition into
components, in normalization, in reference resolution, in fragment
manipulation or in the conversion of an IRI to a URI shows up as a failing
test.

Regenerate the checked-in suite with:

    cargo run --release --manifest-path tools/oracle/Cargo.toml -- --out conformance_test.mbt

To fuzz against the oracle rather than replay the checked-in corpus, generate a
much larger suite with a fresh seed, run it, and throw it away:

    cargo run --release --manifest-path tools/oracle/Cargo.toml -- --seed 42 --count 50000 --out conformance_test.mbt
    moon test conformance_runner_test.mbt
    git checkout conformance_test.mbt

## License

This package is licensed under the Apache License 2.0, see [LICENSE](LICENSE).

It is a derivative work of [`fluent-uri`](https://github.com/yescallop/fluent-uri-rs),
copyright (c) 2024 Scallop Ye, which is licensed under the MIT license; that
license is reproduced in [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
