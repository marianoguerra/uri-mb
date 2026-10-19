///|
/// UTF-16/UTF-8 helpers.
///
/// MoonBit strings are sequences of UTF-16 code units, whereas RFC 3986/3987
/// are defined over UTF-8 octets. Percent-encoding therefore has to go through
/// the UTF-8 encoding of a string, and percent-decoding has to reassemble
/// (possibly ill-formed) UTF-8 octets back into a string.

///|
/// Returns the UTF-16 code unit at `i` as an `Int`.
fn code_at(s : String, i : Int32) -> Int32 {
  s[i].to_int()
}

///|
/// Returns the code unit at `i`, or `-1` if `i` is out of bounds.
fn code_or_eof(s : String, i : Int32) -> Int32 {
  if i < 0 || i >= s.length() {
    -1
  } else {
    s[i].to_int()
  }
}

///|
/// Returns the code point starting at `i` together with its length in code
/// units. An unpaired surrogate is returned as is, which no table allows.
fn next_code_point(s : String, i : Int32) -> (Int32, Int32) {
  let c = code_at(s, i)
  if c >= 0xd800 && c <= 0xdbff && i + 1 < s.length() {
    let d = code_at(s, i + 1)
    if d >= 0xdc00 && d <= 0xdfff {
      return (0x10000 + ((c - 0xd800) << 10) + (d - 0xdc00), 2)
    }
  }
  (c, 1)
}

///|
/// Returns the substring between the two code unit offsets.
fn slice(s : String, start : Int32, end : Int32) -> String {
  if start == 0 && end == s.length() {
    s
  } else {
    s.view(start_offset=start, end_offset=end).to_owned()
  }
}

///|
/// Lowercases the ASCII letters of `s`, leaving other characters untouched.
fn ascii_lowercase(s : String) -> String {
  let mut needed = false
  for i in 0..<s.length() {
    let x = code_at(s, i)
    if x >= 'A'.to_int() && x <= 'Z'.to_int() {
      needed = true
      break
    }
  }
  if !needed {
    return s
  }
  let sb = StringBuilder(size_hint=s.length())
  for ch in s {
    if ch >= 'A' && ch <= 'Z' {
      sb.write_char((ch.to_int() + 32).to_char().unwrap())
    } else {
      sb.write_char(ch)
    }
  }
  sb.to_string()
}

///|
/// Appends the UTF-8 encoding of `cp` to `out`.
fn utf8_encode_code_point(out : Array[Byte], cp : Int32) -> Unit {
  if cp < 0x80 {
    out.push(cp.to_byte())
  } else if cp < 0x800 {
    out.push((0xc0 | (cp >> 6)).to_byte())
    out.push((0x80 | (cp & 0x3f)).to_byte())
  } else if cp < 0x10000 {
    out.push((0xe0 | (cp >> 12)).to_byte())
    out.push((0x80 | ((cp >> 6) & 0x3f)).to_byte())
    out.push((0x80 | (cp & 0x3f)).to_byte())
  } else {
    out.push((0xf0 | (cp >> 18)).to_byte())
    out.push((0x80 | ((cp >> 12) & 0x3f)).to_byte())
    out.push((0x80 | ((cp >> 6) & 0x3f)).to_byte())
    out.push((0x80 | (cp & 0x3f)).to_byte())
  }
}

///|
/// Returns the expected length of the UTF-8 sequence starting with the
/// non-ASCII octet `x`, or `0` if `x` cannot start one.
fn utf8_char_width(x : Int32) -> Int32 {
  if x < 0xc2 {
    0
  } else if x < 0xe0 {
    2
  } else if x < 0xf0 {
    3
  } else if x < 0xf5 {
    4
  } else {
    0
  }
}

///|
/// Decodes a byte range known to be well-formed UTF-8 into a string.
fn utf8_decode_valid(b : ArrayView[Byte], start : Int32, end : Int32) -> String {
  let sb = StringBuilder(size_hint=end - start)
  let mut i = start
  while i < end {
    let x = b[i].to_int()
    let cp = if x < 0x80 {
      i += 1
      x
    } else if x < 0xe0 {
      let v = ((x & 0x1f) << 6) | (b[i + 1].to_int() & 0x3f)
      i += 2
      v
    } else if x < 0xf0 {
      let v = ((x & 0x0f) << 12) |
        ((b[i + 1].to_int() & 0x3f) << 6) |
        (b[i + 2].to_int() & 0x3f)
      i += 3
      v
    } else {
      let v = ((x & 0x07) << 18) |
        ((b[i + 1].to_int() & 0x3f) << 12) |
        ((b[i + 2].to_int() & 0x3f) << 6) |
        (b[i + 3].to_int() & 0x3f)
      i += 4
      v
    }
    sb.write_char(cp.to_char().unwrap())
  }
  sb.to_string()
}

///|
/// Splits `b` into chunks of a maximal well-formed UTF-8 run followed by a
/// maximal invalid sequence, following the "maximal subpart" rule of the
/// Unicode standard (the same one Rust's `String::from_utf8_lossy` uses).
///
/// `on_chunk` receives the decoded valid run (possibly empty) and the offsets
/// of the invalid sequence that follows it (empty when the run reaches the end
/// of the input). No chunk is emitted for empty input.
fn utf8_chunks(
  b : ArrayView[Byte],
  on_chunk : (String, ArrayView[Byte]) -> Unit,
) -> Unit {
  let len = b.length()
  let mut valid_start = 0
  let mut i = 0

  ///|
  fn is_cont(j : Int32) -> Bool {
    let x = b[j].to_int()
    x >= 0x80 && x <= 0xbf
  }

  while i < len {
    let first = b[i].to_int()
    if first < 0x80 {
      i += 1
      continue
    }
    // Number of invalid octets, or 0 if the sequence at `i` is well-formed.
    let mut bad = 0
    let w = utf8_char_width(first)
    if w == 0 {
      bad = 1
    } else if i + 1 >= len {
      bad = len - i
    } else {
      let second = b[i + 1].to_int()
      let second_ok = if w == 2 {
        second >= 0x80 && second <= 0xbf
      } else if w == 3 {
        if first == 0xe0 {
          second >= 0xa0 && second <= 0xbf
        } else if first == 0xed {
          second >= 0x80 && second <= 0x9f
        } else {
          second >= 0x80 && second <= 0xbf
        }
      } else if first == 0xf0 {
        second >= 0x90 && second <= 0xbf
      } else if first == 0xf4 {
        second >= 0x80 && second <= 0x8f
      } else {
        second >= 0x80 && second <= 0xbf
      }
      if !second_ok {
        bad = 1
      } else if w == 2 {
        i += 2
        continue
      } else if i + 2 >= len {
        bad = len - i
      } else if !is_cont(i + 2) {
        bad = 2
      } else if w == 3 {
        i += 3
        continue
      } else if i + 3 >= len {
        bad = len - i
      } else if !is_cont(i + 3) {
        bad = 3
      } else {
        i += 4
        continue
      }
    }
    on_chunk(utf8_decode_valid(b, valid_start, i), b[i:i + bad])
    i += bad
    valid_start = i
  }
  if i > valid_start {
    on_chunk(utf8_decode_valid(b, valid_start, i), b[i:i])
  }
}
