require 'spec_helper'

describe RDF::EDTF::Literal do
  it_behaves_like 'RDF::Literal',
                  EDTF.parse!('1076'),
                  'http://id.loc.gov/datatypes/edtf/EDTF'

  let(:date) { EDTF.parse('1076') }
  subject { described_class.new(EDTF.parse!('1076')) }

  describe '#initialize' do
    context 'with string' do
      let(:date) { '199u' }

      it 'casts object value to EDTF' do
        expect(described_class.new(date).object).to eq EDTF.parse(date)
      end

      it 'sets lexical value' do
        expect(described_class.new(date).value).to eq date
      end

      context 'as invalid edtf' do
        let(:date) { 'not a valid edtf date' }

        it 'retains original value as object' do
          expect(described_class.new(date).object).to eq date
        end

        it 'gives #to_s as lexical value' do
          expect(described_class.new(date).value).to eq date.to_s
        end
      end
    end

    it 'gives value if invalid edtf' do
      date = '19!!'
      expect(described_class.new(date).object).to eq date
    end
  end

  describe '#<=>' do
    it 'is less than succeding date' do
      expect(subject).to be < described_class.new(date.succ)
    end

    it 'is greater than than previous date' do
      expect(subject).to be > described_class.new(date.prev)
    end

    it 'is not equal to date of different precision' do
      day_date = date.clone
      day_date.precision = :day
      expect(subject).not_to eq described_class.new(day_date)
    end

    it 'is not equal to date of different approximation' do
      approx_date = date.clone
      approx_date.approximate!
      expect(subject).not_to eq described_class.new(approx_date)
    end
  end

  describe '#value' do
    it 'gives an edtf string representation' do
      expect(subject.value).to eq date.edtf
    end
  end
end

describe RDF::Literal do
  include_examples 'RDF::Literal lookup',
                   { RDF::EDTF::Literal::DATATYPE => RDF::EDTF::Literal }

  include_examples 'RDF::Literal canonicalization',
                   RDF::EDTF::Literal::DATATYPE,
                   {}

  include_examples 'RDF::Literal validation',
                   RDF::EDTF::Literal::DATATYPE,
                   # valid value examples taken from:
                   # http://www.loc.gov/standards/datetime/pre-submission.html
                   ['2001-02-03',
                    '2008-12',
                    '2008',
                    '-2008',
                    '0000',
                    '2001-02-03T09:30:01',
                    '2004-01-01T10:10:10Z',
                    '2004-01-01T10:10:10+05:00',
                    '1964/2008',
                    '2004-06/2006-08',
                    '2004-02-01/2005-02-08',
                    '2004-02-01/2005-02',
                    '2004-02-01/2005',
                    '2005/2006-02',
                    '1984?',
                    '2004-06?',
                    '2004-06-11?',
                    '1984~',
                    '1984?~',
                    '199u',
                    '19uu',
                    '1999-uu',
                    '1999-01-uu',
                    '1999-uu-uu',
                    '2004-06-01/unknown',
                    '2004-01-01/open',
                    '1984~/2004-06',
                    '1984/2004-06~',
                    '1984?/2004?~',
                    'y170000002',
                    'y-170000002',
                    '2001-21',
                    '2001-22',
                    '2001-23',
                    '2001-24',
                    '2004?-06-11',
                    '2004-06~-11',
                    '2004-(06)?-11',
                    '2004-06-(11)~',
                    '2004-(06)?~',
                    '2004-(06-11)?',
                    '2004?-06-(11)~',
                    '(2004-(06)~)?',
                    '2004?-(06)?~',
                    # in addition to being unsupproed by EDTF.parse, these
                    # appear to be disallowed by EDTF's BNF:
                    # '(2004)?-06-04~', # unsupported; EDTF.parse returns nil
                    # '(2011)-06-04~', # unsupported; EDTF.parse returns nil,
                    '2011-(06-04)~',
                    '2011-23~',
                    '156u-12-25',
                    '15uu-12-25',
                    '15uu-12-uu',
                    '1560-uu-25',
                    '[1667,1668,1670..1672]',
                    '[..1760-12-03]',
                    '[1760-12..]',
                    '[1760-01,1760-02,1760-12..]',
                    '[1667,1760-12]',
                    '{1667,1668,1670..1672}',
                    '{1960,1961-12}',
                    '196x',
                    '19xx',
                    '2004-06-(01)~/2004-06-(20)~',
                    '2004-06-uu/2004-07-03',
                    'y17e7',
                    'y-17e7',
                    'y17101e4p3', # unsupported; EDTF.parse returns nil
                    '2001-21^southernHemisphere'],
                   ['abc', '123', '1921-1', '100000', '1923-13', '192?',
                    '1924a', '1234-22abc', '1xxx']

  describe 'initializing with datatype' do
    subject { RDF::Literal(date, datatype: RDF::EDTF::Literal::DATATYPE) }

    context 'with edtf value' do
      let(:date) { EDTF.parse!('1076') }

      it 'sets date to object' do
        expect(subject.object).to eql date
      end
    end

    context 'with edtf value' do
      let(:date) { '1076' }

      it 'parses date to edtf' do
        expect(subject.object).to eq EDTF.parse(date)
      end
    end
  end
end
