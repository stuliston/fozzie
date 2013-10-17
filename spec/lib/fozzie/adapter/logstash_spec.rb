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

      it 'works' do
        subject.should_receive(:send_to_socket).with("{\"bin\":\"FOO\",\"value\":1,\"type\":\"gauge\",\"sample_rate\":1}")
        subject.register(bin: "FOO", value: 1, type: :gauge, sample_rate: 1)
        subject.register(bin: "FOO", value: 202, type: :timer, sample_rate: 1)
      end

    end
  end
end