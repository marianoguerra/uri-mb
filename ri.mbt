///|
/// URIs, URI references, IRIs and IRI references.

///|
/// The internal, encoder-agnostic form of a URI/IRI (reference).
///
/// `text` always equals the concatenation of the components, so that the four
/// public types can cache it instead of rebuilding it on every use.
priv struct Ri {
  text : String
  scheme : Scheme?
  authority : IAuth?
  path : String
  query : String?
  fragment : String?
}

///|
/// Rebuilds the text of a URI/IRI (reference) from its components.
fn ri_text(
  scheme : Scheme?,
  authority : IAuth?,
  path : String,
  query : String?,
  fragment : String?,
) -> String {
  let sb = StringBuilder::new(size_hint=path.length() + 32)
  if scheme is Some(s) {
    sb.write_string(s.as_str())
    sb.write_char(':')
  }
  if authority is Some(a) {
    sb.write_string("//")
    sb.write_string(a.as_str())
  }
  sb.write_string(path)
  if query is Some(q) {
    sb.write_char('?')
    sb.write_string(q)
  }
  if fragment is Some(f) {
    sb.write_char('#')
    sb.write_string(f)
  }
  sb.to_string()
}

///|
/// Creates a `Ri` from components, computing its text.
fn ri(
  scheme? : Scheme? = None,
  authority? : IAuth? = None,
  path~ : String,
  query? : String? = None,
  fragment? : String? = None,
) -> Ri {
  {
    text: ri_text(scheme, authority, path, query, fragment),
    scheme,
    authority,
    path,
    query,
    fragment,
  }
}

///|
/// Returns the text up to, but not including, the `'#'` of the fragment.
fn Ri::strip_fragment_text(self : Ri) -> String {
  match self.fragment {
    Some(f) => slice(self.text, 0, self.text.length() - f.length() - 1)
    None => self.text
  }
}

///|
/// Replaces the fragment. Altering only the fragment does not change the
/// other components.
fn Ri::set_fragment(self : Ri, fragment : String?) -> Ri {
  let stripped = self.strip_fragment_text()
  let text = match fragment {
    Some(f) => stripped + "#" + f
    None => stripped
  }
  { ..self, text, fragment }
}

// -----------------------------------------------------------------------
// Uri
// -----------------------------------------------------------------------

///|
/// A URI.
///
/// # Examples
///
/// ```mbt check
/// test {
///   let uri = @uri.Uri::parse(
///     "foo://user@example.com:8042/over/there?name=ferret#nose",
///   )
///   assert_eq(uri.scheme, @uri.Scheme::new_or_panic("foo"))
///   let auth = uri.authority.unwrap()
///   assert_eq(auth.as_str(), "user@example.com:8042")
///   assert_eq(auth.userinfo.unwrap().as_str(), "user")
///   assert_eq(auth.host, "example.com")
///   assert_eq(auth.port.unwrap().as_str(), "8042")
///   assert_eq(uri.path.as_str(), "/over/there")
///   assert_eq(uri.query.unwrap().as_str(), "name=ferret")
///   assert_eq(uri.fragment.unwrap().as_str(), "nose")
/// }
/// ```
pub struct Uri {
  /// The URI as a string.
  text : String
  /// The [scheme] component.
  ///
  /// Note that the scheme component is *case-insensitive* and its canonical
  /// form is *lowercase*.
  ///
  /// [scheme]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.1
  scheme : Scheme
  /// The optional [authority] component.
  ///
  /// [authority]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2
  authority : Authority[@enc.Userinfo, @enc.RegName]?
  /// The [path] component, which is always present but may be empty.
  ///
  /// [path]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.3
  path : EStr[@enc.Path]
  /// The optional [query] component.
  ///
  /// [query]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.4
  query : EStr[@enc.Query]?
  /// The optional [fragment] component.
  ///
  /// [fragment]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.5
  fragment : EStr[@enc.Fragment]?
}

///|
/// A URI reference, i.e., either a URI or a relative reference.
pub struct UriRef {
  /// The URI reference as a string.
  text : String
  /// The optional [scheme] component.
  ///
  /// [scheme]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.1
  scheme : Scheme?
  /// The optional [authority] component.
  authority : Authority[@enc.Userinfo, @enc.RegName]?
  /// The [path] component, which is always present but may be empty.
  path : EStr[@enc.Path]
  /// The optional [query] component.
  query : EStr[@enc.Query]?
  /// The optional [fragment] component.
  fragment : EStr[@enc.Fragment]?
}

///|
/// An IRI, i.e., an internationalized URI which may contain non-ASCII
/// characters.
pub struct Iri {
  /// The IRI as a string.
  text : String
  /// The [scheme] component.
  ///
  /// [scheme]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.1
  scheme : Scheme
  /// The optional [authority] component.
  authority : Authority[@enc.IUserinfo, @enc.IRegName]?
  /// The [path] component, which is always present but may be empty.
  path : EStr[@enc.IPath]
  /// The optional [query] component.
  query : EStr[@enc.IQuery]?
  /// The optional [fragment] component.
  fragment : EStr[@enc.IFragment]?
}

