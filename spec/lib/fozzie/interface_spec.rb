require 'spec_helper'

describe Fozzie::Interface do

  subject do 
    MockInterface ||= Class.new() { extend Fozzie::Interface }
  end

  it "ensures block is called on socket error" do
    UDPSocket.any_instance.stub(:send).and_raise { RuntimeError }

    proc { 
      subject.increment('foo') { sleep 0.01 } 
    }.should_not raise_error
    proc { 
      subject.increment('foo') { sleep 0.01 } 
    }.should_not raise_error
  end

  it "raises Timeout on slow lookup" do
    Fozzie.c.timeout = 0.01
    UDPSocket.any_instance.stub(:send).with(any_args) { sleep 0.4 }

    subject.increment('bar').should eq(false)
  end
end
