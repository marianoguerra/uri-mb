///|
/// IP addresses appearing in the host subcomponent.

///|
/// An IPv4 address.
pub struct Ipv4Addr(Byte, Byte, Byte, Byte) derive(Eq, Compare, Hash)

///|
/// Creates an IPv4 address from its four octets.
pub fn Ipv4Addr::new(a : Byte, b : Byte, c : Byte, d : Byte) -> Ipv4Addr {
  Ipv4Addr(a, b, c, d)
}

///|
/// The address `127.0.0.1`.
pub let ipv4_localhost : Ipv4Addr = Ipv4Addr(127, 0, 0, 1)

///|
/// The address `0.0.0.0`.
pub let ipv4_unspecified : Ipv4Addr = Ipv4Addr(0, 0, 0, 0)

///|
/// Returns the four octets of the address.
pub fn Ipv4Addr::octets(self : Ipv4Addr) -> (Byte, Byte, Byte, Byte) {
  (self.0, self.1, self.2, self.3)
}

///|
pub impl Show for Ipv4Addr with fn output(self, logger) {
  logger.write_string(
    "\{self.0.to_int()}.\{self.1.to_int()}.\{self.2.to_int()}.\{self.3.to_int()}",
  )
}

///|
pub impl Debug for Ipv4Addr with fn to_repr(self) {
  Repr(self.to_string())
}

///|
/// An IPv6 address, stored as its sixteen octets.
pub struct Ipv6Addr(Bytes) derive(Eq, Compare, Hash)

///|
/// Creates an IPv6 address from its eight 16-bit segments.
pub fn Ipv6Addr::new(
  a : Int,
  b : Int,
  c : Int,
  d : Int,
  e : Int,
  f : Int,
  g : Int,
  h : Int,
) -> Ipv6Addr {
  let octets : Array[Byte] = []
  for seg in [a, b, c, d, e, f, g, h] {
    octets.push(((seg >> 8) & 0xff).to_byte())
    octets.push((seg & 0xff).to_byte())
  }
  Ipv6Addr(Bytes::from_array(octets))
}

///|
/// The address `::1`.
pub let ipv6_localhost : Ipv6Addr = Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 1)

///|
/// The address `::`.
pub let ipv6_unspecified : Ipv6Addr = Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 0)

///|
/// Returns the `i`th 16-bit segment of the address.
fn Ipv6Addr::seg(self : Ipv6Addr, i : Int) -> Int {
  (self.0[i * 2].to_int() << 8) | self.0[i * 2 + 1].to_int()
}

///|
/// Returns the eight 16-bit segments of the address.
pub fn Ipv6Addr::segments(self : Ipv6Addr) -> Array[Int] {
  let out = []
  for i in 0..<8 {
    out.push(self.seg(i))
  }
  out
}

///|
/// Returns the sixteen octets of the address.
pub fn Ipv6Addr::octets(self : Ipv6Addr) -> Bytes {
  self.0
}

///|
/// Formats the address in the canonical form of
/// [RFC 5952](https://datatracker.ietf.org/doc/html/rfc5952),
/// as `Ipv6Addr` in Rust does.
pub impl Show for Ipv6Addr with fn output(self, logger) {
  if self.seg(0) == 0 &&
    self.seg(1) == 0 &&
    self.seg(2) == 0 &&
    self.seg(3) == 0 &&
    self.seg(4) == 0 &&
    self.seg(5) == 0xffff {
    let a = self.0[12].to_int()
    let b = self.0[13].to_int()
    let c = self.0[14].to_int()
    let d = self.0[15].to_int()
    logger.write_string("::ffff:\{a}.\{b}.\{c}.\{d}")
    return
  }
  // Find the longest run of zero segments.
  let mut best_start = 0
  let mut best_len = 0
  let mut cur_start = 0
  let mut cur_len = 0
  for i in 0..<8 {
    if self.seg(i) == 0 {
      if cur_len == 0 {
        cur_start = i
      }
      cur_len += 1
      if cur_len > best_len {
        best_start = cur_start
        best_len = cur_len
      }
    } else {
      cur_len = 0
    }
  }

  ///|
  fn write_range(from : Int, to : Int) -> Unit {
    for i in from..<to {
      if i > from {
        logger.write_char(':')
      }
      logger.write_string(to_hex_lower(self.seg(i)))
    }
  }

  if best_len > 1 {
    write_range(0, best_start)
    logger.write_string("::")
    write_range(best_start + best_len, 8)
  } else {
    write_range(0, 8)
  }
}

///|
pub impl Debug for Ipv6Addr with fn to_repr(self) {
  Repr(self.to_string())
}

///|
/// Formats `x` as lowercase hexadecimal without leading zeros.
fn to_hex_lower(x : Int) -> String {
  if x == 0 {
    return "0"
  }
  let digits = "0123456789abcdef"
  let sb = StringBuilder(size_hint=4)
  let mut started = false
  for shift in [12, 8, 4, 0] {
    let d = (x >> shift) & 0xf
    if d != 0 || started {
      started = true
      sb.write_char(digits.get_char(d).unwrap())
    }
  }
  sb.to_string()
}
