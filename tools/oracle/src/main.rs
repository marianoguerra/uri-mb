//! Differential-testing oracle for the MoonBit port of `fluent-uri`.
//!
//! Generates URI/IRI inputs, runs them through `fluent-uri` (the reference
//! implementation) and writes a MoonBit test file that replays the very same
//! inputs against the port and compares the results.
//!
//! Usage: `cargo run --release -- [--seed N] [--count N] [--out PATH]`

use fluent_uri::{
    component::Host,
    resolve::Resolver,
    Iri, IriRef, ParseErrorKind, Uri, UriRef,
};
use std::{fmt::Write as _, fs, path::PathBuf};

/// The version of the reference implementation this oracle links against.
const FLUENT_URI_VERSION: &str = "0.4.1+git.76e10ae";

/// A small deterministic PRNG (xorshift64*), so runs are reproducible.
struct Rng(u64);

impl Rng {
    fn new(seed: u64) -> Self {
        Rng(seed.wrapping_mul(0x9e37_79b9_7f4a_7c15) | 1)
    }

    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.0 = x;
        x.wrapping_mul(0x2545_f491_4f6c_dd1d)
    }

    fn below(&mut self, n: usize) -> usize {
        (self.next() % n as u64) as usize
    }
}

/// The pieces the generator picks from. They are chosen to hit every branch of
/// the parser: unreserved and sub-delimiter characters, every general
/// delimiter, characters that are never allowed, percent-encoded octets that
/// are valid, invalid or ill-formed UTF-8, and non-ASCII characters.
const ALPHABET: &[&str] = &[
    "a", "b", "z", "A", "Z", "0", "1", "9", "-", ".", "_", "~", "!", "$", "&", "'", "(", ")", "*",
    "+", ",", ";", "=", ":", "@", "/", "?", "#", "[", "]", "%", "\\", " ", "\"", "<", ">", "^", "`",
    "{", "|", "}", "é", "例", "\u{10300}", "\u{e000}", "%20", "%2F", "%2e", "%2E", "%C3%A9", "%FF",
    "%zz", "%a", "%41", "%7e", "..", ".", "v6", "127.0.0.1", "::1", "[::1]", "example.com", "..%2F",
    "%E2%82", "%ED%A0%80", "%F0%90%8C%80", "%E0%80%80", "%F4%90%80%80", "%F0%9F%98", "%C0%80",
    "%C1%81", "%E0%A0", "%F0%82%82%AC", "%C2%A2", "%E0%A4%B9", "%F0%90%8D%88", "%80", "%BF",
];

