v0.1.0
------

- Initial release
- Implements BNF grammar as a `Regexp` at `RDF::EDTF::Literal::GRAMMAR`
- Supports EDTF level 0-2, with minor caveats:
  - Datetimes without a zone offset will be parsed and reserialized as UTC with
  `+00:00`. See: https://github.com/inukshuk/edtf-ruby/issues/14
  - Sets will be reserialized with spaces in their separators. See:
  https://github.com/inukshuk/edtf-ruby/issues/15
