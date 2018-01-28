require 'spec_helper'

RSpec.describe Obfusc::Config do
  let(:options) { {} }
  let(:model) { described_class.new(options) }

  describe '.encryptor' do
    subject { model.encryptor }

    it { is_expected.to be_an_instance_of(Obfusc::Encryptor) }
  end

  describe '.secret' do
    subject { model.secret }

    it 'returns secret from local .obfusc.cnf file' do
      model.instance_variable_set(:@settings, 'secret' => 'bar')
      is_expected.to eq('bar')
    end
  end

  describe '.token' do
    subject { model.token }

    it 'returns token from local .obfusc.cnf file' do
      model.instance_variable_set(:@settings, 'token' => 'foo')
      is_expected.to eq('foo')
    end
  end

  describe '.dry_run' do
    specify do
      expect { model.dry_run }.not_to raise_exception
    end

    specify do
      model.simulate = false
      expect { |b| model.dry_run(&b) }.to yield_control
    end

    specify do
      model.simulate = true
      expect { |b| model.dry_run(&b) }.not_to yield_control
    end
  end

  describe '.config_path' do
    it { expect(model).to respond_to(:"config_path=") }

    context 'with defaults' do
      before(:each) do
        allow(ENV).to receive(:[]).with('HOME').and_return('/home/user')
      end

      it { expect(model.config_path).to eq('/home/user/.obfusc.cnf') }
    end

    context 'with value from initialization' do
      let(:options) { { config_path: '~user/.obfusc.cnf' } }

      it { expect(model.config_path).to eq('~user/.obfusc.cnf') }
    end
  end

  describe '.extension' do
    it { expect(model).to respond_to(:"extension=") }

    context 'with defaults' do
      it { expect(model.extension).to eq('obfusc') }
    end

    context 'with value from initialization' do
      let(:options) { { extension: 'foo' } }

      it { expect(model.extension).to eq('foo') }
    end
  end

  describe '.simulate' do
    it { expect(model).to respond_to(:"simulate=") }

    context 'with defaults' do
      it { expect(model.simulate).to eq(false) }
    end

    context 'with value from initialization' do
      let(:options) { { simulate: true } }

      it { expect(model.simulate).to eq(true) }
      it { expect(model).to be_simulate }
    end
  end

  describe '.verbose' do
    it { expect(model).to respond_to(:"verbose=") }

    context 'with defaults' do
      it { expect(model.verbose).to eq(false) }
    end

    context 'with value from initialization' do
      let(:options) { { verbose: true } }

      it { expect(model.verbose).to eq(true) }
      it { expect(model).to be_verbose }
    end
  end
end
