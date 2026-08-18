///|
/// Tests for building URIs/IRIs (references) from components, ported from the
/// `build` module documentation of `fluent-uri`.

///|
test "build uri" {
  let uri = @uri.Uri::build(
    scheme=@uri.Scheme::new_or_panic("foo"),
    authority=@uri.Authority::make(
      host=@uri.Host::RegName(@uri.EStr::new_or_panic("example.com")),
      userinfo=@uri.EStr::new_or_panic("user"),
      port=@uri.EStr::new_or_panic("8042"),
    ),
    path=@uri.EStr::new_or_panic("/over/there"),
    query=@uri.EStr::new_or_panic("name=ferret"),
    fragment=@uri.EStr::new_or_panic("nose"),
  )
  inspect(
    uri,
    content="foo://user@example.com:8042/over/there?name=ferret#nose",
  )
  // Building and parsing agree.
  assert_eq(@uri.Uri::parse(uri.text), uri)
}

///|
test "build with empty authority" {
  let uri = @uri.Uri::build(
    scheme=@uri.Scheme::new_or_panic("file"),
    authority=@uri.Authority::empty(),
    path=@uri.EStr::new_or_panic("/path/to/file"),
  )
  inspect(uri, content="file:///path/to/file")
  // An authority taken from another URI can be reused.
  let auth = @uri.Uri::parse("foo://user@example.com:8042").authority.unwrap()
  let uri = @uri.Uri::build(
    scheme=@uri.Scheme::new_or_panic("http"),
    authority=auth,
    path=@uri.EStr::empty(),
  )
  inspect(uri, content="http://user@example.com:8042")
}

///|
test "build uri ref" {
  let uri_ref = @uri.UriRef::build(
    path=@uri.EStr::new_or_panic("foo"),
    query=@uri.EStr::new_or_panic("bar"),
  )
  inspect(uri_ref, content="foo?bar")
  let uri_ref = @uri.UriRef::build(path=@uri.EStr::new_or_panic("/foo"))
  inspect(uri_ref, content="/foo")
  let uri_ref = @uri.UriRef::build(
    path=@uri.EStr::new_or_panic("/foo"),
    scheme=@uri.Scheme::new_or_panic("http"),
    authority=@uri.Authority::make(
      host=@uri.Host::RegName(@uri.EStr::new_or_panic("example.com")),
    ),
  )
  inspect(uri_ref, content="http://example.com/foo")
}

///|
test "build ip hosts" {
  let uri_ref = @uri.UriRef::build(
    path=@uri.EStr::empty(),
    authority=@uri.Authority::make(
      host=@uri.Host::Ipv4(@uri.Ipv4Addr::new(127, 0, 0, 1)),
    ),
  )
  inspect(uri_ref, content="//127.0.0.1")
  assert_true(uri_ref.authority.unwrap().host_parsed is Ipv4(_))
  let uri_ref = @uri.UriRef::build(
    path=@uri.EStr::empty(),
    authority=@uri.Authority::make(host=@uri.Host::Ipv6(@uri.ipv6_localhost)),
  )
  inspect(uri_ref, content="//[::1]")
  assert_true(uri_ref.authority.unwrap().host_parsed is Ipv6(_))
  // A registered name that looks like an IPv4 address is parsed as one.
  let uri_ref = @uri.UriRef::build(
    path=@uri.EStr::empty(),
    authority=@uri.Authority::make(
      host=@uri.Host::RegName(@uri.EStr::new_or_panic("127.0.0.1")),
    ),
  )
  assert_true(uri_ref.authority.unwrap().host_parsed is Ipv4(_))
  // But one that does not is kept as a registered name.
  let uri_ref = @uri.UriRef::build(
    path=@uri.EStr::empty(),
    authority=@uri.Authority::make(
      host=@uri.Host::RegName(@uri.EStr::new_or_panic("127.0.0.001")),
    ),
  )
  assert_true(uri_ref.authority.unwrap().host_parsed is RegName(_))
}

