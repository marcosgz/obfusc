require 'spec_helper'

RSpec.describe Obfusc::CLI do
  describe '.run' do
    let(:model) { described_class.new(args) }
    let(:config) { double }

    before do
      allow(Obfusc::Config).to receive(:new).and_return(config)
    end

    describe 'with setup' do
      let(:args) { ['setup', 'generate', '-v'] }

      specify do
        expect(Obfusc::SetupCommand).to receive(:call).with(config, 'generate')
        model.run
      end
    end

    describe 'with crypt' do
      let(:args) { ['crypt', 'copy', '-v'] }

      specify do
        expect(Obfusc::CryptCommand).to receive(:call).with(config, 'copy')
        model.run
      end
    end

    describe 'with decrypt' do
      let(:args) { ['decrypt', 'move', '-v'] }

      specify do
        expect(Obfusc::DecryptCommand).to receive(:call).with(config, 'move')
        model.run
      end
    end
  end

  describe '.options' do
    subject do
      described_class.new(args).tap do |model|
        model.send(:configure)
      end.instance_variable_get(:@options)
    end

    context 'with extension' do
      let(:args) { ['--extension', 'abc'] }

      it { is_expected.to eq(extension: 'abc') }
    end

    context 'with abbreviated extension' do
      let(:args) { ['-e', 'abc'] }

      it { is_expected.to eq(extension: 'abc') }
    end

    context 'with abreviated config file' do
      let(:args) { ['-c', '~/.obfusc'] }

      it { is_expected.to eq(config_path: '~/.obfusc') }
    end

    context 'with config file' do
      let(:args) { ['--config', '~/.obfusc'] }

      it { is_expected.to eq(config_path: '~/.obfusc') }
    end

    context 'with verbose' do
      let(:args) { ['--verbose'] }

      it { is_expected.to eq(verbose: true) }
    end

    context 'with no verbose' do
      let(:args) { ['--no-verbose'] }

      it { is_expected.to eq(verbose: false) }
    end

    context 'with abbreviated verbose' do
      let(:args) { ['-v'] }

      it { is_expected.to eq(verbose: true) }
    end
  end
end
