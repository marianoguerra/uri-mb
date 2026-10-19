///|
/// Conversions between URIs, URI references, IRIs and IRI references.

///|
/// An error raised when converting a URI/IRI (reference) to a narrower type.
pub(all) suberror ConvertError {
  /// The input is not ASCII. The index points to the first non-ASCII code
  /// unit.
  NotAscii(index~ : Int32)
  /// The input has no scheme.
  NoScheme
} derive(Eq, Debug)

///|
pub impl Show for ConvertError with fn output(self, logger) {
  match self {
    NotAscii(index~) =>
      logger.write_string("non-ASCII character at index \{index}")
    NoScheme => logger.write_string("scheme not present")
  }
}

///|
/// Returns the index of the first non-ASCII code unit of `s`, if any.
fn first_non_ascii(s : String) -> Int32? {
  for i in 0..<s.length() {
    if code_at(s, i) >= 128 {
      return Some(i)
    }
  }
  None
}

///|
fn ensure_ascii(s : String) -> Unit raise ConvertError {
  if first_non_ascii(s) is Some(index) {
    raise NotAscii(index~)
  }
}

// Widening conversions, which never fail.

///|
/// Converts the URI to a URI reference with the same contents.
pub fn Uri::to_uri_ref(self : Uri) -> UriRef {
  uri_ref_of_ri(self.to_ri())
}

///|
/// Converts the URI to an IRI with the same contents.
pub fn Uri::to_iri(self : Uri) -> Iri {
  iri_of_ri(self.to_ri())
}

///|
/// Converts the URI to an IRI reference with the same contents.
pub fn Uri::to_iri_ref(self : Uri) -> IriRef {
  iri_ref_of_ri(self.to_ri())
}

///|
/// Converts the URI reference to an IRI reference with the same contents.
pub fn UriRef::to_iri_ref(self : UriRef) -> IriRef {
  iri_ref_of_ri(self.to_ri())
}

///|
/// Converts the IRI to an IRI reference with the same contents.
pub fn Iri::to_iri_ref(self : Iri) -> IriRef {
  iri_ref_of_ri(self.to_ri())
}

// Narrowing conversions, which keep the contents but may fail.

///|
/// Converts the URI reference to a URI if it has a scheme.
///
/// # Errors
///
/// Raises [`ConvertError`] if the URI reference has no scheme.
pub fn UriRef::as_uri(self : UriRef) -> Uri raise ConvertError {
  guard self.scheme is Some(_) else { raise NoScheme }
  uri_of_ri(self.to_ri())
}

///|
/// Converts the IRI to a URI if it is ASCII.
///
/// Use [`Iri::to_uri`] to percent-encode non-ASCII characters instead.
///
/// # Errors
///
/// Raises [`ConvertError`] if the IRI is not ASCII.
pub fn Iri::as_uri(self : Iri) -> Uri raise ConvertError {
  ensure_ascii(self.text)
  uri_of_ri(self.to_ri())
}

///|
/// Converts the IRI reference to a URI if it has a scheme and is ASCII.
///
/// # Errors
///
/// Raises [`ConvertError`] if the IRI reference has no scheme or is not ASCII.
pub fn IriRef::as_uri(self : IriRef) -> Uri raise ConvertError {
  guard self.scheme is Some(_) else { raise NoScheme }
  ensure_ascii(self.text)
  uri_of_ri(self.to_ri())
}

///|
/// Converts the IRI reference to a URI reference if it is ASCII.
///
/// Use [`IriRef::to_uri_ref`] to percent-encode non-ASCII characters instead.
///
/// # Errors
///
/// Raises [`ConvertError`] if the IRI reference is not ASCII.
pub fn IriRef::as_uri_ref(self : IriRef) -> UriRef raise ConvertError {
  ensure_ascii(self.text)
  uri_ref_of_ri(self.to_ri())
}

///|
/// Converts the IRI reference to an IRI if it has a scheme.
///
/// # Errors
///
/// Raises [`ConvertError`] if the IRI reference has no scheme.
pub fn IriRef::as_iri(self : IriRef) -> Iri raise ConvertError {
  guard self.scheme is Some(_) else { raise NoScheme }
  iri_of_ri(self.to_ri())
}

// Lossless conversions that percent-encode non-ASCII characters.

///|
/// Percent-encodes the non-ASCII characters of `s`.
fn encode_non_ascii_str(s : String) -> String {
  guard first_non_ascii(s) is Some(_) else { return s }
  let sb = StringBuilder(size_hint=s.length() * 2)
  let scratch : Array[Byte] = []
  let len = s.length()
  let mut i = 0
  while i < len {
    let (cp, w) = next_code_point(s, i)
    if cp < 128 {
      sb.write_substring(s, i, w)
    } else {
      scratch.clear()
      utf8_encode_code_point(scratch, cp)
      for x in scratch {
        push_encoded_byte(sb, x.to_int())
      }
    }
    i += w
  }
  sb.to_string()
}

///|
/// Percent-encodes the non-ASCII characters of every component.
fn encode_non_ascii(r : Ri) -> Ri {
  let authority = match r.authority {
    None => None
    Some(auth) => {
      let userinfo = opt_map(auth.userinfo, v => {
        estr(encode_non_ascii_str(v.as_str()))
      })
      let (host, host_parsed) : (String, Host[@enc.IRegName]) = match
        auth.host_parsed {
        RegName(_) => {
          let host = encode_non_ascii_str(auth.host)
          (host, RegName(estr(host)))
        }
        other => (auth.host, other)
      }
      Some({ userinfo, host, host_parsed, port: auth.port, })
    }
  }
  ri(
    scheme=r.scheme,
    authority~,
    path=encode_non_ascii_str(r.path),
    query=opt_map(r.query, encode_non_ascii_str),
    fragment=opt_map(r.fragment, encode_non_ascii_str),
  )
}

///|
/// Converts the IRI to a URI by percent-encoding non-ASCII characters.
///
/// Punycode encoding is **not** performed during conversion.
///
/// ```mbt check
/// test {
///   let iri = @uri.Iri::parse("http://www.example.org/résumé.html")
///   inspect(iri.to_uri(), content="http://www.example.org/r%C3%A9sum%C3%A9.html")
///   let iri = @uri.Iri::parse("http://résumé.example.org")
///   inspect(iri.to_uri(), content="http://r%C3%A9sum%C3%A9.example.org")
/// }
/// ```
pub fn Iri::to_uri(self : Iri) -> Uri {
  uri_of_ri(encode_non_ascii(self.to_ri()))
}

///|
/// Converts the IRI reference to a URI reference by percent-encoding
/// non-ASCII characters.
///
/// Punycode encoding is **not** performed during conversion.
///
/// ```mbt check
/// test {
///   let iri_ref = @uri.IriRef::parse("résumé.html")
///   inspect(iri_ref.to_uri_ref(), content="r%C3%A9sum%C3%A9.html")
///   let iri_ref = @uri.IriRef::parse("//résumé.example.org")
///   inspect(iri_ref.to_uri_ref(), content="//r%C3%A9sum%C3%A9.example.org")
/// }
/// ```
pub fn IriRef::to_uri_ref(self : IriRef) -> UriRef {
  uri_ref_of_ri(encode_non_ascii(self.to_ri()))
}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend ConvertError with Eq::{not_equal, equal}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend ConvertError with Debug::{to_repr}

///|
pub extend ConvertError with Show::{to_string}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend ConvertError with Show::{output}
