///|
/// The URI/IRI (reference) parser.

///|
/// An error raised when parsing a URI/IRI (reference).
///
/// Indexes are counted in UTF-16 code units, i.e., they can be used directly
/// to slice the input string.
pub(all) suberror ParseError {
  /// Unexpected character or end of input. The index points to the first code
  /// unit of the character, or to the end of input.
  UnexpectedCharOrEnd(index~ : Int32)
  /// Invalid IPv6 address. The index points to the first code unit of the
  /// address.
  InvalidIpv6Addr(index~ : Int32)
} derive(Eq, Debug)

///|
/// Returns the index at which the error occurred.
pub fn ParseError::index(self : ParseError) -> Int32 {
  match self {
    UnexpectedCharOrEnd(index~) => index
    InvalidIpv6Addr(index~) => index
  }
}

///|
pub impl Show for ParseError with fn output(self, logger) {
  match self {
    UnexpectedCharOrEnd(index~) =>
      logger.write_string(
        "unexpected character or end of input at index \{index}",
      )
    InvalidIpv6Addr(index~) =>
      logger.write_string("invalid IPv6 address at index \{index}")
  }
}

///|
/// The parsed form of the host subcomponent, without the string contents.
priv enum HostMeta {
  HIpv4(Ipv4Addr)
  HIpv6(Ipv6Addr)
  HIpvFuture
  HRegName
}

///|
priv struct AuthMeta {
  host_start : Int32
  host_end : Int32
  host_meta : HostMeta
}

///|
priv enum PathKind {
  General
  AbEmpty
  ContinuedNoScheme
} derive(Eq)

///|
/// An intermediate result of reading one segment of an IPv6 address.
priv enum Seg {
  /// `*1":" 1*4HEXDIG`
  SegNormal(Int32, Bool)
  /// `"::"`
  SegEllipsis
  /// `*1":" 1*4HEXDIG "."`
  SegMaybeV4(Bool)
  /// `":"`
  SegSingleColon
}

///|
/// A URI/IRI (reference) parser.
///
/// # Invariants
///
/// `pos <= len`, `pos` is non-decreasing and never splits a surrogate pair.
///
/// Start and finish parsing by calling `parse_from_scheme`. When parsing
/// succeeds, all output indexes are within bounds, correctly ordered, and all
/// components they define are validated.
priv struct Parser {
  s : String
  len : Int32
  ascii_only : Bool
  scheme_required : Bool
  mut pos : Int32
  // The index of the trailing colon of the scheme, or 0 if there is no scheme.
  mut scheme_end : Int32
  mut auth : AuthMeta?
  mut path_start : Int32
  mut path_end : Int32
  // One code unit past the last one of the query, or 0 if there is no query.
  mut query_end : Int32
}

///|
fn Parser::new(
  s : String,
  ascii_only~ : Bool,
  scheme_required~ : Bool,
) -> Parser {
  {
    s,
    len: s.length(),
    ascii_only,
    scheme_required,
    pos: 0,
    scheme_end: 0,
    auth: None,
    path_start: 0,
    path_end: 0,
    query_end: 0,
  }
}

///|
/// Returns the code unit `i` positions ahead, or `-1` past the end of input.
fn Parser::peek(self : Parser, i : Int32) -> Int32 {
  code_or_eof(self.s, self.pos + i)
}

///|
fn Parser::has_remaining(self : Parser) -> Bool {
  self.pos < self.len
}

///|
fn Parser::skip(self : Parser, n : Int32) -> Unit {
  self.pos += n
}

///|
/// Reports a malformed percent-encoded octet.
///
/// The index is measured from the start of the current read rather than from
/// the offending octet, which is what the reference implementation does.
fn Parser::invalid_pct(self : Parser) -> Bool raise ParseError {
  let mut i = self.pos + 1
  if i < self.len && is_hexdig(code_at(self.s, i)) {
    i += 1
  }
  raise UnexpectedCharOrEnd(index=i)
}

