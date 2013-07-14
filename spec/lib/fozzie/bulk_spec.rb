require 'spec_helper'

module Fozzie
  describe Bulk do
    
    it { should respond_to(:commit) }
    it { should respond_to(:to_s) }

    it "accumalates packets to send" do
      bulk = described_class.new do
        increment :foo
        decrement :bar
      end

      bulk.to_s.should eq("foo:1|c|@1\nbar:-1|c|@1")
    end

  end
end