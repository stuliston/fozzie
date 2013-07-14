require 'sys/uname'

module Fozzie
  class Utils

    # Returns the origin name of the current machine to register the stat against
    def self.origin_name
      @origin_name ||= Sys::Uname.nodename
    end
    
  end
end