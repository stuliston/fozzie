require 'spec_helper'
require 'fozzie/config/yaml_configuration'

module Fozzie
  describe YamlConfiguration do
    it_behaves_like 'a fozzie configuration file'

    let(:configuration_file) do
      YamlConfiguration.new(
        config_path: config_path,
        environment: 'test'
        )
    end

    describe '#settings' do

      context 'when the file is missing' do
        let(:config_path) { 'clearly/made/up/path' }

        it 'is empty' do
          expect(configuration_file.settings).to eq({})
        end
      end

      context 'when the file is provided' do
        let(:config_path) { './spec' }

        it 'exposes config file settings' do
          settings = {
            appname: "fozzie",
            enable_rails_middleware: false,
            host: "1.1.1.1",
            port: 9876
          }
          expect(configuration_file.settings).to eq(settings)
        end
      end
    end

  end
end