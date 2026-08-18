///|
/// Low-level percent-encoding primitives.

///|
let hex_digits : String = "0123456789ABCDEF"

///|
/// Returns the value of the hexadecimal digit `x`, or `-1` if `x` is not one.
fn decode_hexdig(x : Int) -> Int {
  if x >= '0'.to_int() && x <= '9'.to_int() {
    x - '0'.to_int()
  } else if x >= 'A'.to_int() && x <= 'F'.to_int() {
    x - 'A'.to_int() + 10
  } else if x >= 'a'.to_int() && x <= 'f'.to_int() {
    x - 'a'.to_int() + 10
  } else {
    -1
  }
}

///|
/// Checks whether `x` is a hexadecimal digit.
fn is_hexdig(x : Int) -> Bool {
  decode_hexdig(x) >= 0
}

///|
/// Checks whether `hi` and `lo` are both hexadecimal digits.
fn is_hexdig_pair(hi : Int, lo : Int) -> Bool {
  is_hexdig(hi) && is_hexdig(lo)
}

///|
/// Decodes the octet represented by the hexadecimal digits `hi` and `lo`.
fn decode_octet(hi : Int, lo : Int) -> Int {
  (decode_hexdig(hi) << 4) | decode_hexdig(lo)
}

///|
/// Percent-encodes a single octet, e.g. `0x2f` to `"%2F"`.
fn encode_byte(x : Int) -> String {
  let sb = StringBuilder::new(size_hint=3)
  sb.write_char('%')
  sb.write_char(hex_digits.get_char((x >> 4) & 0xf).unwrap())
  sb.write_char(hex_digits.get_char(x & 0xf).unwrap())
  sb.to_string()
}

///|
/// Appends the percent-encoding of a single octet to `sb`.
fn push_encoded_byte(sb : StringBuilder, x : Int) -> Unit {
  sb.write_char('%')
  sb.write_char(hex_digits.get_char((x >> 4) & 0xf).unwrap())
  sb.write_char(hex_digits.get_char(x & 0xf).unwrap())
}

///|
/// Validates `s` against `table`, i.e., checks that it is formed only of
/// characters the table allows and, if the table allows them, percent-encoded
/// octets.
fn table_validate(table : @enc.Table, s : String) -> Bool {
  let pct = table.allows_pct_encoded()
  let non_ascii = table.allows_non_ascii()
  let len = s.length()
  let mut i = 0
  while i < len {
    let x = code_at(s, i)
    if pct && x == '%' {
      if i + 2 >= len {
        return false
      }
      if !is_hexdig_pair(code_at(s, i + 1), code_at(s, i + 2)) {
        return false
      }
      i += 3
    } else if non_ascii {
      let (cp, w) = next_code_point(s, i)
      if !table.allows_code_point(cp) {
        return false
      }
      i += w
    } else {
      if !table.allows_ascii(x) {
        return false
      }
      i += 1
    }
  }
  true
}
