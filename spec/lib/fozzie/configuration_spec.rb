require 'spec_helper'

describe Fozzie::Configuration do
  let(:mock_env) { Hash.new(nil) }

  before(:each) { stub_const("ENV", mock_env) }

  describe "#env" do
    
    it "loads value from ENV" do
      mock_env['FOZZIE_ENV'] = "ci"
      subject.env.should eq('ci')
    end
    
    it "defaults env to development" do
      subject.env.should eq("development")
    end
  end

  describe "#host" do
    
    it "@host_ip" do
      subject.host_ip.should eq("127.0.0.1")
    end
    
    it "loads value from ENV" do
      mock_env['FOZZIE_HOST'] = "foobar.com"
      subject.host.should eq("foobar.com")
    end
    
    it "defaults to 127.0.0.1" do
      subject.host.should eq("127.0.0.1")
    end
  end

  describe "#port" do

    it "loads value from ENV" do
      mock_env['FOZZIE_PORT'] = "123"
      subject.port.should eq(123)
    end
    
    it "defaults to 8125" do
      subject.port.should eq(8125)
    end
  end

  it "#namespaces" do
    subject.namespaces.should be_kind_of(Array)
    subject.namespaces.should include("Stats")
    subject.namespaces.should include("S")
    subject.namespaces.should include("Statistics")
    subject.namespaces.should include("Warehouse")
  end

  describe "#timeout" do

    it "loads value from ENV" do
      mock_env['FOZZIE_TIMEOUT'] = "0.75"
      subject.timeout.should eq(0.75)
    end
    
    it "defaults to 0.5" do
      subject.timeout.should be_kind_of(Float)
    end
  end
  
  describe "#monitor_classes" do
    
    it "defaults to empty Array" do
      subject.monitor_classes.should eq([])
    end
  end
  
  describe "#sniff_envs" do
    
    it "defaults to populated Array" do
      subject.sniff_envs.should eq([:development, :staging, :production])
    end
  end
  
  describe "#load" do

    it "attempts to load configuration from yaml" do
      subject.tap do |s|
        s.env = "test"
        s.load('./spec/config/fozzie.yml')
      end

      subject.host.should eq('1.1.1.1')
      subject.port.should eq(9876)
    end
  end
  
  describe "#prefix" do

    it "allows dynamic injection of value to prefix" do
      subject.prefix << 'git-sha-1234'
      subject.prefix.should eq(['git-sha-1234'])
    end
  end
  
  it "handles missing configuration namespace" do
    proc { 
      Fozzie::Configuration.new({:env => 'blbala'}) 
    }.should_not raise_error
  end

  describe "#sniff?" do
    it "defaults to false for testing" do
      subject.stub(:env => "test")
      subject.sniff?.should be_false
    end

    it "defaults true when in development" do
      subject.stub(:env => "development")
      subject.sniff?.should be_true
    end

    it "defaults true when in production" do
      subject.stub(:env => "production")
      subject.sniff?.should be_true
    end
  end

  describe "#sniff_envs sets configuration for #sniff?" do
    let!(:sniff_envs) { subject.stub(:sniff_envs => ['test']) }

    it "scopes to return false" do
      subject.stub(:env => "development")
      subject.sniff?.should be_false
    end

    it "scopes to return true" do
      subject.stub(:env => "test")
      subject.sniff?.should be_true
    end
  end
end