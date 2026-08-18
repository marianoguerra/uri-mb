///|
/// URI/IRI components.

///|
/// A [scheme] component.
///
/// [scheme]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.1
///
/// # Comparison
///
/// `Scheme`s are compared case-insensitively. Compare
/// [`Scheme::as_str`] values instead for a case-sensitive comparison.
///
/// ```mbt check
/// test {
///   let scheme = @uri.Uri::parse("HTTP://EXAMPLE.COM/").scheme
///   // Case-insensitive comparison.
///   assert_eq(scheme, @uri.Scheme::new_or_panic("http"))
///   // Case-sensitive comparison.
///   assert_eq(scheme.as_str(), "HTTP")
/// }
/// ```
pub struct Scheme {
  inner : String
}

///|
/// Converts a string to a `Scheme`, returning `None` if it is not a valid
/// scheme name according to [Section 3.1 of RFC 3986][scheme].
///
/// [scheme]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.1
pub fn Scheme::new(s : String) -> Scheme? {
  if s.is_empty() {
    return None
  }
  let first = code_at(s, 0)
  if !@enc.table_alpha.allows_ascii(first) {
    return None
  }
  if !table_validate(@enc.table_scheme, slice(s, 1, s.length())) {
    return None
  }
  Some({ inner: s })
}

///|
/// Converts a string to a `Scheme`.
///
/// # Panics
///
/// Panics if the string is not a valid scheme name.
/// For a non-panicking variant, use [`Scheme::new`].
pub fn Scheme::new_or_panic(s : String) -> Scheme {
  match Scheme::new(s) {
    Some(v) => v
    None => abort("invalid scheme: \{s}")
  }
}

///|
/// Wraps a string that is known to be a valid scheme name.
fn scheme_validated(s : String) -> Scheme {
  { inner: s }
}

///|
/// Returns the scheme component as a string.
pub fn Scheme::as_str(self : Scheme) -> String {
  self.inner
}

///|
/// Compares two schemes case-insensitively.
pub impl Eq for Scheme with fn equal(self, other) {
  let (a, b) = (self.inner, other.inner)
  if a.length() != b.length() {
    return false
  }
  // The only characters allowed in a scheme are letters, digits, '+', '-'
  // and '.'. Their ASCII codes let us simply set the sixth bit and compare.
  for i in 0..<a.length() {
    if (code_at(a, i) | 0x20) != (code_at(b, i) | 0x20) {
      return false
    }
  }
  true
}

///|
pub impl Hash for Scheme with fn hash_combine(self, hasher) {
  hasher.combine_string(ascii_lowercase(self.inner))
}

///|
pub impl Show for Scheme with fn output(self, logger) {
  logger.write_string(self.inner)
}

///|
pub impl Debug for Scheme with fn to_repr(self) {
  Repr(self.inner)
}

///|
/// A parsed [host] subcomponent.
///
/// Note that ASCII characters within a host are *case-insensitive*.
///
/// [host]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.2
pub(all) enum Host[R] {
  /// An IPv4 address.
  Ipv4(Ipv4Addr)
  /// An IPv6 address.
  Ipv6(Ipv6Addr)
  /// An IP address of a future version. The API design for IPvFuture
  /// addresses is to be determined.
  IpvFuture
  /// A registered name.
  RegName(EStr[R])
} derive(Eq, Debug)

///|
pub impl[R] Show for Host[R] with fn output(self, logger) {
  match self {
    Ipv4(addr) => logger.write_string("Ipv4(\{addr})")
    Ipv6(addr) => logger.write_string("Ipv6(\{addr})")
    IpvFuture => logger.write_string("IpvFuture")
    RegName(name) => logger.write_string("RegName(\{name})")
  }
}

///|
/// Reinterprets the host with another registered name encoder.
fn[A, B] Host::cast(self : Host[A]) -> Host[B] {
  match self {
    Ipv4(addr) => Ipv4(addr)
    Ipv6(addr) => Ipv6(addr)
    IpvFuture => IpvFuture
    RegName(name) => RegName(name.cast())
  }
}

