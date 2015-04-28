require 'spec_helper'

describe RDF::EDTF::Literal do
  let(:date) { EDTF.parse('1076') }

  subject { described_class.new(EDTF.parse!('1076')) }

  it { is_expected.to be_typed }

  it 'has correct datatype' do
    expect(subject.datatype).to eq 'http://id.loc.gov/datatypes/edtf/EDTF'
  end

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

  describe '#value' do
    it 'gives an edtf string representation' do
      expect(subject.value).to eq date.edtf
    end
  end
end

describe RDF::Literal do
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
