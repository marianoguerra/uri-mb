///|
/// A small demonstration of the `marianoguerra/uri` package: it parses the URI
/// references given on the command line, or a few examples if there are none,
/// and prints their components together with their normalized form.
fn main {
  let inputs = [
    "foo://user@example.com:8042/over/there?name=ferret#nose", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d",
    "//[0000:0000:0000::1]:8080", "../relative/path", "not a uri",
  ]
  for input in inputs {
    println("input:  \{input}")
    try {
      let r = @uri.UriRef::parse(input)
      println("  scheme:    \{show_opt(r.scheme.map(s => s.as_str()))}")
      match r.authority {
        None => println("  authority: -")
        Some(a) => {
          println("  authority: \{a.as_str()}")
          println("    userinfo: \{show_opt(a.userinfo.map(v => v.as_str()))}")
          println("    host:     \{a.host} (\{a.host_parsed})")
          println("    port:     \{show_opt(a.port.map(v => v.as_str()))}")
        }
      }
      println("  path:      \{r.path}")
      println("  query:     \{show_opt(r.query.map(v => v.as_str()))}")
      println("  fragment:  \{show_opt(r.fragment.map(v => v.as_str()))}")
      println("  normalized: \{r.normalize()}")
    } catch {
      e => println("  error: \{e}")
    }
  }
}

///|
/// Renders an optional component.
fn show_opt(s : String?) -> String {
  match s {
    Some(v) => v
    None => "-"
  }
}
