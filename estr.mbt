///|
/// Percent-encoded string slices and buffers.

///|
/// A percent-encoded string.
///
/// # Type parameter
///
/// `EStr[E]` is parameterized over a type `E` that implements [`@enc.Encoder`].
/// The table `E::table()` specifies the byte patterns allowed in the string:
/// an `EStr[E]` is formed by joining any number of
///
/// - characters `ch` such that `E::table().allows(ch)`, and
/// - percent-encoded octets `"%XX"`, if `E::table().allows_pct_encoded()`.
///
/// # Comparison
///
/// `EStr`s are compared lexicographically by their code units.
/// Normalization is **not** performed prior to comparison.
///
/// # Examples
///
/// Parse key-value pairs from a query string into a map:
///
/// ```mbt check
/// test {
///   let s = "?name=%E5%BC%A0%E4%B8%89&speech=%C2%A1Ol%C3%A9%21"
///   let query = @uri.UriRef::parse(s).query.unwrap()
///   let map : Map[String, String] = Map([])
///   for pair in query.split('&') {
///     let (k, v) = pair.split_once('=').unwrap()
///     map[k.decode_to_string_lossy()] = v.decode_to_string_lossy()
///   }
///   assert_eq(map["name"], "张三")
///   assert_eq(map["speech"], "¡Olé!")
/// }
/// ```
#warnings("-unused_type_variable")
pub struct EStr[E] {
  inner : String
}

///|
/// Wraps a string that is known to be properly encoded with `E`.
fn[E] estr(s : String) -> EStr[E] {
  { inner: s }
}

///|
/// An empty `EStr`.
pub fn[E] EStr::empty() -> EStr[E] {
  { inner: "" }
}

///|
/// Converts a string to an `EStr`, returning `None` if it is not
/// properly encoded with `E`.
///
/// ```mbt check
/// test {
///   let s : @uri.EStr[@enc.Path]? = @uri.EStr::new("a%20b")
///   assert_true(s is Some(_))
///   let bad : @uri.EStr[@enc.Path]? = @uri.EStr::new("a%2")
///   assert_true(bad is None)
/// }
/// ```
pub fn[E : @enc.Encoder] EStr::new(s : String) -> EStr[E]? {
  if table_validate(E::table(), s) {
    Some({ inner: s })
  } else {
    None
  }
}

///|
/// Converts a string to an `EStr`.
///
/// # Panics
///
/// Panics if the string is not properly encoded with `E`.
/// For a non-panicking variant, use [`EStr::new`].
pub fn[E : @enc.Encoder] EStr::new_or_panic(s : String) -> EStr[E] {
  match EStr::new(s) {
    Some(v) => v
    None => abort("improperly encoded string: \{s}")
  }
}

///|
/// Forcefully percent-encodes the given octet to an `EStr`.
///
/// # Panics
///
/// Panics if `E::table()` does not allow percent-encoded octets.
///
/// ```mbt check
/// test {
///   let s : @uri.EStr[@enc.Path] = @uri.EStr::force_encode_byte(b'/')
///   inspect(s, content="%2F")
/// }
/// ```
pub fn[E : @enc.Encoder] EStr::force_encode_byte(x : Byte) -> EStr[E] {
  guard E::table().allows_pct_encoded() else {
    abort("table does not allow percent-encoded octets")
  }
  { inner: encode_byte(x.to_int()) }
}

///|
/// Reinterprets the `EStr` with another encoder, assuming validity.
fn[E, F] EStr::cast(self : EStr[E]) -> EStr[F] {
  { inner: self.inner }
}

///|
/// Returns the `EStr` as a string.
pub fn[E] EStr::as_str(self : EStr[E]) -> String {
  self.inner
}

///|
/// Returns the length of the `EStr` in code units.
pub fn[E] EStr::length(self : EStr[E]) -> Int {
  self.inner.length()
}

///|
/// Checks whether the `EStr` is empty.
pub fn[E] EStr::is_empty(self : EStr[E]) -> Bool {
  self.inner.is_empty()
}

///|
pub impl[E] Eq for EStr[E] with fn equal(self, other) {
  self.inner == other.inner
}

///|
pub impl[E] Compare for EStr[E] with fn compare(self, other) {
  self.inner.compare(other.inner)
}

///|
pub impl[E] Hash for EStr[E] with fn hash_combine(self, hasher) {
  hasher.combine_string(self.inner)
}

///|
pub impl[E] Show for EStr[E] with fn output(self, logger) {
  logger.write_string(self.inner)
}

///|
pub impl[E] Debug for EStr[E] with fn to_repr(self) {
  Repr(self.inner)
}

