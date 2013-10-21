require 'spec_helper'
require 'fozzie/config/default_configuration'

module Fozzie
  describe DefaultConfiguration do
    it_behaves_like 'a fozzie configuration file'

    let(:default_configuration) { subject }

    describe '#settings' do

      it 'exposes the default settings' do
        keys = default_configuration.settings.keys
        expect(keys).to eq [
          :host,
          :prefix,
          :port,
          :config_path,
          :appname,
          :namespaces,
          :timeout,
          :monitor_classes,
          :sniff_envs,
          :ignore_prefix,
          :adapter
        ]
      end
    end

  end
end