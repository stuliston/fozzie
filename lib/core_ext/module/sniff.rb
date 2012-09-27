require 'fozzie/sniff'

module Sniff

  def _monitor(bucket_name = nil)
    return unless Fozzie.c.sniff?

    self.class_eval { include Fozzie::Sniff }

    @_monitor_flag = true
    @_bucket_name  = bucket_name
  end

end

Module.class_eval { include(Sniff) } if defined?(Module)