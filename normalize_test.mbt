///|
/// Tests ported from `tests/normalize.rs` of `fluent-uri`.

///|
test "normalize" {
  // Example from Section 6.2 of RFC 3986.
  let r = @uri.UriRef::parse("eXAMPLE://a/./b/../b/%63/%7bfoo%7d")
  inspect(r.normalize(), content="example://a/b/c/%7Bfoo%7D")

  // Examples from Section 6.2.3 of RFC 3986.
  // An empty path is not normalized to "/" for now.
  inspect(
    @uri.UriRef::parse("http://example.com").normalize(),
    content="http://example.com",
  )
  inspect(
    @uri.UriRef::parse("http://example.com/").normalize(),
    content="http://example.com/",
  )
  inspect(
    @uri.UriRef::parse("http://example.com:/").normalize(),
    content="http://example.com/",
  )
  inspect(
    @uri.UriRef::parse("http://example.com:80/").normalize(),
    content="http://example.com:80/",
  )

  // Lowercase percent-encoded octet.
  inspect(@uri.UriRef::parse("%3a").normalize(), content="%3A")

  // Uppercase letters in scheme and registered name.
  inspect(
    @uri.UriRef::parse("HTTP://www.EXAMPLE.com/").normalize(),
    content="http://www.example.com/",
  )

  // Underflow in path resolution.
  inspect(
    @uri.UriRef::parse("http://a/../../../g").normalize(),
    content="http://a/g",
  )

  // Percent-encoded dot segments.
  inspect(
    @uri.UriRef::parse("http://a/b/c/%2E/%2E./%2e%2E/d").normalize(),
    content="http://a/d",
  )

  // Don't remove dot segments from a relative reference or a rootless path.
  inspect(@uri.UriRef::parse("foo/../bar").normalize(), content="foo/../bar")
  inspect(@uri.UriRef::parse("/foo/../bar").normalize(), content="/foo/../bar")
  inspect(
    @uri.UriRef::parse("foo:bar/../baz").normalize(),
    content="foo:bar/../baz",
  )

  // Do remove dot segments for a URI with an absolute path.
  inspect(
    @uri.UriRef::parse("foo:/bar/./../baz").normalize(),
    content="foo:/baz",
  )

  // However, make sure that the output is a valid URI reference.
  inspect(@uri.UriRef::parse("foo:/.//@@").normalize(), content="foo:/.//@@")

  // Percent-encoded uppercase letters in registered name.
  inspect(
    @uri.UriRef::parse("HTTP://%45XAMPLE.%43Om").normalize(),
    content="http://example.com",
  )

  // Percent-encoded unreserved characters.
  inspect(
    @uri.UriRef::parse(
      "%41%42%43%44%45%46%47%48%49%4A%4B%4C%4D%4E%4F%50%51%52%53%54%55%56%57%58%59%5A%61%62%63%64%65%66%67%68%69%6A%6B%6C%6D%6E%6F%70%71%72%73%74%75%76%77%78%79%7A%30%31%32%33%34%35%36%37%38%39%2D%2E%5F%7E",
    ).normalize(),
    content="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~",
  )

  // Percent-encoded reserved characters are left alone.
  let r = @uri.UriRef::parse(
    "%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25",
  )
  assert_eq(r.normalize(), r)

  // A URI reference that is already normalized.
  let r = @uri.UriRef::parse(
    "foo://user@example.com:8042/over/there?name=ferret#nose",
  )
  assert_eq(r.normalize(), r)

  // Normalization in all components.
  inspect(
    @uri.UriRef::parse(
      "FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b#%24%4d",
    ).normalize(),
    content="foo://User@example.com:8042/K%2F?L%2B#%24M",
  )

  // Normal IPv4 address.
  let r = @uri.UriRef::parse("//127.0.0.1")
  inspect(r.normalize(), content="//127.0.0.1")
  assert_true(
    r.normalize().authority.unwrap().host_parsed is Ipv4(addr) &&
    addr == @uri.ipv4_localhost,
  )

  // Percent-encoded IPv4 address.
  let r = @uri.UriRef::parse("//127.0.0.%31")
  inspect(r.normalize(), content="//127.0.0.1")
  assert_true(
    r.normalize().authority.unwrap().host_parsed is Ipv4(addr) &&
    addr == @uri.ipv4_localhost,
  )

  // Normal IPv6 address.
  let r = @uri.UriRef::parse("//[::1]")
  inspect(r.normalize(), content="//[::1]")
  assert_true(
    r.normalize().authority.unwrap().host_parsed is Ipv6(addr) &&
    addr == @uri.ipv6_localhost,
  )

  // Verbose IPv6 address.
  let r = @uri.UriRef::parse("//[0000:0000:0000::1]")
  inspect(r.normalize(), content="//[::1]")
  assert_true(
    r.normalize().authority.unwrap().host_parsed is Ipv6(addr) &&
    addr == @uri.ipv6_localhost,
  )

  // IPv4-mapped IPv6 address.
  inspect(
    @uri.UriRef::parse("//[0:0:0:0:0:ffff:192.0.2.1]").normalize(),
    content="//[::ffff:192.0.2.1]",
  )

  // Deprecated IPv4-compatible IPv6 address.
  inspect(
    @uri.UriRef::parse("//[::192.0.2.1]").normalize(),
    content="//[::c000:201]",
  )

  // IPvFuture address.
  inspect(
    @uri.UriRef::parse("//[v1FdE.AddR]").normalize(),
    content="//[v1fde.addr]",
  )
}

///|
test "normalize iri" {
  // Example from Section 5.3.2 of RFC 3987.
  let r = @uri.IriRef::parse("eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9")
  inspect(r.normalize(), content="example://a/b/c/%7Bfoo%7D/rosé")

  // Encoded private character in query.
  let r = @uri.IriRef::parse("?%EE%80%80")
  inspect(r.normalize(), content="?\u{e000}")
}

///|
test "normalize default port" {
  let default_port = scheme => {
    match scheme {
      "http" | "ws" => Some(80)
      "https" | "wss" => Some(443)
      _ => None
    }
  }
  inspect(
    @uri.Uri::parse("http://example.com:80/").normalize(default_port~),
    content="http://example.com/",
  )
  inspect(
    @uri.Uri::parse("HTTP://example.com:0080/").normalize(default_port~),
    content="http://example.com/",
  )
  inspect(
    @uri.Uri::parse("foo://example.com:4673/").normalize(default_port~),
    content="foo://example.com:4673/",
  )
  inspect(
    @uri.Uri::parse("http://example.com:8080/").normalize(default_port~),
    content="http://example.com:8080/",
  )
  // A port that does not fit in a u16 is never the default one.
  inspect(
    @uri.Uri::parse("http://example.com:65536/").normalize(default_port~),
    content="http://example.com:65536/",
  )
}

///|
test "normalize strict" {
  let uri = @uri.Uri::parse("http://example.com/..")
  try uri.normalize_strict() catch {
    e => assert_eq(e, @uri.NormalizePathUnderflow)
  } noraise {
    _ => fail("expected an underflow")
  }
  inspect(
    @uri.Uri::parse("http://example.com/a/..").normalize_strict(),
    content="http://example.com/",
  )
}
