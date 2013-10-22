require 'singleton'
require "fozzie/interface"

module Fozzie
  class Dsl
    include Fozzie::Interface, Singleton

    private

    # Send the statistic to the chosen provider
    #
    def send(stat, value, type, sample_rate = 1)
     val = { :bin => stat, :value => value, :type => type, :sample_rate => sample_rate }

     # TODO: We might need to push the val stuff into the StatsD adapter
     adapter.register(val)
    end

  end
end
