///|
/// Tests for the parts of the API that the ported test suites do not reach:
/// error messages, the checked conversions, strict normalization, and the
/// conditions under which the library panics.

///|
test "error messages" {
  inspect(
    @uri.UnexpectedCharOrEnd(index=4),
    content="unexpected character or end of input at index 4",
  )
  inspect(
    @uri.InvalidIpv6Addr(index=8),
    content="invalid IPv6 address at index 8",
  )
  assert_eq(@uri.UnexpectedCharOrEnd(index=4).index(), 4)
  assert_eq(@uri.InvalidIpv6Addr(index=8).index(), 8)
  inspect(@uri.NotAscii(index=7), content="non-ASCII character at index 7")
  inspect(@uri.NoScheme, content="scheme not present")
  inspect(@uri.BaseWithFragment, content="base should not have fragment")
  inspect(
    @uri.InvalidReferenceAgainstOpaqueBase,
    content="when base has a rootless path and no authority, reference should either have scheme, be empty or start with '#'",
  )
  inspect(@uri.PathUnderflow, content="underflow occurred in path resolution")
  inspect(
    @uri.NormalizePathUnderflow,
    content="underflow occurred in path resolution",
  )
  inspect(
    @uri.NonemptyRootlessPath,
    content="when authority is present, path should either be empty or start with '/'",
  )
  inspect(
    @uri.PathStartsWithDoubleSlash,
    content="when authority is not present, path should not start with \"//\"",
  )
  inspect(
    @uri.FirstPathSegmentContainsColon,
    content="when neither scheme nor authority is present, first path segment should not contain ':'",
  )
  inspect(@uri.InvalidPort(port="123456"), content="invalid port value: 123456")
  inspect(
    @uri.NotUtf8(bytes=b"\xff"),
    content="percent-decoded octets are not valid UTF-8",
  )
}

///|
test "debug output" {
  let uri = @uri.Uri::parse("http://example.com/a")
  debug_inspect(
    uri,
    content=(
      #|"http://example.com/a"
    ),
  )
  debug_inspect(
    uri.to_uri_ref(),
    content=(
      #|"http://example.com/a"
    ),
  )
  debug_inspect(
    uri.to_iri(),
    content=(
      #|"http://example.com/a"
    ),
  )
  debug_inspect(
    uri.to_iri_ref(),
    content=(
      #|"http://example.com/a"
    ),
  )
  debug_inspect(
    uri.scheme,
    content=(
      #|"http"
    ),
  )
  debug_inspect(
    uri.path,
    content=(
      #|"/a"
    ),
  )
  debug_inspect(
    @uri.Ipv4Addr::new(127, 0, 0, 1),
    content=(
      #|"127.0.0.1"
    ),
  )
  debug_inspect(
    @uri.ipv6_localhost,
    content=(
      #|"::1"
    ),
  )
  let buf : @uri.EString[@enc.Query] = @uri.EString::new()
  buf.push('a')
  debug_inspect(
    buf,
    content=(
      #|"a"
    ),
  )
  inspect(uri.authority.unwrap(), content="example.com")
  inspect(@uri.Scheme::new_or_panic("http"), content="http")
}

///|
test "estr comparison" {
  let a : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("a")
  let b : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("b")
  assert_eq(a, a)
  assert_not_eq(a, b)
  assert_true(a < b)
  assert_true(b > a)
  let seen = Map::from_array([(a, 1)])
  assert_eq(seen.get(a), Some(1))
  assert_eq(seen.get(b), None)
  let s : @uri.EString[@enc.Path] = @uri.EString::new()
  s.push('a')
  let t : @uri.EString[@enc.Path] = @uri.EString::new()
  t.push('a')
  assert_eq(s, t)
  t.push('b')
  assert_not_eq(s, t)
}

///|
test "uri comparison" {
  let a = @uri.Uri::parse("http://example.com/a")
  let b = @uri.Uri::parse("http://example.com/b")
  assert_eq(a, a)
  assert_not_eq(a, b)
  assert_true(a < b)
  let seen = Map::from_array([(a, 1)])
  assert_eq(seen.get(a), Some(1))
  // Schemes hash consistently with their case-insensitive equality.
  let http = @uri.Scheme::new_or_panic("http")
  let http_upper = @uri.Scheme::new_or_panic("HTTP")
  let schemes = Map::from_array([(http, 1)])
  assert_eq(schemes.get(http_upper), Some(1))
  assert_not_eq(http, @uri.Scheme::new_or_panic("http2"))
}

