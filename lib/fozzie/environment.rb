require 'singleton'

class Environment
  include Singleton

  def self.current
    instance.current
  end

  def current
    (ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')
  end

end