///|
/// Syntax-based normalization, as defined in
/// [Section 6 of RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986#section-6).

///|
/// An error raised when normalizing a URI/IRI (reference).
pub(all) suberror NormalizeError {
  /// An underflow occurred in path normalization. Raised only by the
  /// `normalize_strict` methods.
  NormalizePathUnderflow
} derive(Eq, Debug)

///|
pub impl Show for NormalizeError with fn output(_self, logger) {
  logger.write_string("underflow occurred in path resolution")
}

///|
/// The table used to normalize a query, which additionally preserves the
/// characters matching the `iprivate` ABNF rule.
let table_iquery_data : @enc.Table = @enc.table_idata.or_iprivate()

///|
/// Parses `s` as an IPv4 address, falling back to a registered name.
fn parse_v4_or_reg_name(s : String) -> Host[@enc.IRegName] {
  let p = Parser::new(s, ascii_only=true, scheme_required=false)
  match p.read_v4() {
    Some(addr) if !p.has_remaining() => Ipv4(addr)
    _ => RegName(estr(s))
  }
}

///|
/// Normalizes the percent-encoding of `s`: octets that stand for characters
/// allowed by `table` are decoded, the others are uppercased.
fn normalize_estr(
  s : String,
  to_ascii_lowercase : Bool,
  table : @enc.Table,
) -> String {
  let sb = StringBuilder::new(size_hint=s.length())
  if table.allows_non_ascii() {
    decode_walk(
      s,
      run => {
        if to_ascii_lowercase {
          sb.write_string(ascii_lowercase(run))
        } else {
          sb.write_string(run)
        }
      },
      (valid, invalid) => {
        encode_str(sb, table, valid, to_ascii_lowercase~)
        for i in 0..<invalid.length() {
          push_encoded_byte(sb, invalid[i].to_int())
        }
      },
    )
  } else {
    decode_walk_octets(
      s,
      run => {
        if to_ascii_lowercase {
          sb.write_string(ascii_lowercase(run))
        } else {
          sb.write_string(run)
        }
      },
      octet => {
        if table.allows_ascii(octet) {
          let x = if to_ascii_lowercase &&
            octet >= 'A'.to_int() &&
            octet <= 'Z'.to_int() {
            octet + 32
          } else {
            octet
          }
          sb.write_char(x.to_char().unwrap())
        } else {
          push_encoded_byte(sb, octet)
        }
      },
    )
  }
  sb.to_string()
}

///|
/// Normalizes a URI/IRI (reference), also returning whether an underflow
/// occurred in path normalization.
fn normalize_ri(
  r : Ri,
  ascii_only~ : Bool,
  default_port~ : (String) -> Int?,
) -> (Ri, Bool) {
  let data_table = if ascii_only { @enc.table_data } else { @enc.table_idata }
  let scheme = opt_map(r.scheme, s => {
    scheme_validated(ascii_lowercase(s.as_str()))
  })
  let authority = match r.authority {
    None => None
    Some(auth) => {
      let userinfo = opt_map(auth.userinfo, v => {
        estr(normalize_estr(v.as_str(), false, data_table))
      })
      let (host, host_parsed) : (String, Host[@enc.IRegName]) = match
        auth.host_parsed {
        // An IPv4 address is always canonical.
        Ipv4(addr) => (auth.host, Ipv4(addr))
        Ipv6(addr) => ("[" + addr.to_string() + "]", Ipv6(addr))
        IpvFuture => (ascii_lowercase(auth.host), IpvFuture)
        RegName(_) => {
          let host = normalize_estr(auth.host, true, data_table)
          if host.length() < auth.host.length() {
            // Only reparse when the length is less than before.
            (host, parse_v4_or_reg_name(host))
          } else {
            (host, RegName(estr(host)))
          }
        }
      }
      let port = match auth.port {
        Some(port) if !port.is_empty() => {
          let mut eq_default = false
          if scheme is Some(scheme) {
            if default_port(scheme.as_str()) is Some(default) {
              eq_default = port_eq(port.as_str(), default)
            }
          }
          if eq_default {
            None
          } else {
            Some(port)
          }
        }
        _ => None
      }
      Some({ userinfo, host, host_parsed, port })
    }
  }
  let (path, underflow) = if r.scheme is Some(_) && r.path.has_prefix("/") {
    let path = normalize_estr(r.path, false, data_table)
    let (path, underflow) = remove_dot_segments(path, None)
    // Make sure that the output is a valid URI/IRI reference.
    if authority is None && path.has_prefix("//") {
      ("/." + path, underflow)
    } else {
      (path, underflow)
    }
  } else {
    // Don't remove dot segments from a relative reference or a rootless path.
    (normalize_estr(r.path, false, data_table), false)
  }
  let query_data_table = if ascii_only {
    @enc.table_data
  } else {
    table_iquery_data
  }
  let query = opt_map(r.query, q => normalize_estr(q, false, query_data_table))
  let fragment = opt_map(r.fragment, f => normalize_estr(f, false, data_table))
  (ri(scheme~, authority~, path~, query~, fragment~), underflow)
}

