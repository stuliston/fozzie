require 'spec_helper'

module Fozzie
  describe Bulk do

    it "accumalates packets to send" do
      described_class.any_instance.stub(:commit)

      bulk = described_class.new do
        increment :foo
        decrement :bar
      end

      bulk.to_s.should eq("foo:1|c\nbar:-1|c")
    end

  end
end
