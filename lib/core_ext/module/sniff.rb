require 'fozzie/sniff'

module Sniff

  def _monitor(bucket_name = nil)
    return unless Fozzie.c.sniff?

    self.class_eval { extend Fozzie::Sniff }

    @_monitor_flag, @_bucket_name = true, bucket_name
  end

end

Module.class_eval { include(Sniff) } if defined?(Module)