///|
/// Checks whether the nonempty port `s` denotes the number `default`.
/// Leading zeros are ignored; a port that does not fit in a `u16` never
/// matches.
fn port_eq(s : String, default : Int) -> Bool {
  let mut value = 0
  for i in 0..<s.length() {
    value = value * 10 + (code_at(s, i) - '0'.to_int())
    if value > 65535 {
      return false
    }
  }
  value == default
}

///|
/// The default `default_port` function, which knows no default ports.
fn no_default_port(_scheme : String) -> Int? {
  None
}

///|
/// Normalizes the URI.
///
/// The following normalizations are applied:
///
/// - The scheme and the host are lowercased.
/// - Percent-encoded octets that stand for unreserved characters are decoded,
///   and the remaining ones are uppercased.
/// - Dot segments are removed from an absolute path.
/// - An empty port is removed, and so is a port equal to the scheme's default,
///   as given by `default_port`. The scheme passed to `default_port` is
///   already lowercased.
/// - An IPv6 address is rewritten in its canonical form.
///
/// ```mbt check
/// test {
///   let uri = @uri.Uri::parse("eXAMPLE://a/./b/../b/%63/%7bfoo%7d")
///   inspect(uri.normalize(), content="example://a/b/c/%7Bfoo%7D")
///   let uri = @uri.Uri::parse("http://example.com:80/")
///   inspect(
///     uri.normalize(default_port=scheme => {
///       if scheme is "http" {
///         Some(80)
///       } else {
///         None
///       }
///     }),
///     content="http://example.com/",
///   )
/// }
/// ```
pub fn Uri::normalize(
  self : Uri,
  default_port? : (String) -> Int? = no_default_port,
) -> Uri {
  let (r, _) = normalize_ri(self.to_ri(), ascii_only=true, default_port~)
  uri_of_ri(r)
}

///|
/// Normalizes the URI, rejecting an underflow in path normalization.
///
/// # Errors
///
/// Raises [`NormalizeError`] if a `".."` segment of an absolute path tries to
/// escape the root, e.g. in `"http://example.com/.."`.
pub fn Uri::normalize_strict(
  self : Uri,
  default_port? : (String) -> Int? = no_default_port,
) -> Uri raise NormalizeError {
  let (r, underflow) = normalize_ri(
    self.to_ri(),
    ascii_only=true,
    default_port~,
  )
  if underflow {
    raise NormalizePathUnderflow
  }
  uri_of_ri(r)
}

///|
/// Normalizes the URI reference. See [`Uri::normalize`].
pub fn UriRef::normalize(
  self : UriRef,
  default_port? : (String) -> Int? = no_default_port,
) -> UriRef {
  let (r, _) = normalize_ri(self.to_ri(), ascii_only=true, default_port~)
  uri_ref_of_ri(r)
}

///|
/// Normalizes the URI reference, rejecting an underflow in path
/// normalization. See [`Uri::normalize_strict`].
pub fn UriRef::normalize_strict(
  self : UriRef,
  default_port? : (String) -> Int? = no_default_port,
) -> UriRef raise NormalizeError {
  let (r, underflow) = normalize_ri(
    self.to_ri(),
    ascii_only=true,
    default_port~,
  )
  if underflow {
    raise NormalizePathUnderflow
  }
  uri_ref_of_ri(r)
}

///|
/// Normalizes the IRI. See [`Uri::normalize`].
pub fn Iri::normalize(
  self : Iri,
  default_port? : (String) -> Int? = no_default_port,
) -> Iri {
  let (r, _) = normalize_ri(self.to_ri(), ascii_only=false, default_port~)
  iri_of_ri(r)
}

///|
/// Normalizes the IRI, rejecting an underflow in path normalization.
/// See [`Uri::normalize_strict`].
pub fn Iri::normalize_strict(
  self : Iri,
  default_port? : (String) -> Int? = no_default_port,
) -> Iri raise NormalizeError {
  let (r, underflow) = normalize_ri(
    self.to_ri(),
    ascii_only=false,
    default_port~,
  )
  if underflow {
    raise NormalizePathUnderflow
  }
  iri_of_ri(r)
}

///|
/// Normalizes the IRI reference. See [`Uri::normalize`].
pub fn IriRef::normalize(
  self : IriRef,
  default_port? : (String) -> Int? = no_default_port,
) -> IriRef {
  let (r, _) = normalize_ri(self.to_ri(), ascii_only=false, default_port~)
  iri_ref_of_ri(r)
}

///|
/// Normalizes the IRI reference, rejecting an underflow in path
/// normalization. See [`Uri::normalize_strict`].
pub fn IriRef::normalize_strict(
  self : IriRef,
  default_port? : (String) -> Int? = no_default_port,
) -> IriRef raise NormalizeError {
  let (r, underflow) = normalize_ri(
    self.to_ri(),
    ascii_only=false,
    default_port~,
  )
  if underflow {
    raise NormalizePathUnderflow
  }
  iri_ref_of_ri(r)
}
