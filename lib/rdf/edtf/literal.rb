require 'edtf'

module RDF::EDTF
  ##
  # An EDTF Date literal
  #
  # @example Initializing an EDTF literal with {RDF::Literal}
  #    RDF::Literal('107x', datatype: RDF::EDTF::Literal::DATATYPE)
  #
  class Literal < RDF::Literal
    DATATYPE = RDF::URI('http://id.loc.gov/datatypes/edtf/EDTF')

    YEAR = %r(-*[0-9]{4}).freeze
    ONETHRU12 = %r((01|02|03|04|05|06|07|08|09|10|11|12)).freeze
    ONETHRU13 = Regexp.union(ONETHRU12, /13/).freeze
    ONETHRU23 = Regexp.union(ONETHRU13, %r((14|15|16|17|18|19|20|21|22|23)))
                .freeze
    ZEROTHRU23 =  Regexp.union(/00/, ONETHRU23).freeze
    ONETHRU29 = Regexp.union(ONETHRU23, %r((24|25|26|27|28|29))).freeze
    ONETHRU30 = Regexp.union(ONETHRU29, /30/).freeze
    ONETHRU31 = Regexp.union(ONETHRU30, /31/).freeze

    ONETHRU59 = Regexp.union(ONETHRU31,
                             %r((32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59)))
                .freeze
    ZEROTHRU59 =  Regexp.union(/00/, ONETHRU59).freeze

    POSITIVEDIGIT = %r((1|2|3|4|5|6|7|8|9)).freeze
    DIGIT = Regexp.union(POSITIVEDIGIT, /0/).freeze

    DAY = ONETHRU31
    MONTH = ONETHRU12
    MONTHDAY = %r(((01|03|05|07|08|10|12)-#{ONETHRU31})|((04|06|09|11)\-#{ONETHRU30})|(02\-#{ONETHRU29}))
               .freeze
    YEARMONTH = %r(#{YEAR}\-#{MONTH}).freeze
    YEARMONTHDAY = %r(#{YEAR}\-#{MONTHDAY}).freeze
    HOUR = ZEROTHRU23
    MINUTE = ZEROTHRU59
    SECOND = ZEROTHRU59

    POSITIVEYEAR = %r((#{POSITIVEDIGIT}#{DIGIT}#{DIGIT}#{DIGIT})|(#{DIGIT}#{POSITIVEDIGIT}#{DIGIT}#{DIGIT})|(#{DIGIT}#{DIGIT}#{POSITIVEDIGIT}#{DIGIT})|(#{DIGIT}#{DIGIT}#{DIGIT}#{POSITIVEDIGIT})).freeze
    NEGATIVEYEAR = %r(\-#{POSITIVEYEAR}).freeze
    YYEAR = %r((#{POSITIVEYEAR}|#{NEGATIVEYEAR}|0000)).freeze
    DATE = %r((#{YYEAR}|#{YEARMONTH}|#{YEARMONTHDAY})).freeze

    BASETIME = %r((#{HOUR}\:#{MINUTE}\:#{SECOND}|(24\:00\:00))).freeze
    # Zone offset is specified loosely, due to the issue documented here:
    #   https://github.com/inukshuk/edtf-ruby/issues/14
    # The correct specification is:
    # ZONEOFFSET = %r(Z|((\+|\-))(#{ONETHRU13}((\:#{MINUTE})|$)|14\:00|00\:#{ONETHRU59})).freeze
    ZONEOFFSET = %r(Z|((\+|\-))(#{ONETHRU13}((\:#{MINUTE})|$)|14\:00|00\:#{MINUTE})).freeze
    TIME = %r(#{BASETIME}(#{ZONEOFFSET}|$)).freeze
    DATEANDTIME = %r(#{DATE}T#{TIME}).freeze

    L0INTERVAL = %r(#{DATE}\/#{DATE}).freeze

    LEVEL0EXPRESSION = Regexp.union(/^#{DATE}$/, /^#{DATEANDTIME}/, /^#{L0INTERVAL}$/).freeze

    UASYMBOL = %r((\?|\~|\?\~)).freeze
    SEASONNUMBER = %r((21|22|23|24)).freeze
    SEASON = %r(#{YYEAR}\-#{SEASONNUMBER}).freeze
    DATEORSEASON = %r((#{DATE}|#{SEASON})).freeze

    UNCERTAINORAPPROXDATE = %r(#{DATE}#{UASYMBOL}).freeze
    YEARWITHONEORTWOUNSPECIFEDDIGITS = %r(#{DIGIT}#{DIGIT}(#{DIGIT}|u)u).freeze
    MONTHUNSPECIFIED = %r(#{YEAR}\-uu).freeze
    DAYUNSPECIFIED = %r(#{YEARMONTH}\-uu).freeze
    DAYANDMONTHUNSPECIFIED = %r(#{YEAR}\-uu\-uu).freeze
    UNSPECIFIED = Regexp.union(YEARWITHONEORTWOUNSPECIFEDDIGITS,
                               MONTHUNSPECIFIED,
                               DAYUNSPECIFIED,
                               DAYANDMONTHUNSPECIFIED).freeze

    L1START = %r((#{DATEORSEASON}(#{UASYMBOL})*)|unknown).freeze
    L1END   = %r((#{L1START}|open)).freeze

    L1INTERVAL = %r(#{L1START}\/#{L1END}).freeze

    LONGYEARSIMPLE = %r(y\-?#{POSITIVEDIGIT}#{DIGIT}#{DIGIT}#{DIGIT}#{DIGIT}+).freeze

    LEVEL1EXPRESSION = %r(^(#{UNCERTAINORAPPROXDATE}|#{UNSPECIFIED}|#{L1INTERVAL}|#{LONGYEARSIMPLE}|#{SEASON})$).freeze

    IUABASE = %r((#{YEAR}#{UASYMBOL}\-#{MONTH}(\-\(#{DAY}\)#{UASYMBOL})?|#{YEAR}#{UASYMBOL}\-#{MONTHDAY}#{UASYMBOL}?|#{YEAR}#{UASYMBOL}?\-\(#{MONTH}\)#{UASYMBOL}(\-\(#{DAY}\)#{UASYMBOL})?|#{YEAR}#{UASYMBOL}?\-\(#{MONTH}\)#{UASYMBOL}(\-#{DAY})?|#{YEARMONTH}#{UASYMBOL}\-\(#{DAY}\)#{UASYMBOL}|#{YEARMONTH}#{UASYMBOL}\-#{DAY}|#{YEARMONTH}\-\(#{DAY}\)#{UASYMBOL}|#{YEAR}\-\(#{MONTHDAY}\)#{UASYMBOL}|#{SEASON}#{UASYMBOL})).freeze

    INTERNALUNCERTAINORAPPROXIMATE = %r(#{IUABASE}|\(#{IUABASE}\)#{UASYMBOL}).freeze

    POSITIVEDIGITORU = %r(#{POSITIVEDIGIT}|u).freeze
    DIGITORU = %r(#{POSITIVEDIGITORU}|0).freeze
    ONETHRU3 = %r(1|2|3).freeze

    YEARWITHU = %r(u#{DIGITORU}#{DIGITORU}#{DIGITORU}|#{DIGITORU}u#{DIGITORU}#{DIGITORU}|#{DIGITORU}#{DIGITORU}u#{DIGITORU}|#{DIGITORU}#{DIGITORU}#{DIGITORU}u)
    DAYWITHU = %r(#{ONETHRU31}|u#{DIGITORU}|#{ONETHRU3}u)
    MONTHWITHU = %r(#{ONETHRU12}|0u|1u|(u#{DIGITORU})).freeze

    # these allow days out of range for the month given (e.g. 2013-02-31)
    # is this a bug in the EDTF BNF?
    YEARMONTHWITHU = %r((#{YEAR}|#{YEARWITHU})\-#{MONTHWITHU}|#{YEARWITHU}\-#{MONTH}).freeze
    MONTHDAYWITHU = %r((#{MONTH}|#{MONTHWITHU})\-#{DAYWITHU}|#{MONTHWITHU}\-#{DAY}).freeze
    YEARMONTHDAYWITHU = %r((#{YEARWITHU}|#{YEAR})\-#{MONTHDAYWITHU}|#{YEARWITHU}\-#{MONTHDAY}).freeze

    INTERNALUNSPECIFIED = Regexp.union(YEARWITHU, YEARMONTHWITHU, YEARMONTHDAYWITHU).freeze

    DATEWITHINTERNALUNCERTAINTY = Regexp.union(INTERNALUNCERTAINORAPPROXIMATE, INTERNALUNSPECIFIED).freeze

    EARLIER = %r(\.\.#{DATE}).freeze
    LATER = %r(#{DATE}\.\.).freeze
    CONSECUTIVES = %r(#{YEARMONTHDAY}\.\.#{YEARMONTHDAY}|#{YEARMONTH}\.\.#{YEARMONTH}|#{YEAR}\.\.#{YEAR}).freeze

    LISTELEMENT = %r(#{DATE}|#{DATEWITHINTERNALUNCERTAINTY}|#{UNCERTAINORAPPROXDATE}|#{UNSPECIFIED}|#{CONSECUTIVES}).freeze
    # list contents are specified here to allow spaces:
    #  e.g. [1995, 1996, 1997]
    # this is not allowed in the specification's grammar
    # see: https://github.com/inukshuk/edtf-ruby/issues/15
    LISTCONTENT = %r((#{EARLIER}(\,\s?#{LISTELEMENT})*|(#{EARLIER}\,\s?)?(#{LISTELEMENT}\,\s?)*#{LATER}|#{LISTELEMENT}(\,\s?#{LISTELEMENT})+|#{CONSECUTIVES})).freeze

    CHOICELIST = %r(\[#{LISTCONTENT}\]).freeze
    INCLUSIVELIST = %r(\{#{LISTCONTENT}\}).freeze

    MASKEDPRECISION = %r(#{DIGIT}#{DIGIT}((#{DIGIT}x)|xx)).freeze

    L2INTERVAL = %r((#{DATEORSEASON}\/#{DATEWITHINTERNALUNCERTAINTY})|(#{DATEWITHINTERNALUNCERTAINTY}\/#{DATEORSEASON})|(#{DATEWITHINTERNALUNCERTAINTY}\/#{DATEWITHINTERNALUNCERTAINTY})).freeze

    POSITIVEINTEGER = %r(#{POSITIVEDIGIT}#{DIGIT}*).freeze
    LONGYEARSCIENTIFIC = %r(y\-?#{POSITIVEINTEGER}e#{POSITIVEINTEGER}(p#{POSITIVEINTEGER})?).freeze

    QUALIFYINGSTRING = %r(\S+).freeze
    SEASONQUALIFIED = %r(#{SEASON}\^#{QUALIFYINGSTRING}).freeze

    LEVEL2EXPRESSION = %r(^(#{INTERNALUNCERTAINORAPPROXIMATE}|#{INTERNALUNSPECIFIED}|#{CHOICELIST}|#{INCLUSIVELIST}|#{MASKEDPRECISION}|#{L2INTERVAL}|#{LONGYEARSCIENTIFIC}|#{SEASONQUALIFIED})$).freeze

    ##
    # Grammar is articulated according to the BNF in the EDTF 1.0 pre-submission
    # specification, except where noted above.
    #
    # @todo investigate the allowance for out-of-range days (e.g. 2013-02-31) in
    #   `INTERNALUNSPECIFIED`
    # @todo follow up on zone offset `00:00`; disallow, if appropriate, once
    #   {https://github.com/inukshuk/edtf-ruby/issues/14} is closed
    # @todo disallow spaces in LISTCONTENT when
    #   {https://github.com/inukshuk/edtf-ruby/issues/15} is closed
    #
    # @see http://www.loc.gov/standards/datetime/pre-submission.html#bnf
    GRAMMAR = Regexp.union(LEVEL0EXPRESSION, LEVEL1EXPRESSION, LEVEL2EXPRESSION).freeze

    ##
    # Initializes an RDF::Literal with EDTF datatype.
    #
    # Casts lexical values with the correct datatype to EDTF, if they are
    # parsable. Otherwise retains their original value as an `#invalid?`
    # literal.
    #
    # @see RDF::Literal
    def initialize(value, options = {})
      value = EDTF.parse(value) || value
      @string = value.edtf if value.respond_to? :edtf
      super
    end
  end
end
