require "fozzie/interface"

module Fozzie
  class Bulk
    include Fozzie::Interface

    attr_reader :metrics

    def initialize(&block)
      @metrics = []
      block.arity < 1 ? instance_eval(&block) : block.call(self) if block_given?
      self
    end

    def commit
      send_to_socket(self.to_s)
    end

    def to_s
      Fozzie::Payload.bulk(@metrics)
    end

    private

    # Cache the requested metrics for bulk sending
    #
    def send(stat, value, type, sample_rate = 1)
      @metrics.push({ 
        :bucket => stat, 
        :value => value, 
        :type => type, 
        :sample_rate => sample_rate
      })
    end

  end
end
