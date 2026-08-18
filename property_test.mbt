///|
/// Property-based tests, mirroring the fuzz targets of `fluent-uri`.
///
/// Every test drives a seeded generator, so a failure is reproducible and the
/// offending input is reported.

///|
/// Rebuilds a URI reference from its components, as `fuzz_targets/parse.rs`
/// does. The result must be the original string.
fn reassemble(r : @uri.IriRef) -> String raise {
  let sb = StringBuilder::new()
  if r.scheme is Some(s) {
    sb.write_string(s.as_str())
    sb.write_char(':')
  }
  if r.authority is Some(a) {
    sb.write_string("//")
    let start = sb.to_string().length()
    if a.userinfo is Some(ui) {
      sb.write_string(ui.as_str())
      sb.write_char('@')
    }
    sb.write_string(a.host)
    if a.port is Some(p) {
      sb.write_char(':')
      sb.write_string(p.as_str())
    }
    // The authority component is exactly what we just wrote.
    assert_eq(slice_from(sb.to_string(), start), a.as_str())
  }
  sb.write_string(r.path.as_str())
  if r.query is Some(q) {
    sb.write_char('?')
    sb.write_string(q.as_str())
  }
  if r.fragment is Some(f) {
    sb.write_char('#')
    sb.write_string(f.as_str())
  }
  sb.to_string()
}

///|
fn slice_from(s : String, start : Int) -> String {
  s.view(start_offset=start).to_owned()
}

///|
/// A textual description of the components of a URI reference, used to check
/// that two references decompose in the same way.
fn components(r : @uri.IriRef) -> String {
  let sb = StringBuilder::new()
  sb.write_string("scheme=\{opt_str(r.scheme.map(s => s.as_str()))};")
  match r.authority {
    None => sb.write_string("auth=none;")
    Some(a) => {
      sb.write_string("auth=\{a.as_str()};")
      sb.write_string("userinfo=\{opt_str(a.userinfo.map(v => v.as_str()))};")
      sb.write_string("host=\{a.host};")
      sb.write_string("host_parsed=\{a.host_parsed};")
      sb.write_string("port=\{opt_str(a.port.map(v => v.as_str()))};")
    }
  }
  sb.write_string("path=\{r.path};")
  sb.write_string("query=\{opt_str(r.query.map(v => v.as_str()))};")
  sb.write_string("fragment=\{opt_str(r.fragment.map(v => v.as_str()))}")
  sb.to_string()
}

///|
fn opt_str(x : String?) -> String {
  match x {
    Some(v) => "some(\{v})"
    None => "none"
  }
}

///|
/// Parses `s` as an IRI reference, returning `None` if it is not one.
fn try_parse(s : String) -> @uri.IriRef? {
  Some(@uri.IriRef::parse(s)) catch {
    _ => None
  }
}

///|
test "property: parsing decomposes losslessly" {
  let rand = rng(1)
  let mut parsed = 0
  for i in 0..<3000 {
    let s = gen_input(rand)
    guard try_parse(s) is Some(r) else { continue }
    parsed += 1
    assert_eq(r.text, s, msg="input \{i}: \{s}")
    assert_eq(reassemble(r), s, msg="input \{i}: \{s}")
  }
  // The generator must keep producing parsable inputs.
  assert_true(parsed > 1500, msg="only \{parsed} of 3000 inputs parsed")
}

///|
test "property: a URI is a URI reference with a scheme" {
  let rand = rng(2)
  for _ in 0..<2000 {
    let s = gen_input(rand)
    let as_ref = Some(@uri.UriRef::parse(s)) catch { _ => None }
    let as_uri = Some(@uri.Uri::parse(s)) catch { _ => None }
    match (as_ref, as_uri) {
      (Some(r), Some(u)) => {
        assert_true(r.scheme is Some(_), msg=s)
        assert_eq(u.text, r.text, msg=s)
        assert_eq(u.path.as_str(), r.path.as_str(), msg=s)
      }
      (Some(r), None) => assert_true(r.scheme is None, msg=s)
      (None, Some(_)) => fail("\{s} parses as a URI but not as a URI reference")
      (None, None) => ()
    }
  }
}

///|
test "property: an ASCII IRI reference is a URI reference" {
  let rand = rng(3)
  for _ in 0..<2000 {
    let s = gen_input(rand)
    let as_iri_ref = try_parse(s)
    let as_uri_ref = Some(@uri.UriRef::parse(s)) catch { _ => None }
    match (as_iri_ref, as_uri_ref) {
      (Some(_), Some(u)) =>
        assert_true(u.text.iter().all(c => c.to_int() < 128), msg=s)
      (Some(i), None) =>
        assert_false(i.text.iter().all(c => c.to_int() < 128), msg=s)
      (None, Some(_)) =>
        fail("\{s} parses as a URI reference but not as an IRI reference")
      (None, None) => ()
    }
  }
}

///|
test "property: normalization is stable and idempotent" {
  let rand = rng(4)
  for _ in 0..<2000 {
    let s = gen_input(rand)
    guard try_parse(s) is Some(r) else { continue }
    let n1 = r.normalize()
    guard try_parse(n1.text) is Some(n2) else {
      fail("normalizing \{s} gave \{n1} which does not parse")
    }
    assert_eq(components(n1), components(n2), msg=s)
    // Normalization is idempotent.
    assert_eq(n1.normalize().text, n1.text, msg=s)
  }
}

