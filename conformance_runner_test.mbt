///|
/// Runs the conformance cases generated from the reference implementation.
///
/// The dump functions below must render exactly what `tools/oracle` renders in
/// Rust, so that a mismatch means the two implementations disagree.

///|
/// Renders an optional string: `-` for absent, `+` followed by the contents
/// for present, so that an absent and an empty component differ.
fn dump_opt(s : String?) -> String {
  match s {
    None => "-"
    Some(v) => "+" + v
  }
}

///|
fn[R] dump_host(host : @uri.Host[R]) -> String {
  match host {
    Ipv4(addr) => "4:\{addr}"
    Ipv6(addr) => "6:\{addr}"
    IpvFuture => "v"
    RegName(name) => "n:\{name}"
  }
}

///|
/// Renders the components of a parsed reference.
fn dump_iri_ref(r : @uri.IriRef) -> String {
  let sb = StringBuilder::new()
  sb.write_string("s=\{dump_opt(r.scheme.map(s => s.as_str()))}")
  match r.authority {
    None => sb.write_string("|a=-")
    Some(a) =>
      sb.write_string(
        "|a=+\{a.as_str()}|u=\{dump_opt(a.userinfo.map(v => v.as_str()))}|h=\{a.host}|hp=\{dump_host(a.host_parsed)}|o=\{dump_opt(a.port.map(v => v.as_str()))}",
      )
  }
  sb.write_string(
    "|p=\{r.path}|q=\{dump_opt(r.query.map(v => v.as_str()))}|f=\{dump_opt(r.fragment.map(v => v.as_str()))}",
  )
  sb.to_string()
}

///|
/// Renders the components of a parsed URI reference.
fn dump_uri_ref(r : @uri.UriRef) -> String {
  dump_iri_ref(r.to_iri_ref())
}

///|
fn dump_parse_error(e : @uri.ParseError) -> String {
  match e {
    UnexpectedCharOrEnd(index~) => "E:unexpected:\{index}"
    InvalidIpv6Addr(index~) => "E:ipv6:\{index}"
  }
}

///|
/// Runs every operation on `input` and joins the results, exactly as the
/// oracle does.
fn run_case(input : String) -> String {
  let parts = []
  parts.push(
    try @uri.UriRef::parse(input) |> dump_uri_ref catch {
      e => dump_parse_error(e)
    },
  )
  parts.push(
    try "uri:" + @uri.Uri::parse(input).text catch {
      e => dump_parse_error(e)
    },
  )
  parts.push(
    try @uri.IriRef::parse(input) |> dump_iri_ref catch {
      e => dump_parse_error(e)
    },
  )
  parts.push(
    try "iri:" + @uri.Iri::parse(input).text catch {
      e => dump_parse_error(e)
    },
  )
  parts.push(
    try "n:" + @uri.UriRef::parse(input).normalize().text catch {
      _ => "-"
    },
  )
  parts.push(
    try "ni:" + @uri.IriRef::parse(input).normalize().text catch {
      _ => "-"
    },
  )
  parts.push(
    try "u:" + @uri.IriRef::parse(input).to_uri_ref().text catch {
      _ => "-"
    },
  )
  parts.push(
    try {
      let r = @uri.IriRef::parse(input)
      let with_fragment = r.with_fragment(
        Some(@uri.EStr::new_or_panic("X%20y")),
      )
      "sf:\{r.strip_fragment().text}|wf:\{with_fragment.text}|nf:\{r.with_fragment(None).text}"
    } catch {
      _ => "-"
    },
  )
  parts.join(" ;; ")
}

///|
/// Resolves `reference` against `base`, both with and without underflow
/// allowed, exactly as the oracle does.
fn run_resolve_case(base : String, reference : String) -> String {
  let base = @uri.Iri::parse(base) catch { _ => return "-" }
  let r = @uri.IriRef::parse(reference) catch { _ => return "-" }
  let parts = []
  for allow in [true, false] {
    parts.push(
      try
        "t:" + r.resolve_against(base, allow_path_underflow=allow).text
      catch {
        BaseWithFragment => "E:base_fragment"
        InvalidReferenceAgainstOpaqueBase => "E:opaque_base"
        PathUnderflow => "E:underflow"
      },
    )
  }
  parts.join(" ;; ")
}

///|
test "conformance: parsing, normalization and conversion" {
  for case in parse_cases {
    let (input, expected) = case
    let actual = run_case(input)
    if actual != expected {
      check_parts(actual, expected, input)
    }
  }
}

///|
/// Compares the results operation by operation.
///
/// An expected result of the form `E:<kind>:mid` marks an error whose index
/// the reference implementation reports in the middle of a character, which
/// cannot be expressed in UTF-16 code units; only the kind is compared there.
fn check_parts(
  actual : String,
  expected : String,
  input : String,
) -> Unit raise {
  let actual_parts = actual.split(" ;; ").map(v => v.to_owned()).to_array()
  let expected_parts = expected.split(" ;; ").map(v => v.to_owned()).to_array()
  assert_eq(
    actual_parts.length(),
    expected_parts.length(),
    msg="input \{input}",
  )
  for i in 0..<expected_parts.length() {
    let expected = expected_parts[i]
    let actual = actual_parts[i]
    if expected.has_suffix(":mid") {
      let kind = expected.rev_find(":").unwrap()
      assert_true(
        actual.has_prefix(expected.view(end_offset=kind + 1)),
        msg="input \{input}: expected \{expected}, got \{actual}",
      )
    } else {
      assert_eq(actual, expected, msg="input \{input}, operation \{i}")
    }
  }
}

///|
test "conformance: reference resolution" {
  for case in resolve_cases {
    let (base, reference, expected) = case
    assert_eq(
      run_resolve_case(base, reference),
      expected,
      msg="base \{base}, reference \{reference}",
    )
  }
}
