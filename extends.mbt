// Trait methods kept callable as regular methods. Without these declarations
// the compiler only promotes them implicitly, which is deprecated.

///|
pub extend Ipv4Addr with Show::{to_string}

///|
pub extend Ipv6Addr with Show::{to_string}
