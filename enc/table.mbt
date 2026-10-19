///|
/// Byte pattern tables from RFC 3986 and RFC 3987.
///
/// A `Table` specifies which unencoded characters, and whether percent-encoded
/// octets, are allowed in a string. Tables are combined with [`Table::or`] and
/// friends to describe the ABNF rules of URI/IRI components.
///
/// The predefined tables in this package are documented with the ABNF notation
/// of [RFC 5234](https://datatracker.ietf.org/doc/html/rfc5234).
pub struct Table(UInt64, UInt64) derive(Eq)

///|
/// Bit `b'%'` of the low word marks a table as allowing percent-encoded octets.
let mask_pct_encoded : UInt64 = 1UL << 37

///|
/// Bit 0 of the low word marks a table as allowing `ucschar` (RFC 3987).
let mask_ucschar : UInt64 = 1UL

///|
/// Bit 1 of the low word marks a table as allowing `iprivate` (RFC 3987).
let mask_iprivate : UInt64 = 2UL

///|
/// Bits of the low word that stand for actual unencoded ASCII characters.
/// Codes 0, 1 and `b'%'` are never allowed unencoded, so their bits are free
/// to be used as the markers above.
let mask_unencoded_ascii : UInt64 = 0xFFFF_FFFF_FFFF_FFFFUL ^
  (mask_pct_encoded | mask_ucschar | mask_iprivate)

///|
/// `ucschar = %xA0-D7FF / %xF900-FDCF / %xFDF0-FFEF / ...` (RFC 3987)
fn is_ucschar(x : Int32) -> Bool {
  (x >= 0xa0 && x <= 0xd7ff) ||
  (x >= 0xf900 && x <= 0xfdcf) ||
  (x >= 0xfdf0 && x <= 0xffef) ||
  (x >= 0x10000 && x <= 0xdffff && (x & 0xffff) <= 0xfffd) ||
  (x >= 0xe1000 && x <= 0xefffd)
}

///|
/// `iprivate = %xE000-F8FF / %xF0000-FFFFD / %x100000-10FFFD` (RFC 3987)
fn is_iprivate(x : Int32) -> Bool {
  (x >= 0xe000 && x <= 0xf8ff) || (x >= 0xf0000 && (x & 0xffff) <= 0xfffd)
}

///|
/// Creates a table that only allows the given unencoded characters.
///
/// # Panics
///
/// Panics if any of the characters is not ASCII or equals `'\u{0}'`,
/// `'\u{1}'`, or `'%'`.
///
/// ```mbt check
/// test {
///   let t = @enc.Table::new("abc")
///   assert_true(t.allows('a'))
///   assert_false(t.allows('d'))
///   assert_false(t.allows_pct_encoded())
/// }
/// ```
pub fn Table::new(chars : String) -> Table {
  let mut lo = 0UL
  let mut hi = 0UL
  for ch in chars {
    let x = ch.to_int()
    guard x != 0 && x != 1 && x != 0x25 && x < 128 else {
      abort("cannot allow non-ASCII character, U+0000, U+0001, or '%'")
    }
    if x < 64 {
      lo = lo | (1UL << x)
    } else {
      hi = hi | (1UL << (x - 64))
    }
  }
  Table(lo, hi)
}

///|
/// Combines two tables into one.
///
/// Returns a new table that allows all the byte patterns allowed
/// by `self` or by `other`.
pub fn Table::or(self : Table, other : Table) -> Table {
  Table(self.0 | other.0, self.1 | other.1)
}

///|
/// Marks this table as allowing percent-encoded octets.
pub fn Table::or_pct_encoded(self : Table) -> Table {
  Table(self.0 | mask_pct_encoded, self.1)
}

///|
/// Marks this table as allowing characters matching the [`ucschar`] ABNF rule
/// from RFC 3987.
///
/// [`ucschar`]: https://datatracker.ietf.org/doc/html/rfc3987#section-2.2
pub fn Table::or_ucschar(self : Table) -> Table {
  Table(self.0 | mask_ucschar, self.1)
}

///|
/// Marks this table as allowing characters matching the [`iprivate`] ABNF rule
/// from RFC 3987.
///
/// [`iprivate`]: https://datatracker.ietf.org/doc/html/rfc3987#section-2.2
pub fn Table::or_iprivate(self : Table) -> Table {
  Table(self.0 | mask_iprivate, self.1)
}

///|
/// Subtracts from this table.
///
/// Returns a new table that allows all the byte patterns allowed
/// by `self` but not allowed by `other`.
pub fn Table::sub(self : Table, other : Table) -> Table {
  Table(self.0 & other.0.lnot(), self.1 & other.1.lnot())
}

///|
/// Checks whether the table is a subset of another, i.e., `other`
/// allows at least all the byte patterns allowed by `self`.
pub fn Table::is_subset(self : Table, other : Table) -> Bool {
  (self.0 & other.0) == self.0 && (self.1 & other.1) == self.1
}

///|
/// Checks whether the given ASCII code is allowed unencoded by the table.
pub fn Table::allows_ascii(self : Table, x : Int32) -> Bool {
  if x < 64 {
    (self.0 & mask_unencoded_ascii & (1UL << x)) != 0
  } else if x < 128 {
    (self.1 & (1UL << (x - 64))) != 0
  } else {
    false
  }
}

