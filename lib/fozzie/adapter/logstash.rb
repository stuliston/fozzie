require 'socket'
require 'resolv'
require 'logstash/event'

module Fozzie
  module Adapter

    class Logstash

      RESERVED_CHARS_REGEX       = /[\:\|\@\s]/
      RESERVED_CHARS_REPLACEMENT = '_'
      BULK_DELIMETER             = "\n"

      def register(*stats)
        metrics = stats.flatten.collect do |stat|
          next if sampled?(stat[:sample_rate])

          stat.merge(bin: format_bucket(stat[:bin])).to_json
        end.compact.join(BULK_DELIMETER)

        send_to_socket(metrics)
      end

      def format_bucket(stat)
        bucket = [stat].flatten.compact.collect(&:to_s).join(delimeter).downcase
        bucket = bucket.gsub('::', delimeter).gsub(RESERVED_CHARS_REGEX, RESERVED_CHARS_REPLACEMENT)
        bucket = [Fozzie.c.data_prefix, bucket].compact.join(delimeter)

        bucket
      end

      # If the statistic is sampled, generate a condition to check if it's good to send
      def sampled(sample_rate)
        yield unless sampled?(sample_rate)
      end

      def sampled?(sample_rate)
        sample_rate < 1 and rand > sample_rate
      end

      private

      # Send data to the server via the socket
      def send_to_socket(message)
        Fozzie.logger.debug {"Statsd: #{message}"} if Fozzie.logger
        Timeout.timeout(Fozzie.c.timeout) {
          res = socket.send(message, 0, host_ip, host_port)
          Fozzie.logger.debug {"Statsd sent: #{res}"} if Fozzie.logger
          (res.to_i == message.length)
        }
      rescue => exc
        Fozzie.logger.debug {"Statsd Failure: #{exc.message}\n#{exc.backtrace}"} if Fozzie.logger
        false
      end

      # The Socket we want to use to send data
      def socket
        @socket ||= ::UDPSocket.new
      end

      def host_ip
        @host_ip ||= Resolv.getaddress(Fozzie.c.host)
      end

      def host_port
        @host_port ||= Fozzie.c.port
      end

      def delimeter
        Fozzie.c.delimeter
      end

    end

  end
end