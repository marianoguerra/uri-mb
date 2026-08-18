///|
/// Tests ported from `tests/parse.rs` of `fluent-uri`.

///|
/// Parses a URI reference and returns the error it fails with.
fn ref_err(input : String) -> @uri.ParseError raise {
  try @uri.UriRef::parse(input) catch {
    e => return e
  } noraise {
    _ => fail("expected \{input} to fail to parse")
  }
}

///|
/// Parses a URI and returns the error it fails with.
fn uri_err(input : String) -> @uri.ParseError raise {
  try @uri.Uri::parse(input) catch {
    e => return e
  } noraise {
    _ => fail("expected \{input} to fail to parse")
  }
}

///|
test "parse absolute" {
  let r = @uri.UriRef::parse("file:///etc/hosts")
  assert_eq(r.text, "file:///etc/hosts")
  assert_eq(r.scheme.unwrap().as_str(), "file")
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "")
  assert_eq(a.userinfo, None)
  assert_eq(a.host, "")
  assert_true(a.host_parsed is RegName(n) && n.is_empty())
  assert_eq(a.port, None)
  assert_eq(r.path.as_str(), "/etc/hosts")
  assert_eq(r.query, None)
  assert_eq(r.fragment, None)
  let r = @uri.UriRef::parse("ftp://ftp.is.co.za/rfc/rfc1808.txt")
  assert_eq(r.scheme.unwrap().as_str(), "ftp")
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "ftp.is.co.za")
  assert_eq(a.userinfo, None)
  assert_eq(a.host, "ftp.is.co.za")
  assert_true(a.host_parsed is RegName(n) && n.as_str() == "ftp.is.co.za")
  assert_eq(a.port, None)
  assert_eq(r.path.as_str(), "/rfc/rfc1808.txt")
  assert_eq(r.query, None)
  assert_eq(r.fragment, None)
  let r = @uri.UriRef::parse("ldap://[2001:db8::7]/c=GB?objectClass?one")
  assert_eq(r.scheme.unwrap().as_str(), "ldap")
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "[2001:db8::7]")
  assert_eq(a.host, "[2001:db8::7]")
  assert_true(
    a.host_parsed is Ipv6(addr) &&
    addr == @uri.Ipv6Addr::new(0x2001, 0xdb8, 0, 0, 0, 0, 0, 7),
  )
  assert_eq(a.port, None)
  assert_eq(r.path.as_str(), "/c=GB")
  assert_eq(r.query.unwrap().as_str(), "objectClass?one")
  assert_eq(r.fragment, None)
  let r = @uri.UriRef::parse("mailto:John.Doe@example.com")
  assert_eq(r.scheme.unwrap().as_str(), "mailto")
  assert_true(r.authority is None)
  assert_eq(r.path.as_str(), "John.Doe@example.com")
  let r = @uri.UriRef::parse("tel:+1-816-555-1212")
  assert_eq(r.scheme.unwrap().as_str(), "tel")
  assert_true(r.authority is None)
  assert_eq(r.path.as_str(), "+1-816-555-1212")
  let r = @uri.UriRef::parse("telnet://192.0.2.16:80/")
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "192.0.2.16:80")
  assert_eq(a.host, "192.0.2.16")
  assert_true(
    a.host_parsed is Ipv4(addr) && addr == @uri.Ipv4Addr::new(192, 0, 2, 16),
  )
  assert_eq(a.port.unwrap().as_str(), "80")
  assert_eq(r.path.as_str(), "/")
  let r = @uri.UriRef::parse(
    "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
  )
  assert_eq(r.path.as_str(), "oasis:names:specification:docbook:dtd:xml:4.1.2")
  let r = @uri.UriRef::parse(
    "foo://example.com:8042/over/there?name=ferret#nose",
  )
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "example.com:8042")
  assert_eq(a.userinfo, None)
  assert_eq(a.host, "example.com")
  assert_eq(a.port.unwrap().as_str(), "8042")
  assert_eq(r.path.as_str(), "/over/there")
  assert_eq(r.query.unwrap().as_str(), "name=ferret")
  assert_eq(r.fragment.unwrap().as_str(), "nose")
  let r = @uri.UriRef::parse(
    "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
  )
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "cnn.example.com&story=breaking_news@10.0.0.1")
  assert_eq(a.userinfo.unwrap().as_str(), "cnn.example.com&story=breaking_news")
  assert_eq(a.host, "10.0.0.1")
  assert_true(
    a.host_parsed is Ipv4(addr) && addr == @uri.Ipv4Addr::new(10, 0, 0, 1),
  )
  assert_eq(a.port, None)
  assert_eq(r.path.as_str(), "/top_story.htm")
  let r = @uri.UriRef::parse("http://[vFe.foo.bar]")
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "[vFe.foo.bar]")
  assert_eq(a.host, "[vFe.foo.bar]")
  assert_true(a.host_parsed is IpvFuture)
  assert_eq(a.port, None)
  assert_eq(r.path.as_str(), "")
  let r = @uri.UriRef::parse("http://127.0.0.1:/")
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "127.0.0.1:")
  assert_eq(a.host, "127.0.0.1")
  assert_eq(a.port.unwrap().as_str(), "")
  let r = @uri.UriRef::parse("http://127.0.0.1:80808/")
  let a = r.authority.unwrap()
  assert_eq(a.port.unwrap().as_str(), "80808")
  assert_true(a.host_parsed is Ipv4(_))
}

