require 'fozzie/environment'
require 'fozzie/config/default_configuration'
require 'fozzie/config/yaml_configuration'
require 'yaml'
require 'facets/hash/symbolize_keys'
require 'sys/uname'
require 'timeout'

module Fozzie

  # Fozzie configuration allows assignment of global properties
  # that will be used within the Fozzie codebase.

  class Configuration
    include Sys

    attr_accessor :config_path, :host, :port, :appname, :namespaces,
      :timeout, :monitor_classes, :sniff_envs, :ignore_prefix, :prefix

    def initialize(args = {})
      @args = args
      assign_settings!
    end

    def adapter=(adapter)
      @adapter = eval("Fozzie::Adapter::#{adapter}").new
    rescue NoMethodError
      raise AdapterMissing, "Adapter could not be found for given provider #{@provider}"
    end

    def adapter
      @adapter || default_configuration[:adapter]
    end

    def disable_prefix
      @ignore_prefix = true
    end

    # Returns the prefix for any stat requested to be registered
    def data_prefix
      return nil if @ignore_prefix
      return @data_prefix if @data_prefix

      escaped_prefix_with_dynamically_resolved_parts = prefix.map do |part|
        resolved_part = (part.kind_of?(Symbol) && self.respond_to?(part) ? self.send(part) : part.to_s)
        escaped_resolved_part = resolved_part.gsub(delimeter, safe_separator)
        escaped_resolved_part == "" ? nil : escaped_resolved_part
      end.compact

      @data_prefix = if escaped_prefix_with_dynamically_resolved_parts.any?
                       escaped_prefix_with_dynamically_resolved_parts.join(delimeter).strip
                     else
                       nil
                     end
    end

    # Returns the origin name of the current machine to register the stat against
    def origin_name
      @origin_name ||= Uname.nodename
    end

    def sniff?
      sniff_envs.collect(&:to_sym).include?(env.to_sym)
    end

    def env
      Environment.current
    end

    private

    attr_reader :args

    def assign_settings!
      settings.each do |k,v|
        send("#{k}=", v) if respond_to?(k.to_sym)
      end
    end

    def settings
      configs.inject({}) do |result, config|
        result.merge(config)
      end
    end

    def configs
      [
        default_configuration.settings,
        yaml_configuration.settings,
        args
      ]
    end

    def default_configuration
      DefaultConfiguration.new
    end

    def yaml_configuration
      YamlConfiguration.new(args[:config_path])
    end

    # TODO: Make this config keyed under adapter
    def delimeter
      '.'
    end

    # TODO: Make this config keyed under adapter
    def safe_separator
      '-'
    end

  end

end