///|
test "ipv6 accessors" {
  let addr = @uri.Ipv6Addr::new(1, 2, 3, 4, 5, 6, 7, 8)
  assert_eq(addr.segments(), [1, 2, 3, 4, 5, 6, 7, 8])
  assert_eq(
    addr.octets(),
    b"\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08",
  )
  assert_eq(@uri.ipv6_unspecified.segments(), [0, 0, 0, 0, 0, 0, 0, 0])
  assert_eq(@uri.ipv4_unspecified.octets(), (0, 0, 0, 0))
  assert_eq(@uri.ipv4_localhost.octets(), (127, 0, 0, 1))
}

///|
test "checked conversions succeed" {
  let uri_ref = @uri.UriRef::parse("http://example.com/")
  assert_eq(uri_ref.as_uri().text, "http://example.com/")
  let iri = @uri.Iri::parse("http://example.com/")
  assert_eq(iri.as_uri().text, "http://example.com/")
  let iri_ref = @uri.IriRef::parse("http://example.com/")
  assert_eq(iri_ref.as_uri().text, "http://example.com/")
  assert_eq(iri_ref.as_uri_ref().text, "http://example.com/")
  assert_eq(iri_ref.as_iri().text, "http://example.com/")
  // The components survive the conversion.
  assert_eq(iri_ref.as_uri().authority.unwrap().host, "example.com")
}

///|
test "strict normalization" {
  // Every type rejects an underflow when asked to.
  let uri = @uri.Uri::parse("http://a/..")
  try uri.normalize_strict() catch {
    e => assert_eq(e, @uri.NormalizePathUnderflow)
  } noraise {
    _ => fail("expected an underflow")
  }
  let uri_ref = @uri.UriRef::parse("http://a/..")
  try uri_ref.normalize_strict() catch {
    e => assert_eq(e, @uri.NormalizePathUnderflow)
  } noraise {
    _ => fail("expected an underflow")
  }
  let iri = @uri.Iri::parse("http://a/..")
  try iri.normalize_strict() catch {
    e => assert_eq(e, @uri.NormalizePathUnderflow)
  } noraise {
    _ => fail("expected an underflow")
  }
  let iri_ref = @uri.IriRef::parse("http://a/..")
  try iri_ref.normalize_strict() catch {
    e => assert_eq(e, @uri.NormalizePathUnderflow)
  } noraise {
    _ => fail("expected an underflow")
  }
  // Without an underflow they behave like `normalize`.
  inspect(
    @uri.UriRef::parse("http://a/b/..").normalize_strict(),
    content="http://a/",
  )
  inspect(
    @uri.Iri::parse("http://a/b/..").normalize_strict(),
    content="http://a/",
  )
  inspect(
    @uri.IriRef::parse("http://a/b/..").normalize_strict(),
    content="http://a/",
  )
  // A relative reference has no dot segments removed, so it never underflows.
  inspect(@uri.UriRef::parse("../..").normalize_strict(), content="../..")
}

///|
test "incomplete ip literal" {
  // The last segment of the address runs into the end of the input.
  assert_eq(ref_err("//[12"), InvalidIpv6Addr(index=3))
  assert_eq(ref_err("//[1:2:3"), InvalidIpv6Addr(index=3))
  assert_eq(ref_err("//[v"), UnexpectedCharOrEnd(index=4))
}

///|
test "panic decode without percent-encoding" {
  let port : @uri.EStr[@enc.Port] = @uri.EStr::new_or_panic("8042")
  ignore(port.decode_to_bytes())
}

///|
test "panic force encode byte without percent-encoding" {
  let s : @uri.EStr[@enc.Port] = @uri.EStr::force_encode_byte(b'a')
  ignore(s)
}

///|
test "panic encode with a table that is not a sub-encoder" {
  let buf : @uri.EString[@enc.Port] = @uri.EString::new()
  buf.encode("a", table=@enc.table_data)
}

///|
test "panic encode with a table without percent-encoding" {
  let buf : @uri.EString[@enc.Query] = @uri.EString::new()
  buf.encode("a", table=@enc.table_digit)
}

///|
test "panic build authority with an IPvFuture host" {
  let host : @uri.Host[@enc.RegName] = @uri.Host::IpvFuture
  let auth : @uri.Authority[@enc.Userinfo, @enc.RegName] = @uri.Authority::make(
    host~,
  )
  ignore(auth)
}

