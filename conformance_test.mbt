///|
/// Conformance tests generated from the reference implementation.
///
/// Every case records what `fluent-uri` 0.4.1+git.76e10ae does with an input, so that any
/// divergence of this port shows up as a failing test. Regenerate with
/// `cargo run --release --manifest-path tools/oracle/Cargo.toml -- --seed 20260818 --count 250`.
///
/// DO NOT EDIT BY HAND.

///|
/// Inputs and the results the reference implementation produces for them.
pub let parse_cases : Array[(String, String)] = collect_parse_cases()

///|
fn collect_parse_cases() -> Array[(String, String)] {
  let out = []
  parse_chunk_0(out)
  parse_chunk_1(out)
  out
}

///|
fn parse_chunk_0(out : Array[(String, String)]) -> Unit {
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "foo", "s=-|a=-|p=foo|q=-|f=- ;; E:unexpected:3 ;; s=-|a=-|p=foo|q=-|f=- ;; E:unexpected:3 ;; n:foo ;; ni:foo ;; u:foo ;; sf:foo|wf:foo#X%20y|nf:foo",
    ),
  )
  out.push(
    (
      ".", "s=-|a=-|p=.|q=-|f=- ;; E:unexpected:1 ;; s=-|a=-|p=.|q=-|f=- ;; E:unexpected:1 ;; n:. ;; ni:. ;; u:. ;; sf:.|wf:.#X%20y|nf:.",
    ),
  )
  out.push(
    (
      "..", "s=-|a=-|p=..|q=-|f=- ;; E:unexpected:2 ;; s=-|a=-|p=..|q=-|f=- ;; E:unexpected:2 ;; n:.. ;; ni:.. ;; u:.. ;; sf:..|wf:..#X%20y|nf:..",
    ),
  )
  out.push(
    (
      "/", "s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; n:/ ;; ni:/ ;; u:/ ;; sf:/|wf:/#X%20y|nf:/",
    ),
  )
  out.push(
    (
      "//", "s=-|a=+|u=-|h=|hp=n:|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+|u=-|h=|hp=n:|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n:// ;; ni:// ;; u:// ;; sf://|wf://#X%20y|nf://",
    ),
  )
  out.push(
    (
      "///", "s=-|a=+|u=-|h=|hp=n:|o=-|p=/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+|u=-|h=|hp=n:|o=-|p=/|q=-|f=- ;; E:unexpected:0 ;; n:/// ;; ni:/// ;; u:/// ;; sf:///|wf:///#X%20y|nf:///",
    ),
  )
  out.push(
    (
      "?", "s=-|a=-|p=|q=+|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=+|f=- ;; E:unexpected:0 ;; n:? ;; ni:? ;; u:? ;; sf:?|wf:?#X%20y|nf:?",
    ),
  )
  out.push(
    (
      "#", "s=-|a=-|p=|q=-|f=+ ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=+ ;; E:unexpected:0 ;; n:# ;; ni:# ;; u:# ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "//@", "s=-|a=+@|u=+|h=|hp=n:|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+@|u=+|h=|hp=n:|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://@ ;; ni://@ ;; u://@ ;; sf://@|wf://@#X%20y|nf://@",
    ),
  )
  out.push(
    (
      "//:", "s=-|a=+:|u=-|h=|hp=n:|o=+|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+:|u=-|h=|hp=n:|o=+|p=|q=-|f=- ;; E:unexpected:0 ;; n:// ;; ni:// ;; u://: ;; sf://:|wf://:#X%20y|nf://:",
    ),
  )
  out.push(
    (
      "a:", "s=+a|a=-|p=|q=-|f=- ;; uri:a: ;; s=+a|a=-|p=|q=-|f=- ;; iri:a: ;; n:a: ;; ni:a: ;; u:a: ;; sf:a:|wf:a:#X%20y|nf:a:",
    ),
  )
  out.push(
    (
      "a:b", "s=+a|a=-|p=b|q=-|f=- ;; uri:a:b ;; s=+a|a=-|p=b|q=-|f=- ;; iri:a:b ;; n:a:b ;; ni:a:b ;; u:a:b ;; sf:a:b|wf:a:b#X%20y|nf:a:b",
    ),
  )
  out.push(
    (
      "a://", "s=+a|a=+|u=-|h=|hp=n:|o=-|p=|q=-|f=- ;; uri:a:// ;; s=+a|a=+|u=-|h=|hp=n:|o=-|p=|q=-|f=- ;; iri:a:// ;; n:a:// ;; ni:a:// ;; u:a:// ;; sf:a://|wf:a://#X%20y|nf:a://",
    ),
  )
  out.push(
    (
      "file:///etc/hosts", "s=+file|a=+|u=-|h=|hp=n:|o=-|p=/etc/hosts|q=-|f=- ;; uri:file:///etc/hosts ;; s=+file|a=+|u=-|h=|hp=n:|o=-|p=/etc/hosts|q=-|f=- ;; iri:file:///etc/hosts ;; n:file:///etc/hosts ;; ni:file:///etc/hosts ;; u:file:///etc/hosts ;; sf:file:///etc/hosts|wf:file:///etc/hosts#X%20y|nf:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "ftp://ftp.is.co.za/rfc/rfc1808.txt", "s=+ftp|a=+ftp.is.co.za|u=-|h=ftp.is.co.za|hp=n:ftp.is.co.za|o=-|p=/rfc/rfc1808.txt|q=-|f=- ;; uri:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; s=+ftp|a=+ftp.is.co.za|u=-|h=ftp.is.co.za|hp=n:ftp.is.co.za|o=-|p=/rfc/rfc1808.txt|q=-|f=- ;; iri:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; n:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; ni:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; u:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; sf:ftp://ftp.is.co.za/rfc/rfc1808.txt|wf:ftp://ftp.is.co.za/rfc/rfc1808.txt#X%20y|nf:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "http://www.ietf.org/rfc/rfc2396.txt", "s=+http|a=+www.ietf.org|u=-|h=www.ietf.org|hp=n:www.ietf.org|o=-|p=/rfc/rfc2396.txt|q=-|f=- ;; uri:http://www.ietf.org/rfc/rfc2396.txt ;; s=+http|a=+www.ietf.org|u=-|h=www.ietf.org|hp=n:www.ietf.org|o=-|p=/rfc/rfc2396.txt|q=-|f=- ;; iri:http://www.ietf.org/rfc/rfc2396.txt ;; n:http://www.ietf.org/rfc/rfc2396.txt ;; ni:http://www.ietf.org/rfc/rfc2396.txt ;; u:http://www.ietf.org/rfc/rfc2396.txt ;; sf:http://www.ietf.org/rfc/rfc2396.txt|wf:http://www.ietf.org/rfc/rfc2396.txt#X%20y|nf:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "ldap://[2001:db8::7]/c=GB?objectClass?one", "s=+ldap|a=+[2001:db8::7]|u=-|h=[2001:db8::7]|hp=6:2001:db8::7|o=-|p=/c=GB|q=+objectClass?one|f=- ;; uri:ldap://[2001:db8::7]/c=GB?objectClass?one ;; s=+ldap|a=+[2001:db8::7]|u=-|h=[2001:db8::7]|hp=6:2001:db8::7|o=-|p=/c=GB|q=+objectClass?one|f=- ;; iri:ldap://[2001:db8::7]/c=GB?objectClass?one ;; n:ldap://[2001:db8::7]/c=GB?objectClass?one ;; ni:ldap://[2001:db8::7]/c=GB?objectClass?one ;; u:ldap://[2001:db8::7]/c=GB?objectClass?one ;; sf:ldap://[2001:db8::7]/c=GB?objectClass?one|wf:ldap://[2001:db8::7]/c=GB?objectClass?one#X%20y|nf:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "mailto:John.Doe@example.com", "s=+mailto|a=-|p=John.Doe@example.com|q=-|f=- ;; uri:mailto:John.Doe@example.com ;; s=+mailto|a=-|p=John.Doe@example.com|q=-|f=- ;; iri:mailto:John.Doe@example.com ;; n:mailto:John.Doe@example.com ;; ni:mailto:John.Doe@example.com ;; u:mailto:John.Doe@example.com ;; sf:mailto:John.Doe@example.com|wf:mailto:John.Doe@example.com#X%20y|nf:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "news:comp.infosystems.www.servers.unix", "s=+news|a=-|p=comp.infosystems.www.servers.unix|q=-|f=- ;; uri:news:comp.infosystems.www.servers.unix ;; s=+news|a=-|p=comp.infosystems.www.servers.unix|q=-|f=- ;; iri:news:comp.infosystems.www.servers.unix ;; n:news:comp.infosystems.www.servers.unix ;; ni:news:comp.infosystems.www.servers.unix ;; u:news:comp.infosystems.www.servers.unix ;; sf:news:comp.infosystems.www.servers.unix|wf:news:comp.infosystems.www.servers.unix#X%20y|nf:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "tel:+1-816-555-1212", "s=+tel|a=-|p=+1-816-555-1212|q=-|f=- ;; uri:tel:+1-816-555-1212 ;; s=+tel|a=-|p=+1-816-555-1212|q=-|f=- ;; iri:tel:+1-816-555-1212 ;; n:tel:+1-816-555-1212 ;; ni:tel:+1-816-555-1212 ;; u:tel:+1-816-555-1212 ;; sf:tel:+1-816-555-1212|wf:tel:+1-816-555-1212#X%20y|nf:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "telnet://192.0.2.16:80/", "s=+telnet|a=+192.0.2.16:80|u=-|h=192.0.2.16|hp=4:192.0.2.16|o=+80|p=/|q=-|f=- ;; uri:telnet://192.0.2.16:80/ ;; s=+telnet|a=+192.0.2.16:80|u=-|h=192.0.2.16|hp=4:192.0.2.16|o=+80|p=/|q=-|f=- ;; iri:telnet://192.0.2.16:80/ ;; n:telnet://192.0.2.16:80/ ;; ni:telnet://192.0.2.16:80/ ;; u:telnet://192.0.2.16:80/ ;; sf:telnet://192.0.2.16:80/|wf:telnet://192.0.2.16:80/#X%20y|nf:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "s=+urn|a=-|p=oasis:names:specification:docbook:dtd:xml:4.1.2|q=-|f=- ;; uri:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; s=+urn|a=-|p=oasis:names:specification:docbook:dtd:xml:4.1.2|q=-|f=- ;; iri:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; n:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; ni:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; u:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; sf:urn:oasis:names:specification:docbook:dtd:xml:4.1.2|wf:urn:oasis:names:specification:docbook:dtd:xml:4.1.2#X%20y|nf:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "foo://example.com:8042/over/there?name=ferret#nose", "s=+foo|a=+example.com:8042|u=-|h=example.com|hp=n:example.com|o=+8042|p=/over/there|q=+name=ferret|f=+nose ;; uri:foo://example.com:8042/over/there?name=ferret#nose ;; s=+foo|a=+example.com:8042|u=-|h=example.com|hp=n:example.com|o=+8042|p=/over/there|q=+name=ferret|f=+nose ;; iri:foo://example.com:8042/over/there?name=ferret#nose ;; n:foo://example.com:8042/over/there?name=ferret#nose ;; ni:foo://example.com:8042/over/there?name=ferret#nose ;; u:foo://example.com:8042/over/there?name=ferret#nose ;; sf:foo://example.com:8042/over/there?name=ferret|wf:foo://example.com:8042/over/there?name=ferret#X%20y|nf:foo://example.com:8042/over/there?name=ferret",
    ),
  )
  out.push(
    (
      "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm", "s=+ftp|a=+cnn.example.com&story=breaking_news@10.0.0.1|u=+cnn.example.com&story=breaking_news|h=10.0.0.1|hp=4:10.0.0.1|o=-|p=/top_story.htm|q=-|f=- ;; uri:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; s=+ftp|a=+cnn.example.com&story=breaking_news@10.0.0.1|u=+cnn.example.com&story=breaking_news|h=10.0.0.1|hp=4:10.0.0.1|o=-|p=/top_story.htm|q=-|f=- ;; iri:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; n:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; ni:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; u:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; sf:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm|wf:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm#X%20y|nf:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "http://[vFe.foo.bar]", "s=+http|a=+[vFe.foo.bar]|u=-|h=[vFe.foo.bar]|hp=v|o=-|p=|q=-|f=- ;; uri:http://[vFe.foo.bar] ;; s=+http|a=+[vFe.foo.bar]|u=-|h=[vFe.foo.bar]|hp=v|o=-|p=|q=-|f=- ;; iri:http://[vFe.foo.bar] ;; n:http://[vfe.foo.bar] ;; ni:http://[vfe.foo.bar] ;; u:http://[vFe.foo.bar] ;; sf:http://[vFe.foo.bar]|wf:http://[vFe.foo.bar]#X%20y|nf:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "http://127.0.0.1:/", "s=+http|a=+127.0.0.1:|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+|p=/|q=-|f=- ;; uri:http://127.0.0.1:/ ;; s=+http|a=+127.0.0.1:|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+|p=/|q=-|f=- ;; iri:http://127.0.0.1:/ ;; n:http://127.0.0.1/ ;; ni:http://127.0.0.1/ ;; u:http://127.0.0.1:/ ;; sf:http://127.0.0.1:/|wf:http://127.0.0.1:/#X%20y|nf:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "http://127.0.0.1:80808/", "s=+http|a=+127.0.0.1:80808|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+80808|p=/|q=-|f=- ;; uri:http://127.0.0.1:80808/ ;; s=+http|a=+127.0.0.1:80808|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+80808|p=/|q=-|f=- ;; iri:http://127.0.0.1:80808/ ;; n:http://127.0.0.1:80808/ ;; ni:http://127.0.0.1:80808/ ;; u:http://127.0.0.1:80808/ ;; sf:http://127.0.0.1:80808/|wf:http://127.0.0.1:80808/#X%20y|nf:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "s=+eXAMPLE|a=+a|u=-|h=a|hp=n:a|o=-|p=/./b/../b/%63/%7bfoo%7d|q=-|f=- ;; uri:eXAMPLE://a/./b/../b/%63/%7bfoo%7d ;; s=+eXAMPLE|a=+a|u=-|h=a|hp=n:a|o=-|p=/./b/../b/%63/%7bfoo%7d|q=-|f=- ;; iri:eXAMPLE://a/./b/../b/%63/%7bfoo%7d ;; n:example://a/b/c/%7Bfoo%7D ;; ni:example://a/b/c/%7Bfoo%7D ;; u:eXAMPLE://a/./b/../b/%63/%7bfoo%7d ;; sf:eXAMPLE://a/./b/../b/%63/%7bfoo%7d|wf:eXAMPLE://a/./b/../b/%63/%7bfoo%7d#X%20y|nf:eXAMPLE://a/./b/../b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "http://example.com", "s=+http|a=+example.com|u=-|h=example.com|hp=n:example.com|o=-|p=|q=-|f=- ;; uri:http://example.com ;; s=+http|a=+example.com|u=-|h=example.com|hp=n:example.com|o=-|p=|q=-|f=- ;; iri:http://example.com ;; n:http://example.com ;; ni:http://example.com ;; u:http://example.com ;; sf:http://example.com|wf:http://example.com#X%20y|nf:http://example.com",
    ),
  )
  out.push(
    (
      "http://example.com:/", "s=+http|a=+example.com:|u=-|h=example.com|hp=n:example.com|o=+|p=/|q=-|f=- ;; uri:http://example.com:/ ;; s=+http|a=+example.com:|u=-|h=example.com|hp=n:example.com|o=+|p=/|q=-|f=- ;; iri:http://example.com:/ ;; n:http://example.com/ ;; ni:http://example.com/ ;; u:http://example.com:/ ;; sf:http://example.com:/|wf:http://example.com:/#X%20y|nf:http://example.com:/",
    ),
  )
  out.push(
    (
      "http://example.com:80/", "s=+http|a=+example.com:80|u=-|h=example.com|hp=n:example.com|o=+80|p=/|q=-|f=- ;; uri:http://example.com:80/ ;; s=+http|a=+example.com:80|u=-|h=example.com|hp=n:example.com|o=+80|p=/|q=-|f=- ;; iri:http://example.com:80/ ;; n:http://example.com:80/ ;; ni:http://example.com:80/ ;; u:http://example.com:80/ ;; sf:http://example.com:80/|wf:http://example.com:80/#X%20y|nf:http://example.com:80/",
    ),
  )
  out.push(
    (
      "%3a", "s=-|a=-|p=%3a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%3a|q=-|f=- ;; E:unexpected:0 ;; n:%3A ;; ni:%3A ;; u:%3a ;; sf:%3a|wf:%3a#X%20y|nf:%3a",
    ),
  )
  out.push(
    (
      "HTTP://www.EXAMPLE.com/", "s=+HTTP|a=+www.EXAMPLE.com|u=-|h=www.EXAMPLE.com|hp=n:www.EXAMPLE.com|o=-|p=/|q=-|f=- ;; uri:HTTP://www.EXAMPLE.com/ ;; s=+HTTP|a=+www.EXAMPLE.com|u=-|h=www.EXAMPLE.com|hp=n:www.EXAMPLE.com|o=-|p=/|q=-|f=- ;; iri:HTTP://www.EXAMPLE.com/ ;; n:http://www.example.com/ ;; ni:http://www.example.com/ ;; u:HTTP://www.EXAMPLE.com/ ;; sf:HTTP://www.EXAMPLE.com/|wf:HTTP://www.EXAMPLE.com/#X%20y|nf:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(
    (
      "http://a/../../../g", "s=+http|a=+a|u=-|h=a|hp=n:a|o=-|p=/../../../g|q=-|f=- ;; uri:http://a/../../../g ;; s=+http|a=+a|u=-|h=a|hp=n:a|o=-|p=/../../../g|q=-|f=- ;; iri:http://a/../../../g ;; n:http://a/g ;; ni:http://a/g ;; u:http://a/../../../g ;; sf:http://a/../../../g|wf:http://a/../../../g#X%20y|nf:http://a/../../../g",
    ),
  )
  out.push(
    (
      "http://a/b/c/%2E/%2E./%2e%2E/d", "s=+http|a=+a|u=-|h=a|hp=n:a|o=-|p=/b/c/%2E/%2E./%2e%2E/d|q=-|f=- ;; uri:http://a/b/c/%2E/%2E./%2e%2E/d ;; s=+http|a=+a|u=-|h=a|hp=n:a|o=-|p=/b/c/%2E/%2E./%2e%2E/d|q=-|f=- ;; iri:http://a/b/c/%2E/%2E./%2e%2E/d ;; n:http://a/d ;; ni:http://a/d ;; u:http://a/b/c/%2E/%2E./%2e%2E/d ;; sf:http://a/b/c/%2E/%2E./%2e%2E/d|wf:http://a/b/c/%2E/%2E./%2e%2E/d#X%20y|nf:http://a/b/c/%2E/%2E./%2e%2E/d",
    ),
  )
  out.push(
    (
      "foo/../bar", "s=-|a=-|p=foo/../bar|q=-|f=- ;; E:unexpected:3 ;; s=-|a=-|p=foo/../bar|q=-|f=- ;; E:unexpected:3 ;; n:foo/../bar ;; ni:foo/../bar ;; u:foo/../bar ;; sf:foo/../bar|wf:foo/../bar#X%20y|nf:foo/../bar",
    ),
  )
  out.push(
    (
      "/foo/../bar", "s=-|a=-|p=/foo/../bar|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/foo/../bar|q=-|f=- ;; E:unexpected:0 ;; n:/foo/../bar ;; ni:/foo/../bar ;; u:/foo/../bar ;; sf:/foo/../bar|wf:/foo/../bar#X%20y|nf:/foo/../bar",
    ),
  )
  out.push(
    (
      "foo:bar/../baz", "s=+foo|a=-|p=bar/../baz|q=-|f=- ;; uri:foo:bar/../baz ;; s=+foo|a=-|p=bar/../baz|q=-|f=- ;; iri:foo:bar/../baz ;; n:foo:bar/../baz ;; ni:foo:bar/../baz ;; u:foo:bar/../baz ;; sf:foo:bar/../baz|wf:foo:bar/../baz#X%20y|nf:foo:bar/../baz",
    ),
  )
  out.push(
    (
      "foo:/bar/./../baz", "s=+foo|a=-|p=/bar/./../baz|q=-|f=- ;; uri:foo:/bar/./../baz ;; s=+foo|a=-|p=/bar/./../baz|q=-|f=- ;; iri:foo:/bar/./../baz ;; n:foo:/baz ;; ni:foo:/baz ;; u:foo:/bar/./../baz ;; sf:foo:/bar/./../baz|wf:foo:/bar/./../baz#X%20y|nf:foo:/bar/./../baz",
    ),
  )
  out.push(
    (
      "foo:/.//@@", "s=+foo|a=-|p=/.//@@|q=-|f=- ;; uri:foo:/.//@@ ;; s=+foo|a=-|p=/.//@@|q=-|f=- ;; iri:foo:/.//@@ ;; n:foo:/.//@@ ;; ni:foo:/.//@@ ;; u:foo:/.//@@ ;; sf:foo:/.//@@|wf:foo:/.//@@#X%20y|nf:foo:/.//@@",
    ),
  )
  out.push(
    (
      "HTTP://%45XAMPLE.%43Om", "s=+HTTP|a=+%45XAMPLE.%43Om|u=-|h=%45XAMPLE.%43Om|hp=n:%45XAMPLE.%43Om|o=-|p=|q=-|f=- ;; uri:HTTP://%45XAMPLE.%43Om ;; s=+HTTP|a=+%45XAMPLE.%43Om|u=-|h=%45XAMPLE.%43Om|hp=n:%45XAMPLE.%43Om|o=-|p=|q=-|f=- ;; iri:HTTP://%45XAMPLE.%43Om ;; n:http://example.com ;; ni:http://example.com ;; u:HTTP://%45XAMPLE.%43Om ;; sf:HTTP://%45XAMPLE.%43Om|wf:HTTP://%45XAMPLE.%43Om#X%20y|nf:HTTP://%45XAMPLE.%43Om",
    ),
  )
  out.push(
    (
      "%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25", "s=-|a=-|p=%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25|q=-|f=- ;; E:unexpected:0 ;; n:%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25 ;; ni:%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25 ;; u:%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25 ;; sf:%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25|wf:%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25#X%20y|nf:%3A%2F%3F%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D%25",
    ),
  )
  out.push(
    (
      "FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b#%24%4d", "s=+FOO|a=+%55se%72@EXamp%4ce%2ecom:8042|u=+%55se%72|h=EXamp%4ce%2ecom|hp=n:EXamp%4ce%2ecom|o=+8042|p=/%4b%2f|q=+%4c%2b|f=+%24%4d ;; uri:FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b#%24%4d ;; s=+FOO|a=+%55se%72@EXamp%4ce%2ecom:8042|u=+%55se%72|h=EXamp%4ce%2ecom|hp=n:EXamp%4ce%2ecom|o=+8042|p=/%4b%2f|q=+%4c%2b|f=+%24%4d ;; iri:FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b#%24%4d ;; n:foo://User@example.com:8042/K%2F?L%2B#%24M ;; ni:foo://User@example.com:8042/K%2F?L%2B#%24M ;; u:FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b#%24%4d ;; sf:FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b|wf:FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b#X%20y|nf:FOO://%55se%72@EXamp%4ce%2ecom:8042/%4b%2f?%4c%2b",
    ),
  )
  out.push(
    (
      "//127.0.0.1", "s=-|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://127.0.0.1 ;; ni://127.0.0.1 ;; u://127.0.0.1 ;; sf://127.0.0.1|wf://127.0.0.1#X%20y|nf://127.0.0.1",
    ),
  )
  out.push(
    (
      "//127.0.0.%31", "s=-|a=+127.0.0.%31|u=-|h=127.0.0.%31|hp=n:127.0.0.%31|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+127.0.0.%31|u=-|h=127.0.0.%31|hp=n:127.0.0.%31|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://127.0.0.1 ;; ni://127.0.0.1 ;; u://127.0.0.%31 ;; sf://127.0.0.%31|wf://127.0.0.%31#X%20y|nf://127.0.0.%31",
    ),
  )
  out.push(
    (
      "//[::1]", "s=-|a=+[::1]|u=-|h=[::1]|hp=6:::1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[::1]|u=-|h=[::1]|hp=6:::1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::1] ;; ni://[::1] ;; u://[::1] ;; sf://[::1]|wf://[::1]#X%20y|nf://[::1]",
    ),
  )
  out.push(
    (
      "//[0000:0000:0000::1]", "s=-|a=+[0000:0000:0000::1]|u=-|h=[0000:0000:0000::1]|hp=6:::1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[0000:0000:0000::1]|u=-|h=[0000:0000:0000::1]|hp=6:::1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::1] ;; ni://[::1] ;; u://[0000:0000:0000::1] ;; sf://[0000:0000:0000::1]|wf://[0000:0000:0000::1]#X%20y|nf://[0000:0000:0000::1]",
    ),
  )
  out.push(
    (
      "//[0:0:0:0:0:ffff:192.0.2.1]", "s=-|a=+[0:0:0:0:0:ffff:192.0.2.1]|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[0:0:0:0:0:ffff:192.0.2.1]|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::ffff:192.0.2.1] ;; ni://[::ffff:192.0.2.1] ;; u://[0:0:0:0:0:ffff:192.0.2.1] ;; sf://[0:0:0:0:0:ffff:192.0.2.1]|wf://[0:0:0:0:0:ffff:192.0.2.1]#X%20y|nf://[0:0:0:0:0:ffff:192.0.2.1]",
    ),
  )
  out.push(
    (
      "//[::192.0.2.1]", "s=-|a=+[::192.0.2.1]|u=-|h=[::192.0.2.1]|hp=6:::c000:201|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[::192.0.2.1]|u=-|h=[::192.0.2.1]|hp=6:::c000:201|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::c000:201] ;; ni://[::c000:201] ;; u://[::192.0.2.1] ;; sf://[::192.0.2.1]|wf://[::192.0.2.1]#X%20y|nf://[::192.0.2.1]",
    ),
  )
  out.push(
    (
      "//[v1FdE.AddR]", "s=-|a=+[v1FdE.AddR]|u=-|h=[v1FdE.AddR]|hp=v|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[v1FdE.AddR]|u=-|h=[v1FdE.AddR]|hp=v|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[v1fde.addr] ;; ni://[v1fde.addr] ;; u://[v1FdE.AddR] ;; sf://[v1FdE.AddR]|wf://[v1FdE.AddR]#X%20y|nf://[v1FdE.AddR]",
    ),
  )
  out.push(
    (
      "//127.0.0.001", "s=-|a=+127.0.0.001|u=-|h=127.0.0.001|hp=n:127.0.0.001|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+127.0.0.001|u=-|h=127.0.0.001|hp=n:127.0.0.001|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://127.0.0.001 ;; ni://127.0.0.001 ;; u://127.0.0.001 ;; sf://127.0.0.001|wf://127.0.0.001#X%20y|nf://127.0.0.001",
    ),
  )
  out.push(
    (
      "//127.1", "s=-|a=+127.1|u=-|h=127.1|hp=n:127.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+127.1|u=-|h=127.1|hp=n:127.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://127.1 ;; ni://127.1 ;; u://127.1 ;; sf://127.1|wf://127.1#X%20y|nf://127.1",
    ),
  )
  out.push(
    (
      "//127.00.00.1", "s=-|a=+127.00.00.1|u=-|h=127.00.00.1|hp=n:127.00.00.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+127.00.00.1|u=-|h=127.00.00.1|hp=n:127.00.00.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://127.00.00.1 ;; ni://127.00.00.1 ;; u://127.00.00.1 ;; sf://127.00.00.1|wf://127.00.00.1#X%20y|nf://127.00.00.1",
    ),
  )
  out.push(
    (
      "//[::1.1.1.1]", "s=-|a=+[::1.1.1.1]|u=-|h=[::1.1.1.1]|hp=6:::101:101|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[::1.1.1.1]|u=-|h=[::1.1.1.1]|hp=6:::101:101|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::101:101] ;; ni://[::101:101] ;; u://[::1.1.1.1] ;; sf://[::1.1.1.1]|wf://[::1.1.1.1]#X%20y|nf://[::1.1.1.1]",
    ),
  )
  out.push(
    (
      "//[::ffff:1.1.1.1]", "s=-|a=+[::ffff:1.1.1.1]|u=-|h=[::ffff:1.1.1.1]|hp=6:::ffff:1.1.1.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[::ffff:1.1.1.1]|u=-|h=[::ffff:1.1.1.1]|hp=6:::ffff:1.1.1.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::ffff:1.1.1.1] ;; ni://[::ffff:1.1.1.1] ;; u://[::ffff:1.1.1.1] ;; sf://[::ffff:1.1.1.1]|wf://[::ffff:1.1.1.1]#X%20y|nf://[::ffff:1.1.1.1]",
    ),
  )
  out.push(
    (
      "//[0000:0000:0000:0000:0000:0000:255.255.255.255]", "s=-|a=+[0000:0000:0000:0000:0000:0000:255.255.255.255]|u=-|h=[0000:0000:0000:0000:0000:0000:255.255.255.255]|hp=6:::ffff:ffff|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[0000:0000:0000:0000:0000:0000:255.255.255.255]|u=-|h=[0000:0000:0000:0000:0000:0000:255.255.255.255]|hp=6:::ffff:ffff|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::ffff:ffff] ;; ni://[::ffff:ffff] ;; u://[0000:0000:0000:0000:0000:0000:255.255.255.255] ;; sf://[0000:0000:0000:0000:0000:0000:255.255.255.255]|wf://[0000:0000:0000:0000:0000:0000:255.255.255.255]#X%20y|nf://[0000:0000:0000:0000:0000:0000:255.255.255.255]",
    ),
  )
  out.push(
    (
      "//[::01.1.1.1]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[::00.1.1.1]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[:]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[vG.addr]", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[v.addr]", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[vF.]", "E:unexpected:6 ;; E:unexpected:0 ;; E:unexpected:6 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[vF.%20]", "E:unexpected:6 ;; E:unexpected:0 ;; E:unexpected:6 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[fe80::abcd%eth0]", "E:unexpected:13 ;; E:unexpected:0 ;; E:unexpected:13 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[44:55::66::77]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      ":hello", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "3ttp://a.com", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "exam=ple:foo", "E:unexpected:8 ;; E:unexpected:4 ;; E:unexpected:8 ;; E:unexpected:4 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "(:", "E:unexpected:1 ;; E:unexpected:0 ;; E:unexpected:1 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a%20:foo", "E:unexpected:4 ;; E:unexpected:1 ;; E:unexpected:4 ;; E:unexpected:1 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo\\bar", "E:unexpected:3 ;; E:unexpected:3 ;; E:unexpected:3 ;; E:unexpected:3 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo%xxd", "E:unexpected:4 ;; E:unexpected:3 ;; E:unexpected:4 ;; E:unexpected:3 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "text%a", "E:unexpected:6 ;; E:unexpected:4 ;; E:unexpected:6 ;; E:unexpected:4 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%", "E:unexpected:1 ;; E:unexpected:0 ;; E:unexpected:1 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://example.com:80ab", "E:unexpected:23 ;; E:unexpected:23 ;; E:unexpected:23 ;; E:unexpected:23 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://user@example.com:80ab", "E:unexpected:26 ;; E:unexpected:26 ;; E:unexpected:26 ;; E:unexpected:26 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://user:pass:example.com/", "E:unexpected:28 ;; E:unexpected:28 ;; E:unexpected:28 ;; E:unexpected:28 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "https://[::1/", "E:unexpected:12 ;; E:unexpected:12 ;; E:unexpected:12 ;; E:unexpected:12 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "https://[::1]wrong", "E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9", "s=+eXAMPLE|a=+a|u=-|h=a|hp=n:a|o=-|p=/./b/../b/%63/%7bfoo%7d/ros%C3%A9|q=-|f=- ;; uri:eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9 ;; s=+eXAMPLE|a=+a|u=-|h=a|hp=n:a|o=-|p=/./b/../b/%63/%7bfoo%7d/ros%C3%A9|q=-|f=- ;; iri:eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9 ;; n:example://a/b/c/%7Bfoo%7D/ros%C3%A9 ;; ni:example://a/b/c/%7Bfoo%7D/ros\u{e9} ;; u:eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9 ;; sf:eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9|wf:eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9#X%20y|nf:eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9",
    ),
  )
  out.push(
    (
      "?%EE%80%80", "s=-|a=-|p=|q=+%EE%80%80|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=+%EE%80%80|f=- ;; E:unexpected:0 ;; n:?%EE%80%80 ;; ni:?\u{e000} ;; u:?%EE%80%80 ;; sf:?%EE%80%80|wf:?%EE%80%80#X%20y|nf:?%EE%80%80",
    ),
  )
  out.push(
    (
      "http://r\u{e9}sum\u{e9}.example.org", "E:unexpected:8 ;; E:unexpected:8 ;; s=+http|a=+r\u{e9}sum\u{e9}.example.org|u=-|h=r\u{e9}sum\u{e9}.example.org|hp=n:r\u{e9}sum\u{e9}.example.org|o=-|p=|q=-|f=- ;; iri:http://r\u{e9}sum\u{e9}.example.org ;; - ;; ni:http://r\u{e9}sum\u{e9}.example.org ;; u:http://r%C3%A9sum%C3%A9.example.org ;; sf:http://r\u{e9}sum\u{e9}.example.org|wf:http://r\u{e9}sum\u{e9}.example.org#X%20y|nf:http://r\u{e9}sum\u{e9}.example.org",
    ),
  )
  out.push(
    (
      "http://www.example.org/red%09ros\u{e9}#red", "E:unexpected:32 ;; E:unexpected:32 ;; s=+http|a=+www.example.org|u=-|h=www.example.org|hp=n:www.example.org|o=-|p=/red%09ros\u{e9}|q=-|f=+red ;; iri:http://www.example.org/red%09ros\u{e9}#red ;; - ;; ni:http://www.example.org/red%09ros\u{e9}#red ;; u:http://www.example.org/red%09ros%C3%A9#red ;; sf:http://www.example.org/red%09ros\u{e9}|wf:http://www.example.org/red%09ros\u{e9}#X%20y|nf:http://www.example.org/red%09ros\u{e9}",
    ),
  )
  out.push(
    (
      "http://example.com/\u{10300}\u{10301}\u{10302}", "E:unexpected:19 ;; E:unexpected:19 ;; s=+http|a=+example.com|u=-|h=example.com|hp=n:example.com|o=-|p=/\u{10300}\u{10301}\u{10302}|q=-|f=- ;; iri:http://example.com/\u{10300}\u{10301}\u{10302} ;; - ;; ni:http://example.com/\u{10300}\u{10301}\u{10302} ;; u:http://example.com/%F0%90%8C%80%F0%90%8C%81%F0%90%8C%82 ;; sf:http://example.com/\u{10300}\u{10301}\u{10302}|wf:http://example.com/\u{10300}\u{10301}\u{10302}#X%20y|nf:http://example.com/\u{10300}\u{10301}\u{10302}",
    ),
  )
  out.push(
    (
      "http://www.example.org/r%E9sum%E9.html", "s=+http|a=+www.example.org|u=-|h=www.example.org|hp=n:www.example.org|o=-|p=/r%E9sum%E9.html|q=-|f=- ;; uri:http://www.example.org/r%E9sum%E9.html ;; s=+http|a=+www.example.org|u=-|h=www.example.org|hp=n:www.example.org|o=-|p=/r%E9sum%E9.html|q=-|f=- ;; iri:http://www.example.org/r%E9sum%E9.html ;; n:http://www.example.org/r%E9sum%E9.html ;; ni:http://www.example.org/r%E9sum%E9.html ;; u:http://www.example.org/r%E9sum%E9.html ;; sf:http://www.example.org/r%E9sum%E9.html|wf:http://www.example.org/r%E9sum%E9.html#X%20y|nf:http://www.example.org/r%E9sum%E9.html",
    ),
  )
  out.push(
    (
      "http://www.example.org/D%C3%BCrst", "s=+http|a=+www.example.org|u=-|h=www.example.org|hp=n:www.example.org|o=-|p=/D%C3%BCrst|q=-|f=- ;; uri:http://www.example.org/D%C3%BCrst ;; s=+http|a=+www.example.org|u=-|h=www.example.org|hp=n:www.example.org|o=-|p=/D%C3%BCrst|q=-|f=- ;; iri:http://www.example.org/D%C3%BCrst ;; n:http://www.example.org/D%C3%BCrst ;; ni:http://www.example.org/D\u{fc}rst ;; u:http://www.example.org/D%C3%BCrst ;; sf:http://www.example.org/D%C3%BCrst|wf:http://www.example.org/D%C3%BCrst#X%20y|nf:http://www.example.org/D%C3%BCrst",
    ),
  )
  out.push(
    (
      "http://xn--99zt52a.example.org/%e2%80%ae", "s=+http|a=+xn--99zt52a.example.org|u=-|h=xn--99zt52a.example.org|hp=n:xn--99zt52a.example.org|o=-|p=/%e2%80%ae|q=-|f=- ;; uri:http://xn--99zt52a.example.org/%e2%80%ae ;; s=+http|a=+xn--99zt52a.example.org|u=-|h=xn--99zt52a.example.org|hp=n:xn--99zt52a.example.org|o=-|p=/%e2%80%ae|q=-|f=- ;; iri:http://xn--99zt52a.example.org/%e2%80%ae ;; n:http://xn--99zt52a.example.org/%E2%80%AE ;; ni:http://xn--99zt52a.example.org/\u{202e} ;; u:http://xn--99zt52a.example.org/%e2%80%ae ;; sf:http://xn--99zt52a.example.org/%e2%80%ae|wf:http://xn--99zt52a.example.org/%e2%80%ae#X%20y|nf:http://xn--99zt52a.example.org/%e2%80%ae",
    ),
  )
  out.push(
    (
      "r\u{e9}f/rel", "E:unexpected:1 ;; E:unexpected:1 ;; s=-|a=-|p=r\u{e9}f/rel|q=-|f=- ;; E:unexpected:1 ;; - ;; ni:r\u{e9}f/rel ;; u:r%C3%A9f/rel ;; sf:r\u{e9}f/rel|wf:r\u{e9}f/rel#X%20y|nf:r\u{e9}f/rel",
    ),
  )
  out.push(
    (
      "http://\u{4f60}\u{597d}.example.com/", "E:unexpected:7 ;; E:unexpected:7 ;; s=+http|a=+\u{4f60}\u{597d}.example.com|u=-|h=\u{4f60}\u{597d}.example.com|hp=n:\u{4f60}\u{597d}.example.com|o=-|p=/|q=-|f=- ;; iri:http://\u{4f60}\u{597d}.example.com/ ;; - ;; ni:http://\u{4f60}\u{597d}.example.com/ ;; u:http://%E4%BD%A0%E5%A5%BD.example.com/ ;; sf:http://\u{4f60}\u{597d}.example.com/|wf:http://\u{4f60}\u{597d}.example.com/#X%20y|nf:http://\u{4f60}\u{597d}.example.com/",
    ),
  )
  out.push(
    (
      "a/b/c/../../d", "s=-|a=-|p=a/b/c/../../d|q=-|f=- ;; E:unexpected:1 ;; s=-|a=-|p=a/b/c/../../d|q=-|f=- ;; E:unexpected:1 ;; n:a/b/c/../../d ;; ni:a/b/c/../../d ;; u:a/b/c/../../d ;; sf:a/b/c/../../d|wf:a/b/c/../../d#X%20y|nf:a/b/c/../../d",
    ),
  )
  out.push(
    (
      "a:%2E%2E/b", "s=+a|a=-|p=%2E%2E/b|q=-|f=- ;; uri:a:%2E%2E/b ;; s=+a|a=-|p=%2E%2E/b|q=-|f=- ;; iri:a:%2E%2E/b ;; n:a:../b ;; ni:a:../b ;; u:a:%2E%2E/b ;; sf:a:%2E%2E/b|wf:a:%2E%2E/b#X%20y|nf:a:%2E%2E/b",
    ),
  )
  out.push(
    (
      "foo:/%2e%2E//bar", "s=+foo|a=-|p=/%2e%2E//bar|q=-|f=- ;; uri:foo:/%2e%2E//bar ;; s=+foo|a=-|p=/%2e%2E//bar|q=-|f=- ;; iri:foo:/%2e%2E//bar ;; n:foo:/.//bar ;; ni:foo:/.//bar ;; u:foo:/%2e%2E//bar ;; sf:foo:/%2e%2E//bar|wf:foo:/%2e%2E//bar#X%20y|nf:foo:/%2e%2E//bar",
    ),
  )
  out.push(
    (
      "//user@[::1]:8080/p?q#f", "s=-|a=+user@[::1]:8080|u=+user|h=[::1]|hp=6:::1|o=+8080|p=/p|q=+q|f=+f ;; E:unexpected:0 ;; s=-|a=+user@[::1]:8080|u=+user|h=[::1]|hp=6:::1|o=+8080|p=/p|q=+q|f=+f ;; E:unexpected:0 ;; n://user@[::1]:8080/p?q#f ;; ni://user@[::1]:8080/p?q#f ;; u://user@[::1]:8080/p?q#f ;; sf://user@[::1]:8080/p?q|wf://user@[::1]:8080/p?q#X%20y|nf://user@[::1]:8080/p?q",
    ),
  )
  out.push(
    (
      "s://h/%E2%82", "s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%E2%82|q=-|f=- ;; uri:s://h/%E2%82 ;; s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%E2%82|q=-|f=- ;; iri:s://h/%E2%82 ;; n:s://h/%E2%82 ;; ni:s://h/%E2%82 ;; u:s://h/%E2%82 ;; sf:s://h/%E2%82|wf:s://h/%E2%82#X%20y|nf:s://h/%E2%82",
    ),
  )
  out.push(
    (
      "s://h/%ED%A0%80", "s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%ED%A0%80|q=-|f=- ;; uri:s://h/%ED%A0%80 ;; s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%ED%A0%80|q=-|f=- ;; iri:s://h/%ED%A0%80 ;; n:s://h/%ED%A0%80 ;; ni:s://h/%ED%A0%80 ;; u:s://h/%ED%A0%80 ;; sf:s://h/%ED%A0%80|wf:s://h/%ED%A0%80#X%20y|nf:s://h/%ED%A0%80",
    ),
  )
  out.push(
    (
      "s://h/%F0%90%8C%80", "s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%F0%90%8C%80|q=-|f=- ;; uri:s://h/%F0%90%8C%80 ;; s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%F0%90%8C%80|q=-|f=- ;; iri:s://h/%F0%90%8C%80 ;; n:s://h/%F0%90%8C%80 ;; ni:s://h/\u{10300} ;; u:s://h/%F0%90%8C%80 ;; sf:s://h/%F0%90%8C%80|wf:s://h/%F0%90%8C%80#X%20y|nf:s://h/%F0%90%8C%80",
    ),
  )
  out.push(
    (
      "s://h/%E0%80%80", "s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%E0%80%80|q=-|f=- ;; uri:s://h/%E0%80%80 ;; s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%E0%80%80|q=-|f=- ;; iri:s://h/%E0%80%80 ;; n:s://h/%E0%80%80 ;; ni:s://h/%E0%80%80 ;; u:s://h/%E0%80%80 ;; sf:s://h/%E0%80%80|wf:s://h/%E0%80%80#X%20y|nf:s://h/%E0%80%80",
    ),
  )
  out.push(
    (
      "s://h/%F4%90%80%80", "s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%F4%90%80%80|q=-|f=- ;; uri:s://h/%F4%90%80%80 ;; s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%F4%90%80%80|q=-|f=- ;; iri:s://h/%F4%90%80%80 ;; n:s://h/%F4%90%80%80 ;; ni:s://h/%F4%90%80%80 ;; u:s://h/%F4%90%80%80 ;; sf:s://h/%F4%90%80%80|wf:s://h/%F4%90%80%80#X%20y|nf:s://h/%F4%90%80%80",
    ),
  )
  out.push(
    (
      "s://h/%F0%9F%98", "s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%F0%9F%98|q=-|f=- ;; uri:s://h/%F0%9F%98 ;; s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/%F0%9F%98|q=-|f=- ;; iri:s://h/%F0%9F%98 ;; n:s://h/%F0%9F%98 ;; ni:s://h/%F0%9F%98 ;; u:s://h/%F0%9F%98 ;; sf:s://h/%F0%9F%98|wf:s://h/%F0%9F%98#X%20y|nf:s://h/%F0%9F%98",
    ),
  )
  out.push(
    (
      "s://%C0%80", "s=+s|a=+%C0%80|u=-|h=%C0%80|hp=n:%C0%80|o=-|p=|q=-|f=- ;; uri:s://%C0%80 ;; s=+s|a=+%C0%80|u=-|h=%C0%80|hp=n:%C0%80|o=-|p=|q=-|f=- ;; iri:s://%C0%80 ;; n:s://%C0%80 ;; ni:s://%C0%80 ;; u:s://%C0%80 ;; sf:s://%C0%80|wf:s://%C0%80#X%20y|nf:s://%C0%80",
    ),
  )
  out.push(
    (
      "s://h/a%F1%80%80%E1%80%C2b", "s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/a%F1%80%80%E1%80%C2b|q=-|f=- ;; uri:s://h/a%F1%80%80%E1%80%C2b ;; s=+s|a=+h|u=-|h=h|hp=n:h|o=-|p=/a%F1%80%80%E1%80%C2b|q=-|f=- ;; iri:s://h/a%F1%80%80%E1%80%C2b ;; n:s://h/a%F1%80%80%E1%80%C2b ;; ni:s://h/a%F1%80%80%E1%80%C2b ;; u:s://h/a%F1%80%80%E1%80%C2b ;; sf:s://h/a%F1%80%80%E1%80%C2b|wf:s://h/a%F1%80%80%E1%80%C2b#X%20y|nf:s://h/a%F1%80%80%E1%80%C2b",
    ),
  )
  out.push(
    (
      "s:?%C2%A2%E0%A4%B9%F0%90%8D%88", "s=+s|a=-|p=|q=+%C2%A2%E0%A4%B9%F0%90%8D%88|f=- ;; uri:s:?%C2%A2%E0%A4%B9%F0%90%8D%88 ;; s=+s|a=-|p=|q=+%C2%A2%E0%A4%B9%F0%90%8D%88|f=- ;; iri:s:?%C2%A2%E0%A4%B9%F0%90%8D%88 ;; n:s:?%C2%A2%E0%A4%B9%F0%90%8D%88 ;; ni:s:?\u{a2}\u{939}\u{10348} ;; u:s:?%C2%A2%E0%A4%B9%F0%90%8D%88 ;; sf:s:?%C2%A2%E0%A4%B9%F0%90%8D%88|wf:s:?%C2%A2%E0%A4%B9%F0%90%8D%88#X%20y|nf:s:?%C2%A2%E0%A4%B9%F0%90%8D%88",
    ),
  )
  out.push(
    (
      "s:#%80%BF", "s=+s|a=-|p=|q=-|f=+%80%BF ;; uri:s:#%80%BF ;; s=+s|a=-|p=|q=-|f=+%80%BF ;; iri:s:#%80%BF ;; n:s:#%80%BF ;; ni:s:#%80%BF ;; u:s:#%80%BF ;; sf:s:|wf:s:#X%20y|nf:s:",
    ),
  )
  out.push(
    (
      "/../%2e/..a/%2E/%2E/.%2e/?{}1", "E:unexpected:26 ;; E:unexpected:0 ;; E:unexpected:26 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/..//./%2E/a/a", "s=-|a=-|p=/..//./%2E/a/a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/..//./%2E/a/a|q=-|f=- ;; E:unexpected:0 ;; n:/..//././a/a ;; ni:/..//././a/a ;; u:/..//./%2E/a/a ;; sf:/..//./%2E/a/a|wf:/..//./%2E/a/a#X%20y|nf:/..//./%2E/a/a",
    ),
  )
  out.push(
    (
      "HTTP:/%C1%81%ED%A0%80/\"^?%7e", "E:unexpected:22 ;; E:unexpected:22 ;; E:unexpected:22 ;; E:unexpected:22 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://[V.1]///?", "E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/..a/%2E.", "s=-|a=-|p=/..a/%2E.|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/..a/%2E.|q=-|f=- ;; E:unexpected:0 ;; n:/..a/.. ;; ni:/..a/.. ;; u:/..a/%2E. ;; sf:/..a/%2E.|wf:/..a/%2E.#X%20y|nf:/..a/%2E.",
    ),
  )
  out.push(
    (
      "//[Vg.}%E0%A4%B9]", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo:/%C0%80/", "s=+foo|a=-|p=/%C0%80/|q=-|f=- ;; uri:foo:/%C0%80/ ;; s=+foo|a=-|p=/%C0%80/|q=-|f=- ;; iri:foo:/%C0%80/ ;; n:foo:/%C0%80/ ;; ni:foo:/%C0%80/ ;; u:foo:/%C0%80/ ;; sf:foo:/%C0%80/|wf:foo:/%C0%80/#X%20y|nf:foo:/%C0%80/",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "/a/%2E/./.../a/..a/%2e/", "s=-|a=-|p=/a/%2E/./.../a/..a/%2e/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/a/%2E/./.../a/..a/%2e/|q=-|f=- ;; E:unexpected:0 ;; n:/a/././.../a/..a/./ ;; ni:/a/././.../a/..a/./ ;; u:/a/%2E/./.../a/..a/%2e/ ;; sf:/a/%2E/./.../a/..a/%2e/|wf:/a/%2E/./.../a/..a/%2e/#X%20y|nf:/a/%2E/./.../a/..a/%2e/",
    ),
  )
  out.push(
    (
      "//%2e]@[0:0:0:0:0:ffff:192.0.2.1]:/\u{10300}Z", "E:unexpected:5 ;; E:unexpected:0 ;; E:unexpected:5 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/!0?%", "E:unexpected:5 ;; E:unexpected:0 ;; E:unexpected:5 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2e%2E/.%2e", "s=-|a=-|p=/%2e%2E/.%2e|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2e%2E/.%2e|q=-|f=- ;; E:unexpected:0 ;; n:/../.. ;; ni:/../.. ;; u:/%2e%2E/.%2e ;; sf:/%2e%2E/.%2e|wf:/%2e%2E/.%2e#X%20y|nf:/%2e%2E/.%2e",
    ),
  )
  out.push(
    (
      "%F0%90%8D%88%F4%90%80%80A^?%ED%A0%80", "E:unexpected:25 ;; E:unexpected:0 ;; E:unexpected:25 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a://9*%C2%A2@[0:0:0:0:0:ffff:192.0.2.1]/?.//?[%F0%90%8C%80", "E:unexpected:45 ;; E:unexpected:45 ;; E:unexpected:45 ;; E:unexpected:45 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a:/`?`v6", "E:unexpected:3 ;; E:unexpected:3 ;; E:unexpected:3 ;; E:unexpected:3 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "\u{10300}", "E:unexpected:0 ;; E:unexpected:0 ;; s=-|a=-|p=\u{10300}|q=-|f=- ;; E:unexpected:0 ;; - ;; ni:\u{10300} ;; u:%F0%90%8C%80 ;; sf:\u{10300}|wf:\u{10300}#X%20y|nf:\u{10300}",
    ),
  )
  out.push(
    (
      "//[]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[192.0.2.1192.0.2.10000v192.0.2.1::ffff]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//.../a", "s=-|a=+...|u=-|h=...|hp=n:...|o=-|p=/a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+...|u=-|h=...|hp=n:...|o=-|p=/a|q=-|f=- ;; E:unexpected:0 ;; n://.../a ;; ni://.../a ;; u://.../a ;; sf://.../a|wf://.../a#X%20y|nf://.../a",
    ),
  )
  out.push(
    (
      "z9+-.://[0:0:0:0:0:ffff:192.0.2.1]#%E2%82", "s=+z9+-.|a=+[0:0:0:0:0:ffff:192.0.2.1]|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=-|p=|q=-|f=+%E2%82 ;; uri:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]#%E2%82 ;; s=+z9+-.|a=+[0:0:0:0:0:ffff:192.0.2.1]|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=-|p=|q=-|f=+%E2%82 ;; iri:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]#%E2%82 ;; n:z9+-.://[::ffff:192.0.2.1]#%E2%82 ;; ni:z9+-.://[::ffff:192.0.2.1]#%E2%82 ;; u:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]#%E2%82 ;; sf:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]|wf:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]#X%20y|nf:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]",
    ),
  )
  out.push(
    (
      "/b/b/./%2e%2E", "s=-|a=-|p=/b/b/./%2e%2E|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/b/b/./%2e%2E|q=-|f=- ;; E:unexpected:0 ;; n:/b/b/./.. ;; ni:/b/b/./.. ;; u:/b/b/./%2e%2E ;; sf:/b/b/./%2e%2E|wf:/b/b/./%2e%2E#X%20y|nf:/b/b/./%2e%2E",
    ),
  )
  out.push(
    (
      "http://[abcdFFFF12345::12345255.255.255.255zFFFF%]:94768/%C2%A2%41/Z#", "E:ipv6:8 ;; E:ipv6:8 ;; E:ipv6:8 ;; E:ipv6:8 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//127.0.0.1?%BF:%", "E:unexpected:14 ;; E:unexpected:0 ;; E:unexpected:14 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%BF", "s=-|a=-|p=%BF|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%BF|q=-|f=- ;; E:unexpected:0 ;; n:%BF ;; ni:%BF ;; u:%BF ;; sf:%BF|wf:%BF#X%20y|nf:%BF",
    ),
  )
  out.push(
    (
      "foo:/)#", "s=+foo|a=-|p=/)|q=-|f=+ ;; uri:foo:/)# ;; s=+foo|a=-|p=/)|q=-|f=+ ;; iri:foo:/)# ;; n:foo:/)# ;; ni:foo:/)# ;; u:foo:/)# ;; sf:foo:/)|wf:foo:/)#X%20y|nf:foo:/)",
    ),
  )
  out.push(
    (
      "/", "s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; n:/ ;; ni:/ ;; u:/ ;; sf:/|wf:/#X%20y|nf:/",
    ),
  )
  out.push(
    (
      "http://[v.]/..a/.%2e/..a/..a//", "E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "///", "s=-|a=+|u=-|h=|hp=n:|o=-|p=/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+|u=-|h=|hp=n:|o=-|p=/|q=-|f=- ;; E:unexpected:0 ;; n:/// ;; ni:/// ;; u:/// ;; sf:///|wf:///#X%20y|nf:///",
    ),
  )
  out.push(
    (
      "//[0000%1]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http:?,#\\", "E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a://%E2%82.@[::]/%2e/...", "s=+a|a=+%E2%82.@[::]|u=+%E2%82.|h=[::]|hp=6:::|o=-|p=/%2e/...|q=-|f=- ;; uri:a://%E2%82.@[::]/%2e/... ;; s=+a|a=+%E2%82.@[::]|u=+%E2%82.|h=[::]|hp=6:::|o=-|p=/%2e/...|q=-|f=- ;; iri:a://%E2%82.@[::]/%2e/... ;; n:a://%E2%82.@[::]/... ;; ni:a://%E2%82.@[::]/... ;; u:a://%E2%82.@[::]/%2e/... ;; sf:a://%E2%82.@[::]/%2e/...|wf:a://%E2%82.@[::]/%2e/...#X%20y|nf:a://%E2%82.@[::]/%2e/...",
    ),
  )
  out.push(
    (
      "//[11.2.3%FFFF0000:01.2.3.4v]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo://z%41@[vFFFF:z01.2.3.4.1]/\u{e000}]//%41%ED%A0%80?#", "E:unexpected:17 ;; E:unexpected:17 ;; E:unexpected:17 ;; E:unexpected:17 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2E/%2e%2E/../a/.../a/.", "s=-|a=-|p=/%2E/%2e%2E/../a/.../a/.|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2E/%2e%2E/../a/.../a/.|q=-|f=- ;; E:unexpected:0 ;; n:/./../../a/.../a/. ;; ni:/./../../a/.../a/. ;; u:/%2E/%2e%2E/../a/.../a/. ;; sf:/%2E/%2e%2E/../a/.../a/.|wf:/%2E/%2e%2E/../a/.../a/.#X%20y|nf:/%2E/%2e%2E/../a/.../a/.",
    ),
  )
  out.push(
    (
      "//[::1]:/%2F?#%C0%80#.%E0%A4%B9", "E:unexpected:20 ;; E:unexpected:0 ;; E:unexpected:20 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP:/%2E.?<%C3%A9#=_", "E:unexpected:11 ;; E:unexpected:11 ;; E:unexpected:11 ;; E:unexpected:11 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo:#%a%ED%A0%80", "E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "z9+-.:/,%41//A?", "s=+z9+-.|a=-|p=/,%41//A|q=+|f=- ;; uri:z9+-.:/,%41//A? ;; s=+z9+-.|a=-|p=/,%41//A|q=+|f=- ;; iri:z9+-.:/,%41//A? ;; n:z9+-.:/,A//A? ;; ni:z9+-.:/,A//A? ;; u:z9+-.:/,%41//A? ;; sf:z9+-.:/,%41//A?|wf:z9+-.:/,%41//A?#X%20y|nf:z9+-.:/,%41//A?",
    ),
  )
  out.push(
    (
      "//[%FFFF01.2.3.40]/%2E/%2e%2E?<", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[01.2.3.4FFFF::.:va12345]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/..a", "s=-|a=-|p=/..a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/..a|q=-|f=- ;; E:unexpected:0 ;; n:/..a ;; ni:/..a ;; u:/..a ;; sf:/..a|wf:/..a#X%20y|nf:/..a",
    ),
  )
  out.push(
    (
      "/%2E/.%2e/.../?%a#|", "E:unexpected:17 ;; E:unexpected:0 ;; E:unexpected:17 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a:/.%2e///a/./.%2e/%2E", "s=+a|a=-|p=/.%2e///a/./.%2e/%2E|q=-|f=- ;; uri:a:/.%2e///a/./.%2e/%2E ;; s=+a|a=-|p=/.%2e///a/./.%2e/%2E|q=-|f=- ;; iri:a:/.%2e///a/./.%2e/%2E ;; n:a:/./// ;; ni:a:/./// ;; u:a:/.%2e///a/./.%2e/%2E ;; sf:a:/.%2e///a/./.%2e/%2E|wf:a:/.%2e///a/./.%2e/%2E#X%20y|nf:a:/.%2e///a/./.%2e/%2E",
    ),
  )
  out.push(
    (
      "z9+-.:/%2e/..", "s=+z9+-.|a=-|p=/%2e/..|q=-|f=- ;; uri:z9+-.:/%2e/.. ;; s=+z9+-.|a=-|p=/%2e/..|q=-|f=- ;; iri:z9+-.:/%2e/.. ;; n:z9+-.:/ ;; ni:z9+-.:/ ;; u:z9+-.:/%2e/.. ;; sf:z9+-.:/%2e/..|wf:z9+-.:/%2e/..#X%20y|nf:z9+-.:/%2e/..",
    ),
  )
  out.push(
    (
      "%2e?%2E%E2%82\u{4f8b}0", "E:unexpected:13 ;; E:unexpected:0 ;; s=-|a=-|p=%2e|q=+%2E%E2%82\u{4f8b}0|f=- ;; E:unexpected:0 ;; - ;; ni:.?.%E2%82\u{4f8b}0 ;; u:%2e?%2E%E2%82%E4%BE%8B0 ;; sf:%2e?%2E%E2%82\u{4f8b}0|wf:%2e?%2E%E2%82\u{4f8b}0#X%20y|nf:%2e?%2E%E2%82\u{4f8b}0",
    ),
  )
  out.push(
    (
      "http:/a/.?)<{#=127.0.0.1", "E:unexpected:11 ;; E:unexpected:11 ;; E:unexpected:11 ;; E:unexpected:11 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%2e/_", "s=-|a=-|p=%2e/_|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%2e/_|q=-|f=- ;; E:unexpected:0 ;; n:./_ ;; ni:./_ ;; u:%2e/_ ;; sf:%2e/_|wf:%2e/_#X%20y|nf:%2e/_",
    ),
  )
  out.push(
    (
      "HTTP:!#", "s=+HTTP|a=-|p=!|q=-|f=+ ;; uri:HTTP:!# ;; s=+HTTP|a=-|p=!|q=-|f=+ ;; iri:HTTP:!# ;; n:http:!# ;; ni:http:!# ;; u:HTTP:!# ;; sf:HTTP:!|wf:HTTP:!#X%20y|nf:HTTP:!",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "/%C1%81\u{4f8b}//%F4%90%80%80?%2F.%2e#", "E:unexpected:7 ;; E:unexpected:0 ;; s=-|a=-|p=/%C1%81\u{4f8b}//%F4%90%80%80|q=+%2F.%2e|f=+ ;; E:unexpected:0 ;; - ;; ni:/%C1%81\u{4f8b}//%F4%90%80%80?%2F..# ;; u:/%C1%81%E4%BE%8B//%F4%90%80%80?%2F.%2e# ;; sf:/%C1%81\u{4f8b}//%F4%90%80%80?%2F.%2e|wf:/%C1%81\u{4f8b}//%F4%90%80%80?%2F.%2e#X%20y|nf:/%C1%81\u{4f8b}//%F4%90%80%80?%2F.%2e",
    ),
  )
  out.push(
    (
      "//[255.255.255.255]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://[]//?]%a", "E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a:/%2e/.%2e/..#%ED%A0%80`", "E:unexpected:24 ;; E:unexpected:24 ;; E:unexpected:24 ;; E:unexpected:24 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[01.2.3.412345abcd]:/&", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a://example.com@127.0.0.1/;", "s=+a|a=+example.com@127.0.0.1|u=+example.com|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/;|q=-|f=- ;; uri:a://example.com@127.0.0.1/; ;; s=+a|a=+example.com@127.0.0.1|u=+example.com|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/;|q=-|f=- ;; iri:a://example.com@127.0.0.1/; ;; n:a://example.com@127.0.0.1/; ;; ni:a://example.com@127.0.0.1/; ;; u:a://example.com@127.0.0.1/; ;; sf:a://example.com@127.0.0.1/;|wf:a://example.com@127.0.0.1/;#X%20y|nf:a://example.com@127.0.0.1/;",
    ),
  )
  out.push(
    (
      "%2e%F0%9F%98_}..%2F'", "E:unexpected:13 ;; E:unexpected:0 ;; E:unexpected:13 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[abcd:]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/./%2E./...?", "s=-|a=-|p=/./%2E./...|q=+|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/./%2E./...|q=+|f=- ;; E:unexpected:0 ;; n:/./../...? ;; ni:/./../...? ;; u:/./%2E./...? ;; sf:/./%2E./...?|wf:/./%2E./...?#X%20y|nf:/./%2E./...?",
    ),
  )
  out.push(
    (
      "//[v.%ED%A0%80+]", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://[0:0:0:0:0:ffff:192.0.2.1]//%F0%82%82%AC_/1|#", "E:unexpected:50 ;; E:unexpected:50 ;; E:unexpected:50 ;; E:unexpected:50 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a:/.%2e/a?::1%F0%9F%98}", "E:unexpected:22 ;; E:unexpected:22 ;; E:unexpected:22 ;; E:unexpected:22 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[0000ffff01.2.3.4123450000::]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//@|(@[0:0:0:0:0:ffff:192.0.2.1]/./...", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http:/%C0%80/@", "s=+http|a=-|p=/%C0%80/@|q=-|f=- ;; uri:http:/%C0%80/@ ;; s=+http|a=-|p=/%C0%80/@|q=-|f=- ;; iri:http:/%C0%80/@ ;; n:http:/%C0%80/@ ;; ni:http:/%C0%80/@ ;; u:http:/%C0%80/@ ;; sf:http:/%C0%80/@|wf:http:/%C0%80/@#X%20y|nf:http:/%C0%80/@",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "/.%2e/b/%2E/a/..a", "s=-|a=-|p=/.%2e/b/%2E/a/..a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/.%2e/b/%2E/a/..a|q=-|f=- ;; E:unexpected:0 ;; n:/../b/./a/..a ;; ni:/../b/./a/..a ;; u:/.%2e/b/%2E/a/..a ;; sf:/.%2e/b/%2E/a/..a|wf:/.%2e/b/%2E/a/..a#X%20y|nf:/.%2e/b/%2E/a/..a",
    ),
  )
  out.push(
    (
      "/%2e%2E/%2E./a/%2E.//", "s=-|a=-|p=/%2e%2E/%2E./a/%2E.//|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2e%2E/%2E./a/%2E.//|q=-|f=- ;; E:unexpected:0 ;; n:/../../a/..// ;; ni:/../../a/..// ;; u:/%2e%2E/%2E./a/%2E.// ;; sf:/%2e%2E/%2E./a/%2E.//|wf:/%2e%2E/%2E./a/%2E.//#X%20y|nf:/%2e%2E/%2E./a/%2E.//",
    ),
  )
  out.push(
    (
      "///?%F0%9F%98+b", "s=-|a=+|u=-|h=|hp=n:|o=-|p=/|q=+%F0%9F%98+b|f=- ;; E:unexpected:0 ;; s=-|a=+|u=-|h=|hp=n:|o=-|p=/|q=+%F0%9F%98+b|f=- ;; E:unexpected:0 ;; n:///?%F0%9F%98+b ;; ni:///?%F0%9F%98+b ;; u:///?%F0%9F%98+b ;; sf:///?%F0%9F%98+b|wf:///?%F0%9F%98+b#X%20y|nf:///?%F0%9F%98+b",
    ),
  )
  out.push(
    (
      "z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20//", "s=+z9+-.|a=+)%C0%80%ED%A0%80@127.0.0.1|u=+)%C0%80%ED%A0%80|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/%20//|q=-|f=- ;; uri:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20// ;; s=+z9+-.|a=+)%C0%80%ED%A0%80@127.0.0.1|u=+)%C0%80%ED%A0%80|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/%20//|q=-|f=- ;; iri:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20// ;; n:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20// ;; ni:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20// ;; u:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20// ;; sf:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20//|wf:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20//#X%20y|nf:z9+-.://)%C0%80%ED%A0%80@127.0.0.1/%20//",
    ),
  )
  out.push(
    (
      "HTTP:%20?{", "E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "z9+-.:%2e?", "s=+z9+-.|a=-|p=%2e|q=+|f=- ;; uri:z9+-.:%2e? ;; s=+z9+-.|a=-|p=%2e|q=+|f=- ;; iri:z9+-.:%2e? ;; n:z9+-.:.? ;; ni:z9+-.:.? ;; u:z9+-.:%2e? ;; sf:z9+-.:%2e?|wf:z9+-.:%2e?#X%20y|nf:z9+-.:%2e?",
    ),
  )
  out.push(
    (
      "/%2e%2E/..a/%2e%2E/%2E/??|", "E:unexpected:25 ;; E:unexpected:0 ;; E:unexpected:25 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%2E0%C1%81example.com%C3%A9", "s=-|a=-|p=%2E0%C1%81example.com%C3%A9|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%2E0%C1%81example.com%C3%A9|q=-|f=- ;; E:unexpected:0 ;; n:.0%C1%81example.com%C3%A9 ;; ni:.0%C1%81example.com\u{e9} ;; u:%2E0%C1%81example.com%C3%A9 ;; sf:%2E0%C1%81example.com%C3%A9|wf:%2E0%C1%81example.com%C3%A9#X%20y|nf:%2E0%C1%81example.com%C3%A9",
    ),
  )
  out.push(
    (
      "/..a/%2E/a/%2E/%2e/.../..", "s=-|a=-|p=/..a/%2E/a/%2E/%2e/.../..|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/..a/%2E/a/%2E/%2e/.../..|q=-|f=- ;; E:unexpected:0 ;; n:/..a/./a/././.../.. ;; ni:/..a/./a/././.../.. ;; u:/..a/%2E/a/%2E/%2e/.../.. ;; sf:/..a/%2E/a/%2E/%2e/.../..|wf:/..a/%2E/a/%2E/%2e/.../..#X%20y|nf:/..a/%2E/a/%2E/%2e/.../..",
    ),
  )
  out.push(
    (
      "//_<@[::1]?{ba", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      ">?", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "z9+-.://[]:94966/b/%2e/%2E./%2e%2E", "E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http:/::1`#v6", "E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[v0.", "E:unexpected:6 ;; E:unexpected:0 ;; E:unexpected:6 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP:?%C2%A2%E0%A4%B9%7e", "s=+HTTP|a=-|p=|q=+%C2%A2%E0%A4%B9%7e|f=- ;; uri:HTTP:?%C2%A2%E0%A4%B9%7e ;; s=+HTTP|a=-|p=|q=+%C2%A2%E0%A4%B9%7e|f=- ;; iri:HTTP:?%C2%A2%E0%A4%B9%7e ;; n:http:?%C2%A2%E0%A4%B9~ ;; ni:http:?\u{a2}\u{939}~ ;; u:HTTP:?%C2%A2%E0%A4%B9%7e ;; sf:HTTP:?%C2%A2%E0%A4%B9%7e|wf:HTTP:?%C2%A2%E0%A4%B9%7e#X%20y|nf:HTTP:?%C2%A2%E0%A4%B9%7e",
    ),
  )
  out.push(
    (
      "a://{@[0:0:0:0:0:ffff:192.0.2.1]#)", "E:unexpected:4 ;; E:unexpected:4 ;; E:unexpected:4 ;; E:unexpected:4 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[va.v61]", "s=-|a=+[va.v61]|u=-|h=[va.v61]|hp=v|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[va.v61]|u=-|h=[va.v61]|hp=v|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[va.v61] ;; ni://[va.v61] ;; u://[va.v61] ;; sf://[va.v61]|wf://[va.v61]#X%20y|nf://[va.v61]",
    ),
  )
  out.push(
    (
      "//[v7.Foo.Bar]:66190/%80/-?%C1%81#.a", "s=-|a=+[v7.Foo.Bar]:66190|u=-|h=[v7.Foo.Bar]|hp=v|o=+66190|p=/%80/-|q=+%C1%81|f=+.a ;; E:unexpected:0 ;; s=-|a=+[v7.Foo.Bar]:66190|u=-|h=[v7.Foo.Bar]|hp=v|o=+66190|p=/%80/-|q=+%C1%81|f=+.a ;; E:unexpected:0 ;; n://[v7.foo.bar]:66190/%80/-?%C1%81#.a ;; ni://[v7.foo.bar]:66190/%80/-?%C1%81#.a ;; u://[v7.Foo.Bar]:66190/%80/-?%C1%81#.a ;; sf://[v7.Foo.Bar]:66190/%80/-?%C1%81|wf://[v7.Foo.Bar]:66190/%80/-?%C1%81#X%20y|nf://[v7.Foo.Bar]:66190/%80/-?%C1%81",
    ),
  )
  out.push(
    (
      "%41\u{e000}%C0%80", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%2e%_", "E:unexpected:2 ;; E:unexpected:0 ;; E:unexpected:2 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "127.0.0.11%C2%A2%C1%81", "s=-|a=-|p=127.0.0.11%C2%A2%C1%81|q=-|f=- ;; E:unexpected:10 ;; s=-|a=-|p=127.0.0.11%C2%A2%C1%81|q=-|f=- ;; E:unexpected:10 ;; n:127.0.0.11%C2%A2%C1%81 ;; ni:127.0.0.11\u{a2}%C1%81 ;; u:127.0.0.11%C2%A2%C1%81 ;; sf:127.0.0.11%C2%A2%C1%81|wf:127.0.0.11%C2%A2%C1%81#X%20y|nf:127.0.0.11%C2%A2%C1%81",
    ),
  )
  out.push(
    (
      "/.//..a/%2e%2E/..a/%2E/%2E", "s=-|a=-|p=/.//..a/%2e%2E/..a/%2E/%2E|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/.//..a/%2e%2E/..a/%2E/%2E|q=-|f=- ;; E:unexpected:0 ;; n:/.//..a/../..a/./. ;; ni:/.//..a/../..a/./. ;; u:/.//..a/%2e%2E/..a/%2E/%2E ;; sf:/.//..a/%2e%2E/..a/%2E/%2E|wf:/.//..a/%2e%2E/..a/%2E/%2E#X%20y|nf:/.//..a/%2e%2E/..a/%2E/%2E",
    ),
  )
  out.push(
    (
      "//%E2%82_%FF@[::1]/%E0%A4%B9?", "s=-|a=+%E2%82_%FF@[::1]|u=+%E2%82_%FF|h=[::1]|hp=6:::1|o=-|p=/%E0%A4%B9|q=+|f=- ;; E:unexpected:0 ;; s=-|a=+%E2%82_%FF@[::1]|u=+%E2%82_%FF|h=[::1]|hp=6:::1|o=-|p=/%E0%A4%B9|q=+|f=- ;; E:unexpected:0 ;; n://%E2%82_%FF@[::1]/%E0%A4%B9? ;; ni://%E2%82_%FF@[::1]/\u{939}? ;; u://%E2%82_%FF@[::1]/%E0%A4%B9? ;; sf://%E2%82_%FF@[::1]/%E0%A4%B9?|wf://%E2%82_%FF@[::1]/%E0%A4%B9?#X%20y|nf://%E2%82_%FF@[::1]/%E0%A4%B9?",
    ),
  )
  out.push(
    (
      "//@[:z1.2.3.0FFFF0000]:824//#%F4%90%80%80\u{10300}|", "E:ipv6:4 ;; E:unexpected:0 ;; E:ipv6:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://[::1]/A?/", "s=+http|a=+[::1]|u=-|h=[::1]|hp=6:::1|o=-|p=/A|q=+/|f=- ;; uri:http://[::1]/A?/ ;; s=+http|a=+[::1]|u=-|h=[::1]|hp=6:::1|o=-|p=/A|q=+/|f=- ;; iri:http://[::1]/A?/ ;; n:http://[::1]/A?/ ;; ni:http://[::1]/A?/ ;; u:http://[::1]/A?/ ;; sf:http://[::1]/A?/|wf:http://[::1]/A?/#X%20y|nf:http://[::1]/A?/",
    ),
  )
  out.push(
    (
      ".\u{4f8b}%E2%82}_)", "E:unexpected:1 ;; E:unexpected:1 ;; E:unexpected:8 ;; E:unexpected:1 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http:/%F0%82%82%AC?%41a#%200/", "s=+http|a=-|p=/%F0%82%82%AC|q=+%41a|f=+%200/ ;; uri:http:/%F0%82%82%AC?%41a#%200/ ;; s=+http|a=-|p=/%F0%82%82%AC|q=+%41a|f=+%200/ ;; iri:http:/%F0%82%82%AC?%41a#%200/ ;; n:http:/%F0%82%82%AC?Aa#%200/ ;; ni:http:/%F0%82%82%AC?Aa#%200/ ;; u:http:/%F0%82%82%AC?%41a#%200/ ;; sf:http:/%F0%82%82%AC?%41a|wf:http:/%F0%82%82%AC?%41a#X%20y|nf:http:/%F0%82%82%AC?%41a",
    ),
  )
  out.push(
    (
      "//(#", "s=-|a=+(|u=-|h=(|hp=n:(|o=-|p=|q=-|f=+ ;; E:unexpected:0 ;; s=-|a=+(|u=-|h=(|hp=n:(|o=-|p=|q=-|f=+ ;; E:unexpected:0 ;; n://(# ;; ni://(# ;; u://(# ;; sf://(|wf://(#X%20y|nf://(",
    ),
  )
  out.push(
    (
      "foo:/Z%2E/%F0%82%82%AC#b%a%FF", "E:unexpected:24 ;; E:unexpected:24 ;; E:unexpected:24 ;; E:unexpected:24 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "*", "s=-|a=-|p=*|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=*|q=-|f=- ;; E:unexpected:0 ;; n:* ;; ni:* ;; u:* ;; sf:*|wf:*#X%20y|nf:*",
    ),
  )
}