///|
test "parse relative" {
  let r = @uri.UriRef::parse("")
  assert_true(r.scheme is None)
  assert_true(r.authority is None)
  assert_eq(r.path.as_str(), "")
  assert_eq(r.query, None)
  assert_eq(r.fragment, None)
  let r = @uri.UriRef::parse("foo.txt")
  assert_true(r.scheme is None)
  assert_eq(r.path.as_str(), "foo.txt")
  let r = @uri.UriRef::parse(".")
  assert_eq(r.path.as_str(), ".")
  let r = @uri.UriRef::parse("./this:that")
  assert_true(r.scheme is None)
  assert_eq(r.path.as_str(), "./this:that")
  let r = @uri.UriRef::parse("//example.com")
  assert_true(r.scheme is None)
  let a = r.authority.unwrap()
  assert_eq(a.as_str(), "example.com")
  assert_eq(a.host, "example.com")
  assert_eq(r.path.as_str(), "")
  let r = @uri.UriRef::parse("?query")
  assert_eq(r.path.as_str(), "")
  assert_eq(r.query.unwrap().as_str(), "query")
  assert_eq(r.fragment, None)
  let r = @uri.UriRef::parse("#fragment")
  assert_eq(r.path.as_str(), "")
  assert_eq(r.query, None)
  assert_eq(r.fragment.unwrap().as_str(), "fragment")
}

///|
test "parse error uri" {
  // No scheme.
  assert_eq(uri_err("foo"), UnexpectedCharOrEnd(index=3))
  // Empty scheme.
  assert_eq(uri_err(":hello"), UnexpectedCharOrEnd(index=0))
  // Scheme starts with non-letter.
  assert_eq(uri_err("3ttp://a.com"), UnexpectedCharOrEnd(index=0))
  // Unexpected character in scheme.
  assert_eq(uri_err("exam=ple:foo"), UnexpectedCharOrEnd(index=4))
  assert_eq(uri_err("(:"), UnexpectedCharOrEnd(index=0))
  // Percent-encoded scheme.
  assert_eq(uri_err("a%20:foo"), UnexpectedCharOrEnd(index=1))
}

///|
test "parse error uri ref" {
  // Empty scheme.
  assert_eq(ref_err(":hello"), UnexpectedCharOrEnd(index=0))
  // Scheme starts with non-letter.
  assert_eq(ref_err("3ttp://a.com"), UnexpectedCharOrEnd(index=0))
  // The following two cases are interpreted as containing a colon in the
  // first path segment of a relative reference.
  assert_eq(ref_err("exam=ple:foo"), UnexpectedCharOrEnd(index=8))
  assert_eq(ref_err("(:"), UnexpectedCharOrEnd(index=1))
  // Percent-encoded scheme.
  assert_eq(ref_err("a%20:foo"), UnexpectedCharOrEnd(index=4))
  // Unexpected character in path.
  assert_eq(ref_err("foo\\bar"), UnexpectedCharOrEnd(index=3))
  // Non-hexadecimal percent-encoded octet.
  assert_eq(ref_err("foo%xxd"), UnexpectedCharOrEnd(index=4))
  // Incomplete percent-encoded octet.
  assert_eq(ref_err("text%a"), UnexpectedCharOrEnd(index=6))
  // A single percent.
  assert_eq(ref_err("%"), UnexpectedCharOrEnd(index=1))
  // Non-decimal port.
  assert_eq(ref_err("http://example.com:80ab"), UnexpectedCharOrEnd(index=23))
  assert_eq(
    ref_err("http://user@example.com:80ab"),
    UnexpectedCharOrEnd(index=26),
  )
  // Multiple colons in authority.
  assert_eq(
    ref_err("http://user:pass:example.com/"),
    UnexpectedCharOrEnd(index=28),
  )
  // Unclosed bracket.
  assert_eq(ref_err("https://[::1/"), UnexpectedCharOrEnd(index=12))
  // Not a port after an IP literal.
  assert_eq(ref_err("https://[::1]wrong"), UnexpectedCharOrEnd(index=13))
  // IP literal too short.
  assert_eq(ref_err("http://[:]"), InvalidIpv6Addr(index=8))
  assert_eq(ref_err("http://[]"), UnexpectedCharOrEnd(index=8))
  // Non-hexadecimal version in IPvFuture.
  assert_eq(ref_err("http://[vG.addr]"), UnexpectedCharOrEnd(index=9))
  // Empty version in IPvFuture.
  assert_eq(ref_err("http://[v.addr]"), UnexpectedCharOrEnd(index=9))
  // Empty address in IPvFuture.
  assert_eq(ref_err("ftp://[vF.]"), UnexpectedCharOrEnd(index=10))
  // Percent-encoded address in IPvFuture.
  assert_eq(ref_err("ftp://[vF.%20]"), UnexpectedCharOrEnd(index=10))
  // With a zone identifier.
  assert_eq(ref_err("ftp://[fe80::abcd%eth0]"), UnexpectedCharOrEnd(index=17))
  // Invalid IPv6 address.
  assert_eq(ref_err("example://[44:55::66::77]"), InvalidIpv6Addr(index=11))
}

///|
test "strict ip addr" {
  let r = @uri.UriRef::parse("//127.0.0.001")
  assert_true(r.authority.unwrap().host_parsed is RegName(_))
  let r = @uri.UriRef::parse("//127.1")
  assert_true(r.authority.unwrap().host_parsed is RegName(_))
  let r = @uri.UriRef::parse("//127.00.00.1")
  assert_true(r.authority.unwrap().host_parsed is RegName(_))
  @uri.UriRef::parse("//[::1.1.1.1]") |> ignore
  @uri.UriRef::parse("//[::ffff:1.1.1.1]") |> ignore
  @uri.UriRef::parse("//[0000:0000:0000:0000:0000:0000:255.255.255.255]")
  |> ignore
  assert_eq(ref_err("//[::01.1.1.1]"), InvalidIpv6Addr(index=3))
  assert_eq(ref_err("//[::00.1.1.1]"), InvalidIpv6Addr(index=3))
}
