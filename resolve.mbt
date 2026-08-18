///|
/// Reference resolution, as defined in
/// [Section 5 of RFC 3986](https://datatracker.ietf.org/doc/html/rfc3986#section-5).

///|
/// An error raised when resolving a URI/IRI reference.
pub(all) suberror ResolveError {
  /// The base has a fragment.
  BaseWithFragment
  /// The base has no authority and its path is rootless, but the reference
  /// is relative, is not empty and does not start with `'#'`.
  InvalidReferenceAgainstOpaqueBase
  /// An underflow occurred in path resolution. Raised only when
  /// `allow_path_underflow` is `false`.
  PathUnderflow
} derive(Eq, Debug)

///|
pub impl Show for ResolveError with fn output(self, logger) {
  let msg = match self {
    BaseWithFragment => "base should not have fragment"
    InvalidReferenceAgainstOpaqueBase =>
      "when base has a rootless path and no authority, reference should either have scheme, be empty or start with '#'"
    PathUnderflow => "underflow occurred in path resolution"
  }
  logger.write_string(msg)
}

///|
/// The three kinds of path segment that matter to dot segment removal.
priv enum SegKind {
  Dot
  DoubleDot
  NormalSeg
}

///|
/// Checks whether `s[start..start + 3]` is `"%2E"`, ignoring case.
fn is_pct2e(s : String, start : Int) -> Bool {
  code_at(s, start) == '%' &&
  code_at(s, start + 1) == '2' &&
  (code_at(s, start + 2) | 0x20) == 'e'
}

///|
/// Classifies the segment `s[start..end]`, treating the percent-encoded forms
/// of `'.'` as dots.
fn classify_segment(s : String, start : Int, end : Int) -> SegKind {
  match end - start {
    1 => if code_at(s, start) == '.' { Dot } else { NormalSeg }
    2 =>
      if code_at(s, start) == '.' && code_at(s, start + 1) == '.' {
        DoubleDot
      } else {
        NormalSeg
      }
    3 => if is_pct2e(s, start) { Dot } else { NormalSeg }
    4 =>
      if (code_at(s, start) == '.' && is_pct2e(s, start + 1)) ||
        (code_at(s, start + 3) == '.' && is_pct2e(s, start)) {
        DoubleDot
      } else {
        NormalSeg
      }
    6 =>
      if is_pct2e(s, start) && is_pct2e(s, start + 3) {
        DoubleDot
      } else {
        NormalSeg
      }
    _ => NormalSeg
  }
}

///|
/// Removes the dot segments of an absolute path, optionally continuing with a
/// relative path merged onto it.
///
/// Returns the resulting path and whether an underflow occurred, i.e., whether
/// a `".."` segment tried to escape the root.
fn remove_dot_segments(abs : String, rel : String?) -> (String, Bool) {
  // Each piece is a nonempty segment together with the `'/'` that follows it,
  // if any. Only the last piece may lack a trailing `'/'`, and the first piece
  // is always `"/"`, so popping a piece is exactly truncating the path to the
  // previous segment boundary.
  let pieces : Array[String] = []
  let mut underflow = false
  let parts = match rel {
    Some(rel) => [abs, rel]
    None => [abs]
  }
  for part in parts {
    let len = part.length()
    let mut start = 0
    while start < len {
      let mut end = start
      while end < len && code_at(part, end) != '/' {
        end += 1
      }
      match classify_segment(part, start, end) {
        Dot => ()
        DoubleDot =>
          if pieces.length() <= 1 {
            underflow = true
          } else {
            pieces.pop() |> ignore
          }
        // Append the segment and the following '/' if any.
        NormalSeg =>
          pieces.push(
            slice(part, start, if end + 1 < len { end + 1 } else { len }),
          )
      }
      if end == len {
        break
      }
      // Skip '/'.
      start = end + 1
    }
  }
  let sb = StringBuilder::new(size_hint=abs.length())
  for piece in pieces {
    sb.write_string(piece)
  }
  (sb.to_string(), underflow)
}

