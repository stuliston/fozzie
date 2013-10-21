require 'spec_helper'
require 'fozzie/config/merged_configuration'

module Fozzie
  describe MergedConfiguration do
    it_behaves_like 'a fozzie configuration file'

    class Defaults
      def settings
        {
          host:   '127.0.0.1',
          prefix: [:appname, :origin_name, :env],
          port:   8125
        }
      end
    end

    class Overrides
      def settings
        {
          host:     '0.0.0.0',
          prefix:   [],
          appname:  'bananas'
        }
      end
    end

    describe Defaults do
      it_behaves_like 'a fozzie configuration file'
    end

    describe Overrides do
      it_behaves_like 'a fozzie configuration file'
    end

    let(:merged_configuration) do
      MergedConfiguration.new(Defaults.new, Overrides.new)
    end

    describe '#settings' do

      it 'exposes the merged settings' do
        settings = merged_configuration.settings
        expect(settings).to eq(
          {
            host:     '0.0.0.0',
            prefix:   [],
            appname:  'bananas',
            port:     8125
          }
        )
      end
    end

  end
end