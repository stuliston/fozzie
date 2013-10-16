require "logger"

module Fozzie
  module Adapter

    class SystemLog

      attr_accessor :target_log

      def initialize
        @target_log = Logger.new('/var/log/fozzie.log')
        @target_log.formatter = proc do |severity, datetime, progname, msg|
          msg
        end
      end

      def register(*stats)
        metrics = stats.flatten.collect do |stat|
          format(stat)
        end.compact.join("\n")

        target_log.info(metrics)
      end

      def delimeter
        raise NotImplementedException
      end

      def safe_separator
        raise NotImplementedException
      end

      private

      def format(stat)
        stat.map{|k,v| "#{k}=#{v}"}.join(',')
      end

    end

  end
end