///|
test "build errors" {
  // When an authority is present, the path must be empty or start with '/'.
  try
    @uri.UriRef::build(
      path=@uri.EStr::new_or_panic("foo"),
      authority=@uri.Authority::empty(),
    )
  catch {
    e => assert_eq(e, @uri.NonemptyRootlessPath)
  } noraise {
    _ => fail("expected the build to fail")
  }
  // When no authority is present, the path cannot start with "//".
  try @uri.UriRef::build(path=@uri.EStr::new_or_panic("//foo")) catch {
    e => assert_eq(e, @uri.PathStartsWithDoubleSlash)
  } noraise {
    _ => fail("expected the build to fail")
  }
  // When neither a scheme nor an authority is present, the first path
  // segment cannot contain ':'.
  try @uri.UriRef::build(path=@uri.EStr::new_or_panic("foo:bar")) catch {
    e => assert_eq(e, @uri.FirstPathSegmentContainsColon)
  } noraise {
    _ => fail("expected the build to fail")
  }
  // A colon in a later segment is fine.
  inspect(
    @uri.UriRef::build(path=@uri.EStr::new_or_panic("foo/bar:baz")),
    content="foo/bar:baz",
  )
  // So is one in the first segment of a URI.
  inspect(
    @uri.UriRef::build(
      path=@uri.EStr::new_or_panic("foo:bar"),
      scheme=@uri.Scheme::new_or_panic("http"),
    ),
    content="http:foo:bar",
  )
}

///|
test "build iri" {
  let iri = @uri.Iri::build(
    scheme=@uri.Scheme::new_or_panic("http"),
    path=@uri.EStr::new_or_panic("/rosé"),
    authority=@uri.Authority::make(
      host=@uri.Host::RegName(@uri.EStr::new_or_panic("例え.jp")),
    ),
  )
  inspect(iri, content="http://例え.jp/rosé")
  assert_eq(@uri.Iri::parse(iri.text), iri)
}

///|
test "scheme" {
  assert_true(@uri.Scheme::new("http") is Some(_))
  assert_true(@uri.Scheme::new("a+b-c.d") is Some(_))
  // A scheme must start with a letter.
  assert_true(@uri.Scheme::new("3ttp") is None)
  assert_true(@uri.Scheme::new("") is None)
  assert_true(@uri.Scheme::new("a b") is None)
  // Schemes are compared case-insensitively.
  assert_eq(
    @uri.Scheme::new_or_panic("HTTP"),
    @uri.Scheme::new_or_panic("http"),
  )
  assert_not_eq(
    @uri.Scheme::new_or_panic("http"),
    @uri.Scheme::new_or_panic("https"),
  )
  assert_eq(@uri.Scheme::new_or_panic("HTTP").as_str(), "HTTP")
}

///|
test "fragment manipulation" {
  let uri = @uri.Uri::parse("http://example.com/foo?bar#baz")
  inspect(uri.strip_fragment(), content="http://example.com/foo?bar")
  assert_true(uri.strip_fragment().fragment is None)
  inspect(
    uri.with_fragment(Some(@uri.EStr::new_or_panic("qux"))),
    content="http://example.com/foo?bar#qux",
  )
  inspect(uri.with_fragment(None), content="http://example.com/foo?bar")
  let uri = @uri.Uri::parse("http://example.com/")
  inspect(
    uri.with_fragment(Some(@uri.EStr::empty())),
    content="http://example.com/#",
  )
  // The other components are preserved.
  let uri = uri.with_fragment(Some(@uri.EStr::new_or_panic("x")))
  assert_eq(uri.path.as_str(), "/")
  assert_eq(uri.authority.unwrap().host, "example.com")
  assert_eq(@uri.Uri::parse(uri.text), uri)
}

///|
test "authority accessors" {
  let auth = @uri.Uri::parse("foo://user@example.com:8042/").authority.unwrap()
  assert_true(auth.has_userinfo())
  assert_true(auth.has_port())
  assert_eq(auth.port_to_u16(), Some(8042))
  let auth = @uri.Uri::parse("foo://example.com/").authority.unwrap()
  assert_false(auth.has_userinfo())
  assert_false(auth.has_port())
  assert_eq(auth.port_to_u16(), None)
  let auth = @uri.Uri::parse("foo://example.com:/").authority.unwrap()
  assert_true(auth.has_port())
  assert_eq(auth.port_to_u16(), None)
  let auth = @uri.Uri::parse("foo://example.com:0080/").authority.unwrap()
  assert_eq(auth.port_to_u16(), Some(80))
  let auth = @uri.Uri::parse("foo://example.com:123456/").authority.unwrap()
  try auth.port_to_u16() catch {
    e => assert_eq(e, @uri.InvalidPort(port="123456"))
  } noraise {
    _ => fail("expected the conversion to fail")
  }
}