///|
/// An error raised when percent-decoded octets are not valid UTF-8.
pub(all) suberror DecodeError {
  /// The octets that failed to decode.
  NotUtf8(bytes~ : Bytes)
} derive(Eq, Debug)

///|
pub impl Show for DecodeError with fn output(_self, logger) {
  logger.write_string("percent-decoded octets are not valid UTF-8")
}

///|
/// Percent-decodes the `EStr` into octets.
///
/// Always **split before decoding**, as otherwise the data may be
/// mistaken for component delimiters.
///
/// Note that `U+002B` (+) is **not** decoded as `0x20` (space).
///
/// # Panics
///
/// Panics if `E::table()` does not allow percent-encoded octets.
///
/// ```mbt check
/// test {
///   let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("%C2%A1Hola%21")
///   inspect(
///     s.decode_to_bytes(),
///     content=(
///       #|b"\xc2\xa1Hola!"
///     ),
///   )
/// }
/// ```
pub fn[E : @enc.Encoder] EStr::decode_to_bytes(self : EStr[E]) -> Bytes {
  self.assert_decodable()
  Bytes::from_array(decode_to_byte_array(self.inner))
}

///|
/// Percent-decodes the `EStr` into a string.
///
/// # Errors
///
/// Raises [`DecodeError`] if the decoded octets are not valid UTF-8.
///
/// # Panics
///
/// Panics if `E::table()` does not allow percent-encoded octets.
///
/// ```mbt check
/// test {
///   let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("%C2%A1Hola%21")
///   inspect(s.decode_to_string(), content="¡Hola!")
/// }
/// ```
pub fn[E : @enc.Encoder] EStr::decode_to_string(
  self : EStr[E],
) -> String raise DecodeError {
  self.assert_decodable()
  let sb = StringBuilder::new(size_hint=self.inner.length())
  let mut ok = true
  decode_walk(self.inner, s => sb.write_string(s), (valid, invalid) => {
    sb.write_string(valid)
    if !invalid.is_empty() {
      ok = false
    }
  })
  if !ok {
    raise NotUtf8(bytes=Bytes::from_array(decode_to_byte_array(self.inner)))
  }
  sb.to_string()
}

///|
/// Percent-decodes the `EStr` into a string, replacing any octets that are not
/// valid UTF-8 with `U+FFFD`.
///
/// # Panics
///
/// Panics if `E::table()` does not allow percent-encoded octets.
///
/// ```mbt check
/// test {
///   let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("%C2Hi%FF")
///   inspect(s.decode_to_string_lossy(), content="�Hi�")
/// }
/// ```
pub fn[E : @enc.Encoder] EStr::decode_to_string_lossy(self : EStr[E]) -> String {
  self.assert_decodable()
  let sb = StringBuilder::new(size_hint=self.inner.length())
  decode_walk(self.inner, s => sb.write_string(s), (valid, invalid) => {
    sb.write_string(valid)
    if !invalid.is_empty() {
      sb.write_char('\u{FFFD}')
    }
  })
  sb.to_string()
}

///|
fn[E : @enc.Encoder] EStr::assert_decodable(_self : EStr[E]) -> Unit {
  guard E::table().allows_pct_encoded() else {
    abort("table does not allow percent-encoded octets")
  }
}

///|
/// Returns an iterator over the subslices of the `EStr` separated by `delim`.
///
/// # Panics
///
/// Panics if `delim` is not a [reserved] character.
///
/// [reserved]: https://datatracker.ietf.org/doc/html/rfc3986#section-2.2
///
/// ```mbt check
/// test {
///   let s : @uri.EStr[@enc.Path] = @uri.EStr::new_or_panic("a,b,c")
///   assert_eq(s.split(',').map(v => v.as_str()).to_array(), ["a", "b", "c"])
/// }
/// ```
pub fn[E] EStr::split(self : EStr[E], delim : Char) -> Iter[EStr[E]] {
  assert_reserved(delim)
  self.inner.split(delim.to_string()).map(v => estr(v.to_owned()))
}

///|
/// Splits the `EStr` on the first occurrence of `delim`, returning the prefix
/// before it and the suffix after it, or `None` if it is not found.
///
/// # Panics
///
/// Panics if `delim` is not a [reserved] character.
///
/// [reserved]: https://datatracker.ietf.org/doc/html/rfc3986#section-2.2
pub fn[E] EStr::split_once(self : EStr[E], delim : Char) -> (EStr[E], EStr[E])? {
  assert_reserved(delim)
  match self.inner.split_once(delim.to_string()) {
    Some((a, b)) => Some((estr(a.to_owned()), estr(b.to_owned())))
    None => None
  }
}