///|
/// Checks whether the table allows any non-ASCII character.
pub fn Table::allows_non_ascii(self : Table) -> Bool {
  (self.0 & (mask_ucschar | mask_iprivate)) != 0
}

///|
/// Checks whether the given code point is allowed unencoded by the table.
pub fn Table::allows_code_point(self : Table, x : Int32) -> Bool {
  if x < 128 {
    self.allows_ascii(x)
  } else if (self.0 & mask_ucschar) != 0 && is_ucschar(x) {
    true
  } else {
    (self.0 & mask_iprivate) != 0 && is_iprivate(x)
  }
}

///|
/// Checks whether the given unencoded character is allowed by the table.
pub fn Table::allows(self : Table, ch : Char) -> Bool {
  self.allows_code_point(ch.to_int())
}

///|
/// Checks whether percent-encoded octets are allowed by the table.
pub fn Table::allows_pct_encoded(self : Table) -> Bool {
  (self.0 & mask_pct_encoded) != 0
}

// Rules from RFC 3986:

///|
/// `ALPHA = %x41-5A / %x61-7A`
pub let table_alpha : Table = Table::new(
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
)

///|
/// `DIGIT = %x30-39`
pub let table_digit : Table = Table::new("0123456789")

///|
/// `HEXDIG = DIGIT / "A" / "B" / "C" / "D" / "E" / "F"`
pub let table_hexdig : Table = table_digit.or(Table::new("ABCDEFabcdef"))

///|
/// `scheme = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )`
pub let table_scheme : Table = table_alpha.or(table_digit).or(Table::new("+-."))

///|
/// `unreserved = ALPHA / DIGIT / "-" / "." / "_" / "~"`
pub let table_unreserved : Table = table_alpha
  .or(table_digit)
  .or(Table::new("-._~"))

///|
/// `gen-delims = ":" / "/" / "?" / "#" / "[" / "]" / "@"`
pub let table_gen_delims : Table = Table::new(":/?#[]@")

///|
/// `sub-delims = "!" / "$" / "&" / "'" / "(" / ")"
///             / "*" / "+" / "," / ";" / "="`
pub let table_sub_delims : Table = Table::new("!$&'()*+,;=")

///|
/// `reserved = gen-delims / sub-delims`
pub let table_reserved : Table = table_gen_delims.or(table_sub_delims)

///|
/// `userinfo = *( unreserved / pct-encoded / sub-delims / ":" )`
pub let table_userinfo : Table = table_unreserved
  .or(table_sub_delims)
  .or(Table::new(":"))
  .or_pct_encoded()

///|
/// `IPvFuture = "v" 1*HEXDIG "." 1*( unreserved / sub-delims / ":" )`
pub let table_ipv_future : Table = table_unreserved
  .or(table_sub_delims)
  .or(Table::new(":"))

///|
/// `reg-name = *( unreserved / pct-encoded / sub-delims )`
pub let table_reg_name : Table = table_unreserved
  .or(table_sub_delims)
  .or_pct_encoded()

///|
/// `pchar = unreserved / pct-encoded / sub-delims / ":" / "@"`
pub let table_pchar : Table = table_unreserved
  .or(table_sub_delims)
  .or(Table::new(":@"))
  .or_pct_encoded()

///|
/// `path = *( pchar / "/" )`
pub let table_path : Table = table_pchar.or(Table::new("/"))

///|
/// `segment-nz-nc = 1*( unreserved / pct-encoded / sub-delims / "@" )`
pub let table_segment_nz_nc : Table = table_unreserved
  .or(table_sub_delims)
  .or(Table::new("@"))
  .or_pct_encoded()

///|
/// `query = *( pchar / "/" / "?" )`
pub let table_query : Table = table_pchar.or(Table::new("/?"))

///|
/// `fragment = *( pchar / "/" / "?" )`
pub let table_fragment : Table = table_query

// Rules from RFC 3987:

///|
/// `iuserinfo = *( iunreserved / pct-encoded / sub-delims / ":" )`
pub let table_iuserinfo : Table = table_userinfo.or_ucschar()

///|
/// `ireg-name = *( iunreserved / pct-encoded / sub-delims )`
pub let table_ireg_name : Table = table_reg_name.or_ucschar()

///|
/// `ipath = *( ipchar / "/" )`
pub let table_ipath : Table = table_path.or_ucschar()

///|
/// `isegment-nz-nc = 1*( iunreserved / pct-encoded / sub-delims / "@" )`
pub let table_isegment_nz_nc : Table = table_segment_nz_nc.or_ucschar()

///|
/// `iquery = *( ipchar / iprivate / "/" / "?" )`
pub let table_iquery : Table = table_query.or_ucschar().or_iprivate()

///|
/// `ifragment = *( ipchar / "/" / "?" )`
pub let table_ifragment : Table = table_fragment.or_ucschar()

///|
#deprecated(skip_current_package=true)
#doc(hidden)
pub extend Table with Eq::{not_equal, equal}
