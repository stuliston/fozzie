require 'fozzie/environment'
require 'facets/hash/symbolize_keys'
require 'yaml'

module Fozzie
  class YamlConfiguration

    def initialize(path = nil)
      @path = path || default_path
    end

    def settings
      return {} unless File.exists?(full_path)
      environment_settings.symbolize_keys
    end

    private

    attr_reader :path

    def default_path
      'config/fozzie.yml'
    end

    def environment_settings
      YAML.load(File.open(full_path))[Environment.current]
    end

    def full_path
      File.expand_path(path)
    end

  end
end