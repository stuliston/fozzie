require 'spec_helper'
require 'fozzie/config/yaml_configuration'

module Fozzie
  describe YamlConfiguration do
    it_behaves_like 'a fozzie configuration file'

    let(:yaml_configuration) do
      YamlConfiguration.new(path)
    end

    describe '#settings' do

      context 'when the file is missing' do
        let(:path) { 'clearly/made/up/path' }

        it 'is empty' do
          expect(yaml_configuration.settings).to eq({})
        end
      end

      context 'when the file is provided' do
        let(:path) { './spec/config/fozzie.yml' }

        it 'exposes config file settings' do
          settings = {
            appname: "fozzie",
            enable_rails_middleware: false,
            host: "1.1.1.1",
            port: 9876
          }
          expect(yaml_configuration.settings).to eq(settings)
        end
      end
    end

  end
end