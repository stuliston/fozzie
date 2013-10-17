require 'socket'
require 'resolv'
require 'logstash/event'

module Fozzie
  module Adapter

    class Logstash

      def register(*stats)
        metrics = stats.collect(&:to_json).join("\n")
        send_to_socket(metrics)
      end

      def delimeter
        raise NotImplementedException
      end

      def safe_separator
        raise NotImplementedException
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

    end

  end
end