/// A fixed corpus of inputs that are known to be interesting, taken from the
/// test suite of `fluent-uri` and from the RFCs.
const CORPUS: &[&str] = &[
    "",
    "foo",
    ".",
    "..",
    "/",
    "//",
    "///",
    "?",
    "#",
    "//@",
    "//:",
    "a:",
    "a:b",
    "a://",
    "file:///etc/hosts",
    "ftp://ftp.is.co.za/rfc/rfc1808.txt",
    "http://www.ietf.org/rfc/rfc2396.txt",
    "ldap://[2001:db8::7]/c=GB?objectClass?one",
    "mailto:John.Doe@example.com",
    "news:comp.infosystems.www.servers.unix",
    "tel:+1-816-555-1212",
    "telnet://192.0.2.16:80/",
    "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    "foo://example.com:8042/over/there?name=ferret#nose",
    "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    "http://[vFe.foo.bar]",
    "http://127.0.0.1:/",
    "http://127.0.0.1:80808/",
    "eXAMPLE://a/./b/../b/%63/%7bfoo%7d",
    "http://example.com",
    "http://example.com:/",
    "http://example.com:80/",
    "%3a",
    "HTTP://www.EXAMPLE.com/",
    "http://a/../../../g",
    "http://a/b/c/%2E/%2E./%2e%2E/d",
    "foo/../bar",
    "/foo/../bar",
    "foo:bar/../baz",
    "foo:/bar/./../baz",
    "foo:/.//@@",
    "HTTP://%45XAMPLE.%43Om",
    "%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25",
    "FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b#%24%4d",
    "//127.0.0.1",
    "//127.0.0.%31",
    "//[::1]",
    "//[0000:0000:0000::1]",
    "//[0:0:0:0:0:ffff:192.0.2.1]",
    "//[::192.0.2.1]",
    "//[v1FdE.AddR]",
    "//127.0.0.001",
    "//127.1",
    "//127.00.00.1",
    "//[::1.1.1.1]",
    "//[::ffff:1.1.1.1]",
    "//[0000:0000:0000:0000:0000:0000:255.255.255.255]",
    "//[::01.1.1.1]",
    "//[::00.1.1.1]",
    "//[:]",
    "//[]",
    "//[vG.addr]",
    "//[v.addr]",
    "//[vF.]",
    "//[vF.%20]",
    "//[fe80::abcd%eth0]",
    "//[44:55::66::77]",
    ":hello",
    "3ttp://a.com",
    "exam=ple:foo",
    "(:",
    "a%20:foo",
    "foo\\bar",
    "foo%xxd",
    "text%a",
    "%",
    "http://example.com:80ab",
    "http://user@example.com:80ab",
    "http://user:pass:example.com/",
    "https://[::1/",
    "https://[::1]wrong",
    "eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9",
    "?%EE%80%80",
    "http://résumé.example.org",
    "http://www.example.org/red%09rosé#red",
    "http://example.com/\u{10300}\u{10301}\u{10302}",
    "http://www.example.org/r%E9sum%E9.html",
    "http://www.example.org/D%C3%BCrst",
    "http://xn--99zt52a.example.org/%e2%80%ae",
    "réf/rel",
    "http://你好.example.com/",
    "a/b/c/../../d",
    "a:%2E%2E/b",
    "foo:/%2e%2E//bar",
    "//user@[::1]:8080/p?q#f",
    "s://h/%E2%82",
    "s://h/%ED%A0%80",
    "s://h/%F0%90%8C%80",
    "s://h/%E0%80%80",
    "s://h/%F4%90%80%80",
    "s://h/%F0%9F%98",
    "s://%C0%80",
    "s://h/a%F1%80%80%E1%80%C2b",
    "s:?%C2%A2%E0%A4%B9%F0%90%8D%88",
    "s:#%80%BF",
];

/// A fixed corpus of base URIs for reference resolution.
const BASES: &[&str] = &[
    "http://a/b/c/d;p?q",
    "foo:bar",
    "foo:/",
    "foo:/bar/baz/.%2E/",
    "foo:/bar/..",
    "foo:bar/..",
    "http://example.com/#title1",
    "foo:/..",
    "http://example.com",
    "a:",
    "a://b",
    "http://例え.jp/a/b",
];

fn gen_piece(rng: &mut Rng) -> &'static str {
    ALPHABET[rng.below(ALPHABET.len())]
}

/// Generates an IP-literal-ish host, to exercise the IPv6 and IPvFuture
/// parsers, which have the subtlest rules of the grammar.
fn gen_ip_literal(rng: &mut Rng) -> String {
    const V6_PIECES: &[&str] = &[
        ":", "::", ".", "0", "1", "a", "ff", "abcd", "12345", "0000", "192.0.2.1", "255.255.255.255",
        "1.2.3", "01.2.3.4", "ffff", "FFFF", "%", "v", "z",
    ];
    let mut s = String::from("[");
    if rng.below(6) == 0 {
        // An IPvFuture address.
        s.push(if rng.below(2) == 0 { 'v' } else { 'V' });
        let n = rng.below(3);
        for _ in 0..n {
            s.push_str(["0", "9", "a", "F", "g", ""][rng.below(6)]);
        }
        s.push('.');
        s.push_str(&gen_junk(rng, 2));
    } else {
        let n = rng.below(10);
        for _ in 0..n {
            s.push_str(V6_PIECES[rng.below(V6_PIECES.len())]);
        }
    }
    if rng.below(8) > 0 {
        s.push(']');
    }
    s
}