///|
/// An IRI reference, i.e., either an IRI or a relative reference.
pub struct IriRef {
  /// The IRI reference as a string.
  text : String
  /// The optional [scheme] component.
  scheme : Scheme?
  /// The optional [authority] component.
  authority : Authority[@enc.IUserinfo, @enc.IRegName]?
  /// The [path] component, which is always present but may be empty.
  path : EStr[@enc.IPath]
  /// The optional [query] component.
  query : EStr[@enc.IQuery]?
  /// The optional [fragment] component.
  fragment : EStr[@enc.IFragment]?
}

// Conversions between the public types and the internal form.

///|
fn Uri::to_ri(self : Uri) -> Ri {
  {
    text: self.text,
    scheme: Some(self.scheme),
    authority: opt_map(self.authority, a => a.cast()),
    path: self.path.as_str(),
    query: opt_map(self.query, v => v.as_str()),
    fragment: opt_map(self.fragment, v => v.as_str()),
  }
}

///|
fn UriRef::to_ri(self : UriRef) -> Ri {
  {
    text: self.text,
    scheme: self.scheme,
    authority: opt_map(self.authority, a => a.cast()),
    path: self.path.as_str(),
    query: opt_map(self.query, v => v.as_str()),
    fragment: opt_map(self.fragment, v => v.as_str()),
  }
}

///|
fn Iri::to_ri(self : Iri) -> Ri {
  {
    text: self.text,
    scheme: Some(self.scheme),
    authority: self.authority,
    path: self.path.as_str(),
    query: opt_map(self.query, v => v.as_str()),
    fragment: opt_map(self.fragment, v => v.as_str()),
  }
}

///|
fn IriRef::to_ri(self : IriRef) -> Ri {
  {
    text: self.text,
    scheme: self.scheme,
    authority: self.authority,
    path: self.path.as_str(),
    query: opt_map(self.query, v => v.as_str()),
    fragment: opt_map(self.fragment, v => v.as_str()),
  }
}

///|
/// Builds a `Uri` from the internal form, which must have a scheme.
fn uri_of_ri(r : Ri) -> Uri {
  {
    text: r.text,
    scheme: r.scheme.unwrap(),
    authority: opt_map(r.authority, a => a.cast()),
    path: estr(r.path),
    query: opt_map(r.query, estr),
    fragment: opt_map(r.fragment, estr),
  }
}

///|
fn uri_ref_of_ri(r : Ri) -> UriRef {
  {
    text: r.text,
    scheme: r.scheme,
    authority: opt_map(r.authority, a => a.cast()),
    path: estr(r.path),
    query: opt_map(r.query, estr),
    fragment: opt_map(r.fragment, estr),
  }
}

///|
/// Builds an `Iri` from the internal form, which must have a scheme.
fn iri_of_ri(r : Ri) -> Iri {
  {
    text: r.text,
    scheme: r.scheme.unwrap(),
    authority: r.authority,
    path: estr(r.path),
    query: opt_map(r.query, estr),
    fragment: opt_map(r.fragment, estr),
  }
}

///|
fn iri_ref_of_ri(r : Ri) -> IriRef {
  {
    text: r.text,
    scheme: r.scheme,
    authority: r.authority,
    path: estr(r.path),
    query: opt_map(r.query, estr),
    fragment: opt_map(r.fragment, estr),
  }
}

///|
fn[A, B] opt_map(x : A?, f : (A) -> B) -> B? {
  match x {
    Some(v) => Some(f(v))
    None => None
  }
}

// Parsing.

///|
/// Parses a URI from a string, matching the [`URI`][abnf] ABNF rule
/// from RFC 3986.
///
/// [abnf]: https://datatracker.ietf.org/doc/html/rfc3986#section-3
///
/// ```mbt check
/// test {
///   let uri = @uri.Uri::parse("http://example.com/")
///   inspect(uri, content="http://example.com/")
/// }
/// ```
pub fn Uri::parse(s : String) -> Uri raise ParseError {
  uri_of_ri(parse_ri(s, ascii_only=true, scheme_required=true))
}

///|
/// Parses a URI reference from a string, matching the [`URI-reference`][abnf]
/// ABNF rule from RFC 3986.
///
/// [abnf]: https://datatracker.ietf.org/doc/html/rfc3986#section-4.1
pub fn UriRef::parse(s : String) -> UriRef raise ParseError {
  uri_ref_of_ri(parse_ri(s, ascii_only=true, scheme_required=false))
}

///|
/// Parses an IRI from a string, matching the [`IRI`][abnf] ABNF rule
/// from RFC 3987.
///
/// [abnf]: https://datatracker.ietf.org/doc/html/rfc3987#section-2.2
pub fn Iri::parse(s : String) -> Iri raise ParseError {
  iri_of_ri(parse_ri(s, ascii_only=false, scheme_required=true))
}