///|
/// Reads the longest prefix of the remaining input allowed by `table`,
/// returning whether anything was read.
fn Parser::read(self : Parser, table : @enc.Table) -> Bool raise ParseError {
  let start = self.pos
  let pct = table.allows_pct_encoded()
  let non_ascii = table.allows_non_ascii()
  let mut i = self.pos
  while i < self.len {
    let x = code_at(self.s, i)
    if pct && x == '%' {
      if i + 2 >= self.len {
        return self.invalid_pct()
      }
      if !is_hexdig_pair(code_at(self.s, i + 1), code_at(self.s, i + 2)) {
        return self.invalid_pct()
      }
      i += 3
    } else if non_ascii {
      let (cp, w) = next_code_point(self.s, i)
      if !table.allows_code_point(cp) {
        break
      }
      i += w
    } else {
      if !table.allows_ascii(x) {
        break
      }
      i += 1
    }
  }
  self.pos = i
  self.pos > start
}

///|
/// Reads either the URI table or the IRI table, depending on the constraints.
fn Parser::select_read(
  self : Parser,
  uri_table : @enc.Table,
  iri_table : @enc.Table,
) -> Bool raise ParseError {
  if self.ascii_only {
    self.read(uri_table)
  } else {
    self.read(iri_table)
  }
}

///|
/// Reads `t` if the remaining input starts with it.
fn Parser::read_str(self : Parser, t : String) -> Bool {
  let n = t.length()
  if self.pos + n > self.len {
    return false
  }
  for i in 0..<n {
    if code_at(self.s, self.pos + i) != code_at(t, i) {
      return false
    }
  }
  self.skip(n)
  true
}

///|
fn Parser::peek_digit(self : Parser, i : Int32) -> Int32 {
  let x = self.peek(i)
  if x >= '0'.to_int() && x <= '9'.to_int() {
    x - '0'.to_int()
  } else {
    -1
  }
}

///|
fn Parser::read_v6(self : Parser) -> Ipv6Addr? {
  let segs : Array[Int32] = Array::make(8, 0)
  let mut ellipsis_idx = 8
  let mut i = 0
  while i < 8 {
    match self.read_v6_segment() {
      Some(SegNormal(seg, colon)) => {
        if colon == (i == 0 || i == ellipsis_idx) {
          // Leading colon, triple colons, or no colon.
          return None
        }
        segs[i] = seg
        i += 1
      }
      Some(SegEllipsis) => {
        if ellipsis_idx < 8 {
          // Multiple ellipses.
          return None
        }
        ellipsis_idx = i
      }
      Some(SegMaybeV4(colon)) => {
        if i > 6 || colon == (i == ellipsis_idx) {
          // Not enough space, triple colons, or no colon.
          return None
        }
        guard self.read_v4() is Some(addr) else { return None }
        let (a, b, c, d) = addr.octets()
        segs[i] = (a.to_int() << 8) | b.to_int()
        segs[i + 1] = (c.to_int() << 8) | d.to_int()
        i += 2
        break
      }
      Some(SegSingleColon) => return None
      None => break
    }
  }
  if ellipsis_idx == 8 {
    // No ellipsis.
    if i < 8 {
      // Too short.
      return None
    }
  } else if i == 8 {
    // Eliding nothing.
    return None
  } else {
    // Shift the segments after the ellipsis to the right.
    for j = i - 1; j >= ellipsis_idx; j = j - 1 {
      segs[8 - (i - j)] = segs[j]
      segs[j] = 0
    }
  }
  Some(
    Ipv6Addr::new(
      segs[0],
      segs[1],
      segs[2],
      segs[3],
      segs[4],
      segs[5],
      segs[6],
      segs[7],
    ),
  )
}

///|
fn Parser::read_v6_segment(self : Parser) -> Seg? {
  let colon = self.read_str(":")
  if !self.has_remaining() {
    return if colon { Some(SegSingleColon) } else { None }
  }
  let first = self.peek(0)
  let mut x = decode_hexdig(first)
  if x < 0 {
    if !colon {
      return None
    }
    if first == ':' {
      self.skip(1)
      return Some(SegEllipsis)
    }
    return Some(SegSingleColon)
  }
  let mut i = 1
  while i < 4 {
    let b = self.peek(i)
    if b < 0 {
      self.skip(i)
      return None
    }
    let v = decode_hexdig(b)
    if v >= 0 {
      x = (x << 4) | v
      i += 1
    } else if b == '.' {
      return Some(SegMaybeV4(colon))
    } else {
      break
    }
  }
  self.skip(i)
  Some(SegNormal(x, colon))
}