/// Generates a path made of dot segments and their percent-encoded forms, to
/// exercise dot segment removal.
fn gen_dotted_path(rng: &mut Rng) -> String {
    const SEGMENTS: &[&str] = &[
        ".", "..", "%2e", "%2E", "%2e%2E", ".%2e", "%2E.", "a", "", "b", "...", "..a",
    ];
    let n = rng.below(8);
    let mut s = String::new();
    for _ in 0..n {
        s.push('/');
        s.push_str(SEGMENTS[rng.below(SEGMENTS.len())]);
    }
    if rng.below(4) == 0 {
        s.push('/');
    }
    s
}

fn gen_junk(rng: &mut Rng, max_parts: usize) -> String {
    let n = rng.below(max_parts + 1);
    (0..n).map(|_| gen_piece(rng)).collect()
}

/// Generates a string that is likely, but not guaranteed, to parse.
fn gen_uri_ref(rng: &mut Rng) -> String {
    let mut s = String::new();
    if rng.below(3) > 0 {
        s.push_str(["a", "foo", "HTTP", "http", "z9+-."][rng.below(5)]);
        s.push(':');
    }
    let has_authority = rng.below(2) == 0;
    if has_authority {
        s.push_str("//");
        if rng.below(3) == 0 {
            s.push_str(&gen_junk(rng, 3));
            s.push('@');
        }
        match rng.below(8) {
            0 => s.push_str("[::1]"),
            1 => s.push_str("[0:0:0:0:0:ffff:192.0.2.1]"),
            2 => s.push_str("[v7.Foo.Bar]"),
            3 => s.push_str("127.0.0.1"),
            4 | 5 => s.push_str(&gen_ip_literal(rng)),
            _ => s.push_str(&gen_junk(rng, 3)),
        }
        if rng.below(3) == 0 {
            s.push(':');
            if rng.below(2) == 0 {
                let _ = write!(s, "{}", rng.below(100000));
            }
        }
    }
    let segments = if rng.below(3) == 0 {
        s.push_str(&gen_dotted_path(rng));
        1
    } else {
        let segments = rng.below(4);
        for _ in 0..segments {
            s.push('/');
            s.push_str(&gen_junk(rng, 2));
        }
        segments
    };
    if segments == 0 && !has_authority && rng.below(2) == 0 {
        s.push_str(&gen_junk(rng, 2));
    }
    if rng.below(3) == 0 {
        s.push('?');
        s.push_str(&gen_junk(rng, 3));
    }
    if rng.below(3) == 0 {
        s.push('#');
        s.push_str(&gen_junk(rng, 3));
    }
    s
}

fn gen_input(rng: &mut Rng) -> String {
    match rng.below(8) {
        0 | 1 => gen_junk(rng, 6),
        2 => format!("//{}", gen_ip_literal(rng)),
        3 => gen_dotted_path(rng),
        _ => gen_uri_ref(rng),
    }
}

/// Renders an optional string: `-` for absent, `+` followed by the contents
/// for present, so that an absent and an empty component differ.
fn opt(s: Option<&str>) -> String {
    match s {
        None => "-".to_owned(),
        Some(s) => format!("+{s}"),
    }
}

fn dump_host<E: fluent_uri::pct_enc::Encoder>(host: Host<'_, E>) -> String {
    match host {
        Host::Ipv4(addr) => format!("4:{addr}"),
        Host::Ipv6(addr) => format!("6:{addr}"),
        Host::IpvFuture { .. } => "v".to_owned(),
        Host::RegName(name) => format!("n:{name}"),
    }
}

/// Renders the components of a parsed reference. The MoonBit port renders the
/// same string from its own components.
macro_rules! dump {
    ($r:expr) => {{
        let r = $r;
        let mut out = String::new();
        let _ = write!(out, "s={}", opt(r.scheme().map(|s| s.as_str())));
        match r.authority() {
            None => out.push_str("|a=-"),
            Some(a) => {
                let _ = write!(
                    out,
                    "|a=+{}|u={}|h={}|hp={}|o={}",
                    a.as_str(),
                    opt(a.userinfo().map(|s| s.as_str())),
                    a.host(),
                    dump_host(a.host_parsed()),
                    opt(a.port().map(|s| s.as_str())),
                );
            }
        }
        let _ = write!(
            out,
            "|p={}|q={}|f={}",
            r.path(),
            opt(r.query().map(|s| s.as_str())),
            opt(r.fragment().map(|s| s.as_str())),
        );
        out
    }};
}