///|
/// An [authority] component.
///
/// [authority]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2
///
/// The `host` field holds the host subcomponent verbatim, including the square
/// brackets that enclose an IPv6 or IPvFuture address; `host_parsed` holds its
/// parsed form. Note that ASCII characters within a host are
/// *case-insensitive*.
///
/// A port may be empty, have leading zeros, or be larger than `65535`. It is up
/// to you to decide whether to deny such ports, fall back to the scheme's
/// default if it is empty, ignore the leading zeros, or use a special
/// addressing mechanism that allows ports larger than `65535`.
pub struct Authority[U, R] {
  /// The optional [userinfo] subcomponent.
  ///
  /// [userinfo]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.1
  userinfo : EStr[U]?
  /// The [host] subcomponent, verbatim.
  ///
  /// [host]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.2
  host : String
  /// The parsed host subcomponent.
  host_parsed : Host[R]
  /// The optional [port] subcomponent.
  ///
  /// [port]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.3
  port : EStr[@enc.Port]?
} derive(Eq, Debug)

///|
/// The internal, IRI-permissive form of an authority.
type IAuth = Authority[@enc.IUserinfo, @enc.IRegName]

///|
/// An empty authority component.
pub fn[U, R] Authority::empty() -> Authority[U, R] {
  { userinfo: None, host: "", host_parsed: RegName(EStr::empty()), port: None }
}

///|
/// Reinterprets the authority with other userinfo and registered name
/// encoders.
fn[U, R, U2, R2] Authority::cast(self : Authority[U, R]) -> Authority[U2, R2] {
  {
    userinfo: match self.userinfo {
      Some(v) => Some(v.cast())
      None => None
    },
    host: self.host,
    host_parsed: self.host_parsed.cast(),
    port: self.port,
  }
}

///|
/// Returns the authority component as a string.
///
/// ```mbt check
/// test {
///   let auth = @uri.Uri::parse("http://user@example.com:8080/").authority.unwrap()
///   inspect(auth.as_str(), content="user@example.com:8080")
/// }
/// ```
pub fn[U, R] Authority::as_str(self : Authority[U, R]) -> String {
  let sb = StringBuilder::new(size_hint=self.host.length() + 16)
  if self.userinfo is Some(v) {
    sb.write_string(v.as_str())
    sb.write_char('@')
  }
  sb.write_string(self.host)
  if self.port is Some(v) {
    sb.write_char(':')
    sb.write_string(v.as_str())
  }
  sb.to_string()
}

///|
pub impl[U, R] Show for Authority[U, R] with fn output(self, logger) {
  logger.write_string(self.as_str())
}

///|
/// An error raised when a port cannot be converted to an integer.
pub(all) suberror InvalidPort {
  /// The port that failed to convert.
  InvalidPort(port~ : String)
} derive(Eq, Debug)

///|
pub impl Show for InvalidPort with fn output(self, logger) {
  let InvalidPort(port~) = self
  logger.write_string("invalid port value: \{port}")
}

///|
/// Converts the [port] subcomponent to an integer, if present and nonempty.
///
/// Returns `None` if the port is not present or is empty.
/// Leading zeros are ignored.
///
/// [port]: https://datatracker.ietf.org/doc/html/rfc3986#section-3.2.3
///
/// # Errors
///
/// Raises [`InvalidPort`] if the port does not fit in a `u16`.
///
/// ```mbt check
/// test {
///   let auth = @uri.Uri::parse("foo://localhost:4673/").authority.unwrap()
///   assert_eq(auth.port_to_u16(), Some(4673))
///   let auth = @uri.Uri::parse("foo://localhost:/").authority.unwrap()
///   assert_eq(auth.port_to_u16(), None)
/// }
/// ```
pub fn[U, R] Authority::port_to_u16(
  self : Authority[U, R],
) -> Int? raise InvalidPort {
  guard self.port is Some(port) else { return None }
  let s = port.as_str()
  if s.is_empty() {
    return None
  }
  let mut value = 0
  for i in 0..<s.length() {
    value = value * 10 + (code_at(s, i) - '0'.to_int())
    if value > 65535 {
      raise InvalidPort(port=s)
    }
  }
  Some(value)
}

///|
/// Checks whether a userinfo subcomponent is present.
pub fn[U, R] Authority::has_userinfo(self : Authority[U, R]) -> Bool {
  self.userinfo is Some(_)
}

///|
/// Checks whether a port subcomponent is present.
pub fn[U, R] Authority::has_port(self : Authority[U, R]) -> Bool {
  self.port is Some(_)
}
