require 'spec_helper'

RSpec.describe Obfusc::CryptCommand do
  let(:config) { Obfusc::Config.new(config_path: 'spec/fixtures/obfusc.cnf') }

  describe '.copy' do
    subject { model.send(:copy) }

    let(:model) { described_class.new(config, from, to) }
    let(:to) { '/tmp' }

    context 'without a valid source path' do
      let(:from) { 'spec/fixtures/does-not-exist' }

      specify do
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).not_to receive(:mv)
        is_expected.to eq(0)
      end
    end

    context 'a valid source but missing target directory' do
      let(:from) { 'spec/fixtures/files/home/marcos/empty.gif' }
      let(:to) { '/tmp/obfusc' }

      before do
        FileUtils.rm_r(to) if File.exist?(to)
      end

      specify do
        expect(FileUtils).to receive(:mkdir_p).with('/tmp/obfusc')
        expect(FileUtils).not_to receive(:mv)
        expect(FileUtils).to receive(:cp).with(
          from,
          '/tmp/obfusc/obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___UMJFA.SQT.obfusc',
          verbose: false
        )
        is_expected.to eq(1)
      end

      specify do
        config.simulate = true
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).not_to receive(:mv)

        is_expected.to eq(1)
      end
    end

    context 'a valid source and valid target' do
      let(:from) { 'spec/fixtures/files/home/marcos/empty.gif' }
      let(:to) { 'tmp' }

      before do
        FileUtils.mkdir_p(to) unless File.exist?(to)
      end

      specify do
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:mv)
        expect(FileUtils).to receive(:cp).with(
          from,
          'tmp/obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___UMJFA.SQT.obfusc',
          verbose: false
        )
        is_expected.to eq(1)
      end

      specify do
        config.simulate = true
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).not_to receive(:mv)

        is_expected.to eq(1)
      end
    end
  end

  describe '.move' do
    subject { model.send(:move) }

    let(:model) { described_class.new(config, from, to) }
    let(:to) { '/tmp' }

    context 'without a valid source path' do
      let(:from) { 'spec/fixtures/does-not-exist' }

      specify do
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).not_to receive(:mv)
        is_expected.to eq(0)
      end
    end

    context 'a valid source but missing target directory' do
      let(:from) { 'spec/fixtures/files/home/marcos/empty.gif' }
      let(:to) { '/tmp/obfusc' }

      before do
        FileUtils.rm_r(to) if File.exist?(to)
      end

      specify do
        expect(FileUtils).to receive(:mkdir_p).with('/tmp/obfusc')
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).to receive(:mv).with(
          from,
          '/tmp/obfusc/obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___UMJFA.SQT.obfusc',
          verbose: false
        )
        is_expected.to eq(1)
      end

      specify do
        config.simulate = true
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).not_to receive(:mv)

        is_expected.to eq(1)
      end
    end

    context 'a valid source and valid target' do
      let(:from) { 'spec/fixtures/files/home/marcos/empty.gif' }
      let(:to) { 'tmp' }

      before do
        FileUtils.mkdir_p(to) unless File.exist?(to)
      end

      specify do
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).to receive(:mv).with(
          from,
          'tmp/obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___UMJFA.SQT.obfusc',
          verbose: false
        )
        is_expected.to eq(1)
      end

      specify do
        config.simulate = true
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(FileUtils).not_to receive(:cp)
        expect(FileUtils).not_to receive(:mv)

        is_expected.to eq(1)
      end
    end
  end

  describe '.files' do
    subject { model.send(:files) }

    let(:model) { described_class.new(config, from, to) }
    let(:to) { nil }

    context 'with invalid directory' do
      let(:from) { 'spec/fixtures/does-not-exist' }

      specify do
        is_expected.to eq({})
      end
    end

    context 'with relative directory' do
      let(:from) { 'spec/fixtures/files/home' }

      specify do
        is_expected.to eq(
          'spec/fixtures/files/home/marcos/.hidden.txt'     => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___.RQVVUL.FBF.obfusc',
          'spec/fixtures/files/home/marcos/empty.gif'       => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___UMJFA.SQT.obfusc',
          'spec/fixtures/files/home/marcos/empty.gif.zip'   => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___UMJFA.SQT.9QJ.obfusc',
          'spec/fixtures/files/home/marcos/empty.tiff'      => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___UMJFA.FQTT.obfusc',
          'spec/fixtures/files/home/marcos/zimmermann.txt'  => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___9QMMUHMYLL.FBF.obfusc',
          'spec/fixtures/files/home/matheus/sample_pdf.pdf' => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYFRUEG___|___GYMJNU6JVT.JVT.obfusc',
          'spec/fixtures/files/home/matheus/zimmermann.txt' => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYFRUEG___|___9QMMUHMYLL.FBF.obfusc'
        )
      end
    end

    context 'with a file pattern' do
      let(:from) { 'spec/fixtures/files/home/**/*.txt' }

      specify do
        is_expected.to eq(
          'spec/fixtures/files/home/marcos/zimmermann.txt'  => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___9QMMUHMYLL.FBF.obfusc',
          'spec/fixtures/files/home/matheus/zimmermann.txt' => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYFRUEG___|___9QMMUHMYLL.FBF.obfusc'
        )
      end
    end

    context 'with a specific list of directories' do
      let(:from) { 'spec/fixtures/files/home/{marcos,matheus}/*.txt' }

      specify do
        is_expected.to eq(
          'spec/fixtures/files/home/marcos/zimmermann.txt'  => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYHWKG___|___9QMMUHMYLL.FBF.obfusc',
          'spec/fixtures/files/home/matheus/zimmermann.txt' => './obfusc__GJUW___|___TQBFEHUG___|___TQNUG___|___RKMU___|___MYFRUEG___|___9QMMUHMYLL.FBF.obfusc'
        )
      end
    end
  end

  describe '.call' do
    let(:model) { double }

    before do
      expect(described_class).to \
        receive(:new).with(config, nil, nil).and_return(model)
    end

    context 'with copy' do
      specify do
        expect(model).to receive(:copy)
        described_class.call(config, 'copy')
      end
    end

    context 'with move' do
      specify do
        expect(model).to receive(:move)
        described_class.call(config, 'move')
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
