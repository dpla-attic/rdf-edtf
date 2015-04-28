require 'rdf'

module RDF
  ##
  #
  # @example Initializing anEDTF literal with {RDF::Literal}
  #    RDF::Literal('107x', datatype: RDF::EDTF::Literal::DATATYPE)
  #
  #
  module EDTF
    autoload :Literal, 'rdf/edtf/literal'
  end
end