///|
/// Splits the `EStr` on the last occurrence of `delim`, returning the prefix
/// before it and the suffix after it, or `None` if it is not found.
///
/// # Panics
///
/// Panics if `delim` is not a [reserved] character.
///
/// [reserved]: https://datatracker.ietf.org/doc/html/rfc3986#section-2.2
pub fn[E] EStr::rsplit_once(
  self : EStr[E],
  delim : Char,
) -> (EStr[E], EStr[E])? {
  assert_reserved(delim)
  match self.inner.rev_find(delim.to_string()) {
    Some(i) =>
      Some(
        (
          estr(slice(self.inner, 0, i)),
          estr(slice(self.inner, i + 1, self.inner.length())),
        ),
      )
    None => None
  }
}

///|
fn assert_reserved(delim : Char) -> Unit {
  guard @enc.table_reserved.allows(delim) else {
    abort("splitting with non-reserved character")
  }
}

///|
/// Checks whether the path is absolute, i.e., starting with `'/'`.
pub fn[E : @enc.PathEncoder] EStr::is_absolute(self : EStr[E]) -> Bool {
  self.inner.has_prefix("/")
}

///|
/// Checks whether the path is rootless, i.e., not starting with `'/'`.
pub fn[E : @enc.PathEncoder] EStr::is_rootless(self : EStr[E]) -> Bool {
  !self.inner.has_prefix("/")
}

///|
/// Returns an iterator over the path segments, separated by `'/'`,
/// or `None` if the path is [rootless](EStr::is_rootless).
///
/// Note that the path can be empty when an authority is present,
/// in which case this method returns `None`.
///
/// ```mbt check
/// test {
///   let path = @uri.Uri::parse("file:///path/to//dir/").path
///   assert_eq(
///     path.segments_if_absolute().unwrap().map(v => v.as_str()).to_array(),
///     ["path", "to", "", "dir", ""],
///   )
///   let path = @uri.Uri::parse("foo:bar/baz").path
///   assert_true(path.segments_if_absolute() is None)
/// }
/// ```
pub fn[E : @enc.PathEncoder] EStr::segments_if_absolute(
  self : EStr[E],
) -> Iter[EStr[E]]? {
  if self.inner.has_prefix("/") {
    let rest : EStr[E] = estr(slice(self.inner, 1, self.inner.length()))
    Some(rest.split('/'))
  } else {
    None
  }
}

///|
/// A percent-encoded, growable string; the owned counterpart of [`EStr`].
///
/// # Examples
///
/// Encode key-value pairs into a query string and use it to build a
/// URI reference:
///
/// ```mbt check
/// test {
///   let pairs = [("name", "张三"), ("speech", "¡Olé!")]
///   let buf : @uri.EString[@enc.Query] = @uri.EString::new()
///   for pair in pairs {
///     let (k, v) = pair
///     if !buf.is_empty() {
///       buf.push('&')
///     }
///     // WARNING: Absolutely do not confuse data with delimiters!
///     // Use `@enc.Data` (or `@enc.IData`) to encode data contained in a URI
///     // (or an IRI) unless you know what you're doing!
///     buf.encode(k, table=@enc.table_data)
///     buf.push('=')
///     buf.encode(v, table=@enc.table_data)
///   }
///   inspect(buf, content="name=%E5%BC%A0%E4%B8%89&speech=%C2%A1Ol%C3%A9%21")
/// }
/// ```
pub struct EString[E] {
  mut buf : String
}

///|
/// Creates a new empty `EString`.
pub fn[E] EString::new() -> EString[E] {
  { buf: "" }
}

///|
/// Returns the `EString` as an [`EStr`].
pub fn[E] EString::to_estr(self : EString[E]) -> EStr[E] {
  { inner: self.buf }
}

///|
/// Checks whether the `EString` is empty.
pub fn[E] EString::is_empty(self : EString[E]) -> Bool {
  self.buf.is_empty()
}

///|
/// Truncates the `EString`, removing all contents.
pub fn[E] EString::clear(self : EString[E]) -> Unit {
  self.buf = ""
}

///|
/// Percent-encodes `s` with `table` and appends the result.
///
/// `table` should be the table of a sub-encoder of `E`, typically
/// [`@enc.table_data`] or [`@enc.table_idata`]: data contained in a URI/IRI must be
/// encoded more strictly than the component that holds it, or it would be
/// mistaken for delimiters.
///
/// # Panics
///
/// Panics if `table` is not a subset of `E::table()`, or if `table`
/// does not allow percent-encoded octets.
pub fn[E : @enc.Encoder] EString::encode(
  self : EString[E],
  s : String,
  table~ : @enc.Table,
) -> Unit {
  guard table.is_subset(E::table()) else { abort("not a sub-encoder") }
  guard table.allows_pct_encoded() else {
    abort("table does not allow percent-encoded octets")
  }
  let sb = StringBuilder::new(size_hint=s.length() * 3)
  encode_str(sb, table, s)
  self.buf = self.buf + sb.to_string()
}

