RSpec.describe Obfusc::Random do
  describe '.generate!' do
    subject { described_class.generate! }

    it { is_expected.to be_a_kind_of(Hash) }

    it 'does not include same key in the hash value' do
      subject.each do |key, value|
        expect(key).not_to eq(value)
      end
    end
  end

  describe '.randonize!' do
    subject { Obfusc::Random.send(:randonize!, memo, collection) }

    let(:memo) { {} }

    context 'with an empty array' do
      let(:collection) { [] }

      it { is_expected.to eq({}) }
    end

    context 'with only one entry' do
      let(:collection) { [:a] }

      it { is_expected.to eq(a: :a) }
    end

    context 'with two or more entries' do
      let(:collection) { %i[a b] }

      it { is_expected.to eq(a: :b, b: :a) }
    end
  end
end
