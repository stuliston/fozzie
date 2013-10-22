require 'spec_helper'
require 'resolv'

module Fozzie
  describe Configuration do

    it "#host" do
      subject.host.should be_kind_of(String)
    end

    it "#port" do
      subject.port.should be_kind_of(Fixnum)
    end

    it "attempts to load configuration from yaml" do

      c = Configuration.new(
        config_path: 'spec/',
        adapter:     :TestAdapter,
        config_path:  './spec/config/fozzie.yml'
      )

      c.stub(origin_name: "")
      c.host.should eq '1.1.1.1'
      c.port.should eq 9876
      c.appname.should eq 'fozzie'
    end

    describe "#adapter" do
      it "throw error on incorrect assignment" do
        -> { Configuration.new({env: 'test', adapter: 'foo'}) }.should raise_error(AdapterMissing)
      end

      it "defaults adapter to Statsd" do
        subject.adapter.should be_kind_of(Adapter::Statsd)
      end
    end

    describe "#disable_prefix" do
      it "sets the data_prefix to nil" do
        subject.disable_prefix
        subject.data_prefix.should be_nil
      end
    end

    describe "#prefix and #data_prefix" do
      it "creates a #data_prefix" do
        subject.stub(origin_name: "")
        subject.data_prefix.should eq 'test'
      end

      it "creates a #data_prefix with appname when set" do
        subject.stub(origin_name: "")
        subject.appname = 'astoria'
        subject.data_prefix.should eq 'astoria.test'
      end

      it "creates a #data_prefix with origin" do
        subject.appname = 'astoria'
        subject.data_prefix.should match /^astoria\.(\S+)\.test$/
      end

      it "allows dynamic assignment of #prefix to derive #data_prefix" do
        subject.prefix = [:foo, :bar, :car]
        subject.data_prefix.should eq 'foo.bar.car'
      end

      it "allows dynamic injection of value to prefix" do
        subject.stub(origin_name: "")
        subject.prefix << 'git-sha-1234'
        subject.data_prefix.should eq 'test.git-sha-1234'
      end
    end

    it "handles missing configuration namespace" do
      proc { Configuration.new({config_path: './spec/config/fozzie.yml'}) }.should_not raise_error
    end

    describe "#namespaces" do
      its(:namespaces) { should be_kind_of(Array) }
      its(:namespaces) { should include("Stats") }
      its(:namespaces) { should include("S") }
    end

    describe "#sniff?" do
      it "defaults to false for testing" do
        subject.stub(env: "test")
        subject.sniff?.should be_false
      end

      it "defaults true when in development" do
        subject.stub(env: "development")
        subject.sniff?.should be_true
      end

      it "defaults true when in production" do
        subject.stub(env: "production")
        subject.sniff?.should be_true
      end
    end

    describe "#sniff_envs allows configuration for #sniff?" do
      let!(:sniff_envs) { subject.stub(sniff_envs: ['test']) }

      it "scopes to return false" do
        subject.stub(env: "development")
        subject.sniff?.should be_false
      end

      it "scopes to return true" do
        subject.stub(env: "test")
        subject.sniff?.should be_true
      end
    end

    describe "ignoring prefix" do
      it "does not use prefix when set to ignore" do
        subject.disable_prefix
        subject.ignore_prefix.should eq(true)
      end
    end

  end
end