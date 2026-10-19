///|
/// Random generators shared by the property-based tests.
///
/// Generation is seeded so that failures are reproducible: each test creates
/// its own generator with a fixed seed.

///|
/// Creates a deterministic random source from a seed.
fn rng(seed : Int32) -> @random.Rand {
  let bytes = Array::make(32, b'\x00')
  bytes[0] = (seed & 0xff).to_byte()
  bytes[1] = ((seed >> 8) & 0xff).to_byte()
  bytes[2] = ((seed >> 16) & 0xff).to_byte()
  bytes[3] = ((seed >> 24) & 0xff).to_byte()
  @random.Rand::chacha8(seed=Bytes::from_array(bytes))
}

///|
/// The characters the generators pick from, chosen to hit every branch of the
/// parser: unreserved and sub-delimiter characters, every general delimiter,
/// characters that are never allowed, and non-ASCII ones.
let alphabet : Array[String] = [
  "a", "b", "z", "A", "Z", "0", "1", "9", "-", ".", "_", "~", "!", "$", "&", "'",
  "(", ")", "*", "+", ",", ";", "=", ":", "@", "/", "?", "#", "[", "]", "%", "\\",
  " ", "\"", "<", ">", "^", "`", "{", "|", "}", "é", "例", "\u{10300}", "\u{e000}",
  "%20", "%2F", "%2e", "%C3%A9", "%FF", "%zz", "%a", "..", ".", "v6", "127.0.0.1",
  "::1", "[::1]", "example.com",
]

///|
/// Generates a random string of up to `max_parts` pieces of the alphabet.
fn gen_junk(rand : @random.Rand, max_parts : Int32) -> String {
  let n = rand.int(limit=max_parts + 1)
  let sb = StringBuilder()
  for _ in 0..<n {
    sb.write_string(alphabet[rand.int(limit=alphabet.length())])
  }
  sb.to_string()
}

///|
/// Generates a string of characters allowed in `table`, mixed with a few that
/// are not, so that both accepted and rejected inputs are produced.
fn gen_from_table(
  rand : @random.Rand,
  table : @enc.Table,
  max_parts : Int32,
) -> String {
  let n = rand.int(limit=max_parts + 1)
  let sb = StringBuilder()
  for _ in 0..<n {
    let part = alphabet[rand.int(limit=alphabet.length())]
    // Keep the piece if the table allows it, otherwise mostly drop it.
    let keep = part.iter().all(c => table.allows(c) || c == '%') ||
      rand.int(limit=8) == 0
    if keep {
      sb.write_string(part)
    }
  }
  sb.to_string()
}

///|
/// Generates a string that is likely, but not guaranteed, to parse as a URI
/// reference.
fn gen_uri_ref_string(rand : @random.Rand) -> String {
  let sb = StringBuilder()
  let has_scheme = rand.int(limit=3) > 0
  if has_scheme {
    sb.write_string(["a", "foo", "HTTP", "http", "z9+-."][rand.int(limit=5)])
    sb.write_char(':')
  }
  let has_authority = rand.int(limit=2) == 0
  if has_authority {
    sb.write_string("//")
    if rand.int(limit=3) == 0 {
      sb.write_string(gen_from_table(rand, @enc.table_iuserinfo, 3))
      sb.write_char('@')
    }
    let host = rand.int(limit=8)
    if host == 0 {
      sb.write_string("[::1]")
    } else if host == 1 {
      sb.write_string("[0:0:0:0:0:ffff:192.0.2.1]")
    } else if host == 2 {
      sb.write_string("[v7.Foo.Bar]")
    } else if host == 3 {
      sb.write_string("127.0.0.1")
    } else {
      sb.write_string(gen_from_table(rand, @enc.table_ireg_name, 3))
    }
    if rand.int(limit=3) == 0 {
      sb.write_char(':')
      if rand.int(limit=2) == 0 {
        sb.write_string(rand.int(limit=100000).to_string())
      }
    }
  }
  // A path that is absolute whenever an authority is present.
  let segments = rand.int(limit=4)
  for _ in 0..<segments {
    sb.write_char('/')
    sb.write_string(gen_from_table(rand, @enc.table_ipath, 2))
  }
  if segments == 0 && !has_authority && rand.int(limit=2) == 0 {
    sb.write_string(gen_from_table(rand, @enc.table_isegment_nz_nc, 2))
  }
  if rand.int(limit=3) == 0 {
    sb.write_char('?')
    sb.write_string(gen_from_table(rand, @enc.table_iquery, 3))
  }
  if rand.int(limit=3) == 0 {
    sb.write_char('#')
    sb.write_string(gen_from_table(rand, @enc.table_ifragment, 3))
  }
  sb.to_string()
}

///|
/// Generates a string that is likely to parse as a base URI, i.e., a URI with
/// a scheme and no fragment.
fn gen_base_string(rand : @random.Rand) -> String {
  let sb = StringBuilder()
  sb.write_string(["a", "foo", "http"][rand.int(limit=3)])
  sb.write_char(':')
  if rand.int(limit=2) == 0 {
    sb.write_string("//")
    sb.write_string(gen_from_table(rand, @enc.table_ireg_name, 2))
  }
  let segments = rand.int(limit=4)
  for _ in 0..<segments {
    sb.write_char('/')
    sb.write_string(gen_from_table(rand, @enc.table_ipath, 2))
  }
  if rand.int(limit=4) == 0 {
    sb.write_char('?')
    sb.write_string(gen_from_table(rand, @enc.table_iquery, 2))
  }
  sb.to_string()
}

///|
/// Generates a mixture of structured and unstructured inputs.
fn gen_input(rand : @random.Rand) -> String {
  if rand.int(limit=4) == 0 {
    gen_junk(rand, 6)
  } else {
    gen_uri_ref_string(rand)
  }
}