///|
fn Parser::read_v4(self : Parser) -> Ipv4Addr? {
  guard self.read_v4_octet() is Some(a) else { return None }
  let octets = [a, 0, 0, 0]
  for i in 1..<4 {
    if !self.read_str(".") {
      return None
    }
    guard self.read_v4_octet() is Some(x) else { return None }
    octets[i] = x
  }
  Some(
    Ipv4Addr(
      octets[0].to_byte(),
      octets[1].to_byte(),
      octets[2].to_byte(),
      octets[3].to_byte(),
    ),
  )
}

///|
fn Parser::read_v4_octet(self : Parser) -> Int32? {
  let mut res = self.peek_digit(0)
  if res < 0 {
    return None
  }
  if res == 0 {
    self.skip(1)
    return Some(0)
  }
  for i in 1..<3 {
    let x = self.peek_digit(i)
    if x < 0 {
      self.skip(i)
      return Some(res)
    }
    res = res * 10 + x
  }
  self.skip(3)
  if res <= 255 {
    Some(res)
  } else {
    None
  }
}

///|
fn Parser::read_port(self : Parser) -> Unit {
  if self.read_str(":") {
    let mut i = 0
    while self.peek_digit(i) >= 0 {
      i += 1
    }
    self.skip(i)
  }
}

///|
fn Parser::read_ip_literal(self : Parser) -> HostMeta? raise ParseError {
  if !self.read_str("[") {
    return None
  }
  let start = self.pos
  let meta = match self.read_v6() {
    Some(addr) => HIpv6(addr)
    None =>
      if self.pos == start {
        self.read_ipv_future()
        HIpvFuture
      } else {
        raise InvalidIpv6Addr(index=start)
      }
  }
  if !self.read_str("]") {
    raise UnexpectedCharOrEnd(index=self.pos)
  }
  Some(meta)
}

///|
fn Parser::read_ipv_future(self : Parser) -> Unit raise ParseError {
  let x = self.peek(0)
  if x == 'v' || x == 'V' {
    self.skip(1)
    if self.read(@enc.table_hexdig) &&
      self.read_str(".") &&
      self.read(@enc.table_ipv_future) {
      return
    }
  }
  raise UnexpectedCharOrEnd(index=self.pos)
}

///|
fn Parser::read_v4_or_reg_name(self : Parser) -> HostMeta raise ParseError {
  let addr = self.read_v4()
  let read_more = self.select_read(@enc.table_reg_name, @enc.table_ireg_name)
  match (addr, read_more) {
    (Some(a), false) => HIpv4(a)
    _ => HRegName
  }
}

///|
fn Parser::read_host(self : Parser) -> HostMeta raise ParseError {
  match self.read_ip_literal() {
    Some(host) => host
    None => self.read_v4_or_reg_name()
  }
}

///|
fn Parser::parse_from_scheme(self : Parser) -> Unit raise ParseError {
  self.read(@enc.table_scheme) |> ignore
  if self.peek(0) == ':' {
    // A scheme starts with a letter.
    if self.pos > 0 && @enc.table_alpha.allows_ascii(code_at(self.s, 0)) {
      self.scheme_end = self.pos
    } else {
      raise UnexpectedCharOrEnd(index=0)
    }
    self.skip(1)
    if self.read_str("//") {
      return self.parse_from_authority()
    }
    return self.parse_from_path(General)
  } else if self.scheme_required {
    raise UnexpectedCharOrEnd(index=self.pos)
  } else if self.pos == 0 {
    // Nothing read.
    if self.read_str("//") {
      return self.parse_from_authority()
    }
  }
  // Scheme characters are valid for a path.
  self.parse_from_path(ContinuedNoScheme)
}

