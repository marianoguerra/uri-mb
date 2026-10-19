///|
/// Percent-encoders for URI/IRI components.
///
/// An encoder is a zero-sized marker type used as the type parameter of
/// [`EStr`] and [`EString`]. It carries the [`Table`] that specifies which
/// byte patterns the string may contain.
///
/// A *sub-encoder* `Sub` of `E` is an encoder whose table is a
/// [subset](Table::is_subset) of `E`'s.
pub trait Encoder {
  /// The table used for encoding.
  fn table() -> Table
}

///|
/// An encoder for URI userinfo.
pub enum Userinfo {}

///|
pub impl Encoder for Userinfo with fn table() {
  table_userinfo
}

///|
/// An encoder for IRI userinfo.
pub enum IUserinfo {}

///|
pub impl Encoder for IUserinfo with fn table() {
  table_iuserinfo
}

///|
/// An encoder for URI registered name.
pub enum RegName {}

///|
pub impl Encoder for RegName with fn table() {
  table_reg_name
}

///|
/// An encoder for IRI registered name.
pub enum IRegName {}

///|
pub impl Encoder for IRegName with fn table() {
  table_ireg_name
}

///|
/// An encoder for URI/IRI port.
pub enum Port {}

///|
pub impl Encoder for Port with fn table() {
  table_digit
}

///|
/// An encoder for a path component, for which `EStr` has extension methods.
pub trait PathEncoder: Encoder {}

///|
/// An encoder for URI path.
pub enum Path {}

///|
pub impl Encoder for Path with fn table() {
  table_path
}

///|
/// An encoder for IRI path.
pub enum IPath {}

///|
pub impl Encoder for IPath with fn table() {
  table_ipath
}

///|
pub impl PathEncoder for Path

///|
pub impl PathEncoder for IPath

///|
/// An encoder for URI query.
pub enum Query {}

///|
pub impl Encoder for Query with fn table() {
  table_query
}

///|
/// An encoder for IRI query.
pub enum IQuery {}

///|
pub impl Encoder for IQuery with fn table() {
  table_iquery
}

///|
/// An encoder for URI fragment.
pub enum Fragment {}

///|
pub impl Encoder for Fragment with fn table() {
  table_fragment
}

///|
/// An encoder for IRI fragment.
pub enum IFragment {}

///|
pub impl Encoder for IFragment with fn table() {
  table_ifragment
}

///|
/// An encoder for URI data which preserves only [unreserved] characters
/// and encodes the others.
///
/// [unreserved]: https://datatracker.ietf.org/doc/html/rfc3986#section-2.3
pub enum Data {}

///|
pub let table_data : Table = table_unreserved.or_pct_encoded()

///|
pub impl Encoder for Data with fn table() {
  table_data
}

///|
/// An encoder for IRI data which preserves only [unreserved] characters
/// and encodes the others.
///
/// [unreserved]: https://datatracker.ietf.org/doc/html/rfc3987#section-2.1
pub enum IData {}

///|
pub let table_idata : Table = table_unreserved.or_pct_encoded().or_ucschar()

///|
pub impl Encoder for IData with fn table() {
  table_idata
}

///|
pub extend Userinfo with Encoder::{table}

///|
pub extend IUserinfo with Encoder::{table}

///|
pub extend RegName with Encoder::{table}

///|
pub extend IRegName with Encoder::{table}

///|
pub extend Port with Encoder::{table}

///|
pub extend Path with Encoder::{table}

///|
pub extend IPath with Encoder::{table}

///|
pub extend Query with Encoder::{table}

///|
pub extend IQuery with Encoder::{table}

///|
pub extend Fragment with Encoder::{table}

///|
pub extend IFragment with Encoder::{table}

///|
pub extend Data with Encoder::{table}

///|
pub extend IData with Encoder::{table}