/// Renders a parse error, with the index converted to UTF-16 code units so
/// that it can be compared with the MoonBit port, which indexes strings that
/// way.
fn dump_parse_error(input: &str, e: fluent_uri::ParseError) -> String {
    let kind = match e.kind() {
        ParseErrorKind::UnexpectedCharOrEnd => "unexpected",
        ParseErrorKind::InvalidIpv6Addr => "ipv6",
        _ => "other",
    };
    // `fluent-uri` measures the index of a malformed percent-encoded octet
    // from the start of the component being read, which can land in the middle
    // of a character. Such an index cannot be expressed in UTF-16 code units,
    // so the case is marked and only the kind is compared.
    if !input.is_char_boundary(e.index()) {
        return format!("E:{kind}:mid");
    }
    let index = input[..e.index()].encode_utf16().count();
    format!("E:{kind}:{index}")
}

/// Runs every operation on `input` and joins the results.
fn oracle(input: &str) -> String {
    let mut parts: Vec<String> = Vec::new();

    parts.push(match UriRef::parse(input) {
        Ok(r) => dump!(r),
        Err(e) => dump_parse_error(input, e),
    });
    parts.push(match Uri::parse(input) {
        Ok(r) => format!("uri:{r}"),
        Err(e) => dump_parse_error(input, e),
    });
    parts.push(match IriRef::parse(input) {
        Ok(r) => dump!(r),
        Err(e) => dump_parse_error(input, e),
    });
    parts.push(match Iri::parse(input) {
        Ok(r) => format!("iri:{r}"),
        Err(e) => dump_parse_error(input, e),
    });
    parts.push(match UriRef::parse(input) {
        Ok(r) => format!("n:{}", r.normalize()),
        Err(_) => "-".to_owned(),
    });
    parts.push(match IriRef::parse(input) {
        Ok(r) => format!("ni:{}", r.normalize()),
        Err(_) => "-".to_owned(),
    });
    parts.push(match IriRef::parse(input) {
        Ok(r) => format!("u:{}", r.to_uri_ref()),
        Err(_) => "-".to_owned(),
    });
    parts.push(match IriRef::parse(input) {
        Ok(r) => format!(
            "sf:{}|wf:{}|nf:{}",
            r.strip_fragment(),
            r.with_fragment(Some(fluent_uri::pct_enc::EStr::new_or_panic("X%20y"))),
            r.with_fragment(None),
        ),
        Err(_) => "-".to_owned(),
    });
    parts.join(" ;; ")
}

/// Runs reference resolution of `reference` against `base`.
fn oracle_resolve(base: &str, reference: &str) -> String {
    let (Ok(base), Ok(r)) = (Iri::parse(base), IriRef::parse(reference)) else {
        return "-".to_owned();
    };
    let mut parts: Vec<String> = Vec::new();
    for allow_underflow in [true, false] {
        let resolver = Resolver::with_base(base).allow_path_underflow(allow_underflow);
        parts.push(match resolver.resolve(&r) {
            Ok(t) => format!("t:{t}"),
            Err(e) => format!(
                "E:{}",
                match e {
                    fluent_uri::resolve::ResolveError::BaseWithFragment => "base_fragment",
                    fluent_uri::resolve::ResolveError::InvalidReferenceAgainstOpaqueBase =>
                        "opaque_base",
                    fluent_uri::resolve::ResolveError::PathUnderflow => "underflow",
                }
            ),
        });
    }
    parts.join(" ;; ")
}

/// Escapes a string as a MoonBit string literal.
fn mbt_str(s: &str) -> String {
    let mut out = String::with_capacity(s.len() + 2);
    out.push('"');
    for c in s.chars() {
        match c {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if c.is_ascii_graphic() || c == ' ' => out.push(c),
            c => {
                let _ = write!(out, "\\u{{{:x}}}", c as u32);
            }
        }
    }
    out.push('"');
    out
}

