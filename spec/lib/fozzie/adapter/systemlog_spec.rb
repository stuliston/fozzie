require "spec_helper"
require "fozzie/adapter/systemLog"

module Fozzie
  module Adapter

    describe SystemLog do
      it_behaves_like "fozzie adapter"

      class StubSyslog
        def open(*whatevs)
          yield self
        end
      end

      describe "#register" do

        before { subject.target_log = StubSyslog.new }

        it "sends the stats to the SystemLog" do
          stat = { bin: "FOO", value: 1, type: :gauge }
          message = "fozzie: [notice] #{stat.to_s}\n"

          subject.target_log.should_receive(:notice).with(message)

          subject.register(stat)
        end
      end
    end

  end
end