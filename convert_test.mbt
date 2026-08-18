///|
/// Tests ported from `tests/convert.rs` of `fluent-uri`.

///|
test "iri to uri" {
  let iri = @uri.Iri::parse("http://résumé.example.org")
  inspect(iri.to_uri(), content="http://r%C3%A9sum%C3%A9.example.org")
  let iri = @uri.Iri::parse("http://www.example.org/red%09rosé#red")
  inspect(iri.to_uri(), content="http://www.example.org/red%09ros%C3%A9#red")
  let iri = @uri.Iri::parse(
    "foo://user@example.com:8042/over/there?name=ferret#nose",
  )
  assert_eq(iri.to_uri().text, iri.text)
  let iri = @uri.Iri::parse("http://example.com/\u{10300}\u{10301}\u{10302}")
  inspect(
    iri.to_uri(),
    content="http://example.com/%F0%90%8C%80%F0%90%8C%81%F0%90%8C%82",
  )
}

///|
test "uri to iri" {
  let uri = @uri.Uri::parse("http://www.example.org/r%E9sum%E9.html")
  inspect(
    uri.to_iri().normalize(),
    content="http://www.example.org/r%E9sum%E9.html",
  )
  let uri = @uri.Uri::parse("http://www.example.org/D%C3%BCrst")
  inspect(uri.to_iri().normalize(), content="http://www.example.org/Dürst")
  let uri = @uri.Uri::parse("http://www.example.org/D%FCrst")
  inspect(uri.to_iri().normalize(), content="http://www.example.org/D%FCrst")
  let uri = @uri.Uri::parse("http://xn--99zt52a.example.org/%e2%80%ae")
  inspect(
    uri.to_iri().normalize(),
    content="http://xn--99zt52a.example.org/\u{202e}",
  )
}

///|
test "convert error" {
  let uri_ref = @uri.UriRef::parse("rel/ref")
  try uri_ref.as_uri() catch {
    e => assert_eq(e, @uri.NoScheme)
  } noraise {
    _ => fail("expected the conversion to fail")
  }
  let uri_ref = @uri.UriRef::parse("")
  try uri_ref.as_uri() catch {
    e => assert_eq(e, @uri.NoScheme)
  } noraise {
    _ => fail("expected the conversion to fail")
  }
  let iri = @uri.Iri::parse("http://你好.example.com/")
  try iri.as_uri() catch {
    e => assert_eq(e, @uri.NotAscii(index=7))
  } noraise {
    _ => fail("expected the conversion to fail")
  }
  let iri_ref = @uri.IriRef::parse("réf/rel")
  try iri_ref.as_uri() catch {
    e => assert_eq(e, @uri.NoScheme)
  } noraise {
    _ => fail("expected the conversion to fail")
  }
  try iri_ref.as_uri_ref() catch {
    e => assert_eq(e, @uri.NotAscii(index=1))
  } noraise {
    _ => fail("expected the conversion to fail")
  }
  try iri_ref.as_iri() catch {
    e => assert_eq(e, @uri.NoScheme)
  } noraise {
    _ => fail("expected the conversion to fail")
  }
}

///|
test "widening conversions" {
  let uri = @uri.Uri::parse("http://example.com/a?b#c")
  assert_eq(uri.to_uri_ref().text, uri.text)
  assert_eq(uri.to_iri().text, uri.text)
  assert_eq(uri.to_iri_ref().text, uri.text)
  let uri_ref = @uri.UriRef::parse("//example.com/a")
  assert_eq(uri_ref.to_iri_ref().text, uri_ref.text)
  let iri = @uri.Iri::parse("http://例え.jp/")
  assert_eq(iri.to_iri_ref().text, iri.text)
  // The components survive the conversion.
  let iri_ref = uri.to_iri_ref()
  assert_eq(iri_ref.scheme.unwrap().as_str(), "http")
  assert_eq(iri_ref.authority.unwrap().host, "example.com")
  assert_eq(iri_ref.path.as_str(), "/a")
  assert_eq(iri_ref.query.unwrap().as_str(), "b")
  assert_eq(iri_ref.fragment.unwrap().as_str(), "c")
}