fn main() {
    let mut seed = 20260818u64;
    let mut count = 250usize;
    let mut out = PathBuf::from("../../conformance_test.mbt");

    let args: Vec<String> = std::env::args().skip(1).collect();
    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--seed" => {
                seed = args[i + 1].parse().expect("invalid seed");
                i += 2;
            }
            "--count" => {
                count = args[i + 1].parse().expect("invalid count");
                i += 2;
            }
            "--out" => {
                out = PathBuf::from(&args[i + 1]);
                i += 2;
            }
            other => panic!("unknown argument {other}"),
        }
    }

    let mut rng = Rng::new(seed);
    let mut inputs: Vec<String> = CORPUS.iter().map(|s| (*s).to_owned()).collect();
    inputs.extend((0..count).map(|_| gen_input(&mut rng)));

    let mut pairs: Vec<(String, String)> = Vec::new();
    for base in BASES {
        for r in CORPUS.iter().take(40) {
            pairs.push(((*base).to_owned(), (*r).to_owned()));
        }
    }
    for _ in 0..count {
        let base = if rng.below(3) == 0 {
            format!(
                "{}:{}{}",
                ["a", "foo", "http"][rng.below(3)],
                if rng.below(2) == 0 { "//host" } else { "" },
                gen_dotted_path(&mut rng)
            )
        } else {
            BASES[rng.below(BASES.len())].to_owned()
        };
        pairs.push((base, gen_input(&mut rng)));
    }

    let mut f = String::new();
    f.push_str(&format!(
        "///|\n\
         /// Conformance tests generated from the reference implementation.\n\
         ///\n\
         /// Every case records what `fluent-uri` {} does with an input, so that any\n\
         /// divergence of this port shows up as a failing test. Regenerate with\n\
         /// `cargo run --release --manifest-path tools/oracle/Cargo.toml -- --seed {} --count {}`.\n\
         ///\n\
         /// DO NOT EDIT BY HAND.\n\n",
        FLUENT_URI_VERSION,
        seed,
        count
    ));

    // The cases are emitted in chunks of pushes rather than as one array
    // literal: a literal with thousands of elements overflows the local
    // variable limit of the WebAssembly backend.
    const CHUNK: usize = 200;

    f.push_str(
        "///|\n\
         /// Inputs and the results the reference implementation produces for them.\n\
         pub let parse_cases : Array[(String, String)] = collect_parse_cases()\n\n",
    );
    f.push_str("///|\nfn collect_parse_cases() -> Array[(String, String)] {\n  let out = []\n");
    for i in 0..inputs.len().div_ceil(CHUNK) {
        let _ = writeln!(f, "  parse_chunk_{i}(out)");
    }
    f.push_str("  out\n}\n\n");

    for (i, chunk) in inputs.chunks(CHUNK).enumerate() {
        let _ = writeln!(
            f,
            "///|\nfn parse_chunk_{i}(out : Array[(String, String)]) -> Unit {{"
        );
        for input in chunk {
            let _ = writeln!(
                f,
                "  out.push(({}, {}))",
                mbt_str(input),
                mbt_str(&oracle(input))
            );
        }
        f.push_str("}\n\n");
    }

    f.push_str(
        "///|\n\
         /// Base and reference pairs, with the results of resolving them.\n\
         pub let resolve_cases : Array[(String, String, String)] = collect_resolve_cases()\n\n",
    );
    f.push_str(
        "///|\nfn collect_resolve_cases() -> Array[(String, String, String)] {\n  let out = []\n",
    );
    for i in 0..pairs.len().div_ceil(CHUNK) {
        let _ = writeln!(f, "  resolve_chunk_{i}(out)");
    }
    f.push_str("  out\n}\n\n");

    for (i, chunk) in pairs.chunks(CHUNK).enumerate() {
        let _ = writeln!(
            f,
            "///|\nfn resolve_chunk_{i}(out : Array[(String, String, String)]) -> Unit {{"
        );
        for (base, r) in chunk {
            let _ = writeln!(
                f,
                "  out.push(({}, {}, {}))",
                mbt_str(base),
                mbt_str(r),
                mbt_str(&oracle_resolve(base, r))
            );
        }
        f.push_str("}\n\n");
    }

    fs::write(&out, f).expect("failed to write the test file");
    eprintln!(
        "wrote {} parse cases and {} resolve cases to {}",
        inputs.len(),
        pairs.len(),
        out.display()
    );
}