///|
test "property: resolution is stable and commutes with normalization" {
  let rand = rng(5)
  let mut resolved = 0
  for _ in 0..<2000 {
    let base_str = gen_base_string(rand)
    let ref_str = gen_input(rand)
    let base = @uri.Iri::parse(base_str) catch { _ => continue }
    guard try_parse(ref_str) is Some(r) else { continue }
    let target = r.resolve_against(base) catch { _ => continue }
    resolved += 1
    let msg = "base \{base_str}, reference \{ref_str}"
    guard try_parse(target.text) is Some(reparsed) else {
      fail("resolving \{msg} gave \{target} which does not parse")
    }
    assert_eq(components(target.to_iri_ref()), components(reparsed), msg~)
    // Swapping the order of resolution and normalization does not change
    // the result.
    let resolve_then_normalize = target.normalize()
    let normalize_then_resolve = r.normalize().resolve_against(base.normalize())
    assert_eq(resolve_then_normalize.text, normalize_then_resolve.text, msg~)
  }
  assert_true(resolved > 500, msg="only \{resolved} references resolved")
}

///|
test "property: encoding non-ASCII characters preserves the components" {
  let rand = rng(6)
  for _ in 0..<2000 {
    let s = gen_input(rand)
    guard try_parse(s) is Some(r) else { continue }
    let encoded = r.to_uri_ref()
    let reparsed = @uri.UriRef::parse(encoded.text)
    assert_eq(
      components(encoded.to_iri_ref()),
      components(reparsed.to_iri_ref()),
      msg=s,
    )
    // Encoding commutes with normalization.
    assert_eq(r.normalize().text, encoded.to_iri_ref().normalize().text, msg=s)
  }
}

///|
test "property: percent-encoding round-trips" {
  let rand = rng(7)
  for _ in 0..<2000 {
    let s = gen_junk(rand, 8)
    let buf : @uri.EString[@enc.IQuery] = @uri.EString::new()
    buf.encode(s, table=@enc.table_idata)
    let e = buf.to_estr()
    assert_eq(e.decode_to_string(), s, msg=s)
    // Encoding with the URI data table gives an ASCII string.
    let buf : @uri.EString[@enc.Query] = @uri.EString::new()
    buf.encode(s, table=@enc.table_data)
    let e = buf.to_estr()
    assert_true(e.as_str().iter().all(c => c.to_int() < 128), msg=s)
    assert_eq(e.decode_to_string(), s, msg=s)
  }
}

///|
test "property: decoding agrees with itself" {
  let rand = rng(8)
  for _ in 0..<2000 {
    let s = gen_input(rand)
    guard try_parse(s) is Some(r) else { continue }
    check_decode(r.path, s)
    if r.authority is Some(a) {
      if a.userinfo is Some(ui) {
        check_decode(ui, s)
      }
      if a.host_parsed is RegName(name) {
        check_decode(name, s)
      }
    }
    if r.query is Some(q) {
      check_decode(q, s)
    }
    if r.fragment is Some(f) {
      check_decode(f, s)
    }
  }
}

///|
/// Checks that the three ways of percent-decoding a component agree.
fn[E : @enc.Encoder] check_decode(
  component : @uri.EStr[E],
  msg : String,
) -> Unit raise {
  let bytes = component.decode_to_bytes()
  let lossy = component.decode_to_string_lossy()
  let strict = Some(component.decode_to_string()) catch { _ => None }
  match strict {
    // A successful strict decoding agrees with the lossy one, and the octets
    // are exactly its UTF-8 encoding.
    Some(v) => {
      assert_eq(v, lossy, msg~)
      assert_eq(utf8_bytes(v), bytes, msg~)
    }
    // Otherwise the lossy decoding must have inserted a replacement character.
    None => assert_true(lossy.contains("\u{FFFD}"), msg~)
  }
}

///|
/// The UTF-8 encoding of `s`.
fn utf8_bytes(s : String) -> Bytes {
  let buf : @uri.EString[@enc.Query] = @uri.EString::new()
  buf.encode(s, table=@enc.table_data)
  buf.to_estr().decode_to_bytes()
}

///|
test "property: IPv6 addresses round-trip through their canonical form" {
  let rand = rng(9)
  for _ in 0..<2000 {
    let segs = []
    for _ in 0..<8 {
      // Favour zeros so that the elision rules are exercised.
      segs.push(
        if rand.int(limit=2) == 0 {
          0
        } else {
          rand.int(limit=0x10000)
        },
      )
    }
    let addr = @uri.Ipv6Addr::new(
      segs[0],
      segs[1],
      segs[2],
      segs[3],
      segs[4],
      segs[5],
      segs[6],
      segs[7],
    )
    let text = "//[\{addr}]"
    let r = @uri.UriRef::parse(text)
    assert_true(
      r.authority.unwrap().host_parsed is Ipv6(a) && a == addr,
      msg=text,
    )
    // The canonical form is a fixed point.
    assert_eq(r.normalize().text, text, msg=text)
  }
}

///|
test "property: building from the parsed components rebuilds the reference" {
  let rand = rng(10)
  let mut built = 0
  for _ in 0..<2000 {
    let s = gen_input(rand)
    guard try_parse(s) is Some(r) else { continue }
    let rebuilt = @uri.IriRef::build(
      path=r.path,
      scheme?=r.scheme,
      authority?=r.authority,
      query?=r.query,
      fragment?=r.fragment,
    ) catch {
      // The components of a parsed reference always go back together.
      e => fail("rebuilding \{s} failed with \{e}")
    }
    built += 1
    assert_eq(rebuilt.text, s, msg=s)
    assert_eq(components(rebuilt), components(r), msg=s)
  }
  assert_true(built > 1000, msg="only \{built} references were rebuilt")
}
