require 'syslog'

module Fozzie
  module Adapter

    class SystemLog

      attr_accessor :target_log

      def initialize
        @target_log = Syslog
      end

      def register(*stats)
        metrics = stats.flatten.collect(&:to_s).compact.join('|')
        send_to_log(metrics)
      end

      def delimeter
        raise NotImplementedException
      end

      def safe_separator
        raise NotImplementedException
      end

      private

      def send_to_log(message, severity = :notice)
        target_log.open($0, Syslog::LOG_PID | Syslog::LOG_CONS) do |log|
          log.send(severity, format(message, severity))
        end
      end

      def format(message, severity)
        "fozzie: [#{severity}] #{message.strip}\n"
      end

    end

  end
end