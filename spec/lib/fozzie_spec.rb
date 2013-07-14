require 'spec_helper'
require 'logger'

describe Fozzie do
  
  it "allows dynamic assignment" do
    { :host => 'somewhere.local', :port => 99 }.each do |field, val|
      described_class.configure {|c| c.send("#{field}=", val) }
      described_class.c.send(field).should == val
    end
  end

  describe ".logger" do
  
    it "assigns a logger" do
      log = mock('log')
      described_class.logger = log
      described_class.logger.should eq(log)
    end    
  end

  describe ".log" do

    it "accepts level and message" do
      described_class.logger = mock('log')
      described_class.logger.should_receive(:send).with(:info, /foo$/)

      described_class.log(:info, "foo")
    end
  end

  it "has configuration" do
    described_class.config.should be_kind_of(Fozzie::Configuration)
    described_class.c.should be_kind_of(Fozzie::Configuration)
  end

  it "creates new classes for statistics gathering" do
    described_class.c.namespaces.each do |k|
      Kernel.const_defined?(k).should == true
    end
  end
end
