require 'spec_helper'

RSpec.describe Obfusc::ShowCommand do
  let(:config) { Obfusc::Config.new(config_path: 'spec/fixtures/obfusc.cnf') }

  describe '.run' do
    subject { model.run }

    let(:model) { described_class.new(config, source) }

    context 'with a directory without any obfuscated file' do
      let(:source) { 'spec/fixtures/files/home' }

      specify do
        expect(model).not_to receive(:puts)
        subject
      end
    end

    context 'with a obfuscated file path' do
      let(:source) { 'spec/fixtures/files/obfuscated/obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___9QMMUHMYLL.FBF.obfusc' }

      specify do
        expect(model).to receive(:puts).with("#{source}:")
        expect(model).to receive(:puts).with('---> spec/fixtures/files/home/marcos/zimmermann.txt')
        subject
      end
    end
  end

  describe '.call' do
    let(:model) { double }

    before do
      expect(described_class).to \
        receive(:new).with(config, source).and_return(model)
    end

    context 'with a invalid directory' do
      let(:source) { '/missing/directory' }

      specify do
        expect(model).to receive(:show_usage)
        described_class.call(config, source)
      end
    end

    context 'with a invalid directory' do
      let(:source) { 'spec/fixtures/files/obfuscated' }

      specify do
        expect(model).to receive(:run)
        described_class.call(config, source)
      end
    end
  end
end
