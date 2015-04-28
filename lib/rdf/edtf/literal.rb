require 'edtf'

module RDF::EDTF
  class Literal < RDF::Literal
    DATATYPE = RDF::URI('http://id.loc.gov/datatypes/edtf/EDTF')
    GRAMMAR = %r(.*)

    def initialize(value, options = {})
      value = EDTF.parse(value) || value
      @string = value.edtf if value.respond_to? :edtf
      super
    end
  end
end