///|
/// Parses an IRI reference from a string, matching the [`IRI-reference`][abnf]
/// ABNF rule from RFC 3987.
///
/// [abnf]: https://datatracker.ietf.org/doc/html/rfc3987#section-2.2
pub fn IriRef::parse(s : String) -> IriRef raise ParseError {
  iri_ref_of_ri(parse_ri(s, ascii_only=false, scheme_required=false))
}

// Common instances.

///|
pub impl Show for Uri with fn output(self, logger) {
  logger.write_string(self.text)
}

///|
pub impl Show for UriRef with fn output(self, logger) {
  logger.write_string(self.text)
}

///|
pub impl Show for Iri with fn output(self, logger) {
  logger.write_string(self.text)
}

///|
pub impl Show for IriRef with fn output(self, logger) {
  logger.write_string(self.text)
}

///|
pub impl Debug for Uri with fn to_repr(self) {
  Repr(self.text)
}

///|
pub impl Debug for UriRef with fn to_repr(self) {
  Repr(self.text)
}

///|
pub impl Debug for Iri with fn to_repr(self) {
  Repr(self.text)
}

///|
pub impl Debug for IriRef with fn to_repr(self) {
  Repr(self.text)
}

///|
pub impl Eq for Uri with fn equal(self, other) {
  self.text == other.text
}

///|
pub impl Eq for UriRef with fn equal(self, other) {
  self.text == other.text
}

///|
pub impl Eq for Iri with fn equal(self, other) {
  self.text == other.text
}

///|
pub impl Eq for IriRef with fn equal(self, other) {
  self.text == other.text
}

///|
pub impl Compare for Uri with fn compare(self, other) {
  self.text.compare(other.text)
}

///|
pub impl Compare for UriRef with fn compare(self, other) {
  self.text.compare(other.text)
}

///|
pub impl Compare for Iri with fn compare(self, other) {
  self.text.compare(other.text)
}

///|
pub impl Compare for IriRef with fn compare(self, other) {
  self.text.compare(other.text)
}

///|
pub impl Hash for Uri with fn hash_combine(self, hasher) {
  hasher.combine_string(self.text)
}

///|
pub impl Hash for UriRef with fn hash_combine(self, hasher) {
  hasher.combine_string(self.text)
}

///|
pub impl Hash for Iri with fn hash_combine(self, hasher) {
  hasher.combine_string(self.text)
}

///|
pub impl Hash for IriRef with fn hash_combine(self, hasher) {
  hasher.combine_string(self.text)
}

// @enc.Fragment manipulation.

///|
/// Returns the URI with its fragment removed.
///
/// ```mbt check
/// test {
///   let uri = @uri.Uri::parse("http://example.com/#title")
///   inspect(uri.strip_fragment(), content="http://example.com/")
/// }
/// ```
pub fn Uri::strip_fragment(self : Uri) -> Uri {
  uri_of_ri(self.to_ri().set_fragment(None))
}

///|
/// Returns the URI reference with its fragment removed.
pub fn UriRef::strip_fragment(self : UriRef) -> UriRef {
  uri_ref_of_ri(self.to_ri().set_fragment(None))
}

///|
/// Returns the IRI with its fragment removed.
pub fn Iri::strip_fragment(self : Iri) -> Iri {
  iri_of_ri(self.to_ri().set_fragment(None))
}

///|
/// Returns the IRI reference with its fragment removed.
pub fn IriRef::strip_fragment(self : IriRef) -> IriRef {
  iri_ref_of_ri(self.to_ri().set_fragment(None))
}

///|
/// Returns the URI with its fragment replaced by `fragment`.
pub fn Uri::with_fragment(self : Uri, fragment : EStr[@enc.Fragment]?) -> Uri {
  uri_of_ri(self.to_ri().set_fragment(opt_map(fragment, v => v.as_str())))
}

///|
/// Returns the URI reference with its fragment replaced by `fragment`.
pub fn UriRef::with_fragment(
  self : UriRef,
  fragment : EStr[@enc.Fragment]?,
) -> UriRef {
  uri_ref_of_ri(self.to_ri().set_fragment(opt_map(fragment, v => v.as_str())))
}

///|
/// Returns the IRI with its fragment replaced by `fragment`.
pub fn Iri::with_fragment(self : Iri, fragment : EStr[@enc.IFragment]?) -> Iri {
  iri_of_ri(self.to_ri().set_fragment(opt_map(fragment, v => v.as_str())))
}

///|
/// Returns the IRI reference with its fragment replaced by `fragment`.
pub fn IriRef::with_fragment(
  self : IriRef,
  fragment : EStr[@enc.IFragment]?,
) -> IriRef {
  iri_ref_of_ri(self.to_ri().set_fragment(opt_map(fragment, v => v.as_str())))
}
