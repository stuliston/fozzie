module Fozzie
  class MergedConfiguration

    def initialize(*configs)
      @configs = configs || []
    end

    def settings
      configs.inject({}) do |result, config|
        result.merge(config.settings)
      end
    end

    private

    attr_reader :configs

  end
end