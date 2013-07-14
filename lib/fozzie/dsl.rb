require "singleton"
require "fozzie/interface"

module Fozzie
  class DSL
    include Singleton,Fozzie::Interface
  end
end
