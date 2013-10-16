require "spec_helper"
require "fozzie/adapter/systemLog"

module Fozzie
  module Adapter

    class Stublog
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

        before { subject.target_log = Stublog }

        it "sends the stats to the SystemLog" do
          stat = { bin: "FOO", value: 1, type: :gauge }

          subject.target_log.should_receive(:info).with("bin=FOO,value=1,type=gauge")

          subject.register(stat)
        end
      end
    end

  end
end