module Fozzie
  class Version
    MAJOR, MINOR, PATCH = 0, 0, 27

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end
  end
end