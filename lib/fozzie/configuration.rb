require "yaml"
require "facets/hash/symbolize_keys"
require "timeout"
require "resolv"

module Fozzie

  # Fozzie configuration allows assignment of global properties
  # that will be used within the Fozzie codebase.
  class Configuration

    attr_accessor :env, :host, :host_ip, :port, :namespaces,
      :timeout, :monitor_classes, :sniff_envs, :prefix

    def initialize(args = {})
      merge_and_assign_config(args)
    end
    
    def host=(val)
      @host     = val
      @host_ip  = Resolv.getaddress(@host) rescue nil
      @host
    end

    def sniff?
      self.sniff_envs.collect(&:to_sym).include?(self.env.to_sym)
    end

    def load(filepath)
      assign_config(config_from_yaml(filepath))
    end

    private

    # Handle the merging of the given configuaration, and the default config.
    def merge_and_assign_config(args = {})
      arg = self.class.default_configuration.merge(args.symbolize_keys)
      arg.merge!(config_from_yaml(full_config_path))
      assign_config(arg)
    end
    
    def assign_config(args = {})
      args.each {|a,v| self.send("#{a}=", v) if self.respond_to?(a.to_sym) }

      args
    end

    # Default configuration settings
    def self.default_configuration
      {
        :env             => (ENV['FOZZIE_ENV'] || 'development'),
        :host            => (ENV['FOZZIE_HOST'] || '127.0.0.1'),
        :port            => (ENV['FOZZIE_PORT'] || 8125).to_i,
        :namespaces      => %w{Stats S Statistics Warehouse},
        :timeout         => (ENV['FOZZIE_TIMEOUT'] || 0.5).to_f,
        :monitor_classes => [],
        :sniff_envs      => [:development, :staging, :production].collect(&:to_sym),
        :prefix          => []
      }.dup
    end

    # Loads the configuration from YAML, if possible
    def config_from_yaml(path)
      return {} unless File.exists?(path)
      
      cnf = YAML.load(File.open(path))
      cnf = cnf.kind_of?(Hash) ? cnf.symbolize_keys : {}
      cnf = cnf[env.to_sym] unless env.nil? and cnf[env.to_sym].nil?

      cnf
    end

    # Returns the absolute file path for the Fozzie configuration
    def full_config_path
      File.expand_path('./config/fozzie.yml')
    end

  end

end