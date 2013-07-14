require 'spec_helper'
require 'fozzie/payload'

describe Fozzie::Payload do

  describe "#payload" do

    it "assigned on initialize" do
      subject.args = { foo: :bar }
      subject.args.should eq({foo: :bar })
    end
  end

  describe "#type" do

    it "accepts a String" do
      subject.args = { :type => "gauge" }
      subject.type.should eq('g')
    end

    it "accepts :gauge" do
      subject.args = { :type => :gauge }
      subject.type.should eq('g')
    end

    it "accepts :count" do
      subject.args = { :type => :count }
      subject.type.should eq('c')
    end

    it "accepts :timing" do
      subject.args = { :type => :timing }
      subject.type.should eq('ms')
    end

    it "accepts :histogram" do
      subject.args = { :type => :histogram }
      subject.type.should eq('h')
    end

    it "defaults unknown type to gauge" do
      subject.args = { :type => :foo }
      subject.type.should eq('g')
    end
  end

  describe "#bucket" do

    it "accepts String" do
      subject.args = { :bucket => "foo" } 
      subject.bucket.should match(%r{.foo$})
    end

    it "accepts Array" do
      subject.args = { :bucket => [:foo, "bar"] } 
      subject.bucket.should match(%r{.foo.bar$})
    end

    it "converts values to lowercase" do
      subject.args = { :bucket => [:foo, "BAR"] } 
      subject.bucket.should match(%r{.foo.bar$})
    end

    it "removes reserved characters" do
      subject.args = { :bucket => "foo@bar" }
      subject.bucket.should match(%r{.foo_bar})
    end
  end

  it "#value" do
    subject.args = { :value => 500 }
    subject.value.should eq('500')
  end

  it "#sample_rate" do
    subject.args = { :sample_rate => 1 }
    subject.sample_rate.should eq("@1")
  end

  describe "#to_s" do

    it "returns entire payload String" do
      subject.args = { :bucket => "foo", :value => 500, :type => :count, :sample_rate => 5 }
      subject.to_s.should match(%r{.foo|500|c|@5$})
    end
  end

end
