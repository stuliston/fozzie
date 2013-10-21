module Fozzie
  class DefaultConfiguration

    def settings
      {
        host:            '127.0.0.1',
        prefix:          [:appname, :origin_name, :env],
        port:            8125,
        config_path:     '',
        appname:         '',
        namespaces:      %w{Stats S Statistics Warehouse},
        timeout:         0.5,
        monitor_classes: [],
        sniff_envs:      [:development, :staging, :production],
        ignore_prefix:   false,
        adapter:         :Statsd
      }
    end

  end
end