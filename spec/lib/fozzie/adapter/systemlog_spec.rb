require "spec_helper"
require "fozzie/adapter/systemLog"

module Fozzie
  module Adapter

    class StubSyslog
      def self.open(*whatevs)
        yield self
      end

      def notice(message)
        # swallow
      end
    end

    describe SystemLog do
      it_behaves_like "fozzie adapter"

      describe "#register" do

        before { subject.target_log = StubSyslog }

        it "sends the stats to the SystemLog" do
          stat = { bin: "FOO", value: 1, type: :gauge }
          message = "fozzie: [notice] {\"bin\":\"FOO\",\"value\":1,\"type\":\"gauge\"}\n"

          subject.target_log.should_receive(:notice).with(message)

          subject.register(stat)
        end
      end
    end

  end
end