///|
test "panic invalid scheme" {
  ignore(@uri.Scheme::new_or_panic("3ttp"))
}

///|
test "remaining comparisons and builders" {
  // Schemes of the same length that differ.
  assert_not_eq(
    @uri.Scheme::new_or_panic("http"),
    @uri.Scheme::new_or_panic("htTf"),
  )
  // Comparison of the reference and IRI types.
  let a = @uri.UriRef::parse("a")
  let b = @uri.UriRef::parse("b")
  assert_true(a < b)
  assert_eq(a, @uri.UriRef::parse("a"))
  let a = @uri.Iri::parse("a:x")
  let b = @uri.Iri::parse("a:y")
  assert_true(a < b)
  assert_eq(a, @uri.Iri::parse("a:x"))
  let a = @uri.IriRef::parse("x")
  let b = @uri.IriRef::parse("y")
  assert_true(a < b)
  assert_eq(a, @uri.IriRef::parse("x"))
  // Hashing is by the textual form.
  assert_eq(
    Map::from_array([(@uri.UriRef::parse("a"), 1)]).get(a.to_uri_ref()),
    None,
  )
  assert_eq(
    Map::from_array([(@uri.Iri::parse("a:x"), 1)]).get(@uri.Iri::parse("a:x")),
    Some(1),
  )
  assert_eq(
    Map::from_array([(@uri.IriRef::parse("x"), 1)]).get(@uri.IriRef::parse("x")),
    Some(1),
  )
  // Builders with every optional component.
  inspect(
    @uri.UriRef::build(
      path=@uri.EStr::new_or_panic("p"),
      query=@uri.EStr::new_or_panic("q"),
      fragment=@uri.EStr::new_or_panic("f"),
    ),
    content="p?q#f",
  )
  inspect(
    @uri.Iri::build(
      scheme=@uri.Scheme::new_or_panic("a"),
      path=@uri.EStr::new_or_panic("/p"),
      query=@uri.EStr::new_or_panic("q"),
      fragment=@uri.EStr::new_or_panic("f"),
    ),
    content="a:/p?q#f",
  )
  inspect(
    @uri.IriRef::build(
      path=@uri.EStr::new_or_panic("/p"),
      query=@uri.EStr::new_or_panic("q"),
      fragment=@uri.EStr::new_or_panic("f"),
    ),
    content="/p?q#f",
  )
}

///|
test "data encoders" {
  // The data encoders preserve only unreserved characters.
  let s : @uri.EStr[@enc.Data]? = @uri.EStr::new("a-b")
  assert_true(s is Some(_))
  let s : @uri.EStr[@enc.Data]? = @uri.EStr::new("a/b")
  assert_true(s is None)
  let s : @uri.EStr[@enc.IData]? = @uri.EStr::new("aé")
  assert_true(s is Some(_))
  let s : @uri.EStr[@enc.IData]? = @uri.EStr::new("a?b")
  assert_true(s is None)
  // Private-use characters are not part of the IRI data table.
  let s : @uri.EStr[@enc.IData]? = @uri.EStr::new("\u{e000}")
  assert_true(s is None)
  // Nor are they allowed in an IRI path.
  let s : @uri.EStr[@enc.IPath]? = @uri.EStr::new("\u{e000}")
  assert_true(s is None)
}

///|
test "fragment methods on every type" {
  let uri_ref = @uri.UriRef::parse("//h/p?q#f")
  inspect(uri_ref.strip_fragment(), content="//h/p?q")
  inspect(
    uri_ref.with_fragment(Some(@uri.EStr::new_or_panic("g"))),
    content="//h/p?q#g",
  )
  let iri = @uri.Iri::parse("a://h/p?q#f")
  inspect(iri.strip_fragment(), content="a://h/p?q")
  inspect(
    iri.with_fragment(Some(@uri.EStr::new_or_panic("é"))),
    content="a://h/p?q#é",
  )
  let iri_ref = @uri.IriRef::parse("//h/p?q#f")
  inspect(iri_ref.strip_fragment(), content="//h/p?q")
  inspect(iri_ref.with_fragment(None), content="//h/p?q")
  inspect(
    iri_ref.with_fragment(Some(@uri.EStr::new_or_panic("例"))),
    content="//h/p?q#例",
  )
  // The stripped value still parses to the same components.
  let stripped = iri.strip_fragment()
  assert_eq(@uri.Iri::parse(stripped.text), stripped)
}
