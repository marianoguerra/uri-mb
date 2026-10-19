///|
/// Building URIs, URI references, IRIs and IRI references from components.

///|
/// An error raised when building a URI/IRI (reference) from components that
/// cannot be put back together unambiguously.
pub(all) suberror BuildError {
  /// An authority is present, but the path is not empty and does not start
  /// with `'/'`.
  NonemptyRootlessPath
  /// No authority is present, but the path starts with `"//"`.
  PathStartsWithDoubleSlash
  /// Neither a scheme nor an authority is present, but the first path segment
  /// contains `':'`.
  FirstPathSegmentContainsColon
} derive(Eq, Debug)

///|
pub impl Show for BuildError with fn output(self, logger) {
  let msg = match self {
    NonemptyRootlessPath =>
      "when authority is present, path should either be empty or start with '/'"
    PathStartsWithDoubleSlash =>
      "when authority is not present, path should not start with \"//\""
    FirstPathSegmentContainsColon =>
      "when neither scheme nor authority is present, first path segment should not contain ':'"
  }
  logger.write_string(msg)
}

///|
/// Creates an [authority] component from its subcomponents.
///
/// If the contents of a `Host::RegName` host match the `IPv4address` ABNF rule from
/// [Section 3.2.2 of RFC 3986][host], the resulting authority holds an
/// [`Host::Ipv4`] host instead.
///
/// Note that ASCII characters within a host are *case-insensitive*.
/// For consistency, you should only produce normalized hosts.
///
/// [authority]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2
/// [host]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.2
///
/// # Panics
///
/// Panics if `host` is [`Host::IpvFuture`], which carries no address and so
/// cannot be written back out.
///
/// ```mbt check
/// test {
///   let auth : @uri.Authority[@enc.Userinfo, @enc.RegName] = @uri.Authority::make(
///     host=@uri.Host::RegName(@uri.EStr::new_or_panic("example.com")),
///     userinfo=@uri.EStr::new_or_panic("user"),
///     port=@uri.EStr::new_or_panic("8042"),
///   )
///   inspect(auth, content="user@example.com:8042")
/// }
/// ```
pub fn[U, R] Authority::make(
  host~ : Host[R],
  userinfo? : EStr[U],
  port? : EStr[@enc.Port],
) -> Authority[U, R] {
  let (text, parsed) : (String, Host[@enc.IRegName]) = match host {
    Ipv4(addr) => (addr.to_string(), Ipv4(addr))
    Ipv6(addr) => ("[" + addr.to_string() + "]", Ipv6(addr))
    RegName(name) => {
      let text = name.as_str()
      (text, parse_v4_or_reg_name(text))
    }
    IpvFuture => abort("cannot build an authority with an IPvFuture host")
  }
  { userinfo, host: text, host_parsed: parsed.cast(), port, }
}

///|
/// Checks that the components can be put back together unambiguously.
fn build_ri(
  scheme : Scheme?,
  authority : IAuth?,
  path : String,
  query : String?,
  fragment : String?,
) -> Ri raise BuildError {
  if authority is Some(_) {
    if !path.is_empty() && !path.has_prefix("/") {
      raise NonemptyRootlessPath
    }
  } else {
    if path.has_prefix("//") {
      raise PathStartsWithDoubleSlash
    }
    if scheme is None {
      let first_segment = match path.split_once("/") {
        Some((first, _)) => first.to_owned()
        None => path
      }
      if first_segment.contains(":") {
        raise FirstPathSegmentContainsColon
      }
    }
  }
  ri(scheme~, authority~, path~, query~, fragment~)
}

///|
/// Builds a URI from its components.
///
/// # Errors
///
/// Raises [`BuildError`] unless both of the following hold.
///
/// - When an authority is present, the path is empty or starts with `'/'`.
/// - When no authority is present, the path does not start with `"//"`.
///
/// ```mbt check
/// test {
///   let uri = @uri.Uri::build(
///     scheme=@uri.Scheme::new_or_panic("foo"),
///     authority=@uri.Authority::make(
///       host=@uri.Host::RegName(@uri.EStr::new_or_panic("example.com")),
///       userinfo=@uri.EStr::new_or_panic("user"),
///       port=@uri.EStr::new_or_panic("8042"),
///     ),
///     path=@uri.EStr::new_or_panic("/over/there"),
///     query=@uri.EStr::new_or_panic("name=ferret"),
///     fragment=@uri.EStr::new_or_panic("nose"),
///   )
///   inspect(
///     uri,
///     content="foo://user@example.com:8042/over/there?name=ferret#nose",
///   )
/// }
/// ```
pub fn Uri::build(
  scheme~ : Scheme,
  path~ : EStr[@enc.Path],
  authority? : Authority[@enc.Userinfo, @enc.RegName],
  query? : EStr[@enc.Query],
  fragment? : EStr[@enc.Fragment],
) -> Uri raise BuildError {
  uri_of_ri(
    build_ri(
      Some(scheme),
      opt_map(authority, a => a.cast()),
      path.as_str(),
      opt_map(query, v => v.as_str()),
      opt_map(fragment, v => v.as_str()),
    ),
  )
}

///|
/// Builds a URI reference from its components.
///
/// # Errors
///
/// Raises [`BuildError`] unless all of the following hold.
///
/// - When an authority is present, the path is empty or starts with `'/'`.
/// - When no authority is present, the path does not start with `"//"`.
/// - When neither a scheme nor an authority is present, the first path
///   segment does not contain `':'`.
pub fn UriRef::build(
  path~ : EStr[@enc.Path],
  scheme? : Scheme,
  authority? : Authority[@enc.Userinfo, @enc.RegName],
  query? : EStr[@enc.Query],
  fragment? : EStr[@enc.Fragment],
) -> UriRef raise BuildError {
  uri_ref_of_ri(
    build_ri(
      scheme,
      opt_map(authority, a => a.cast()),
      path.as_str(),
      opt_map(query, v => v.as_str()),
      opt_map(fragment, v => v.as_str()),
    ),
  )
}

///|
/// Builds an IRI from its components. See [`Uri::build`].
pub fn Iri::build(
  scheme~ : Scheme,
  path~ : EStr[@enc.IPath],
  authority? : Authority[@enc.IUserinfo, @enc.IRegName],
  query? : EStr[@enc.IQuery],
  fragment? : EStr[@enc.IFragment],
) -> Iri raise BuildError {
  iri_of_ri(
    build_ri(
      Some(scheme),
      authority,
      path.as_str(),
      opt_map(query, v => v.as_str()),
      opt_map(fragment, v => v.as_str()),
    ),
  )
}

///|
/// Builds an IRI reference from its components. See [`UriRef::build`].
pub fn IriRef::build(
  path~ : EStr[@enc.IPath],
  scheme? : Scheme,
  authority? : Authority[@enc.IUserinfo, @enc.IRegName],
  query? : EStr[@enc.IQuery],
  fragment? : EStr[@enc.IFragment],
) -> IriRef raise BuildError {
  iri_ref_of_ri(
    build_ri(
      scheme,
      authority,
      path.as_str(),
      opt_map(query, v => v.as_str()),
      opt_map(fragment, v => v.as_str()),
    ),
  )
}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend BuildError with Eq::{not_equal, equal}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend BuildError with Debug::{to_repr}

///|
pub extend BuildError with Show::{to_string}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend BuildError with Show::{output}
