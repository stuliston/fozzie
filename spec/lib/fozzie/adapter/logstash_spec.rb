require 'spec_helper'
require 'fozzie/adapter/logstash'


module Fozzie
  module Adapter

    describe Logstash do
      it_behaves_like "fozzie adapter"

      # Switch to Logstash adapter for the duration of this test
      before(:all) do
        Fozzie.c.adapter = :Logstash
        Fozzie.c.port = 9999
      end

      after(:all) do
        Fozzie.c.adapter = :TestAdapter
        Fozzie.c.port = 8125
      end

      describe "#register" do

        it 'sends the formatted message to the socket' do
          # TODO: Make host name configurable (stu.local)
          expected_message = "{\"bin\":\"stu-local.test.foo\",\"value\":1,\"type\":\"gauge\",\"sample_rate\":1}"
          subject.should_receive(:send_to_socket).with(expected_message)
          subject.register(bin: "FOO", value: 1, type: :gauge, sample_rate: 1)
        end
      end

      describe "#format_bucket" do
        it "accepts arrays" do
          subject.format_bucket([:foo, '2']).should match /foo.2$/
          subject.format_bucket([:foo, '2']).should match /foo.2$/
          subject.format_bucket(%w{foo bar}).should match /foo.bar$/
        end

        it "converts any values to strings for stat value, ignoring nil" do
          subject.format_bucket([:foo, 1, nil, "@", "BAR"]).should =~ /foo.1._.bar/
        end

        it "replaces invalid chracters" do
          subject.format_bucket([:foo, ':']).should match /foo.#{subject.class::RESERVED_CHARS_REPLACEMENT}$/
          subject.format_bucket([:foo, '@']).should match /foo.#{subject.class::RESERVED_CHARS_REPLACEMENT}$/
          subject.format_bucket('foo.bar.|').should match /foo.bar.#{subject.class::RESERVED_CHARS_REPLACEMENT}$/
        end
      end

    end
  end
end