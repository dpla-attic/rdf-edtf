require 'rdf'

module RDF
  ##
  # A module implementing Extended Date Time Format (EDTF) handling for
  # {RDF::Literal}.
  #
  # @example requiring RDF::EDTF
  #   require 'rdf/edtf'
  #
  # @example Initializing an EDTF literal with {RDF::Literal}
  #    RDF::Literal('107x', datatype: RDF::EDTF::Literal::DATATYPE)
  #
  # @see RDF::Literal
  # @see http://www.loc.gov/standards/datetime/pre-submission.html the EDTF
  #    Specification
  # @see http://id.loc.gov/datatypes/edtf.html
  module EDTF
    autoload :Literal, 'rdf/edtf/literal'
  end
end
