RSpec.describe Obfusc::Config do
  let(:options) { {} }
  let(:config) { described_class.new(options) }

  describe '.config_path' do
    it { expect(config).to respond_to(:"config_path=") }

    context 'with defaults' do
      before(:each) do
        allow(ENV).to receive(:[]).with('HOME').and_return('/home/user')
      end

      it { expect(config.config_path).to eq('/home/user/.obfusc.cnf') }
    end

    context 'with value from initialization' do
      let(:options) { { config_path: '~user/.obfusc.cnf' } }

      it { expect(config.config_path).to eq('~user/.obfusc.cnf') }
    end
  end

  describe '.extension' do
    it { expect(config).to respond_to(:"extension=") }

    context 'with defaults' do
      it { expect(config.extension).to eq('obfusc') }
    end

    context 'with value from initialization' do
      let(:options) { { extension: 'foo' } }

      it { expect(config.extension).to eq('foo') }
    end
  end

  describe '.verbose' do
    it { expect(config).to respond_to(:"verbose=") }

    context 'with defaults' do
      it { expect(config.verbose).to eq(false) }
    end

    context 'with value from initialization' do
      let(:options) { { verbose: true } }

      it { expect(config.verbose).to eq(true) }
    end
  end
end
