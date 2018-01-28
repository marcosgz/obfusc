require 'spec_helper'

RSpec.describe Obfusc::CryptCommand do
  describe '.call' do
    let(:model) { double }

    before do
      expect(described_class).to receive(:new).with(config).and_return(model)
    end

    context 'with copy' do
      specify do
        expect(model).to receive(:generate)
        described_class.call(config, 'generate')
      end
    end

    context 'with move' do
      specify do
        expect(model).to receive(:show)
        described_class.call(config, 'show')
      end
    end

    context 'with invalid command' do
      specify do
        expect(model).to receive(:show_usage)
        described_class.call(config, 'other')
      end
    end
  end
end
