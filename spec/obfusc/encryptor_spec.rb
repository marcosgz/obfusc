require 'spec_helper'

RSpec.describe Obfusc::Encryptor do
  let(:config) { Obfusc::Config.new({}) }
  let :secret do
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -_,(){}|'
  end
  let :token do
    '|}{)(,_- zyxwvutsrqponmlkjihgfedcbaZYXWVUTSRQPONMLKJIHGFEDCBA9876543210'
  end

  before do
    allow(config).to receive(:secret).and_return(secret)
    allow(config).to receive(:token).and_return(token)
  end

  describe '.encrypted?' do
    let(:model) { described_class.new(config) }

    it { expect(model.obfuscated?('obfusc__foo.obfusc')).to be true }
    it { expect(model.obfuscated?('ofusc__foo.ofusc')).to be false }
    it { expect(model.obfuscated?(nil)).to be false }

    context 'with a custom file extension' do
      before { config.extension = 'foo' }

      it { expect(model.obfuscated?('obfusc__foo.foo')).to be true }
      it { expect(model.obfuscated?('obfusc__foo.obfusc')).to be false }
    end

    context 'with a custom file prefix' do
      before { config.prefix = 'foo' }

      it { expect(model.obfuscated?('foo__xyz123.obfusc')).to be true }
      it { expect(model.obfuscated?('obfusc__xyz123.obfusc')).to be false }
    end
  end

  describe '.encrypt' do
    let(:model) { described_class.new(config) }

    it 'replaces all mapped characters from token to secret' do
      expect(model.encrypt(secret)).to eq("obfusc__#{token}.obfusc")
    end

    it 'keep untouched unmapping characters' do
      expect(model.encrypt('MARCOS@["]zimmermann')).to \
        eq('obfusc__myhwkg@["]9QMMUHMYLL.obfusc')
    end

    it 'replace separators by an especial key' do
      expect(model.encrypt('path/to2/dir')).to \
        eq('obfusc__JYFR___|___FK{___|___VQH.obfusc')
    end

    it 'ignores already encrypted file' do
      expect(model.encrypt('obfusc__JYFR___|___FK{___|___VQH.obfusc')).to \
        eq('obfusc__JYFR___|___FK{___|___VQH.obfusc')
    end

    it 'expands existing and encrypted files' do
      encrypted = model.encrypt('already/encrypted')
      expect(encrypted).to eq('obfusc__YNHUYVA___|___ULWHAJFUV.obfusc')
      dir = model.encrypt('dir')
      expect(dir).to eq('obfusc__VQH.obfusc')
      recrypt = model.encrypt("dir/#{encrypted}")
      expect(recrypt).to eq('obfusc__VQH___|___YNHUYVA___|___ULWHAJFUV.obfusc')
    end
  end

  describe '.decrypt' do
    let(:model) { described_class.new(config) }

    it 'replaces all mapped characters from token to secret' do
      expect(model.decrypt("obfusc__#{token}.obfusc")).to eq(secret)
    end

    it 'keep untouched unmapping characters' do
      expect(model.decrypt('obfusc__myhwkg@["]9QMMUHMYLL.obfusc')).to \
        eq('MARCOS@["]zimmermann')
    end

    it 'replace separators by an especial key' do
      expect(model.decrypt('obfusc__JYFR___|___FK{___|___VQH.obfusc')).to \
        eq('path/to2/dir')
    end

    it 'ignores directories before encrypted file' do
      encrypted = 'obfusc__YNHUYVA___|___ULWHAJFUV.obfusc'
      decrypted = model.decrypt("directory/before/#{encrypted}")
      expect(decrypted).to eq('directory/before/already/encrypted')
    end

    it 'ignores directoires that does not match with obfuscation pattern' do
      encrypted = 'bfusc__YNHUYVA___|___ULWHAJFUV.obfus'
      decrypted = model.decrypt(encrypted)
      expect(decrypted).to eq(encrypted)
    end
  end

  describe '.charlist' do
    subject { described_class.new(config).send(:charlist) }

    let(:secret) { '12345 6789' }
    let(:token) { '9876 54321' }
    let :result do
      {
        '1' => '9',
        '2' => '8',
        '3' => '7',
        '4' => '6',
        ' ' => '5',
        '5' => ' ',
        '6' => '4',
        '7' => '3',
        '8' => '2',
        '9' => '1'
      }
    end

    it { is_expected.to eq(result) }
  end
end
