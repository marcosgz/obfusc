require 'spec_helper'

RSpec.describe Obfusc::CLI do
  describe '.run' do
    pending 'with setup' do
    end

    pending 'with crypt' do
    end

    pending 'with decrypt' do
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
