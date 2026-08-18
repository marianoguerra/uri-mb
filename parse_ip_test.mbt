///|
/// Tests ported from `tests/parse_ip.rs` of `fluent-uri`.

///|
/// Parses `s` as the host of a URI reference and returns the IPv4 address it
/// denotes, if any.
fn parse_v4(s : String) -> @uri.Ipv4Addr? {
  let r = @uri.UriRef::parse("//" + s) catch { _ => return None }
  guard r.authority is Some(a) else { return None }
  match a.host_parsed {
    Ipv4(addr) => Some(addr)
    _ => None
  }
}

///|
/// Parses `s` as the IP literal host of a URI reference and returns the IPv6
/// address it denotes, if any.
fn parse_v6(s : String) -> @uri.Ipv6Addr? {
  let r = @uri.UriRef::parse("//[" + s + "]") catch { _ => return None }
  guard r.authority is Some(a) else { return None }
  match a.host_parsed {
    Ipv6(addr) => Some(addr)
    _ => None
  }
}

///|
test "parse v4" {
  assert_eq(parse_v4("127.0.0.1"), Some(@uri.Ipv4Addr::new(127, 0, 0, 1)))
  assert_eq(
    parse_v4("255.255.255.255"),
    Some(@uri.Ipv4Addr::new(255, 255, 255, 255)),
  )
  assert_eq(parse_v4("0.0.0.0"), Some(@uri.Ipv4Addr::new(0, 0, 0, 0)))
  // Out of range.
  assert_eq(parse_v4("256.0.0.1"), None)
  // Too short.
  assert_eq(parse_v4("255.0.0"), None)
  // Too long.
  assert_eq(parse_v4("255.0.0.1.2"), None)
  // No number between dots.
  assert_eq(parse_v4("255.0..1"), None)
  // Octal.
  assert_eq(parse_v4("255.0.0.01"), None)
  // Octal zero.
  assert_eq(parse_v4("255.0.0.00"), None)
  assert_eq(parse_v4("255.0.00.0"), None)
  // Leading dot.
  assert_eq(parse_v4(".0.0.0.0"), None)
  // Trailing dot.
  assert_eq(parse_v4("0.0.0.0."), None)
}

///|
test "parse v6" {
  assert_eq(
    parse_v6("0:0:0:0:0:0:0:0"),
    Some(@uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 0)),
  )
  assert_eq(
    parse_v6("1:02:003:0004:0005:006:07:8"),
    Some(@uri.Ipv6Addr::new(1, 2, 3, 4, 5, 6, 7, 8)),
  )
  assert_eq(parse_v6("::1"), Some(@uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 1)))
  assert_eq(parse_v6("1::"), Some(@uri.Ipv6Addr::new(1, 0, 0, 0, 0, 0, 0, 0)))
  assert_eq(parse_v6("::"), Some(@uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 0)))
  assert_eq(
    parse_v6("2a02:6b8::11:11"),
    Some(@uri.Ipv6Addr::new(0x2a02, 0x6b8, 0, 0, 0, 0, 0x11, 0x11)),
  )
  assert_eq(
    parse_v6("::2:3:4:5:6:7:8"),
    Some(@uri.Ipv6Addr::new(0, 2, 3, 4, 5, 6, 7, 8)),
  )
  assert_eq(
    parse_v6("1:2:3:4::6:7:8"),
    Some(@uri.Ipv6Addr::new(1, 2, 3, 4, 0, 6, 7, 8)),
  )
  assert_eq(
    parse_v6("1:2:3:4:5:6:7::"),
    Some(@uri.Ipv6Addr::new(1, 2, 3, 4, 5, 6, 7, 0)),
  )
  // Only a colon.
  assert_eq(parse_v6(":"), None)
  // Too long a group.
  assert_eq(parse_v6("::00000"), None)
  // Too short.
  assert_eq(parse_v6("1:2:3:4:5:6:7"), None)
  // Too long.
  assert_eq(parse_v6("1:2:3:4:5:6:7:8:9"), None)
  // Triple colon.
  assert_eq(parse_v6("1:2:::6:7:8"), None)
  assert_eq(parse_v6("1:2:::"), None)
  assert_eq(parse_v6(":::6:7:8"), None)
  assert_eq(parse_v6(":::"), None)
  // Two double colons.
  assert_eq(parse_v6("1:2::6::8"), None)
  assert_eq(parse_v6("::6::8"), None)
  assert_eq(parse_v6("1:2::6::"), None)
  assert_eq(parse_v6("::2:6::"), None)
  // `::` indicating zero groups of zeros.
  assert_eq(parse_v6("::1:2:3:4:5:6:7:8"), None)
  assert_eq(parse_v6("1:2:3:4::5:6:7:8"), None)
  assert_eq(parse_v6("1:2:3:4:5:6:7:8::"), None)
  // Leading colon.
  assert_eq(parse_v6(":1:2:3:4:5:6:7:8"), None)
  assert_eq(parse_v6(":1::1"), None)
  assert_eq(parse_v6(":1"), None)
  // Trailing colon.
  assert_eq(parse_v6("1:2:3:4:5:6:7:8:"), None)
  assert_eq(parse_v6("1::1:"), None)
  assert_eq(parse_v6("1:"), None)
}

///|
test "parse v4 in v6" {
  assert_eq(
    parse_v6("::192.0.2.33"),
    Some(@uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0, 49152, 545)),
  )
  assert_eq(
    parse_v6("::FFFF:192.0.2.33"),
    Some(@uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0xFFFF, 49152, 545)),
  )
  assert_eq(
    parse_v6("64:ff9b::192.0.2.33"),
    Some(@uri.Ipv6Addr::new(0x64, 0xff9b, 0, 0, 0, 0, 49152, 545)),
  )
  assert_eq(
    parse_v6("2001:db8:122:c000:2:2100:192.0.2.33"),
    Some(
      @uri.Ipv6Addr::new(0x2001, 0xdb8, 0x122, 0xc000, 0x2, 0x2100, 49152, 545),
    ),
  )
  // Colon after v4.
  assert_eq(parse_v6("::127.0.0.1:"), None)
  // Not enough groups.
  assert_eq(parse_v6("1:2:3:4:5:127.0.0.1"), None)
  // Too many groups.
  assert_eq(parse_v6("1:2:3:4:5:6:7:127.0.0.1"), None)
  // Triple colons before v4.
  assert_eq(parse_v6(":::4.4.4.4"), None)
  // No colon before v4.
  assert_eq(parse_v6("::ffff4.4.4.4"), None)
}

///|
test "format ip addr" {
  inspect(@uri.Ipv4Addr::new(127, 0, 0, 1), content="127.0.0.1")
  inspect(@uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 1), content="::1")
  inspect(@uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0, 0, 0), content="::")
  inspect(
    @uri.Ipv6Addr::new(0x2001, 0xdb8, 0, 0, 0, 0, 0, 7),
    content="2001:db8::7",
  )
  inspect(
    @uri.Ipv6Addr::new(0, 0, 0, 0, 0, 0xffff, 0xc000, 0x201),
    content="::ffff:192.0.2.1",
  )
  inspect(@uri.Ipv6Addr::new(1, 2, 3, 4, 5, 6, 7, 8), content="1:2:3:4:5:6:7:8")
  inspect(@uri.Ipv6Addr::new(0, 1, 0, 1, 0, 1, 0, 1), content="0:1:0:1:0:1:0:1")
}