///|
/// Resolves `r` against `base`, which must have a scheme.
fn resolve_ri(
  base : Ri,
  r : Ri,
  allow_path_underflow : Bool,
) -> Ri raise ResolveError {
  if base.fragment is Some(_) {
    raise BaseWithFragment
  }
  if base.authority is None &&
    !base.path.has_prefix("/") &&
    r.scheme is None &&
    !(r.text.is_empty() || code_at(r.text, 0) == '#') {
    raise InvalidReferenceAgainstOpaqueBase
  }
  // The target components, per Section 5.2.2 of RFC 3986. `t_path_rel` is the
  // relative path to be merged onto `t_path_abs`, if any.
  let (t_scheme, t_authority, t_path_abs, t_path_rel, t_query) = if r.scheme
    is Some(_) {
    (r.scheme, r.authority, r.path, None, r.query)
  } else if r.authority is Some(_) {
    (base.scheme, r.authority, r.path, None, r.query)
  } else if r.path.is_empty() {
    (
      base.scheme,
      base.authority,
      base.path,
      None,
      if r.query is Some(_) {
        r.query
      } else {
        base.query
      },
    )
  } else if r.path.has_prefix("/") {
    (base.scheme, base.authority, r.path, None, r.query)
  } else {
    let base_path = if base.path.is_empty() { "/" } else { base.path }
    // Make sure that swapping the order of resolution and normalization
    // does not change the result.
    let last_slash_idx = base_path.rev_find("/").unwrap()
    let base_path_stripped = match
      classify_segment(base_path, last_slash_idx + 1, base_path.length()) {
      DoubleDot => base_path
      _ => slice(base_path, 0, last_slash_idx + 1)
    }
    // Instead of merging the paths, remove dot segments incrementally.
    (base.scheme, base.authority, base_path_stripped, Some(r.path), r.query)
  }
  let path = if t_path_abs.has_prefix("/") {
    let (path, underflow) = remove_dot_segments(t_path_abs, t_path_rel)
    if underflow && !allow_path_underflow {
      raise PathUnderflow
    }
    path
  } else {
    t_path_abs
  }
  // Close the loophole in the original algorithm.
  let path = if t_authority is None && path.has_prefix("//") {
    "/." + path
  } else {
    path
  }
  ri(
    scheme=t_scheme,
    authority=t_authority,
    path~,
    query=t_query,
    fragment=r.fragment,
  )
}

///|
/// Resolves the URI reference against the given base URI and returns the
/// target URI.
///
/// The base URI must have no fragment. If it also has no authority and its
/// path is rootless, the reference must either have a scheme, be empty, or
/// start with `'#'`.
///
/// Setting `allow_path_underflow` to `false` deviates from RFC 3986 by
/// rejecting references whose `".."` segments escape the root of the base.
///
/// ```mbt check
/// test {
///   let base = @uri.Uri::parse("http://example.com/foo/bar")
///   inspect(
///     @uri.UriRef::parse("baz").resolve_against(base),
///     content="http://example.com/foo/baz",
///   )
///   inspect(
///     @uri.UriRef::parse("../baz").resolve_against(base),
///     content="http://example.com/baz",
///   )
///   inspect(
///     @uri.UriRef::parse("?baz").resolve_against(base),
///     content="http://example.com/foo/bar?baz",
///   )
/// }
/// ```
pub fn UriRef::resolve_against(
  self : UriRef,
  base : Uri,
  allow_path_underflow? : Bool = true,
) -> Uri raise ResolveError {
  uri_of_ri(resolve_ri(base.to_ri(), self.to_ri(), allow_path_underflow))
}

///|
/// Resolves the IRI reference against the given base IRI and returns the
/// target IRI. See [`UriRef::resolve_against`] for the exact behavior.
pub fn IriRef::resolve_against(
  self : IriRef,
  base : Iri,
  allow_path_underflow? : Bool = true,
) -> Iri raise ResolveError {
  iri_of_ri(resolve_ri(base.to_ri(), self.to_ri(), allow_path_underflow))
}
