RSpec.describe Obfusc::DecryptCommand do
  describe '.call' do
    specify do
      expect(described_class).to respond_to(:call)
    end
  end
end
