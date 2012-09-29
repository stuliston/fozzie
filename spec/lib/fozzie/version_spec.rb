require 'spec_helper'

module Fozzie
  describe Version do

    it "MAJOR" do
      Version::MAJOR.should be_kind_of(Integer)
    end

    it "MINOR" do
      Version::MINOR.should be_kind_of(Integer)
    end

    it "PATCH" do
      Version::PATCH.should be_kind_of(Integer)
    end

    it ".to_s" do
      Fozzie::Version.to_s.should match /\d{1,3}?\.?/
    end

  end
end