///|
/// Appends a character to the `EString`.
///
/// # Panics
///
/// Panics if `E::table()` does not allow the character.
pub fn[E : @enc.Encoder] EString::push(self : EString[E], ch : Char) -> Unit {
  guard E::table().allows(ch) else { abort("table does not allow the char") }
  self.buf = self.buf + ch.to_string()
}

///|
/// Appends an [`EStr`] to the `EString`.
pub fn[E] EString::push_estr(self : EString[E], s : EStr[E]) -> Unit {
  self.buf = self.buf + s.inner
}

///|
pub impl[E] Show for EString[E] with fn output(self, logger) {
  logger.write_string(self.buf)
}

///|
pub impl[E] Debug for EString[E] with fn to_repr(self) {
  Repr(self.buf)
}

///|
pub impl[E] Eq for EString[E] with fn equal(self, other) {
  self.buf == other.buf
}

// The encoding and decoding routines.

///|
/// Percent-encodes `s` with `table`, appending the result to `sb`.
///
/// Characters that the table allows are kept as they are, and lowercased
/// beforehand if `to_ascii_lowercase` is set.
fn encode_str(
  sb : StringBuilder,
  table : @enc.Table,
  s : String,
  to_ascii_lowercase? : Bool = false,
) -> Unit {
  let len = s.length()
  let mut i = 0
  let scratch : Array[Byte] = []
  while i < len {
    let (cp, w) = next_code_point(s, i)
    if table.allows_code_point(cp) {
      if to_ascii_lowercase && cp >= 'A'.to_int() && cp <= 'Z'.to_int() {
        sb.write_char((cp + 32).to_char().unwrap())
      } else {
        sb.write_substring(s, i, w)
      }
    } else {
      scratch.clear()
      utf8_encode_code_point(scratch, cp)
      for x in scratch {
        push_encoded_byte(sb, x.to_int())
      }
    }
    i += w
  }
}

///|
/// Percent-decodes `s` into octets.
fn decode_to_byte_array(s : String) -> Array[Byte] {
  let out : Array[Byte] = []
  let len = s.length()
  let mut i = 0
  while i < len {
    let x = code_at(s, i)
    if x == '%' {
      out.push(decode_octet(code_at(s, i + 1), code_at(s, i + 2)).to_byte())
      i += 3
    } else {
      let (cp, w) = next_code_point(s, i)
      utf8_encode_code_point(out, cp)
      i += w
    }
  }
  out
}

///|
/// Walks the decoded contents of `s`.
///
/// `on_unencoded` is called with each maximal run of characters that are not
/// percent-encoded, and `on_decoded` with the UTF-8 chunks (see
/// [`utf8_chunks`]) of each maximal run of percent-decoded octets. Runs are
/// visited in order of appearance.
fn decode_walk(
  s : String,
  on_unencoded : (String) -> Unit,
  on_decoded : (String, ArrayView[Byte]) -> Unit,
) -> Unit {
  let len = s.length()
  let buf : Array[Byte] = []
  let mut i = 0
  while i < len {
    let start = i
    while i < len && code_at(s, i) != '%' {
      i += 1
    }
    if i > start {
      if !buf.is_empty() {
        utf8_chunks(buf[:], on_decoded)
        buf.clear()
      }
      on_unencoded(slice(s, start, i))
    }
    while i < len && code_at(s, i) == '%' {
      buf.push(decode_octet(code_at(s, i + 1), code_at(s, i + 2)).to_byte())
      i += 3
    }
  }
  if !buf.is_empty() {
    utf8_chunks(buf[:], on_decoded)
  }
}

///|
/// Walks the decoded contents of `s`, one percent-decoded octet at a time.
///
/// `on_unencoded` is called with each maximal run of characters that are not
/// percent-encoded, and `on_octet` with each percent-decoded octet.
fn decode_walk_octets(
  s : String,
  on_unencoded : (String) -> Unit,
  on_octet : (Int) -> Unit,
) -> Unit {
  let len = s.length()
  let mut i = 0
  while i < len {
    let start = i
    while i < len && code_at(s, i) != '%' {
      i += 1
    }
    if i > start {
      on_unencoded(slice(s, start, i))
    }
    while i < len && code_at(s, i) == '%' {
      on_octet(decode_octet(code_at(s, i + 1), code_at(s, i + 2)))
      i += 3
    }
  }
}