///|
fn parse_chunk_1(out : Array[(String, String)]) -> Unit {
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "//[]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/./..//.../%2e/.../.", "s=-|a=-|p=/./..//.../%2e/.../.|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/./..//.../%2e/.../.|q=-|f=- ;; E:unexpected:0 ;; n:/./..//..././.../. ;; ni:/./..//..././.../. ;; u:/./..//.../%2e/.../. ;; sf:/./..//.../%2e/.../.|wf:/./..//.../%2e/.../.#X%20y|nf:/./..//.../%2e/.../.",
    ),
  )
  out.push(
    (
      "%2E=", "s=-|a=-|p=%2E=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%2E=|q=-|f=- ;; E:unexpected:0 ;; n:.= ;; ni:.= ;; u:%2E= ;; sf:%2E=|wf:%2E=#X%20y|nf:%2E=",
    ),
  )
  out.push(
    (
      "HTTP:/%20//#", "s=+HTTP|a=-|p=/%20//|q=-|f=+ ;; uri:HTTP:/%20//# ;; s=+HTTP|a=-|p=/%20//|q=-|f=+ ;; iri:HTTP:/%20//# ;; n:http:/%20//# ;; ni:http:/%20//# ;; u:HTTP:/%20//# ;; sf:HTTP:/%20//|wf:HTTP:/%20//#X%20y|nf:HTTP:/%20//",
    ),
  )
  out.push(
    (
      "/%2e%2E", "s=-|a=-|p=/%2e%2E|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2e%2E|q=-|f=- ;; E:unexpected:0 ;; n:/.. ;; ni:/.. ;; u:/%2e%2E ;; sf:/%2e%2E|wf:/%2e%2E#X%20y|nf:/%2e%2E",
    ),
  )
  out.push(
    (
      "`?..%2F", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%a1('#", "s=-|a=-|p=%a1('|q=-|f=+ ;; E:unexpected:0 ;; s=-|a=-|p=%a1('|q=-|f=+ ;; E:unexpected:0 ;; n:%A1('# ;; ni:%A1('# ;; u:%a1('# ;; sf:%a1('|wf:%a1('#X%20y|nf:%a1('",
    ),
  )
  out.push(
    (
      "a:/?#...%2F127.0.0.1", "s=+a|a=-|p=/|q=+|f=+...%2F127.0.0.1 ;; uri:a:/?#...%2F127.0.0.1 ;; s=+a|a=-|p=/|q=+|f=+...%2F127.0.0.1 ;; iri:a:/?#...%2F127.0.0.1 ;; n:a:/?#...%2F127.0.0.1 ;; ni:a:/?#...%2F127.0.0.1 ;; u:a:/?#...%2F127.0.0.1 ;; sf:a:/?|wf:a:/?#X%20y|nf:a:/?",
    ),
  )
  out.push(
    (
      "%ED%A0%809%C2%A2", "s=-|a=-|p=%ED%A0%809%C2%A2|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%ED%A0%809%C2%A2|q=-|f=- ;; E:unexpected:0 ;; n:%ED%A0%809%C2%A2 ;; ni:%ED%A0%809\u{a2} ;; u:%ED%A0%809%C2%A2 ;; sf:%ED%A0%809%C2%A2|wf:%ED%A0%809%C2%A2#X%20y|nf:%ED%A0%809%C2%A2",
    ),
  )
  out.push(
    (
      "z9+-.://", "s=+z9+-.|a=+|u=-|h=|hp=n:|o=-|p=|q=-|f=- ;; uri:z9+-.:// ;; s=+z9+-.|a=+|u=-|h=|hp=n:|o=-|p=|q=-|f=- ;; iri:z9+-.:// ;; n:z9+-.:// ;; ni:z9+-.:// ;; u:z9+-.:// ;; sf:z9+-.://|wf:z9+-.://#X%20y|nf:z9+-.://",
    ),
  )
  out.push(
    (
      "//[ffv]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "0.({%a%C3%A9", "E:unexpected:3 ;; E:unexpected:2 ;; E:unexpected:3 ;; E:unexpected:2 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http:/.../%2E/..a/./../?\u{e9}", "E:unexpected:24 ;; E:unexpected:24 ;; s=+http|a=-|p=/.../%2E/..a/./../|q=+\u{e9}|f=- ;; iri:http:/.../%2E/..a/./../?\u{e9} ;; - ;; ni:http:/.../?\u{e9} ;; u:http:/.../%2E/..a/./../?%C3%A9 ;; sf:http:/.../%2E/..a/./../?\u{e9}|wf:http:/.../%2E/..a/./../?\u{e9}#X%20y|nf:http:/.../%2E/..a/./../?\u{e9}",
    ),
  )
  out.push(
    (
      "//[00:v1.2.3000012345ffffff", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//%2F%a@127.0.0.1:", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://[v7.Foo.Bar]/?!", "s=+http|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=/|q=+!|f=- ;; uri:http://[v7.Foo.Bar]/?! ;; s=+http|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=/|q=+!|f=- ;; iri:http://[v7.Foo.Bar]/?! ;; n:http://[v7.foo.bar]/?! ;; ni:http://[v7.foo.bar]/?! ;; u:http://[v7.Foo.Bar]/?! ;; sf:http://[v7.Foo.Bar]/?!|wf:http://[v7.Foo.Bar]/?!#X%20y|nf:http://[v7.Foo.Bar]/?!",
    ),
  )
  out.push(
    (
      " %F0%82%82%ACv6%E0%80%80%F4%90%80%80", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "///b/..a/%2e/a/..a", "s=-|a=+|u=-|h=|hp=n:|o=-|p=/b/..a/%2e/a/..a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+|u=-|h=|hp=n:|o=-|p=/b/..a/%2e/a/..a|q=-|f=- ;; E:unexpected:0 ;; n:///b/..a/./a/..a ;; ni:///b/..a/./a/..a ;; u:///b/..a/%2e/a/..a ;; sf:///b/..a/%2e/a/..a|wf:///b/..a/%2e/a/..a#X%20y|nf:///b/..a/%2e/a/..a",
    ),
  )
  out.push(
    (
      "z9+-.://%F0%90%8C%80/127.0.0.1:?", "s=+z9+-.|a=+%F0%90%8C%80|u=-|h=%F0%90%8C%80|hp=n:%F0%90%8C%80|o=-|p=/127.0.0.1:|q=+|f=- ;; uri:z9+-.://%F0%90%8C%80/127.0.0.1:? ;; s=+z9+-.|a=+%F0%90%8C%80|u=-|h=%F0%90%8C%80|hp=n:%F0%90%8C%80|o=-|p=/127.0.0.1:|q=+|f=- ;; iri:z9+-.://%F0%90%8C%80/127.0.0.1:? ;; n:z9+-.://%F0%90%8C%80/127.0.0.1:? ;; ni:z9+-.://\u{10300}/127.0.0.1:? ;; u:z9+-.://%F0%90%8C%80/127.0.0.1:? ;; sf:z9+-.://%F0%90%8C%80/127.0.0.1:?|wf:z9+-.://%F0%90%8C%80/127.0.0.1:?#X%20y|nf:z9+-.://%F0%90%8C%80/127.0.0.1:?",
    ),
  )
  out.push(
    (
      "/%2E/.%2e/./a/%2e/%2e/", "s=-|a=-|p=/%2E/.%2e/./a/%2e/%2e/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2E/.%2e/./a/%2e/%2e/|q=-|f=- ;; E:unexpected:0 ;; n:/./.././a/././ ;; ni:/./.././a/././ ;; u:/%2E/.%2e/./a/%2e/%2e/ ;; sf:/%2E/.%2e/./a/%2e/%2e/|wf:/%2E/.%2e/./a/%2e/%2e/#X%20y|nf:/%2E/.%2e/./a/%2e/%2e/",
    ),
  )
  out.push(
    (
      "%C3%A9\u{10300}%2e\u{e9}", "E:unexpected:6 ;; E:unexpected:0 ;; s=-|a=-|p=%C3%A9\u{10300}%2e\u{e9}|q=-|f=- ;; E:unexpected:0 ;; - ;; ni:\u{e9}\u{10300}.\u{e9} ;; u:%C3%A9%F0%90%8C%80%2e%C3%A9 ;; sf:%C3%A9\u{10300}%2e\u{e9}|wf:%C3%A9\u{10300}%2e\u{e9}#X%20y|nf:%C3%A9\u{10300}%2e\u{e9}",
    ),
  )
  out.push(
    (
      "]|%C2%A2|", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a://[v7.Foo.Bar]/..a/.../%2e%2E/../%2e%2E/%2E/b", "s=+a|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=/..a/.../%2e%2E/../%2e%2E/%2E/b|q=-|f=- ;; uri:a://[v7.Foo.Bar]/..a/.../%2e%2E/../%2e%2E/%2E/b ;; s=+a|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=/..a/.../%2e%2E/../%2e%2E/%2E/b|q=-|f=- ;; iri:a://[v7.Foo.Bar]/..a/.../%2e%2E/../%2e%2E/%2E/b ;; n:a://[v7.foo.bar]/b ;; ni:a://[v7.foo.bar]/b ;; u:a://[v7.Foo.Bar]/..a/.../%2e%2E/../%2e%2E/%2E/b ;; sf:a://[v7.Foo.Bar]/..a/.../%2e%2E/../%2e%2E/%2E/b|wf:a://[v7.Foo.Bar]/..a/.../%2e%2E/../%2e%2E/%2E/b#X%20y|nf:a://[v7.Foo.Bar]/..a/.../%2e%2E/../%2e%2E/%2E/b",
    ),
  )
  out.push(
    (
      "http:///..Z#%zzb\u{4f8b}", "E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/.../.%2e/..", "s=-|a=-|p=/.../.%2e/..|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/.../.%2e/..|q=-|f=- ;; E:unexpected:0 ;; n:/.../../.. ;; ni:/.../../.. ;; u:/.../.%2e/.. ;; sf:/.../.%2e/..|wf:/.../.%2e/..#X%20y|nf:/.../.%2e/..",
    ),
  )
  out.push(
    (
      "/", "s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; n:/ ;; ni:/ ;; u:/ ;; sf:/|wf:/#X%20y|nf:/",
    ),
  )
  out.push(
    (
      "/%2e%2E/%2E./.././%2e/.%2e/b", "s=-|a=-|p=/%2e%2E/%2E./.././%2e/.%2e/b|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2e%2E/%2E./.././%2e/.%2e/b|q=-|f=- ;; E:unexpected:0 ;; n:/../../../././../b ;; ni:/../../../././../b ;; u:/%2e%2E/%2E./.././%2e/.%2e/b ;; sf:/%2e%2E/%2E./.././%2e/.%2e/b|wf:/%2e%2E/%2E./.././%2e/.%2e/b#X%20y|nf:/%2e%2E/%2E./.././%2e/.%2e/b",
    ),
  )
  out.push(
    (
      "//[V.9\u{4f8b}]", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "z9+-.://[::1]/>!/%FF[?#[::1]", "E:unexpected:14 ;; E:unexpected:14 ;; E:unexpected:14 ;; E:unexpected:14 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo://=%BF@[255.255.255.2551.2.3000012345123450255.255.255.255%abcd]", "E:unexpected:12 ;; E:unexpected:12 ;; E:unexpected:12 ;; E:unexpected:12 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[ffa12345]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo://[01.2.3.4101.2.3.4]/..a/%2E/%2E/b/?)\u{e000}%#%ED%A0%80\u{e9}z", "E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo://@(:z:/%2e%2E/%2e?%C2%A2#", "E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; E:unexpected:9 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "=", "s=-|a=-|p==|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p==|q=-|f=- ;; E:unexpected:0 ;; n:= ;; ni:= ;; u:= ;; sf:=|wf:=#X%20y|nf:=",
    ),
  )
  out.push(
    (
      "http://[FFFFaz]/?%C0%80:\\", "E:ipv6:8 ;; E:ipv6:8 ;; E:ipv6:8 ;; E:ipv6:8 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%C2%A2", "s=-|a=-|p=/%C2%A2|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%C2%A2|q=-|f=- ;; E:unexpected:0 ;; n:/%C2%A2 ;; ni:/\u{a2} ;; u:/%C2%A2 ;; sf:/%C2%A2|wf:/%C2%A2#X%20y|nf:/%C2%A2",
    ),
  )
  out.push(
    (
      "foo://127.0.0.1/*%FF/", "s=+foo|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/*%FF/|q=-|f=- ;; uri:foo://127.0.0.1/*%FF/ ;; s=+foo|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/*%FF/|q=-|f=- ;; iri:foo://127.0.0.1/*%FF/ ;; n:foo://127.0.0.1/*%FF/ ;; ni:foo://127.0.0.1/*%FF/ ;; u:foo://127.0.0.1/*%FF/ ;; sf:foo://127.0.0.1/*%FF/|wf:foo://127.0.0.1/*%FF/#X%20y|nf:foo://127.0.0.1/*%FF/",
    ),
  )
  out.push(
    (
      "..%2F~\\%2F", "E:unexpected:6 ;; E:unexpected:2 ;; E:unexpected:6 ;; E:unexpected:2 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%E0%A4%B9%E0%80%80{_", "E:unexpected:18 ;; E:unexpected:0 ;; E:unexpected:18 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://127.0.0.1/..a/.../b/.%2e", "s=+http|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/..a/.../b/.%2e|q=-|f=- ;; uri:http://127.0.0.1/..a/.../b/.%2e ;; s=+http|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/..a/.../b/.%2e|q=-|f=- ;; iri:http://127.0.0.1/..a/.../b/.%2e ;; n:http://127.0.0.1/..a/.../ ;; ni:http://127.0.0.1/..a/.../ ;; u:http://127.0.0.1/..a/.../b/.%2e ;; sf:http://127.0.0.1/..a/.../b/.%2e|wf:http://127.0.0.1/..a/.../b/.%2e#X%20y|nf:http://127.0.0.1/..a/.../b/.%2e",
    ),
  )
  out.push(
    (
      "z9+-.://[0:0:0:0:0:ffff:192.0.2.1]:13164//.?%F0%9F%98%E2%82", "s=+z9+-.|a=+[0:0:0:0:0:ffff:192.0.2.1]:13164|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=+13164|p=//.|q=+%F0%9F%98%E2%82|f=- ;; uri:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]:13164//.?%F0%9F%98%E2%82 ;; s=+z9+-.|a=+[0:0:0:0:0:ffff:192.0.2.1]:13164|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=+13164|p=//.|q=+%F0%9F%98%E2%82|f=- ;; iri:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]:13164//.?%F0%9F%98%E2%82 ;; n:z9+-.://[::ffff:192.0.2.1]:13164//?%F0%9F%98%E2%82 ;; ni:z9+-.://[::ffff:192.0.2.1]:13164//?%F0%9F%98%E2%82 ;; u:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]:13164//.?%F0%9F%98%E2%82 ;; sf:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]:13164//.?%F0%9F%98%E2%82|wf:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]:13164//.?%F0%9F%98%E2%82#X%20y|nf:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]:13164//.?%F0%9F%98%E2%82",
    ),
  )
  out.push(
    (
      "/\u{e9}%C3%A9/1/%F0%90%8C%80}", "E:unexpected:1 ;; E:unexpected:0 ;; E:unexpected:23 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a:/%ED%A0%800/_)", "s=+a|a=-|p=/%ED%A0%800/_)|q=-|f=- ;; uri:a:/%ED%A0%800/_) ;; s=+a|a=-|p=/%ED%A0%800/_)|q=-|f=- ;; iri:a:/%ED%A0%800/_) ;; n:a:/%ED%A0%800/_) ;; ni:a:/%ED%A0%800/_) ;; u:a:/%ED%A0%800/_) ;; sf:a:/%ED%A0%800/_)|wf:a:/%ED%A0%800/_)#X%20y|nf:a:/%ED%A0%800/_)",
    ),
  )
  out.push(
    (
      ",%F0%82%82%AC", "s=-|a=-|p=,%F0%82%82%AC|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=,%F0%82%82%AC|q=-|f=- ;; E:unexpected:0 ;; n:,%F0%82%82%AC ;; ni:,%F0%82%82%AC ;; u:,%F0%82%82%AC ;; sf:,%F0%82%82%AC|wf:,%F0%82%82%AC#X%20y|nf:,%F0%82%82%AC",
    ),
  )
  out.push(
    (
      "//[abcdffv]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[0000ff01.2.3.401.2.3.4]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[v7.Foo.Bar]/./?\u{10300}[", "E:unexpected:18 ;; E:unexpected:0 ;; E:unexpected:20 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP:/)/[::1]/!#%7e~", "E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//%E0%A4%B9[::1]@127.0.0.1/%2e%2E#127.0.0.1%C1%81%ED%A0%80", "E:unexpected:11 ;; E:unexpected:0 ;; E:unexpected:11 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP://127.0.0.1:36188/...", "s=+HTTP|a=+127.0.0.1:36188|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+36188|p=/...|q=-|f=- ;; uri:HTTP://127.0.0.1:36188/... ;; s=+HTTP|a=+127.0.0.1:36188|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+36188|p=/...|q=-|f=- ;; iri:HTTP://127.0.0.1:36188/... ;; n:http://127.0.0.1:36188/... ;; ni:http://127.0.0.1:36188/... ;; u:HTTP://127.0.0.1:36188/... ;; sf:HTTP://127.0.0.1:36188/...|wf:HTTP://127.0.0.1:36188/...#X%20y|nf:HTTP://127.0.0.1:36188/...",
    ),
  )
  out.push(
    (
      "HTTP:/{", "E:unexpected:6 ;; E:unexpected:6 ;; E:unexpected:6 ;; E:unexpected:6 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "#", "s=-|a=-|p=|q=-|f=+ ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=+ ;; E:unexpected:0 ;; n:# ;; ni:# ;; u:# ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "foo:/``/%E0%80%80/:%41", "E:unexpected:5 ;; E:unexpected:5 ;; E:unexpected:5 ;; E:unexpected:5 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/.", "s=-|a=-|p=/.|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/.|q=-|f=- ;; E:unexpected:0 ;; n:/. ;; ni:/. ;; u:/. ;; sf:/.|wf:/.#X%20y|nf:/.",
    ),
  )
  out.push(
    (
      "a:///;//..%2F[?", "E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a:/%/?[", "E:unexpected:3 ;; E:unexpected:3 ;; E:unexpected:3 ;; E:unexpected:3 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2e%2E/../a", "s=-|a=-|p=/%2e%2E/../a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2e%2E/../a|q=-|f=- ;; E:unexpected:0 ;; n:/../../a ;; ni:/../../a ;; u:/%2e%2E/../a ;; sf:/%2e%2E/../a|wf:/%2e%2E/../a#X%20y|nf:/%2e%2E/../a",
    ),
  )
  out.push(
    (
      "/A%FF/&?/*%zz?.A+", "E:unexpected:9 ;; E:unexpected:0 ;; E:unexpected:9 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[::1]/a/../.%2e/%2e/./%2E./#&\u{4f8b}+", "E:unexpected:31 ;; E:unexpected:0 ;; s=-|a=+[::1]|u=-|h=[::1]|hp=6:::1|o=-|p=/a/../.%2e/%2e/./%2E./|q=-|f=+&\u{4f8b}+ ;; E:unexpected:0 ;; - ;; ni://[::1]/a/../../././../#&\u{4f8b}+ ;; u://[::1]/a/../.%2e/%2e/./%2E./#&%E4%BE%8B+ ;; sf://[::1]/a/../.%2e/%2e/./%2E./|wf://[::1]/a/../.%2e/%2e/./%2E./#X%20y|nf://[::1]/a/../.%2e/%2e/./%2E./",
    ),
  )
  out.push(
    (
      "foo://[v7.Foo.Bar]", "s=+foo|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=|q=-|f=- ;; uri:foo://[v7.Foo.Bar] ;; s=+foo|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=|q=-|f=- ;; iri:foo://[v7.Foo.Bar] ;; n:foo://[v7.foo.bar] ;; ni:foo://[v7.foo.bar] ;; u:foo://[v7.Foo.Bar] ;; sf:foo://[v7.Foo.Bar]|wf:foo://[v7.Foo.Bar]#X%20y|nf:foo://[v7.Foo.Bar]",
    ),
  )
  out.push(
    (
      "/%2E./../..a/..a/..", "s=-|a=-|p=/%2E./../..a/..a/..|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2E./../..a/..a/..|q=-|f=- ;; E:unexpected:0 ;; n:/../../..a/..a/.. ;; ni:/../../..a/..a/.. ;; u:/%2E./../..a/..a/.. ;; sf:/%2E./../..a/..a/..|wf:/%2E./../..a/..a/..#X%20y|nf:/%2E./../..a/..a/..",
    ),
  )
  out.push(
    (
      "'%2E%2e%2e", "s=-|a=-|p='%2E%2e%2e|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p='%2E%2e%2e|q=-|f=- ;; E:unexpected:0 ;; n:'... ;; ni:'... ;; u:'%2E%2e%2e ;; sf:'%2E%2e%2e|wf:'%2E%2e%2e#X%20y|nf:'%2E%2e%2e",
    ),
  )
  out.push(
    (
      "\u{e000}*/%F0%82%82%AC%E0%A0%7e", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://[v7.Foo.Bar]/.../b/%2e/b/..a/%2E?%", "E:unexpected:41 ;; E:unexpected:41 ;; E:unexpected:41 ;; E:unexpected:41 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//::1%2E/v6%2F#", "E:unexpected:8 ;; E:unexpected:0 ;; E:unexpected:8 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http://[::1]//%E0%A4%B9|?", "E:unexpected:23 ;; E:unexpected:23 ;; E:unexpected:23 ;; E:unexpected:23 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "(", "s=-|a=-|p=(|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=(|q=-|f=- ;; E:unexpected:0 ;; n:( ;; ni:( ;; u:( ;; sf:(|wf:(#X%20y|nf:(",
    ),
  )
  out.push(
    (
      "foo:/%F0%90%8C%80", "s=+foo|a=-|p=/%F0%90%8C%80|q=-|f=- ;; uri:foo:/%F0%90%8C%80 ;; s=+foo|a=-|p=/%F0%90%8C%80|q=-|f=- ;; iri:foo:/%F0%90%8C%80 ;; n:foo:/%F0%90%8C%80 ;; ni:foo:/\u{10300} ;; u:foo:/%F0%90%8C%80 ;; sf:foo:/%F0%90%8C%80|wf:foo:/%F0%90%8C%80#X%20y|nf:foo:/%F0%90%8C%80",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "//(`\"@[0:0:0:0:0:ffff:192.0.2.1]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/..././..a/../%2e%2E", "s=-|a=-|p=/..././..a/../%2e%2E|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/..././..a/../%2e%2E|q=-|f=- ;; E:unexpected:0 ;; n:/..././..a/../.. ;; ni:/..././..a/../.. ;; u:/..././..a/../%2e%2E ;; sf:/..././..a/../%2e%2E|wf:/..././..a/../%2e%2E#X%20y|nf:/..././..a/../%2e%2E",
    ),
  )
  out.push(
    (
      "1%20%F4%90%80%80[::1]0%F4%90%80%80", "E:unexpected:16 ;; E:unexpected:1 ;; E:unexpected:16 ;; E:unexpected:1 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "///...?%41", "s=-|a=+|u=-|h=|hp=n:|o=-|p=/...|q=+%41|f=- ;; E:unexpected:0 ;; s=-|a=+|u=-|h=|hp=n:|o=-|p=/...|q=+%41|f=- ;; E:unexpected:0 ;; n:///...?A ;; ni:///...?A ;; u:///...?%41 ;; sf:///...?%41|wf:///...?%41#X%20y|nf:///...?%41",
    ),
  )
  out.push(
    (
      "z9+-.://&@[1.2.31av]/%E0%A4%B9%?%F0%90%8C%80%BF#", "E:unexpected:11 ;; E:unexpected:11 ;; E:unexpected:11 ;; E:unexpected:11 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%7e<\u{4f8b}?", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[::1]/.#>%E2%82$", "E:unexpected:10 ;; E:unexpected:0 ;; E:unexpected:10 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      ",*[%C0%80%41", "E:unexpected:2 ;; E:unexpected:0 ;; E:unexpected:2 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2e/%2E/./#,%41", "s=-|a=-|p=/%2e/%2E/./|q=-|f=+,%41 ;; E:unexpected:0 ;; s=-|a=-|p=/%2e/%2E/./|q=-|f=+,%41 ;; E:unexpected:0 ;; n:/./././#,A ;; ni:/./././#,A ;; u:/%2e/%2E/./#,%41 ;; sf:/%2e/%2E/./|wf:/%2e/%2E/./#X%20y|nf:/%2e/%2E/./",
    ),
  )
  out.push(
    (
      "z9+-.:%9", "E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; E:unexpected:8 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[::192.0.2.1ffff255.255.255.2550000]", "E:unexpected:14 ;; E:unexpected:0 ;; E:unexpected:14 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP:/!/", "s=+HTTP|a=-|p=/!/|q=-|f=- ;; uri:HTTP:/!/ ;; s=+HTTP|a=-|p=/!/|q=-|f=- ;; iri:HTTP:/!/ ;; n:http:/!/ ;; ni:http:/!/ ;; u:HTTP:/!/ ;; sf:HTTP:/!/|wf:HTTP:/!/#X%20y|nf:HTTP:/!/",
    ),
  )
  out.push(
    (
      "//[V.^a]", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "z9+-.://example.com%7ev6@:%F0%90%8D%88/%2E/b/./.../%2e", "E:unexpected:26 ;; E:unexpected:26 ;; E:unexpected:26 ;; E:unexpected:26 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "a://[abcd192.0.2.1]//..%2F}/??", "E:ipv6:5 ;; E:ipv6:5 ;; E:ipv6:5 ;; E:ipv6:5 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/.%2e/b/...//./", "s=-|a=-|p=/.%2e/b/...//./|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/.%2e/b/...//./|q=-|f=- ;; E:unexpected:0 ;; n:/../b/...//./ ;; ni:/../b/...//./ ;; u:/.%2e/b/...//./ ;; sf:/.%2e/b/...//./|wf:/.%2e/b/...//./#X%20y|nf:/.%2e/b/...//./",
    ),
  )
  out.push(
    (
      "//[::FFFF0FFFF11.2.3%192.0.2.1]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2E./../", "s=-|a=-|p=/%2E./../|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2E./../|q=-|f=- ;; E:unexpected:0 ;; n:/../../ ;; ni:/../../ ;; u:/%2E./../ ;; sf:/%2E./../|wf:/%2E./../#X%20y|nf:/%2E./../",
    ),
  )
  out.push(
    (
      "%20%20..%2F", "s=-|a=-|p=%20%20..%2F|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=%20%20..%2F|q=-|f=- ;; E:unexpected:0 ;; n:%20%20..%2F ;; ni:%20%20..%2F ;; u:%20%20..%2F ;; sf:%20%20..%2F|wf:%20%20..%2F#X%20y|nf:%20%20..%2F",
    ),
  )
  out.push(
    (
      "//[v0g.", "E:unexpected:5 ;; E:unexpected:0 ;; E:unexpected:5 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2E/", "s=-|a=-|p=/%2E/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2E/|q=-|f=- ;; E:unexpected:0 ;; n:/./ ;; ni:/./ ;; u:/%2E/ ;; sf:/%2E/|wf:/%2E/#X%20y|nf:/%2E/",
    ),
  )
  out.push(
    (
      "z127.0.0.11%FF\u{10300}", "E:unexpected:14 ;; E:unexpected:11 ;; s=-|a=-|p=z127.0.0.11%FF\u{10300}|q=-|f=- ;; E:unexpected:11 ;; - ;; ni:z127.0.0.11%FF\u{10300} ;; u:z127.0.0.11%FF%F0%90%8C%80 ;; sf:z127.0.0.11%FF\u{10300}|wf:z127.0.0.11%FF\u{10300}#X%20y|nf:z127.0.0.11%FF\u{10300}",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "\"-", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//%C1%819#", "s=-|a=+%C1%819|u=-|h=%C1%819|hp=n:%C1%819|o=-|p=|q=-|f=+ ;; E:unexpected:0 ;; s=-|a=+%C1%819|u=-|h=%C1%819|hp=n:%C1%819|o=-|p=|q=-|f=+ ;; E:unexpected:0 ;; n://%C1%819# ;; ni://%C1%819# ;; u://%C1%819# ;; sf://%C1%819|wf://%C1%819#X%20y|nf://%C1%819",
    ),
  )
  out.push(
    (
      "//[V0.0%C3%A9]/?~", "E:unexpected:7 ;; E:unexpected:0 ;; E:unexpected:7 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "[::1]", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2e%2E/%2E/..a/.../%2E.?%20", "s=-|a=-|p=/%2e%2E/%2E/..a/.../%2E.|q=+%20|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2e%2E/%2E/..a/.../%2E.|q=+%20|f=- ;; E:unexpected:0 ;; n:/.././..a/.../..?%20 ;; ni:/.././..a/.../..?%20 ;; u:/%2e%2E/%2E/..a/.../%2E.?%20 ;; sf:/%2e%2E/%2E/..a/.../%2E.?%20|wf:/%2e%2E/%2E/..a/.../%2E.?%20#X%20y|nf:/%2e%2E/%2E/..a/.../%2E.?%20",
    ),
  )
  out.push(
    (
      "////%F0%9F%98]/`", "E:unexpected:13 ;; E:unexpected:0 ;; E:unexpected:13 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo:/./%C3%A9", "s=+foo|a=-|p=/./%C3%A9|q=-|f=- ;; uri:foo:/./%C3%A9 ;; s=+foo|a=-|p=/./%C3%A9|q=-|f=- ;; iri:foo:/./%C3%A9 ;; n:foo:/%C3%A9 ;; ni:foo:/\u{e9} ;; u:foo:/./%C3%A9 ;; sf:foo:/./%C3%A9|wf:foo:/./%C3%A9#X%20y|nf:foo:/./%C3%A9",
    ),
  )
  out.push(
    (
      "foo:/%2e/./%2E./%2e%2E/", "s=+foo|a=-|p=/%2e/./%2E./%2e%2E/|q=-|f=- ;; uri:foo:/%2e/./%2E./%2e%2E/ ;; s=+foo|a=-|p=/%2e/./%2E./%2e%2E/|q=-|f=- ;; iri:foo:/%2e/./%2E./%2e%2E/ ;; n:foo:/ ;; ni:foo:/ ;; u:foo:/%2e/./%2E./%2e%2E/ ;; sf:foo:/%2e/./%2E./%2e%2E/|wf:foo:/%2e/./%2E./%2e%2E/#X%20y|nf:foo:/%2e/./%2E./%2e%2E/",
    ),
  )
  out.push(
    (
      "//[", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%2F%E0%80%80%E0%A4%B9>=", "E:unexpected:21 ;; E:unexpected:0 ;; E:unexpected:21 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP://;%C2%A2=@[z%12345z]//$%BF", "E:unexpected:17 ;; E:unexpected:17 ;; E:unexpected:17 ;; E:unexpected:17 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo://,\"@[.a%0ffff12345]/a/.%2e/..././%2e/./...#%E0%80%80", "E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP://}^$/./a/%2e", "E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/b///.././.%2e/..a", "s=-|a=-|p=/b///.././.%2e/..a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/b///.././.%2e/..a|q=-|f=- ;; E:unexpected:0 ;; n:/b///.././../..a ;; ni:/b///.././../..a ;; u:/b///.././.%2e/..a ;; sf:/b///.././.%2e/..a|wf:/b///.././.%2e/..a#X%20y|nf:/b///.././.%2e/..a",
    ),
  )
  out.push(
    (
      "//[255.255.255.255ffff1v]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo:/.//%2E/%2e%2E/", "s=+foo|a=-|p=/.//%2E/%2e%2E/|q=-|f=- ;; uri:foo:/.//%2E/%2e%2E/ ;; s=+foo|a=-|p=/.//%2E/%2e%2E/|q=-|f=- ;; iri:foo:/.//%2E/%2e%2E/ ;; n:foo:/ ;; ni:foo:/ ;; u:foo:/.//%2E/%2e%2E/ ;; sf:foo:/.//%2E/%2e%2E/|wf:foo:/.//%2E/%2e%2E/#X%20y|nf:foo:/.//%2E/%2e%2E/",
    ),
  )
  out.push(
    (
      "+:z", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "%F0%90%8C%80A%E0%A0%F0%82%82%AC%zz", "E:unexpected:2 ;; E:unexpected:0 ;; E:unexpected:2 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2e//%2E././", "s=-|a=-|p=/%2e//%2E././|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2e//%2E././|q=-|f=- ;; E:unexpected:0 ;; n:/.//.././ ;; ni:/.//.././ ;; u:/%2e//%2E././ ;; sf:/%2e//%2E././|wf:/%2e//%2E././#X%20y|nf:/%2e//%2E././",
    ),
  )
  out.push(
    (
      "///..%2F]/%2F#%E2%82%20", "E:unexpected:8 ;; E:unexpected:0 ;; E:unexpected:8 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[V.%20]", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/", "s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/|q=-|f=- ;; E:unexpected:0 ;; n:/ ;; ni:/ ;; u:/ ;; sf:/|wf:/#X%20y|nf:/",
    ),
  )
  out.push(
    (
      "foo://127.0.0.1:14277/", "s=+foo|a=+127.0.0.1:14277|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+14277|p=/|q=-|f=- ;; uri:foo://127.0.0.1:14277/ ;; s=+foo|a=+127.0.0.1:14277|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+14277|p=/|q=-|f=- ;; iri:foo://127.0.0.1:14277/ ;; n:foo://127.0.0.1:14277/ ;; ni:foo://127.0.0.1:14277/ ;; u:foo://127.0.0.1:14277/ ;; sf:foo://127.0.0.1:14277/|wf:foo://127.0.0.1:14277/#X%20y|nf:foo://127.0.0.1:14277/",
    ),
  )
  out.push(
    (
      "/..", "s=-|a=-|p=/..|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/..|q=-|f=- ;; E:unexpected:0 ;; n:/.. ;; ni:/.. ;; u:/.. ;; sf:/..|wf:/..#X%20y|nf:/..",
    ),
  )
  out.push(
    (
      "/./.%2e/./%2e", "s=-|a=-|p=/./.%2e/./%2e|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/./.%2e/./%2e|q=-|f=- ;; E:unexpected:0 ;; n:/./.././. ;; ni:/./.././. ;; u:/./.%2e/./%2e ;; sf:/./.%2e/./%2e|wf:/./.%2e/./%2e#X%20y|nf:/./.%2e/./%2e",
    ),
  )
  out.push(
    (
      "//[]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http:/../%2E#]\u{10300}:", "E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/./..a/%2e%2E/...", "s=-|a=-|p=/./..a/%2e%2E/...|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/./..a/%2e%2E/...|q=-|f=- ;; E:unexpected:0 ;; n:/./..a/../... ;; ni:/./..a/../... ;; u:/./..a/%2e%2E/... ;; sf:/./..a/%2e%2E/...|wf:/./..a/%2e%2E/...#X%20y|nf:/./..a/%2e%2E/...",
    ),
  )
  out.push(
    (
      "foo:/%2e/%2E/", "s=+foo|a=-|p=/%2e/%2E/|q=-|f=- ;; uri:foo:/%2e/%2E/ ;; s=+foo|a=-|p=/%2e/%2E/|q=-|f=- ;; iri:foo:/%2e/%2E/ ;; n:foo:/ ;; ni:foo:/ ;; u:foo:/%2e/%2E/ ;; sf:foo:/%2e/%2E/|wf:foo:/%2e/%2E/#X%20y|nf:foo:/%2e/%2E/",
    ),
  )
  out.push(
    (
      "//[abcdff00001%a:01.2.3.41.2.3", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP://[v7.Foo.Bar]#%2e.", "s=+HTTP|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=|q=-|f=+%2e. ;; uri:HTTP://[v7.Foo.Bar]#%2e. ;; s=+HTTP|a=+[v7.Foo.Bar]|u=-|h=[v7.Foo.Bar]|hp=v|o=-|p=|q=-|f=+%2e. ;; iri:HTTP://[v7.Foo.Bar]#%2e. ;; n:http://[v7.foo.bar]#.. ;; ni:http://[v7.foo.bar]#.. ;; u:HTTP://[v7.Foo.Bar]#%2e. ;; sf:HTTP://[v7.Foo.Bar]|wf:HTTP://[v7.Foo.Bar]#X%20y|nf:HTTP://[v7.Foo.Bar]",
    ),
  )
  out.push(
    (
      "//[abcdz.affff]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "}[::1]!}%E0%A0", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/%2E/./%2e//%2E.", "s=-|a=-|p=/%2E/./%2e//%2E.|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2E/./%2e//%2E.|q=-|f=- ;; E:unexpected:0 ;; n:/./././/.. ;; ni:/./././/.. ;; u:/%2E/./%2e//%2E. ;; sf:/%2E/./%2e//%2E.|wf:/%2E/./%2e//%2E.#X%20y|nf:/%2E/./%2e//%2E.",
    ),
  )
  out.push(
    (
      "HTTP://127.0.0.1/?;%7e%E0%A0", "s=+HTTP|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/|q=+;%7e%E0%A0|f=- ;; uri:HTTP://127.0.0.1/?;%7e%E0%A0 ;; s=+HTTP|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=/|q=+;%7e%E0%A0|f=- ;; iri:HTTP://127.0.0.1/?;%7e%E0%A0 ;; n:http://127.0.0.1/?;~%E0%A0 ;; ni:http://127.0.0.1/?;~%E0%A0 ;; u:HTTP://127.0.0.1/?;%7e%E0%A0 ;; sf:HTTP://127.0.0.1/?;%7e%E0%A0|wf:HTTP://127.0.0.1/?;%7e%E0%A0#X%20y|nf:HTTP://127.0.0.1/?;%7e%E0%A0",
    ),
  )
  out.push(
    (
      "a:/.#=\"'", "E:unexpected:6 ;; E:unexpected:6 ;; E:unexpected:6 ;; E:unexpected:6 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "http:", "s=+http|a=-|p=|q=-|f=- ;; uri:http: ;; s=+http|a=-|p=|q=-|f=- ;; iri:http: ;; n:http: ;; ni:http: ;; u:http: ;; sf:http:|wf:http:#X%20y|nf:http:",
    ),
  )
  out.push(
    (
      "HTTP://127.0.0.1", "s=+HTTP|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=|q=-|f=- ;; uri:HTTP://127.0.0.1 ;; s=+HTTP|a=+127.0.0.1|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=-|p=|q=-|f=- ;; iri:HTTP://127.0.0.1 ;; n:http://127.0.0.1 ;; ni:http://127.0.0.1 ;; u:HTTP://127.0.0.1 ;; sf:HTTP://127.0.0.1|wf:HTTP://127.0.0.1#X%20y|nf:HTTP://127.0.0.1",
    ),
  )
  out.push(
    (
      "/./)?", "s=-|a=-|p=/./)|q=+|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/./)|q=+|f=- ;; E:unexpected:0 ;; n:/./)? ;; ni:/./)? ;; u:/./)? ;; sf:/./)?|wf:/./)?#X%20y|nf:/./)?",
    ),
  )
  out.push(
    (
      "//[123451.2.3v]", "E:ipv6:3 ;; E:unexpected:0 ;; E:ipv6:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/a/a", "s=-|a=-|p=/a/a|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/a/a|q=-|f=- ;; E:unexpected:0 ;; n:/a/a ;; ni:/a/a ;; u:/a/a ;; sf:/a/a|wf:/a/a#X%20y|nf:/a/a",
    ),
  )
  out.push(
    (
      "a://[:255.255.255.255ffff]/%2E./%2e/%2e%2E/.%2e/b/b//#%BF;%2E", "E:ipv6:5 ;; E:ipv6:5 ;; E:ipv6:5 ;; E:ipv6:5 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "HTTP://}@[zvffFFFF]/%80%20/1%F0%90%8D%88/%C1%81?%2E z#)", "E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "", "s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=|q=-|f=- ;; E:unexpected:0 ;; n: ;; ni: ;; u: ;; sf:|wf:#X%20y|nf:",
    ),
  )
  out.push(
    (
      "a://127.0.0.1:22970/%FF/?%7e", "s=+a|a=+127.0.0.1:22970|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+22970|p=/%FF/|q=+%7e|f=- ;; uri:a://127.0.0.1:22970/%FF/?%7e ;; s=+a|a=+127.0.0.1:22970|u=-|h=127.0.0.1|hp=4:127.0.0.1|o=+22970|p=/%FF/|q=+%7e|f=- ;; iri:a://127.0.0.1:22970/%FF/?%7e ;; n:a://127.0.0.1:22970/%FF/?~ ;; ni:a://127.0.0.1:22970/%FF/?~ ;; u:a://127.0.0.1:22970/%FF/?%7e ;; sf:a://127.0.0.1:22970/%FF/?%7e|wf:a://127.0.0.1:22970/%FF/?%7e#X%20y|nf:a://127.0.0.1:22970/%FF/?%7e",
    ),
  )
  out.push(
    (
      "//[01.2.3.4%v0]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "z9+-.:/%7e%2E/%a1/%?|", "E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; E:unexpected:7 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//@[]:73846/-)", "E:unexpected:4 ;; E:unexpected:0 ;; E:unexpected:4 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[.255.255.255.255::ffav]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "foo:/%2e/b/%2E/..a/%2e/.%2e/.#%F0%90%8C%80..%2F%2F", "s=+foo|a=-|p=/%2e/b/%2E/..a/%2e/.%2e/.|q=-|f=+%F0%90%8C%80..%2F%2F ;; uri:foo:/%2e/b/%2E/..a/%2e/.%2e/.#%F0%90%8C%80..%2F%2F ;; s=+foo|a=-|p=/%2e/b/%2E/..a/%2e/.%2e/.|q=-|f=+%F0%90%8C%80..%2F%2F ;; iri:foo:/%2e/b/%2E/..a/%2e/.%2e/.#%F0%90%8C%80..%2F%2F ;; n:foo:/b/#%F0%90%8C%80..%2F%2F ;; ni:foo:/b/#\u{10300}..%2F%2F ;; u:foo:/%2e/b/%2E/..a/%2e/.%2e/.#%F0%90%8C%80..%2F%2F ;; sf:foo:/%2e/b/%2E/..a/%2e/.%2e/.|wf:foo:/%2e/b/%2E/..a/%2e/.%2e/.#X%20y|nf:foo:/%2e/b/%2E/..a/%2e/.%2e/.",
    ),
  )
  out.push(
    (
      "http://[::1]/`/", "E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; E:unexpected:13 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      ".", "s=-|a=-|p=.|q=-|f=- ;; E:unexpected:1 ;; s=-|a=-|p=.|q=-|f=- ;; E:unexpected:1 ;; n:. ;; ni:. ;; u:. ;; sf:.|wf:.#X%20y|nf:.",
    ),
  )
  out.push(
    (
      "/%2E./.../.../", "s=-|a=-|p=/%2E./.../.../|q=-|f=- ;; E:unexpected:0 ;; s=-|a=-|p=/%2E./.../.../|q=-|f=- ;; E:unexpected:0 ;; n:/../.../.../ ;; ni:/../.../.../ ;; u:/%2E./.../.../ ;; sf:/%2E./.../.../|wf:/%2E./.../.../#X%20y|nf:/%2E./.../.../",
    ),
  )
  out.push(
    (
      "HTTP://127.0.0.1/!%F4%90%80%80//|^#.", "E:unexpected:32 ;; E:unexpected:32 ;; E:unexpected:32 ;; E:unexpected:32 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "/ ", "E:unexpected:1 ;; E:unexpected:0 ;; E:unexpected:1 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "%example.com%F4%90%80%80", "E:unexpected:2 ;; E:unexpected:0 ;; E:unexpected:2 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[0:0:0:0:0:ffff:192.0.2.1]", "s=-|a=+[0:0:0:0:0:ffff:192.0.2.1]|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; s=-|a=+[0:0:0:0:0:ffff:192.0.2.1]|u=-|h=[0:0:0:0:0:ffff:192.0.2.1]|hp=6:::ffff:192.0.2.1|o=-|p=|q=-|f=- ;; E:unexpected:0 ;; n://[::ffff:192.0.2.1] ;; ni://[::ffff:192.0.2.1] ;; u://[0:0:0:0:0:ffff:192.0.2.1] ;; sf://[0:0:0:0:0:ffff:192.0.2.1]|wf://[0:0:0:0:0:ffff:192.0.2.1]#X%20y|nf://[0:0:0:0:0:ffff:192.0.2.1]",
    ),
  )
  out.push(
    (
      "[::1]", "E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[.a.]", "E:unexpected:3 ;; E:unexpected:0 ;; E:unexpected:3 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
  out.push(
    (
      "//[vF.(\\]", "E:unexpected:7 ;; E:unexpected:0 ;; E:unexpected:7 ;; E:unexpected:0 ;; - ;; - ;; - ;; -",
    ),
  )
}

///|
/// Base and reference pairs, with the results of resolving them.
pub let resolve_cases : Array[(String, String, String)] = collect_resolve_cases()

///|
fn collect_resolve_cases() -> Array[(String, String, String)] {
  let out = []
  resolve_chunk_0(out)
  resolve_chunk_1(out)
  resolve_chunk_2(out)
  resolve_chunk_3(out)
  out
}

///|
fn resolve_chunk_0(out : Array[(String, String, String)]) -> Unit {
  out.push(
    ("http://a/b/c/d;p?q", "", "t:http://a/b/c/d;p?q ;; t:http://a/b/c/d;p?q"),
  )
  out.push(
    ("http://a/b/c/d;p?q", "foo", "t:http://a/b/c/foo ;; t:http://a/b/c/foo"),
  )
  out.push(("http://a/b/c/d;p?q", ".", "t:http://a/b/c/ ;; t:http://a/b/c/"))
  out.push(("http://a/b/c/d;p?q", "..", "t:http://a/b/ ;; t:http://a/b/"))
  out.push(("http://a/b/c/d;p?q", "/", "t:http://a/ ;; t:http://a/"))
  out.push(("http://a/b/c/d;p?q", "//", "t:http:// ;; t:http://"))
  out.push(("http://a/b/c/d;p?q", "///", "t:http:/// ;; t:http:///"))
  out.push(
    ("http://a/b/c/d;p?q", "?", "t:http://a/b/c/d;p? ;; t:http://a/b/c/d;p?"),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "#", "t:http://a/b/c/d;p?q# ;; t:http://a/b/c/d;p?q#",
    ),
  )
  out.push(("http://a/b/c/d;p?q", "//@", "t:http://@ ;; t:http://@"))
  out.push(("http://a/b/c/d;p?q", "//:", "t:http://: ;; t:http://:"))
  out.push(("http://a/b/c/d;p?q", "a:", "t:a: ;; t:a:"))
  out.push(("http://a/b/c/d;p?q", "a:b", "t:a:b ;; t:a:b"))
  out.push(("http://a/b/c/d;p?q", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "http://a/b/c/d;p?q", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
      "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "foo://example.com:8042/over/there?name=ferret#nose",
      "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(
    ("http://a/b/c/d;p?q", "%3a", "t:http://a/b/c/%3a ;; t:http://a/b/c/%3a"),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(
    ("http://a/b/c/d;p?q", "http://a/../../../g", "t:http://a/g ;; E:underflow"),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "foo/../bar", "t:http://a/b/c/bar ;; t:http://a/b/c/bar",
    ),
  )
  out.push(
    ("http://a/b/c/d;p?q", "/foo/../bar", "t:http://a/bar ;; t:http://a/bar"),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz",
    ),
  )
  out.push(
    ("http://a/b/c/d;p?q", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"),
  )
  out.push(("foo:bar", "", "t:foo:bar ;; t:foo:bar"))
  out.push(("foo:bar", "foo", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", ".", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "..", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "/", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "//", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "///", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "?", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "#", "t:foo:bar# ;; t:foo:bar#"))
  out.push(("foo:bar", "//@", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "//:", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "a:", "t:a: ;; t:a:"))
  out.push(("foo:bar", "a:b", "t:a:b ;; t:a:b"))
  out.push(("foo:bar", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "foo:bar", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "foo:bar", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "foo:bar", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "foo:bar", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "foo:bar", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "foo:bar", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "foo:bar", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "foo:bar", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "foo:bar", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "foo:bar", "foo://example.com:8042/over/there?name=ferret#nose", "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "foo:bar", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "foo:bar", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "foo:bar", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "foo:bar", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "foo:bar", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "foo:bar", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "foo:bar", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "foo:bar", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("foo:bar", "%3a", "E:opaque_base ;; E:opaque_base"))
  out.push(
    (
      "foo:bar", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(("foo:bar", "http://a/../../../g", "t:http://a/g ;; E:underflow"))
  out.push(
    (
      "foo:bar", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(("foo:bar", "foo/../bar", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "/foo/../bar", "E:opaque_base ;; E:opaque_base"))
  out.push(
    ("foo:bar", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz"),
  )
  out.push(("foo:bar", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"))
  out.push(("foo:/", "", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/", "foo", "t:foo:/foo ;; t:foo:/foo"))
  out.push(("foo:/", ".", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/", "..", "t:foo:/ ;; E:underflow"))
  out.push(("foo:/", "/", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/", "//", "t:foo:// ;; t:foo://"))
  out.push(("foo:/", "///", "t:foo:/// ;; t:foo:///"))
  out.push(("foo:/", "?", "t:foo:/? ;; t:foo:/?"))
  out.push(("foo:/", "#", "t:foo:/# ;; t:foo:/#"))
  out.push(("foo:/", "//@", "t:foo://@ ;; t:foo://@"))
  out.push(("foo:/", "//:", "t:foo://: ;; t:foo://:"))
  out.push(("foo:/", "a:", "t:a: ;; t:a:"))
  out.push(("foo:/", "a:b", "t:a:b ;; t:a:b"))
  out.push(("foo:/", "a://", "t:a:// ;; t:a://"))
  out.push(
    ("foo:/", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts"),
  )
  out.push(
    (
      "foo:/", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "foo:/", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "foo:/", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "foo:/", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "foo:/", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "foo:/", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "foo:/", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "foo:/", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "foo:/", "foo://example.com:8042/over/there?name=ferret#nose", "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "foo:/", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "foo:/", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "foo:/", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "foo:/", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "foo:/", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "foo:/", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "foo:/", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "foo:/", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("foo:/", "%3a", "t:foo:/%3a ;; t:foo:/%3a"))
  out.push(
    (
      "foo:/", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(("foo:/", "http://a/../../../g", "t:http://a/g ;; E:underflow"))
  out.push(
    ("foo:/", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d"),
  )
  out.push(("foo:/", "foo/../bar", "t:foo:/bar ;; t:foo:/bar"))
  out.push(("foo:/", "/foo/../bar", "t:foo:/bar ;; t:foo:/bar"))
  out.push(("foo:/", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz"))
  out.push(("foo:/", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"))
  out.push(("foo:/bar/baz/.%2E/", "", "t:foo:/bar/ ;; t:foo:/bar/"))
  out.push(("foo:/bar/baz/.%2E/", "foo", "t:foo:/bar/foo ;; t:foo:/bar/foo"))
  out.push(("foo:/bar/baz/.%2E/", ".", "t:foo:/bar/ ;; t:foo:/bar/"))
  out.push(("foo:/bar/baz/.%2E/", "..", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/bar/baz/.%2E/", "/", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/bar/baz/.%2E/", "//", "t:foo:// ;; t:foo://"))
  out.push(("foo:/bar/baz/.%2E/", "///", "t:foo:/// ;; t:foo:///"))
  out.push(("foo:/bar/baz/.%2E/", "?", "t:foo:/bar/? ;; t:foo:/bar/?"))
  out.push(("foo:/bar/baz/.%2E/", "#", "t:foo:/bar/# ;; t:foo:/bar/#"))
  out.push(("foo:/bar/baz/.%2E/", "//@", "t:foo://@ ;; t:foo://@"))
  out.push(("foo:/bar/baz/.%2E/", "//:", "t:foo://: ;; t:foo://:"))
  out.push(("foo:/bar/baz/.%2E/", "a:", "t:a: ;; t:a:"))
  out.push(("foo:/bar/baz/.%2E/", "a:b", "t:a:b ;; t:a:b"))
  out.push(("foo:/bar/baz/.%2E/", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "foo:/bar/baz/.%2E/", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
      "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "foo://example.com:8042/over/there?name=ferret#nose",
      "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("foo:/bar/baz/.%2E/", "%3a", "t:foo:/bar/%3a ;; t:foo:/bar/%3a"))
  out.push(
    (
      "foo:/bar/baz/.%2E/", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(
    ("foo:/bar/baz/.%2E/", "http://a/../../../g", "t:http://a/g ;; E:underflow"),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(
    ("foo:/bar/baz/.%2E/", "foo/../bar", "t:foo:/bar/bar ;; t:foo:/bar/bar"),
  )
  out.push(("foo:/bar/baz/.%2E/", "/foo/../bar", "t:foo:/bar ;; t:foo:/bar"))
  out.push(
    (
      "foo:/bar/baz/.%2E/", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz",
    ),
  )
  out.push(
    ("foo:/bar/baz/.%2E/", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"),
  )
  out.push(("foo:/bar/..", "", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/bar/..", "foo", "t:foo:/foo ;; t:foo:/foo"))
  out.push(("foo:/bar/..", ".", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/bar/..", "..", "t:foo:/ ;; E:underflow"))
  out.push(("foo:/bar/..", "/", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/bar/..", "//", "t:foo:// ;; t:foo://"))
  out.push(("foo:/bar/..", "///", "t:foo:/// ;; t:foo:///"))
  out.push(("foo:/bar/..", "?", "t:foo:/? ;; t:foo:/?"))
  out.push(("foo:/bar/..", "#", "t:foo:/# ;; t:foo:/#"))
  out.push(("foo:/bar/..", "//@", "t:foo://@ ;; t:foo://@"))
  out.push(("foo:/bar/..", "//:", "t:foo://: ;; t:foo://:"))
  out.push(("foo:/bar/..", "a:", "t:a: ;; t:a:"))
  out.push(("foo:/bar/..", "a:b", "t:a:b ;; t:a:b"))
  out.push(("foo:/bar/..", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "foo:/bar/..", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "foo://example.com:8042/over/there?name=ferret#nose", "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "foo:/bar/..", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("foo:/bar/..", "%3a", "t:foo:/%3a ;; t:foo:/%3a"))
  out.push(
    (
      "foo:/bar/..", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(
    ("foo:/bar/..", "http://a/../../../g", "t:http://a/g ;; E:underflow"),
  )
  out.push(
    (
      "foo:/bar/..", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(("foo:/bar/..", "foo/../bar", "t:foo:/bar ;; t:foo:/bar"))
  out.push(("foo:/bar/..", "/foo/../bar", "t:foo:/bar ;; t:foo:/bar"))
  out.push(
    ("foo:/bar/..", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz"),
  )
  out.push(("foo:/bar/..", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"))
}

///|
fn resolve_chunk_1(out : Array[(String, String, String)]) -> Unit {
  out.push(("foo:bar/..", "", "t:foo:bar/.. ;; t:foo:bar/.."))
  out.push(("foo:bar/..", "foo", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", ".", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "..", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "/", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "//", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "///", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "?", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "#", "t:foo:bar/..# ;; t:foo:bar/..#"))
  out.push(("foo:bar/..", "//@", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "//:", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "a:", "t:a: ;; t:a:"))
  out.push(("foo:bar/..", "a:b", "t:a:b ;; t:a:b"))
  out.push(("foo:bar/..", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "foo:bar/..", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "foo:bar/..", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "foo:bar/..", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "foo:bar/..", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "foo:bar/..", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "foo:bar/..", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "foo:bar/..", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "foo:bar/..", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "foo:bar/..", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "foo:bar/..", "foo://example.com:8042/over/there?name=ferret#nose", "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "foo:bar/..", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "foo:bar/..", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "foo:bar/..", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "foo:bar/..", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "foo:bar/..", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "foo:bar/..", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "foo:bar/..", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "foo:bar/..", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("foo:bar/..", "%3a", "E:opaque_base ;; E:opaque_base"))
  out.push(
    (
      "foo:bar/..", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(("foo:bar/..", "http://a/../../../g", "t:http://a/g ;; E:underflow"))
  out.push(
    (
      "foo:bar/..", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(("foo:bar/..", "foo/../bar", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar/..", "/foo/../bar", "E:opaque_base ;; E:opaque_base"))
  out.push(
    ("foo:bar/..", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz"),
  )
  out.push(("foo:bar/..", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"))
  out.push(
    ("http://example.com/#title1", "", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "foo", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", ".", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "..", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "/", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "//", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "///", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "?", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "#", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "//@", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "//:", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "a:", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "a:b", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    ("http://example.com/#title1", "a://", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    (
      "http://example.com/#title1", "file:///etc/hosts", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://www.ietf.org/rfc/rfc2396.txt", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "ldap://[2001:db8::7]/c=GB?objectClass?one",
      "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "mailto:John.Doe@example.com", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "news:comp.infosystems.www.servers.unix", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "tel:+1-816-555-1212", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "telnet://192.0.2.16:80/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
      "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "foo://example.com:8042/over/there?name=ferret#nose",
      "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://[vFe.foo.bar]", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://127.0.0.1:/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://127.0.0.1:80808/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://example.com", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://example.com:/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://example.com:80/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    ("http://example.com/#title1", "%3a", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(
    (
      "http://example.com/#title1", "HTTP://www.EXAMPLE.com/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://a/../../../g", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "http://a/b/c/%2E/%2E./%2e%2E/d", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "foo/../bar", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "/foo/../bar", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "foo:bar/../baz", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "foo:/bar/./../baz", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(("foo:/..", "", "t:foo:/ ;; E:underflow"))
  out.push(("foo:/..", "foo", "t:foo:/foo ;; E:underflow"))
  out.push(("foo:/..", ".", "t:foo:/ ;; E:underflow"))
  out.push(("foo:/..", "..", "t:foo:/ ;; E:underflow"))
  out.push(("foo:/..", "/", "t:foo:/ ;; t:foo:/"))
  out.push(("foo:/..", "//", "t:foo:// ;; t:foo://"))
  out.push(("foo:/..", "///", "t:foo:/// ;; t:foo:///"))
  out.push(("foo:/..", "?", "t:foo:/? ;; E:underflow"))
  out.push(("foo:/..", "#", "t:foo:/# ;; E:underflow"))
  out.push(("foo:/..", "//@", "t:foo://@ ;; t:foo://@"))
  out.push(("foo:/..", "//:", "t:foo://: ;; t:foo://:"))
  out.push(("foo:/..", "a:", "t:a: ;; t:a:"))
  out.push(("foo:/..", "a:b", "t:a:b ;; t:a:b"))
  out.push(("foo:/..", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "foo:/..", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "foo:/..", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "foo:/..", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "foo:/..", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "foo:/..", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "foo:/..", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "foo:/..", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "foo:/..", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "foo:/..", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "foo:/..", "foo://example.com:8042/over/there?name=ferret#nose", "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "foo:/..", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "foo:/..", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "foo:/..", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "foo:/..", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "foo:/..", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "foo:/..", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "foo:/..", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "foo:/..", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("foo:/..", "%3a", "t:foo:/%3a ;; E:underflow"))
  out.push(
    (
      "foo:/..", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(("foo:/..", "http://a/../../../g", "t:http://a/g ;; E:underflow"))
  out.push(
    (
      "foo:/..", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(("foo:/..", "foo/../bar", "t:foo:/bar ;; E:underflow"))
  out.push(("foo:/..", "/foo/../bar", "t:foo:/bar ;; t:foo:/bar"))
  out.push(
    ("foo:/..", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz"),
  )
  out.push(("foo:/..", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"))
  out.push(
    ("http://example.com", "", "t:http://example.com ;; t:http://example.com"),
  )
  out.push(
    (
      "http://example.com", "foo", "t:http://example.com/foo ;; t:http://example.com/foo",
    ),
  )
  out.push(
    (
      "http://example.com", ".", "t:http://example.com/ ;; t:http://example.com/",
    ),
  )
  out.push(("http://example.com", "..", "t:http://example.com/ ;; E:underflow"))
  out.push(
    (
      "http://example.com", "/", "t:http://example.com/ ;; t:http://example.com/",
    ),
  )
  out.push(("http://example.com", "//", "t:http:// ;; t:http://"))
  out.push(("http://example.com", "///", "t:http:/// ;; t:http:///"))
  out.push(
    (
      "http://example.com", "?", "t:http://example.com? ;; t:http://example.com?",
    ),
  )
  out.push(
    (
      "http://example.com", "#", "t:http://example.com# ;; t:http://example.com#",
    ),
  )
  out.push(("http://example.com", "//@", "t:http://@ ;; t:http://@"))
  out.push(("http://example.com", "//:", "t:http://: ;; t:http://:"))
  out.push(("http://example.com", "a:", "t:a: ;; t:a:"))
  out.push(("http://example.com", "a:b", "t:a:b ;; t:a:b"))
  out.push(("http://example.com", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "http://example.com", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "http://example.com", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "http://example.com", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "http://example.com", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "http://example.com", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "http://example.com", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "http://example.com", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "http://example.com", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "http://example.com", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
      "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "http://example.com", "foo://example.com:8042/over/there?name=ferret#nose",
      "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "http://example.com", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "http://example.com", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "http://example.com", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "http://example.com", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "http://example.com", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "http://example.com", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "http://example.com", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "http://example.com", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(
    (
      "http://example.com", "%3a", "t:http://example.com/%3a ;; t:http://example.com/%3a",
    ),
  )
  out.push(
    (
      "http://example.com", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(
    ("http://example.com", "http://a/../../../g", "t:http://a/g ;; E:underflow"),
  )
  out.push(
    (
      "http://example.com", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(
    (
      "http://example.com", "foo/../bar", "t:http://example.com/bar ;; t:http://example.com/bar",
    ),
  )
  out.push(
    (
      "http://example.com", "/foo/../bar", "t:http://example.com/bar ;; t:http://example.com/bar",
    ),
  )
  out.push(
    (
      "http://example.com", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz",
    ),
  )
  out.push(
    ("http://example.com", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"),
  )
  out.push(("a:", "", "t:a: ;; t:a:"))
  out.push(("a:", "foo", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", ".", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "..", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "/", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "//", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "///", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "?", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "#", "t:a:# ;; t:a:#"))
  out.push(("a:", "//@", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "//:", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "a:", "t:a: ;; t:a:"))
  out.push(("a:", "a:b", "t:a:b ;; t:a:b"))
  out.push(("a:", "a://", "t:a:// ;; t:a://"))
  out.push(
    ("a:", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts"),
  )
  out.push(
    (
      "a:", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "a:", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "a:", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "a:", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "a:", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "a:", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "a:", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "a:", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "a:", "foo://example.com:8042/over/there?name=ferret#nose", "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "a:", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm", "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "a:", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    ("a:", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/"),
  )
  out.push(
    (
      "a:", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "a:", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    ("a:", "http://example.com", "t:http://example.com ;; t:http://example.com"),
  )
  out.push(
    (
      "a:", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "a:", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("a:", "%3a", "E:opaque_base ;; E:opaque_base"))
  out.push(
    (
      "a:", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(("a:", "http://a/../../../g", "t:http://a/g ;; E:underflow"))
  out.push(
    ("a:", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d"),
  )
  out.push(("a:", "foo/../bar", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "/foo/../bar", "E:opaque_base ;; E:opaque_base"))
  out.push(("a:", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz"))
  out.push(("a:", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"))
}

///|
fn resolve_chunk_2(out : Array[(String, String, String)]) -> Unit {
  out.push(("a://b", "", "t:a://b ;; t:a://b"))
  out.push(("a://b", "foo", "t:a://b/foo ;; t:a://b/foo"))
  out.push(("a://b", ".", "t:a://b/ ;; t:a://b/"))
  out.push(("a://b", "..", "t:a://b/ ;; E:underflow"))
  out.push(("a://b", "/", "t:a://b/ ;; t:a://b/"))
  out.push(("a://b", "//", "t:a:// ;; t:a://"))
  out.push(("a://b", "///", "t:a:/// ;; t:a:///"))
  out.push(("a://b", "?", "t:a://b? ;; t:a://b?"))
  out.push(("a://b", "#", "t:a://b# ;; t:a://b#"))
  out.push(("a://b", "//@", "t:a://@ ;; t:a://@"))
  out.push(("a://b", "//:", "t:a://: ;; t:a://:"))
  out.push(("a://b", "a:", "t:a: ;; t:a:"))
  out.push(("a://b", "a:b", "t:a:b ;; t:a:b"))
  out.push(("a://b", "a://", "t:a:// ;; t:a://"))
  out.push(
    ("a://b", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts"),
  )
  out.push(
    (
      "a://b", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "a://b", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "a://b", "ldap://[2001:db8::7]/c=GB?objectClass?one", "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "a://b", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "a://b", "news:comp.infosystems.www.servers.unix", "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "a://b", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "a://b", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "a://b", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2", "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "a://b", "foo://example.com:8042/over/there?name=ferret#nose", "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "a://b", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "a://b", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "a://b", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "a://b", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "a://b", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "a://b", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "a://b", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "a://b", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(("a://b", "%3a", "t:a://b/%3a ;; t:a://b/%3a"))
  out.push(
    (
      "a://b", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(("a://b", "http://a/../../../g", "t:http://a/g ;; E:underflow"))
  out.push(
    ("a://b", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d"),
  )
  out.push(("a://b", "foo/../bar", "t:a://b/bar ;; t:a://b/bar"))
  out.push(("a://b", "/foo/../bar", "t:a://b/bar ;; t:a://b/bar"))
  out.push(("a://b", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz"))
  out.push(("a://b", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "", "t:http://\u{4f8b}\u{3048}.jp/a/b ;; t:http://\u{4f8b}\u{3048}.jp/a/b",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "foo", "t:http://\u{4f8b}\u{3048}.jp/a/foo ;; t:http://\u{4f8b}\u{3048}.jp/a/foo",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", ".", "t:http://\u{4f8b}\u{3048}.jp/a/ ;; t:http://\u{4f8b}\u{3048}.jp/a/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "..", "t:http://\u{4f8b}\u{3048}.jp/ ;; t:http://\u{4f8b}\u{3048}.jp/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "/", "t:http://\u{4f8b}\u{3048}.jp/ ;; t:http://\u{4f8b}\u{3048}.jp/",
    ),
  )
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "//", "t:http:// ;; t:http://"))
  out.push(
    ("http://\u{4f8b}\u{3048}.jp/a/b", "///", "t:http:/// ;; t:http:///"),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "?", "t:http://\u{4f8b}\u{3048}.jp/a/b? ;; t:http://\u{4f8b}\u{3048}.jp/a/b?",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "#", "t:http://\u{4f8b}\u{3048}.jp/a/b# ;; t:http://\u{4f8b}\u{3048}.jp/a/b#",
    ),
  )
  out.push(
    ("http://\u{4f8b}\u{3048}.jp/a/b", "//@", "t:http://@ ;; t:http://@"),
  )
  out.push(
    ("http://\u{4f8b}\u{3048}.jp/a/b", "//:", "t:http://: ;; t:http://:"),
  )
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "a:", "t:a: ;; t:a:"))
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "a:b", "t:a:b ;; t:a:b"))
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "a://", "t:a:// ;; t:a://"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "file:///etc/hosts", "t:file:///etc/hosts ;; t:file:///etc/hosts",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "ftp://ftp.is.co.za/rfc/rfc1808.txt", "t:ftp://ftp.is.co.za/rfc/rfc1808.txt ;; t:ftp://ftp.is.co.za/rfc/rfc1808.txt",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://www.ietf.org/rfc/rfc2396.txt", "t:http://www.ietf.org/rfc/rfc2396.txt ;; t:http://www.ietf.org/rfc/rfc2396.txt",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "ldap://[2001:db8::7]/c=GB?objectClass?one",
      "t:ldap://[2001:db8::7]/c=GB?objectClass?one ;; t:ldap://[2001:db8::7]/c=GB?objectClass?one",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "mailto:John.Doe@example.com", "t:mailto:John.Doe@example.com ;; t:mailto:John.Doe@example.com",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "news:comp.infosystems.www.servers.unix",
      "t:news:comp.infosystems.www.servers.unix ;; t:news:comp.infosystems.www.servers.unix",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "tel:+1-816-555-1212", "t:tel:+1-816-555-1212 ;; t:tel:+1-816-555-1212",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "telnet://192.0.2.16:80/", "t:telnet://192.0.2.16:80/ ;; t:telnet://192.0.2.16:80/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
      "t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2 ;; t:urn:oasis:names:specification:docbook:dtd:xml:4.1.2",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "foo://example.com:8042/over/there?name=ferret#nose",
      "t:foo://example.com:8042/over/there?name=ferret#nose ;; t:foo://example.com:8042/over/there?name=ferret#nose",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
      "t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm ;; t:ftp://cnn.example.com&story=breaking_news@10.0.0.1/top_story.htm",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://[vFe.foo.bar]", "t:http://[vFe.foo.bar] ;; t:http://[vFe.foo.bar]",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://127.0.0.1:/", "t:http://127.0.0.1:/ ;; t:http://127.0.0.1:/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://127.0.0.1:80808/", "t:http://127.0.0.1:80808/ ;; t:http://127.0.0.1:80808/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "eXAMPLE://a/./b/../b/%63/%7bfoo%7d", "t:eXAMPLE://a/b/%63/%7bfoo%7d ;; t:eXAMPLE://a/b/%63/%7bfoo%7d",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://example.com", "t:http://example.com ;; t:http://example.com",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://example.com:/", "t:http://example.com:/ ;; t:http://example.com:/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://example.com:80/", "t:http://example.com:80/ ;; t:http://example.com:80/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "%3a", "t:http://\u{4f8b}\u{3048}.jp/a/%3a ;; t:http://\u{4f8b}\u{3048}.jp/a/%3a",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "HTTP://www.EXAMPLE.com/", "t:HTTP://www.EXAMPLE.com/ ;; t:HTTP://www.EXAMPLE.com/",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://a/../../../g", "t:http://a/g ;; E:underflow",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://a/b/c/%2E/%2E./%2e%2E/d", "t:http://a/d ;; t:http://a/d",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "foo/../bar", "t:http://\u{4f8b}\u{3048}.jp/a/bar ;; t:http://\u{4f8b}\u{3048}.jp/a/bar",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "/foo/../bar", "t:http://\u{4f8b}\u{3048}.jp/bar ;; t:http://\u{4f8b}\u{3048}.jp/bar",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "foo:bar/../baz", "t:foo:bar/../baz ;; t:foo:bar/../baz",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "foo:/bar/./../baz", "t:foo:/baz ;; t:foo:/baz",
    ),
  )
  out.push(("foo:bar/..", "", "t:foo:bar/.. ;; t:foo:bar/.."))
  out.push(("foo:/%2E/..a/.../.%2e", "..?%20", "t:foo:/?%20 ;; t:foo:/?%20"))
  out.push(
    (
      "http:/%2E./..a/.../..a/%2e%2E/..a/..", "http://+%7eA/:/#::1%F0%90%8D%889",
      "t:http://+%7eA/:/#::1%F0%90%8D%889 ;; t:http://+%7eA/:/#::1%F0%90%8D%889",
    ),
  )
  out.push(("a:/%2E.", "/...", "t:a:/... ;; t:a:/..."))
  out.push(
    (
      "http://host/..a/%2E./.", "z9+-.:/%7e%FF/%2E?", "t:z9+-.:/%7e%FF/? ;; t:z9+-.:/%7e%FF/?",
    ),
  )
  out.push(("a:", "/..%2F{/!..%2F", "-"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "/%2E/a///%2e%2E/a/b", "t:http://\u{4f8b}\u{3048}.jp/a//a/b ;; t:http://\u{4f8b}\u{3048}.jp/a//a/b",
    ),
  )
  out.push(
    (
      "foo://host/%2E./..a/../%2E./..a/%2e%2E/a", "/.../%2e//.../%2e", "t:foo://host/...//.../ ;; t:foo://host/...//.../",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "HTTP://[192.0.2.1%ffff192.0.2.1FFFFz1]/<?,%E2%82=",
      "-",
    ),
  )
  out.push(("http://example.com/#title1", "http://| /=%2F//%F0%82%82%AC", "-"))
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "}&%F0%90%8D%88^", "-"))
  out.push(("foo:bar/..", "z9+-.:/0/b_", "t:z9+-.:/0/b_ ;; t:z9+-.:/0/b_"))
  out.push(("a:", "/.%2e/%2e///.%2e/...", "E:opaque_base ;; E:opaque_base"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "a:/%2E/.../b/a/.%2e/.%2e/a?%E0%80%80?%C2%A2",
      "t:a:/.../a?%E0%80%80?%C2%A2 ;; t:a:/.../a?%E0%80%80?%C2%A2",
    ),
  )
  out.push(
    (
      "foo:/..", "foo://[0:0:0:0:0:ffff:192.0.2.1]#%F0%90%8C%80example.com", "t:foo://[0:0:0:0:0:ffff:192.0.2.1]#%F0%90%8C%80example.com ;; t:foo://[0:0:0:0:0:ffff:192.0.2.1]#%F0%90%8C%80example.com",
    ),
  )
  out.push(("http:/", "\",^-", "-"))
  out.push(
    ("foo:/bar/baz/.%2E/", "http:/.../.%2e#&~", "t:http:/#&~ ;; t:http:/#&~"),
  )
  out.push(
    ("foo:bar", "/%2E/b/%2E.//%2E./a/", "E:opaque_base ;; E:opaque_base"),
  )
  out.push(("foo:/bar/..", "http:/", "t:http:/ ;; t:http:/"))
  out.push(
    (
      "foo://host/.%2e", "//%2e/a/.../%2e/%2e", "t:foo://%2e/a/.../ ;; t:foo://%2e/a/.../",
    ),
  )
  out.push(("foo:/..", "//127.0.0.1/%2E./%2E./...?%C0%80]##", "-"))
  out.push(("foo:bar", "\u{e9}/", "E:opaque_base ;; E:opaque_base"))
  out.push(
    (
      "http://example.com/#title1", "/..a/%2e%2E/b/../..a/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "foo:/", "/.%2e/%2E./%2E.///../.%2e?%C0%80z@", "t:foo:/?%C0%80z@ ;; E:underflow",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "HTTP://)/b/..", "t:HTTP://)/ ;; t:HTTP://)/",
    ),
  )
  out.push(
    (
      "foo:/%2e%2E/b/.%2e/.../%2E/..a/", "//127.0.0.1:", "t:foo://127.0.0.1: ;; t:foo://127.0.0.1:",
    ),
  )
  out.push(("foo:/..", "%2F%ED%A0%80", "t:foo:/%2F%ED%A0%80 ;; E:underflow"))
  out.push(("a://b", "//[::1]/", "t:a://[::1]/ ;; t:a://[::1]/"))
  out.push(("a://b", "/%2e", "t:a://b/ ;; t:a://b/"))
  out.push(
    (
      "a:", "http://>@[v7.Foo.Bar]/%2e\u{e9}/{/\u{4f8b}{?%example.com\u{e9}", "-",
    ),
  )
  out.push(
    (
      "a://b", "http:/%C1%81/%F4%90%80%80%F4%90%80%80", "t:http:/%C1%81/%F4%90%80%80%F4%90%80%80 ;; t:http:/%C1%81/%F4%90%80%80%F4%90%80%80",
    ),
  )
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "%E0%80%80:\". ", "-"))
  out.push(("http://example.com", "/%80/!%F0%9F%98/%2e<", "-"))
  out.push(
    (
      "foo:/b/%2e%2E", "a://[::1]/?%2e)", "t:a://[::1]/?%2e) ;; t:a://[::1]/?%2e)",
    ),
  )
  out.push(("a:", "", "t:a: ;; t:a:"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "//[z::255.255.255.255v255.255.255.255]//%2E/././?%av6",
      "-",
    ),
  )
  out.push(("a://b", "/%2e%2E/.%2e/%2E", "t:a://b/ ;; E:underflow"))
  out.push(("foo:/.", "/=/A%20?#.", "t:foo:/=/A%20?#. ;; t:foo:/=/A%20?#."))
  out.push(("foo:bar/..", "a:#%C0%80[::1]", "-"))
  out.push(
    ("foo:/..", "/?%2e_\u{e9}", "t:foo:/?%2e_\u{e9} ;; t:foo:/?%2e_\u{e9}"),
  )
  out.push(("foo:bar", "", "t:foo:bar ;; t:foo:bar"))
  out.push(
    (
      "a:", "//%E0%80%80\u{e9}#@[01.2.3.4ffffa::ffff01.2.3.41.2.3]// %F0%90%8D%88?@%E0%A4%B9",
      "-",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "foo://%F0%90%8C%80'#%E0%80%80Z9", "t:foo://%F0%90%8C%80'#%E0%80%80Z9 ;; t:foo://%F0%90%8C%80'#%E0%80%80Z9",
    ),
  )
  out.push(("foo:/..", ".$&/%41", "t:foo:/.$&/%41 ;; E:underflow"))
  out.push(("foo://host", "%a*%C2%A2%2F%=", "-"))
  out.push(("foo:bar/..", "//[VgF.]", "-"))
  out.push(("foo:/..", "//%\u{4f8b}@[::1]:28597/%41", "-"))
  out.push(
    (
      "foo:/", "%C0%80a*?%C3%A9%FF", "t:foo:/%C0%80a*?%C3%A9%FF ;; t:foo:/%C0%80a*?%C3%A9%FF",
    ),
  )
  out.push(
    (
      "foo:/b/%2e%2E/", "z9+-.:%20#~\u{4f8b}", "t:z9+-.:%20#~\u{4f8b} ;; t:z9+-.:%20#~\u{4f8b}",
    ),
  )
  out.push(("foo:bar/..", "a://[v7.Foo.Bar]//?%F0%90%8D%88%zz", "-"))
  out.push(("foo:/bar/baz/.%2E/", "", "t:foo:/bar/ ;; t:foo:/bar/"))
  out.push(
    ("foo://host/..a/%2E./..a", "/...", "t:foo://host/... ;; t:foo://host/..."),
  )
  out.push(("a:", ";#'v6", "E:opaque_base ;; E:opaque_base"))
  out.push(("a://b", "", "t:a://b ;; t:a://b"))
  out.push(
    (
      "foo:bar/..", "//[v7.Foo.Bar]//%2e/%2e%2E/", "E:opaque_base ;; E:opaque_base",
    ),
  )
  out.push(("http://host/b/%2e", "z9+-.://[::1]/'../%a%F0%9F%98/_?%E2%82", "-"))
  out.push(("http://host/%2E./%2e//..a/b/a", "a:/[/'%F0%82%82%AC#_$", "-"))
  out.push(("foo:/bar/..", "http:/..<//", "-"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "/%2e/../a/a/b/.", "t:http://\u{4f8b}\u{3048}.jp/a/a/b/ ;; E:underflow",
    ),
  )
  out.push(
    (
      "http://host/..././%2E.//a/%2E.", "http://\u{e9}%20@[vga.(a/%E0%80%80//[::1]\u{10300}?",
      "-",
    ),
  )
  out.push(
    (
      "a:/%2e/%2e%2E/%2E/./%2E/.%2e/", "//@[::1]/\u{10300}/%7e%2E/?", "t:a://@[::1]/\u{10300}/%7e%2E/? ;; t:a://@[::1]/\u{10300}/%7e%2E/?",
    ),
  )
  out.push(("a:", "%C0%80", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:/", "\u{e000}%BFa127.0.0.1\"%80", "-"))
  out.push(
    ("http:", "//@[0:0:0:0:0:ffff:192.0.2.1]:49570/[::1/%C2%A2..?.", "-"),
  )
  out.push(("http://a/b/c/d;p?q", "/a/a", "t:http://a/a/a ;; t:http://a/a/a"))
  out.push(
    (
      "http://example.com/#title1", "z9+-.://[::1]", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(("http://host/a/..a/./.%2e/%2e%2E", "/&/#|", "-"))
  out.push(
    ("http://a/b/c/d;p?q", "HTTP:/.../../%2E./%2E/..././...?%@example.com", "-"),
  )
  out.push(("foo:bar", "z9+-.://[1/%2F%E2%82/", "-"))
  out.push(("http://example.com/#title1", "//[01.2.3]", "-"))
  out.push(("foo:/", "/...", "t:foo:/... ;; t:foo:/..."))
  out.push(
    ("http://a/b/c/d;p?q", "/a/b/", "t:http://a/a/b/ ;; t:http://a/a/b/"),
  )
  out.push(("http://example.com/#title1", "@\\@@", "-"))
  out.push(("http://a/b/c/d;p?q", "//[0000]", "-"))
  out.push(
    (
      "a://host/./%2e", "HTTP:/%2E./b/%2e%2E/.%2e/%2E#%C1%81", "t:HTTP:/#%C1%81 ;; E:underflow",
    ),
  )
  out.push(("foo:/bar/baz/.%2E/", "//[0000ffv1:a00001234501.2.3.4]", "-"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "a://@[v7.Foo.Bar]/..", "t:a://@[v7.Foo.Bar]/ ;; E:underflow",
    ),
  )
  out.push(
    (
      "http://example.com", "z9+-.://[0:0:0:0:0:ffff:192.0.2.1]/%41//", "t:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]/%41// ;; t:z9+-.://[0:0:0:0:0:ffff:192.0.2.1]/%41//",
    ),
  )
  out.push(
    ("http://host/./b/%2e%2E/...//", "%2F%C2%A2\"\u{e000}%F0%82%82%AC$", "-"),
  )
  out.push(("a:", "z9+-.://[a]:4647/a/../%2E/..a/a/", "-"))
  out.push(("a:", ">", "-"))
  out.push(("a://b", "", "t:a://b ;; t:a://b"))
  out.push(("http://example.com/#title1", "//[01.2.3.41.2.3a::01.2.3.4]", "-"))
  out.push(("foo:/..", "z9+-.://", "t:z9+-.:// ;; t:z9+-.://"))
  out.push(("foo:/..", "", "t:foo:/ ;; E:underflow"))
  out.push(("foo:bar", "", "t:foo:bar ;; t:foo:bar"))
  out.push(
    (
      "foo:/..", "http://[::1]:/../a?:\u{4f8b}", "t:http://[::1]:/a?:\u{4f8b} ;; E:underflow",
    ),
  )
  out.push(
    ("http://example.com", "/%2E./b/", "t:http://example.com/b/ ;; E:underflow"),
  )
  out.push(
    (
      "a:/./.././%2E/%2E./..a/%2E/", "//%80#+%41", "t:a://%80#+%41 ;; t:a://%80#+%41",
    ),
  )
  out.push(
    (
      "foo:bar", "z9+-.://@[0:0:0:0:0:ffff:192.0.2.1]:8241/../%2E./%2e%2E/..a/../?>z",
      "-",
    ),
  )
  out.push(("foo:bar", "HTTP:", "t:HTTP: ;; t:HTTP:"))
  out.push(("a://b", "http:/.../.", "t:http:/.../ ;; t:http:/.../"))
  out.push(
    (
      "http://example.com", "z9+-.://%2E@[10255.255.255.255abcd]///127.0.0.1A#%a%C0%80'",
      "-",
    ),
  )
  out.push(
    (
      "http://host/%2E./%2e%2E/a/a/", "a:/%F0%82%82%AC#[::1]%7e%F4%90%80%80", "-",
    ),
  )
  out.push(
    (
      "a://host/b//", "//[ff1.2.3192.0.2.100001:::/%2e%2E/%2e%2E?_..#example.com%E0%A0@",
      "-",
    ),
  )
  out.push(("foo:/..", "", "t:foo:/ ;; E:underflow"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "/.%2e", "t:http://\u{4f8b}\u{3048}.jp/ ;; E:underflow",
    ),
  )
  out.push(
    (
      "foo:/%2e%2E/a/.%2e/a", "http:/0a//%41#A\u{10300}", "t:http:/0a//%41#A\u{10300} ;; t:http:/0a//%41#A\u{10300}",
    ),
  )
  out.push(("foo:/..", "//[::1]:87856/'a?\u{10300}[::1]%C1%81", "-"))
  out.push(("a:", "/%2e%2E/..a", "E:opaque_base ;; E:opaque_base"))
  out.push(
    (
      "a://host/.../", "%C1%81#%C2%A2%FF", "t:a://host/.../%C1%81#%C2%A2%FF ;; t:a://host/.../%C1%81#%C2%A2%FF",
    ),
  )
  out.push(
    (
      "a://host/b/..a", "foo:/?z127.0.0.1%F4%90%80%80#..%2F%C3%A9,", "t:foo:/?z127.0.0.1%F4%90%80%80#..%2F%C3%A9, ;; t:foo:/?z127.0.0.1%F4%90%80%80#..%2F%C3%A9,",
    ),
  )
  out.push(("a://b", "/../.%2e/.%2e/.../.%2e", "t:a://b/ ;; E:underflow"))
  out.push(("http://host", "/%2e/%2E.#<127.0.0.1", "-"))
  out.push(("foo:bar", "/b/./", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:/..", "HTTP://[V././a/%2e%2E/../...#|%ED%A0%80", "-"))
  out.push(
    (
      "a://host/%2E./a/.../..a/.%2e/%2E./..", "//[::1]:98969/%2F/\u{e000}/%F4%90%80%80!?z%C3%A9",
      "-",
    ),
  )
  out.push(("http://a/b/c/d;p?q", "http:/%zz/}#%^", "-"))
  out.push(
    (
      "http://host/../a/..a/.%2e/.%2e//%2e", "/a/", "t:http://host/a/ ;; t:http://host/a/",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "foo://@[v7.Foo.Bar]", "t:foo://@[v7.Foo.Bar] ;; t:foo://@[v7.Foo.Bar]",
    ),
  )
  out.push(
    ("http:", "a://[::1]?..%2F9,", "t:a://[::1]?..%2F9, ;; t:a://[::1]?..%2F9,"),
  )
  out.push(("foo://host/%2E./.%2e/a/a", "http://%F0%9F%98\"/", "-"))
  out.push(("foo:/", "/%2e/%2e/..a/", "t:foo:/..a/ ;; t:foo:/..a/"))
  out.push(("foo:/bar/..", "%20", "t:foo:/%20 ;; t:foo:/%20"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "/%2e/%2E./%2e%2E/a/.%2e#:/.", "t:http://\u{4f8b}\u{3048}.jp/#:/. ;; E:underflow",
    ),
  )
  out.push(("a://b", "/%2e%2E", "t:a://b/ ;; E:underflow"))
  out.push(("foo:/..", "//[v7.Foo.Bar]#%", "-"))
  out.push(("a://b", "|", "-"))
  out.push(("foo:/", "=%C3%A9`v6", "-"))
  out.push(
    ("foo:/", "http:/_\u{4f8b}", "t:http:/_\u{4f8b} ;; t:http:/_\u{4f8b}"),
  )
}

///|
fn resolve_chunk_3(out : Array[(String, String, String)]) -> Unit {
  out.push(
    (
      "a://host/a/a/.%2e/./%2E.", "foo://%C2%A2)%F0%90%8D%88/\"=/%ED%A0%80/?}%20#\\?",
      "-",
    ),
  )
  out.push(("foo:bar/..", "%F0%9F%98&", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:/bar/..", "//[::a255.255.255.255]", "-"))
  out.push(
    (
      "http://example.com/#title1", "//[v7.Foo.Bar]/b/..a/#))", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "foo:/", "//%2e:13115/example.com\u{e9}", "t:foo://%2e:13115/example.com\u{e9} ;; t:foo://%2e:13115/example.com\u{e9}",
    ),
  )
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "HTTP:/=/`Z/&@", "-"))
  out.push(("foo:/..", "//[1112345abcd01.2.3.4", "-"))
  out.push(("a://host/a/", "//[.1.2.3255.255.255.255abcd00000%abcdff]", "-"))
  out.push(
    (
      "http:/.%2e/a/..//", "%F0%90%8D%88127.0.0.1", "t:http:/.//%F0%90%8D%88127.0.0.1 ;; E:underflow",
    ),
  )
  out.push(("http://\u{4f8b}\u{3048}.jp/a/b", "foo:/]/(/+{??%C2%A2\\", "-"))
  out.push(
    ("foo:bar/..", "/.//.../a/%2e/%2E./%2e", "E:opaque_base ;; E:opaque_base"),
  )
  out.push(
    ("foo:/..", "%E0%A4%B9*Z%7e", "t:foo:/%E0%A4%B9*Z%7e ;; E:underflow"),
  )
  out.push(("foo:bar", "=#\u{e000}%F4%90%80%80b", "-"))
  out.push(("http://a/b/c/d;p?q", "%E0%A4%B9127.0.0.1:%E2%82;", "-"))
  out.push(("foo:/..", "HTTP://%BF%2EZ@[1zvff]//", "-"))
  out.push(("a:", "a%a)", "-"))
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "//%F0%9F%98b?(?#", "t:http://%F0%9F%98b?(?# ;; t:http://%F0%9F%98b?(?#",
    ),
  )
  out.push(("a://host/b/./..a/.../%2e%2E/%2E", "//::1857//\"", "-"))
  out.push(("a://host/%2E/%2E./..", "%20%2F/%^=", "-"))
  out.push(("foo:/bar/baz/.%2E/", "HTTP://@[::1]:/%F4%90%80%80\"//", "-"))
  out.push(("a:/./b/", "foo:/#//?A >", "-"))
  out.push(("http:/a/...", "a://}::1/~", "-"))
  out.push(
    (
      "foo://host", "%F0%90%8C%80%41%C1%81", "t:foo://host/%F0%90%8C%80%41%C1%81 ;; t:foo://host/%F0%90%8C%80%41%C1%81",
    ),
  )
  out.push(
    (
      "a:/b/%2E./..././..a/..a/..a", "", "t:a:/.../..a/..a/..a ;; t:a:/.../..a/..a/..a",
    ),
  )
  out.push(
    (
      "foo:/bar/baz/.%2E/", "127.0.0.1(%E2%82", "t:foo:/bar/127.0.0.1(%E2%82 ;; t:foo:/bar/127.0.0.1(%E2%82",
    ),
  )
  out.push(
    ("http://example.com/#title1", "127.0.0.1%FF\u{e000}{%F0%90%8C%80", "-"),
  )
  out.push(("foo:/", "a\u{e9}\\", "-"))
  out.push(("a:", "foo:", "t:foo: ;; t:foo:"))
  out.push(
    (
      "http:/.../../a/%2E/b/%2e%2E/..", "/%2E./a/%2E/b//...", "t:http:/a/b//... ;; E:underflow",
    ),
  )
  out.push(("foo:/", "//%2E.", "t:foo://%2E. ;; t:foo://%2E."))
  out.push(("foo://a/..a/b", "foo://[z:ff1.2.3ff11.2.3a1]:16676#9{%FF", "-"))
  out.push(
    (
      "foo:/..", "a://\u{4f8b}@%C1%81/9%BF/", "t:a://\u{4f8b}@%C1%81/9%BF/ ;; t:a://\u{4f8b}@%C1%81/9%BF/",
    ),
  )
  out.push(("foo://host", "//[ffff:ff01.2.3.4:z:FFFFa]", "-"))
  out.push(("http://example.com/#title1", ")::1[::1]", "-"))
  out.push(
    ("a://b", "/..a/b/..a/.././%2e/%2e", "t:a://b/..a/b/ ;; t:a://b/..a/b/"),
  )
  out.push(("foo:/..", "//[v.^]", "-"))
  out.push(
    ("foo:/.%2e/b/..", "http://#a%FF_", "t:http://#a%FF_ ;; t:http://#a%FF_"),
  )
  out.push(("http://host/a/.../%2e%2E/a/a/%2E.", "//[v:192.0.2.1ffff]", "-"))
  out.push(
    ("foo:/", "/#_\u{10300}", "t:foo:/#_\u{10300} ;; t:foo:/#_\u{10300}"),
  )
  out.push(
    (
      "foo:bar/..", "http:/a/.../.../%2E/./.%2e", "t:http:/a/.../ ;; t:http:/a/.../",
    ),
  )
  out.push(
    ("http:/a/%2E//%2e/...", "/%C2%A2/", "t:http:/%C2%A2/ ;; t:http:/%C2%A2/"),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "/../a", "t:http://\u{4f8b}\u{3048}.jp/a ;; E:underflow",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "//[0:0:0:0:0:ffff:192.0.2.1]:/./.%2e/%2e%2E/a#0[", "-",
    ),
  )
  out.push(("http:/..a/.%2e/%2e%2E/.%2e/%2E./%2e", "/|%F0%90%8C%80?%41*", "-"))
  out.push(("foo:/..a", "/%E2%82/%20%a", "-"))
  out.push(
    ("foo://host/..././%2e%2E/a/%2E/./...", "foo://[abcdabcd:]/:a/./\\", "-"),
  )
  out.push(("a://host/%2E/%2e", "`%F0%90%8D%88%F4%90%80%80;%BF`", "-"))
  out.push(("foo:/", "//[FFFFffff0FFFFz]", "-"))
  out.push(
    (
      "foo://host/.%2e", "a:/~.#%F0%90%8D%88", "t:a:/~.#%F0%90%8D%88 ;; t:a:/~.#%F0%90%8D%88",
    ),
  )
  out.push(("foo://host//..a/b//./b", "%a%2E%2F\u{10300}{", "-"))
  out.push(("http:", "..%2F'z#%F0%82%82%AC", "E:opaque_base ;; E:opaque_base"))
  out.push(("foo:bar", "{&(%2E%2F$", "-"))
  out.push(("a://b", "//[::z]", "-"))
  out.push(("foo:/", "//[v.01.2.3.4abcd::]", "-"))
  out.push(
    (
      "http://example.com/#title1", "HTTP://[v7.Foo.Bar]/../b/./%2E/%2e/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(("a://b", "foo://%zz/,", "-"))
  out.push(("a://host/..a//%2E/", "a:/", "t:a:/ ;; t:a:/"))
  out.push(
    (
      "http://host/%2E/%2e/%2E./../a/.", "//[v7.Foo.Bar]/.../../...//%2e/%2E/.%2e",
      "t:http://[v7.Foo.Bar]/.../ ;; t:http://[v7.Foo.Bar]/.../",
    ),
  )
  out.push(("a://b", "/./.%2e/%2E/.", "t:a://b/ ;; E:underflow"))
  out.push(
    (
      "foo:/bar/..", "%F0%90%8D%88", "t:foo:/%F0%90%8D%88 ;; t:foo:/%F0%90%8D%88",
    ),
  )
  out.push(("http://example.com/#title1", "%~:", "-"))
  out.push(
    (
      "foo:/bar/baz/.%2E/", "HTTP://[v7.Foo.Bar]//Z%F0%9F%98/v6?", "t:HTTP://[v7.Foo.Bar]//Z%F0%9F%98/v6? ;; t:HTTP://[v7.Foo.Bar]//Z%F0%9F%98/v6?",
    ),
  )
  out.push(("a://..a/..", "\u{e000}%E2%82%2FA%BF%2e", "-"))
  out.push(("foo:/bar/..", "z9+-.:/%2E.#", "t:z9+-.:/# ;; E:underflow"))
  out.push(("foo:/", "//[vF.[", "-"))
  out.push(
    (
      "foo:/b/%2E./.%2e/..//%2e%2E", "foo://@%C2%A2)//?+", "t:foo://@%C2%A2)//?+ ;; t:foo://@%C2%A2)//?+",
    ),
  )
  out.push(("foo:/..", "::1?%F0%9F%98~=*", "-"))
  out.push(("foo:/", "/b/%2E/a/%2E./.%2e/%2e%2E/%2e", "t:foo:/ ;; E:underflow"))
  out.push(
    (
      "foo://host/", "~\u{10300}%E0%80%80/%2F~", "t:foo://host/~\u{10300}%E0%80%80/%2F~ ;; t:foo://host/~\u{10300}%E0%80%80/%2F~",
    ),
  )
  out.push(("foo:bar/..", "<%2e0", "-"))
  out.push(("a://./%2e%2E/%2e/", "/%2E/..", "t:a://./ ;; E:underflow"))
  out.push(("http://host/a", "a:/%ED%A0%80%FF/?example.com#b[", "-"))
  out.push(("a:", "http:/a/%2e/b//%2E.", "t:http:/a/b/ ;; t:http:/a/b/"))
  out.push(("a:/%2E.//%2e%2E/%2E/.%2e/..", "/", "t:a:/ ;; t:a:/"))
  out.push(
    ("foo:/", "a:/%2E/../../..a/%2E/a?#(A", "t:a:/..a/a?#(A ;; E:underflow"),
  )
  out.push(
    (
      "foo://host/a/..a/.../%2e/%2e%2E", "HTTP://@[01.2.3.401.2.3.401.2.3.4azFFFFa192.0.2.1255.255.255.255]:80872//%F0%9F%98",
      "-",
    ),
  )
  out.push(
    (
      "a:/%2e%2E/././.", "z9+-.:,?;%F0%90%8D%88A", "t:z9+-.:,?;%F0%90%8D%88A ;; t:z9+-.:,?;%F0%90%8D%88A",
    ),
  )
  out.push(("a://host/%2e/%2E/...", "::11'::1*", "-"))
  out.push(("a:/%2E./%2e%2E/", "", "t:a:/ ;; E:underflow"))
  out.push(("http://example.com/#title1", "//[VF.]", "-"))
  out.push(("foo:/bar/..", "//..%2F%C0%80}/./../b/%2E?/[", "-"))
  out.push(("http://host", "a:/%E0%A0%BF#>a%a", "-"))
  out.push(
    ("foo:/", "!127.0.0.1Zb", "t:foo:/!127.0.0.1Zb ;; t:foo:/!127.0.0.1Zb"),
  )
  out.push(("foo:/bar/baz/.%2E/", "http://", "t:http:// ;; t:http://"))
  out.push(
    (
      "http://example.com/#title1", "z9+-.:/%2E/%2e%2E/a/%2E./%2e%2E/.%2e/", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(("a:", "http:", "t:http: ;; t:http:"))
  out.push(("foo:/bar/..", "foo://A@[0:0:0:0:0:ffff:192.0.2.1]//b?*a#[", "-"))
  out.push(("a:/./.../", "//[FFFF]", "-"))
  out.push(("foo:bar/..", "/$\u{10300}//\\", "-"))
  out.push(
    ("foo:/%2e%2E/%2E/%2e%2E/../", "//[FFFF:0000FFFF11234501.2.3.4z]", "-"),
  )
  out.push(("http://a/b/c/d;p?q", "#:*1`", "-"))
  out.push(
    (
      "foo://host/.%2e/%2e/%2E/.../%2E/../", "foo://[192.0.2.1:z.]/../127.0.0.1'",
      "-",
    ),
  )
  out.push(("http:/%2E.", "foo:#%E0%A4%B9%C2%A2^", "-"))
  out.push(("foo:bar", "", "t:foo:bar ;; t:foo:bar"))
  out.push(
    (
      "foo:/bar/..", "//[255.255.255.255%12345%0000::192.0.2.1255.255.255.25501.2.3.4",
      "-",
    ),
  )
  out.push(
    (
      "http://a/b/c/d;p?q", "/%2e%2E/..././..a/.%2e/..a/?%E0%A4%B9z%C0%80", "t:http://a/.../..a/?%E0%A4%B9z%C0%80 ;; E:underflow",
    ),
  )
  out.push(
    (
      "a:/%2E./../%2e%2E/.%2e//%2E.", "http://#@[v7.Foo.Bar]:?%E0%A0example.com..%2F",
      "-",
    ),
  )
  out.push(
    (
      "http://\u{4f8b}\u{3048}.jp/a/b", "http://[0:0:0:0:0:ffff:192.0.2.1]:/%2E#A%2E%2E",
      "t:http://[0:0:0:0:0:ffff:192.0.2.1]:/#A%2E%2E ;; t:http://[0:0:0:0:0:ffff:192.0.2.1]:/#A%2E%2E",
    ),
  )
  out.push(("foo:/bar/..", "http:", "t:http: ;; t:http:"))
  out.push(("a://b", "foo://\u{e9}:/.%2e", "t:foo://\u{e9}:/ ;; E:underflow"))
  out.push(
    (
      "http://example.com/#title1", "foo:/.%2e/%2e/b/%2e/%2E./?'$", "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(
    (
      "a://b", "//%C2%A2^%F0%90%8D%88@[0:0:0:0:0:ffff:192.0.2.1]//#%F4%90%80%80",
      "-",
    ),
  )
  out.push(("foo:/bar/..", "//[abcd0000ffff%zFFFF]", "-"))
  out.push(
    ("foo:bar", "http://[::1]/%F4%90%80%80|/..%2F%41/#%F0%9F%98%2F/", "-"),
  )
  out.push(
    ("foo://host//.%2e/", "z9+-.://[::01.2.3.4255.255.255.255]:/@^/1#%209", "-"),
  )
  out.push(("foo://host", "//:@\u{10300}%a:/|", "-"))
  out.push(
    ("http://example.com", "", "t:http://example.com ;; t:http://example.com"),
  )
  out.push(
    (
      "foo://host/%2E/a", "a://[::1]/..././%2E./%2E./.%2e/.%2e", "t:a://[::1]/ ;; E:underflow",
    ),
  )
  out.push(
    ("foo:", "a:/b/%2E./#..%ED%A0%80", "t:a:/#..%ED%A0%80 ;; t:a:/#..%ED%A0%80"),
  )
  out.push(("http://example.com", "//[101.2.3:255.255.255.2551abcd]", "-"))
  out.push(
    (
      "http://host/.%2e/%2e/%2e%2E/%2E.", "/?.", "t:http://host/?. ;; t:http://host/?.",
    ),
  )
  out.push(
    (
      "http://example.com/#title1", "//[0:0:0:0:0:ffff:192.0.2.1]//../..a/././b?%F0%9F%98",
      "E:base_fragment ;; E:base_fragment",
    ),
  )
  out.push(("http://example.com", "//127.0.0.1//`)?\u{10300}~+", "-"))
  out.push(
    (
      "http://host/%2E/.../../..a/.", "//;%FF@[0:0:0:0:0:ffff:192.0.2.1]///1", "t:http://;%FF@[0:0:0:0:0:ffff:192.0.2.1]///1 ;; t:http://;%FF@[0:0:0:0:0:ffff:192.0.2.1]///1",
    ),
  )
  out.push(("foo:/../%2e/b/..", "foo:/[::1]\u{e9}/", "-"))
  out.push(
    (
      "foo:/bar/..", "/,-/:/%C1%81#%F0%82%82%AC%C1%81(", "t:foo:/,-/:/%C1%81#%F0%82%82%AC%C1%81( ;; t:foo:/,-/:/%C1%81#%F0%82%82%AC%C1%81(",
    ),
  )
  out.push(("a://host/%2e%2E//%2E./%2e/%2e%2E/a", "//[a0123451]", "-"))
  out.push(("http://a/b/c/d;p?q", "/%2E/.%2e", "t:http://a/ ;; E:underflow"))
  out.push(("foo:bar", "(%E0%A0%E2%82..%2F/", "E:opaque_base ;; E:opaque_base"))
  out.push(("http://example.com", "//[1.::0000255.255.255.255]", "-"))
  out.push(("foo:/bar/baz/.%2E/", "", "t:foo:/bar/ ;; t:foo:/bar/"))
  out.push(("a://b", "//[1192.0.2.1vabcdzaFFFF12345z]", "-"))
  out.push(("http://host/...", "z9+-.://[::1]0/%2E#\"%F0%9F%98", "-"))
  out.push(
    (
      "a://host/%2e%2E/.%2e/..a/.../..", "http:////+/?#A", "t:http:////+/?#A ;; t:http:////+/?#A",
    ),
  )
  out.push(("http://example.com/#title1", "//[%]", "-"))
  out.push(("a://b", "%2EZ[%20=", "-"))
  out.push(("foo:/b", "[::1]Z\u{e000}%FF", "-"))
  out.push(
    ("http://example.com/#title1", "", "E:base_fragment ;; E:base_fragment"),
  )
  out.push(("a://host/%2E./%2e%2E/%2E./", "%2e%E0%A0[::1]\\1,", "-"))
  out.push(
    ("http://host/%2E./%2e%2E/./../%2E/.../", "a://##`%F4%90%80%80", "-"),
  )
}
