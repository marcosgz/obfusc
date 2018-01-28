require 'spec_helper'

RSpec.describe Obfusc::SetupCommand do
  let(:config) { Obfusc::Config.new(config_path: '/tmp/.obfusc.cnf') }

  describe '.call' do
    let(:model) { double }

    before do
      expect(described_class).to receive(:new).with(config).and_return(model)
    end

    context 'with generate' do
      specify do
        expect(model).to receive(:generate)
        described_class.call(config, 'generate')
      end
    end

    context 'with show' do
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

  describe '.show' do
    let(:model) { described_class.new(config) }

    it { expect(model).to respond_to(:show) }

    it 'does not raise exception when file does not exist' do
      config.config_path = '/some/invalid/directory/for/the-file/.ofusc.cnf'

      expect { model.show }.not_to raise_exception
    end
  end

  describe '.generate' do
    let(:path) { '/tmp/.obfusc.cnf' }
    let(:model) { described_class.new(config) }

    it 'generates the /tmp/.obfusc.cnf file' do
      expect { model.generate }.not_to raise_exception
      expect(File.exist?(path)).to be true
      config = YAML.load_file(path)
      expect(config.keys).to match_array(%w[token secret])
    end

    it 'fails to create a file when specified an invalid directory' do
      config.config_path = '/some/invalid/directory/for/the-file/.ofusc.cnf'
      expect { model.generate }.to raise_exception(Errno::ENOENT)
      expect(File.exist?(config.config_path)).to be false
    end
  end

  describe '.tokenize protected method' do
    subject { model.send(:tokenize, hash) }

    let(:model) { described_class.new(config) }

    context 'with an empty hash' do
      let(:hash) { {} }

      specify do
        result = <<-YAML.gsub('        ', '')
        ---
        token: ''
        secret: ''
        YAML
        is_expected.to eq(result)
      end
    end

    context 'with a hash with multiple values' do
      let(:hash) { { 'a' => 'a', 'b' => 'b', ' ' => ' ' } }

      before do
        allow(model).to receive(:rand).and_return(1)
      end

      specify do
        result = <<-YAML.gsub('        ', '')
        ---
        token: 'ab '
        secret: 'ab '
        YAML
        is_expected.to eq(result)
      end
    end
  end
end
