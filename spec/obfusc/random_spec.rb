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
end
