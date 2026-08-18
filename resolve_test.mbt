///|
/// Tests ported from `tests/resolve.rs` of `fluent-uri`.

///|
/// Asserts that `r` resolves against `base` to `expected`, whether or not path
/// underflow is allowed.
fn pass(base : @uri.Uri, r : String, expected : String) -> Unit raise {
  let r = @uri.UriRef::parse(r)
  for allow in [true, false] {
    assert_eq(
      r.resolve_against(base, allow_path_underflow=allow).text,
      expected,
    )
  }
}

///|
/// Asserts that resolving `r` against `base` fails with `expected`, whether or
/// not path underflow is allowed.
fn resolve_fail(
  base : @uri.Uri,
  r : String,
  expected : @uri.ResolveError,
) -> Unit raise {
  let r = @uri.UriRef::parse(r)
  for allow in [true, false] {
    try r.resolve_against(base, allow_path_underflow=allow) catch {
      e => assert_eq(e, expected)
    } noraise {
      _ => fail("expected resolution to fail")
    }
  }
}

///|
test "resolve" {
  // Examples from Section 5.4 of RFC 3986.
  let base = @uri.Uri::parse("http://a/b/c/d;p?q")
  pass(base, "g:h", "g:h")
  pass(base, "g", "http://a/b/c/g")
  pass(base, "./g", "http://a/b/c/g")
  pass(base, "g/", "http://a/b/c/g/")
  pass(base, "/g", "http://a/g")
  pass(base, "//g", "http://g")
  pass(base, "?y", "http://a/b/c/d;p?y")
  pass(base, "g?y", "http://a/b/c/g?y")
  pass(base, "#s", "http://a/b/c/d;p?q#s")
  pass(base, "g#s", "http://a/b/c/g#s")
  pass(base, "g?y#s", "http://a/b/c/g?y#s")
  pass(base, ";x", "http://a/b/c/;x")
  pass(base, "g;x", "http://a/b/c/g;x")
  pass(base, "g;x?y#s", "http://a/b/c/g;x?y#s")
  pass(base, "", "http://a/b/c/d;p?q")
  pass(base, ".", "http://a/b/c/")
  pass(base, "./", "http://a/b/c/")
  pass(base, "..", "http://a/b/")
  pass(base, "../", "http://a/b/")
  pass(base, "../g", "http://a/b/g")
  pass(base, "../..", "http://a/")
  pass(base, "../../", "http://a/")
  pass(base, "../../g", "http://a/g")
  pass(base, "/./g", "http://a/g")
  pass(base, "g.", "http://a/b/c/g.")
  pass(base, ".g", "http://a/b/c/.g")
  pass(base, "g..", "http://a/b/c/g..")
  pass(base, "..g", "http://a/b/c/..g")
  pass(base, "./../g", "http://a/b/g")
  pass(base, "./g/.", "http://a/b/c/g/")
  pass(base, "g/./h", "http://a/b/c/g/h")
  pass(base, "g/../h", "http://a/b/c/h")
  pass(base, "g;x=1/./y", "http://a/b/c/g;x=1/y")
  pass(base, "g;x=1/../y", "http://a/b/c/y")
  pass(base, "g?y/./x", "http://a/b/c/g?y/./x")
  pass(base, "g?y/../x", "http://a/b/c/g?y/../x")
  pass(base, "g#s/./x", "http://a/b/c/g#s/./x")
  pass(base, "g#s/../x", "http://a/b/c/g#s/../x")
  pass(base, "http:g", "http:g")

  // Non-hierarchical base URI.
  let base = @uri.Uri::parse("foo:bar")
  pass(base, "", "foo:bar")
  pass(base, "#baz", "foo:bar#baz")
  pass(base, "http://example.com/", "http://example.com/")
  pass(base, "foo:baz", "foo:baz")
  pass(base, "bar:baz", "bar:baz")

  // The result would be "foo://@@" using the original algorithm.
  let base = @uri.Uri::parse("foo:/")
  pass(base, ".//@@", "foo:/.//@@")

  // The result would be "foo:/bar/baz" using the original algorithm.
  let base = @uri.Uri::parse("foo:/bar/baz/.%2E/")
  pass(base, "..", "foo:/")

  // The result would be "foo:/bar/" using the original algorithm.
  let base = @uri.Uri::parse("foo:/bar/..")
  pass(base, ".", "foo:/")
  pass(base.normalize(), ".", "foo:/")
}

///|
test "resolve error" {
  let base = @uri.Uri::parse("http://example.com/#title1")
  resolve_fail(base, "foo", @uri.BaseWithFragment)
  let base = @uri.Uri::parse("foo:bar")
  resolve_fail(base, "baz", @uri.InvalidReferenceAgainstOpaqueBase)
  resolve_fail(base, "?baz", @uri.InvalidReferenceAgainstOpaqueBase)
}

///|
test "resolve underflow" {
  for
    case in [
      ("http://a/b/c/d;p?q", ["../../../g", "../../../../g", "/../g"]),
      ("foo:/..", ["", "?a", "#a"]),
    ] {
    let (base, rs) = case
    let base = @uri.Uri::parse(base)
    for r in rs {
      let r = @uri.UriRef::parse(r)
      r.resolve_against(base, allow_path_underflow=true) |> ignore
      try r.resolve_against(base, allow_path_underflow=false) catch {
        e => assert_eq(e, @uri.PathUnderflow)
      } noraise {
        _ => fail("expected an underflow")
      }
    }
  }
  let base = @uri.Uri::parse("foo:bar/..")
  pass(base, "", "foo:bar/..")
  resolve_fail(base, "?a", @uri.InvalidReferenceAgainstOpaqueBase)
  pass(base, "#a", "foo:bar/..#a")
}

///|
test "resolve iri" {
  let base = @uri.Iri::parse("http://例え.jp/a/b")
  let r = @uri.IriRef::parse("../ç")
  inspect(r.resolve_against(base), content="http://例え.jp/ç")
}
