module Fozzie
  class Payload

    RESERVED_CHARS_REGEX       = /[\:\|\@\s]/
    RESERVED_CHARS_REPLACEMENT = '_'
    DELIMETER                  = '.'
    SAFE_SEPARATOR             = '-'
    TYPES                      = { :gauge => 'g', :count => 'c', :timing => 'ms', :histogram => 'h' }
    BULK_DELIMETER             = "\n"

    attr_accessor :args

    def self.bulk(args = [])
      args.collect {|entry| new(entry).to_s }.join(BULK_DELIMETER)
    end

    def initialize(args = {})
      @args = args
    end

    def bucket
      raise ArgumentError, "bucket required" if @args[:bucket].to_s.empty?

      buck = [@args[:bucket]].flatten.compact.collect(&:to_s).join(DELIMETER).downcase
      buck = clean_generated_string(buck)
      buck = [prefix, buck].compact.reject(&:empty?).join(DELIMETER)

      buck 
    end

    def value
      @args[:value].to_s
    end

    def type
      TYPES[@args[:type].to_sym] || TYPES[:gauge]
    end

    def sample_rate
      '@%s' % @args[:sample_rate].to_s
    end
    
    def prefix
      clean_generated_string(Fozzie.c.prefix.compact.join(DELIMETER).downcase)
    end

    def to_s
      ["#{bucket}:#{value}", type].compact.join('|')
    end

    def sampled?
      @sampled = (!(@args[:sample_rate] < 1) and !(rand > @args[:sample_rate]))
    end
    
    private
    
    def clean_generated_string(str)
      str.gsub(RESERVED_CHARS_REGEX, RESERVED_CHARS_REPLACEMENT)
    end

  end
end
