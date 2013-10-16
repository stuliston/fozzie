require 'syslog'
require 'json'

module Fozzie
  module Adapter

    class SystemLog

      attr_accessor :target_log

      def initialize
        @target_log = Syslog
      end

      def register(*stats)
        metrics = stats.flatten.collect do |stat|
          convert_to_json(stat)
        end.compact.join('|')
        send_to_log(metrics)
      end

      def delimeter
        raise NotImplementedException
      end

      def safe_separator
        raise NotImplementedException
      end

      private

      def convert_to_json(stat)
        JSON.fast_generate(stat)
      end

      def send_to_log(message, severity = :notice)
        target_log.open($0, Syslog::LOG_PID | Syslog::LOG_CONS) do |log|
          log.send(severity, "{'bin':'FOO','value':1,'type':'gauge'}\n")
        end
      end

    end

  end
end