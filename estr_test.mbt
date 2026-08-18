///|
/// Tests for percent-encoded strings, ported from the `pct_enc` module
/// documentation and fuzz targets of `fluent-uri`.

///|
test "estr new" {
  let s : @uri.EStr[@enc.Path]? = @uri.EStr::new("a/b%20c")
  assert_eq(s.unwrap().as_str(), "a/b%20c")
  // A path may not contain a '?'.
  let s : @uri.EStr[@enc.Path]? = @uri.EStr::new("a?b")
  assert_eq(s, None)
  // A query may.
  let s : @uri.EStr[@enc.Query]? = @uri.EStr::new("a?b")
  assert_eq(s.unwrap().as_str(), "a?b")
  // Incomplete percent-encoded octets.
  let s : @uri.EStr[@enc.Path]? = @uri.EStr::new("a%2")
  assert_eq(s, None)
  let s : @uri.EStr[@enc.Path]? = @uri.EStr::new("a%zz")
  assert_eq(s, None)
  // A port is made of digits only.
  let s : @uri.EStr[@enc.Port]? = @uri.EStr::new("8042")
  assert_eq(s.unwrap().as_str(), "8042")
  let s : @uri.EStr[@enc.Port]? = @uri.EStr::new("80a")
  assert_eq(s, None)
  // Non-ASCII characters are only allowed by IRI encoders.
  let s : @uri.EStr[@enc.Path]? = @uri.EStr::new("rosé")
  assert_eq(s, None)
  let s : @uri.EStr[@enc.IPath]? = @uri.EStr::new("rosé")
  assert_eq(s.unwrap().as_str(), "rosé")
  // Empty strings are always valid.
  let s : @uri.EStr[@enc.Fragment] = @uri.EStr::empty()
  assert_true(s.is_empty())
  assert_eq(s.length(), 0)
}

///|
test "panic estr new_or_panic" {
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("a%2")
  ignore(s)
}

///|
test "estr decode" {
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("%C2%A1Hola%21")
  inspect(s.decode_to_string(), content="¡Hola!")
  inspect(s.decode_to_string_lossy(), content="¡Hola!")
  assert_eq(s.decode_to_bytes(), b"\xc2\xa1Hola!")
  // Decoding does not touch '+'.
  let s : @uri.EStr[@enc.Query] = @uri.EStr::new_or_panic("a+b")
  inspect(s.decode_to_string(), content="a+b")
  // Octets that are not valid UTF-8.
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("a%FFb")
  assert_eq(s.decode_to_bytes(), b"a\xffb")
  inspect(s.decode_to_string_lossy(), content="a\u{FFFD}b")
  try s.decode_to_string() catch {
    e => assert_eq(e, @uri.NotUtf8(bytes=b"a\xffb"))
  } noraise {
    _ => fail("expected the decoding to fail")
  }
  // One replacement character per maximal invalid subsequence.
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("%E2%82")
  inspect(s.decode_to_string_lossy(), content="\u{FFFD}")
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("%E2%82a")
  inspect(s.decode_to_string_lossy(), content="\u{FFFD}a")
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("%FF%FF")
  inspect(s.decode_to_string_lossy(), content="\u{FFFD}\u{FFFD}")
  // Decoded octets are not merged across unencoded characters.
  let s : @uri.EStr[@enc.IPath] = @uri.EStr::new_or_panic("%E2é")
  inspect(s.decode_to_string_lossy(), content="\u{FFFD}é")
}

///|
test "estr force encode byte" {
  let s : @uri.EStr[@enc.Path] = @uri.EStr::force_encode_byte(b'/')
  inspect(s, content="%2F")
  let s : @uri.EStr[@enc.Path] = @uri.EStr::force_encode_byte(b'\xff')
  inspect(s, content="%FF")
  inspect(
    s.decode_to_bytes(),
    content=(
      #|b"\xff"
    ),
  )
}

///|
test "estr split" {
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("a,b,c")
  assert_eq(s.split(',').map(v => v.as_str()).to_array(), ["a", "b", "c"])
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic(",")
  assert_eq(s.split(',').map(v => v.as_str()).to_array(), ["", ""])
  let s : @uri.EStr[@enc.Path] = @uri.EStr::empty()
  assert_eq(s.split(',').map(v => v.as_str()).to_array(), [""])
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("foo;bar;baz")
  let (a, b) = s.split_once(';').unwrap()
  assert_eq(a.as_str(), "foo")
  assert_eq(b.as_str(), "bar;baz")
  let (a, b) = s.rsplit_once(';').unwrap()
  assert_eq(a.as_str(), "foo;bar")
  assert_eq(b.as_str(), "baz")
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("foo")
  assert_true(s.split_once(';') is None)
  assert_true(s.rsplit_once(';') is None)
}

///|
test "panic estr split with unreserved delimiter" {
  let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("a.b")
  ignore(s.split('.').to_array())
}

