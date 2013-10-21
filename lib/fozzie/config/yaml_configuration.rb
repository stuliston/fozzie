require 'facets/hash/symbolize_keys'
require 'yaml'

module Fozzie
  class YamlConfiguration

    def initialize(args = {})
      @config_path = args[:config_path] || ''
      @environment = args[:environment]
    end

    def settings
      return {} unless File.exists?(full_config_path)
      environment_settings.symbolize_keys
    end

    private

    attr_reader :config_path

    def environment_settings
      YAML.load(File.open(full_config_path))[environment]
    end

    def full_config_path
      File.expand_path('config/fozzie.yml', config_path)
    end

    def environment
      (@environment || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')
    end

  end
end