///|
fn Parser::parse_from_authority(self : Parser) -> Unit raise ParseError {
  // We first try to read a host and a port, noting that
  // a reg-name or IPv4address can also be part of userinfo.
  let host_start = self.pos
  let host_meta = self.read_host()
  let mut auth_meta = { host_start, host_end: self.pos, host_meta, }
  self.read_port()
  if host_meta is (HIpv4(_) | HRegName) {
    let userinfo_read = self.select_read(
      @enc.table_userinfo, @enc.table_iuserinfo,
    )
    if self.peek(0) == '@' {
      // @enc.Userinfo present.
      self.skip(1)
      let host_start = self.pos
      let host_meta = self.read_host()
      auth_meta = { host_start, host_end: self.pos, host_meta, }
      self.read_port()
    } else if userinfo_read {
      raise UnexpectedCharOrEnd(index=self.pos)
    }
  }
  self.auth = Some(auth_meta)
  self.parse_from_path(AbEmpty)
}

///|
fn Parser::parse_from_path(
  self : Parser,
  kind : PathKind,
) -> Unit raise ParseError {
  let path_start = match kind {
    General | AbEmpty => self.pos
    ContinuedNoScheme => {
      self.select_read(@enc.table_segment_nz_nc, @enc.table_isegment_nz_nc)
      |> ignore
      if self.peek(0) == ':' {
        // In a relative reference, the first path
        // segment cannot contain a colon character.
        raise UnexpectedCharOrEnd(index=self.pos)
      }
      0
    }
  }
  if self.select_read(@enc.table_path, @enc.table_ipath) &&
    kind == AbEmpty &&
    code_at(self.s, path_start) != '/' {
    raise UnexpectedCharOrEnd(index=path_start)
  }
  self.path_start = path_start
  self.path_end = self.pos
  if self.read_str("?") {
    self.select_read(@enc.table_query, @enc.table_iquery) |> ignore
    self.query_end = self.pos
  }
  if self.read_str("#") {
    self.select_read(@enc.table_fragment, @enc.table_ifragment) |> ignore
  }
  if self.has_remaining() {
    raise UnexpectedCharOrEnd(index=self.pos)
  }
}

///|
/// Parses a URI/IRI (reference) into its components.
fn parse_ri(
  s : String,
  ascii_only~ : Bool,
  scheme_required~ : Bool,
) -> Ri raise ParseError {
  let p = Parser::new(s, ascii_only~, scheme_required~)
  p.parse_from_scheme()
  let scheme = if p.scheme_end > 0 {
    Some(scheme_validated(slice(s, 0, p.scheme_end)))
  } else {
    None
  }
  let authority = match p.auth {
    Some(am) => {
      let start = if p.scheme_end > 0 { p.scheme_end + 3 } else { 2 }
      let end = p.path_start
      let host = slice(s, am.host_start, am.host_end)
      let host_parsed : Host[@enc.IRegName] = match am.host_meta {
        HIpv4(addr) => Ipv4(addr)
        HIpv6(addr) => Ipv6(addr)
        HIpvFuture => IpvFuture
        HRegName => RegName(estr(host))
      }
      Some({
        userinfo: if am.host_start > start {
          Some(estr(slice(s, start, am.host_start - 1)))
        } else {
          None
        },
        host,
        host_parsed,
        port: if am.host_end < end {
          Some(estr(slice(s, am.host_end + 1, end)))
        } else {
          None
        },
      })
    }
    None => None
  }
  let query_or_path_end = if p.query_end > 0 { p.query_end } else { p.path_end }
  {
    text: s,
    scheme,
    authority,
    path: slice(s, p.path_start, p.path_end),
    query: if p.query_end > 0 {
      Some(slice(s, p.path_end + 1, p.query_end))
    } else {
      None
    },
    fragment: if query_or_path_end < p.len {
      Some(slice(s, query_or_path_end + 1, p.len))
    } else {
      None
    },
  }
}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend ParseError with Eq::{not_equal, equal}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend ParseError with Debug::{to_repr}

///|
pub extend ParseError with Show::{to_string}

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend ParseError with Show::{output}