///|
test "estr path extensions" {
  let path = @uri.Uri::parse("file:///path/to//dir/").path
  assert_true(path.is_absolute())
  assert_false(path.is_rootless())
  assert_eq(
    path.segments_if_absolute().unwrap().map(v => v.as_str()).to_array(),
    ["path", "to", "", "dir", ""],
  )
  let path = @uri.Uri::parse("foo:bar/baz").path
  assert_false(path.is_absolute())
  assert_true(path.is_rootless())
  assert_true(path.segments_if_absolute() is None)
  let path = @uri.Uri::parse("http://example.com").path
  assert_true(path.is_empty())
  assert_true(path.segments_if_absolute() is None)
}

///|
test "estring" {
  let buf : @uri.EString[@enc.Query] = @uri.EString::new()
  assert_true(buf.is_empty())
  for pair in [("name", "张三"), ("speech", "¡Olé!")] {
    let (k, v) = pair
    if !buf.is_empty() {
      buf.push('&')
    }
    buf.encode(k, table=@enc.table_data)
    buf.push('=')
    buf.encode(v, table=@enc.table_data)
  }
  inspect(buf, content="name=%E5%BC%A0%E4%B8%89&speech=%C2%A1Ol%C3%A9%21")
  let uri_ref = @uri.UriRef::build(path=@uri.EStr::empty(), query=buf.to_estr())
  inspect(uri_ref, content="?name=%E5%BC%A0%E4%B8%89&speech=%C2%A1Ol%C3%A9%21")
  buf.clear()
  assert_true(buf.is_empty())
  buf.push_estr(@uri.EStr::new_or_panic("a=b"))
  inspect(buf, content="a=b")
}

///|
test "estring encode round trip" {
  // Encoding with the data table and decoding gives back the input.
  for s in ["", "hello", "a/b?c#d", "¡Olé!", "\u{10300}", "%25", "a+b c"] {
    let buf : @uri.EString[@enc.Query] = @uri.EString::new()
    buf.encode(s, table=@enc.table_data)
    assert_eq(buf.to_estr().decode_to_string(), s)
  }
}

///|
test "panic estring push disallowed char" {
  let buf : @uri.EString[@enc.Query] = @uri.EString::new()
  buf.push('#')
}

///|
test "table" {
  let t = @enc.Table::new("abc")
  assert_true(t.allows('a'))
  assert_false(t.allows('d'))
  assert_false(t.allows_pct_encoded())
  assert_true(t.or_pct_encoded().allows_pct_encoded())
  assert_true(t.is_subset(@enc.Table::new("abcd")))
  assert_false(@enc.Table::new("abcd").is_subset(t))
  assert_false(t.sub(@enc.Table::new("a")).allows('a'))
  assert_true(@enc.table_unreserved.is_subset(@enc.table_path))
  assert_true(@enc.table_data.is_subset(@enc.table_query))
  assert_false(@enc.table_query.is_subset(@enc.table_data))
  // Non-ASCII characters are only allowed by the IRI tables.
  assert_false(@enc.table_path.allows('é'))
  assert_true(@enc.table_ipath.allows('é'))
  // Private-use characters are only allowed in an IRI query.
  assert_false(@enc.table_ipath.allows('\u{e000}'))
  assert_true(@enc.table_iquery.allows('\u{e000}'))
}

///|
test "panic table with non-ascii character" {
  ignore(@enc.Table::new("é"))
}

///|
test "estr decode ill-formed utf-8" {
  // The replacement follows the "maximal subpart" rule, so the number of
  // replacement characters matches `String::from_utf8_lossy` in Rust.
  let cases = [
    // (percent-encoded octets, lossy decoding)
    ("%E0%80%80", "\u{FFFD}\u{FFFD}\u{FFFD}"),
    ("%F4%90%80%80", "\u{FFFD}\u{FFFD}\u{FFFD}\u{FFFD}"),
    ("%F0%9F%98", "\u{FFFD}"),
    ("%C0%80", "\u{FFFD}\u{FFFD}"),
    ("%C1%81", "\u{FFFD}\u{FFFD}"),
    ("%E0%A0", "\u{FFFD}"),
    ("%ED%A0%80", "\u{FFFD}\u{FFFD}\u{FFFD}"),
    ("%F0%82%82%AC", "\u{FFFD}\u{FFFD}\u{FFFD}\u{FFFD}"),
    ("a%F1%80%80%E1%80%C2b", "a\u{FFFD}\u{FFFD}\u{FFFD}b"),
    // Well-formed sequences of every length.
    ("%24", "$"),
    ("%C2%A2", "¢"),
    ("%E0%A4%B9", "ह"),
    ("%F0%90%8D%88", "\u{10348}"),
  ]
  for case in cases {
    let (encoded, expected) = case
    let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic(encoded)
    assert_eq(s.decode_to_string_lossy(), expected, msg=encoded)
  }
}
