// Trait methods kept callable as regular methods. Without these declarations
// the compiler only promotes them implicitly, which is deprecated.

///|
pub extend Ipv4Addr with Show::{to_string}

///|
pub extend Ipv6Addr with Show::{to_string}

///|
pub extend Uri with Show::{to_string}

///|
pub extend UriRef with Show::{to_string}

///|
pub extend Iri with Show::{to_string}

///|
pub extend IriRef with Show::{to_string}

///|
pub extend EStr with Show::{to_string}

///|
pub extend EString with Show::{to_string}

///|
pub extend Scheme with Show::{to_string}

///|
pub extend Host with Show::{to_string}

///|
pub extend Authority with Show::{to_string}
