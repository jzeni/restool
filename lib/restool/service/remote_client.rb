require "net/http"
require "net/https"
require_relative 'request_utils'
require_relative '../logger/request_logger'

module Restool
  module Service
    class RemoteClient

      def initialize(host, verify_ssl, timeout, opts)
        @request_logger = Restool::RequestLogger.new(host, opts)
        @connection = build_connection(host, verify_ssl, timeout, opts)
      end

      def make_request(path, method, request_params, headers, basic_auth)
        operation_request = RequestUtils.build_request(method, path, request_params, headers, basic_auth)

        @request_logger.log(operation_request) do
          @connection.request(operation_request.http_request)
        end
      end

      private

      def build_connection(host, verify_ssl, timeout, opts)
        uri = URI.parse(host)

        connection = if proxy_uri
                       Net::HTTP.new(uri.host, uri.port, proxy_uri.host, proxy_uri.port)
                     else
                       Net::HTTP.new(uri.host, uri.port)
                     end

        connection.use_ssl      = uri.is_a?(URI::HTTPS)
        connection.verify_mode  = verify_ssl?(verify_ssl)
        connection.read_timeout = timeout
        connection.open_timeout = timeout
        connection.set_debug_output($stdout) if opts[:debug]

        connection
      end

      def proxy_uri
        # Patch for Net/Http issue with env var
        proxy_env = ENV['http_proxy'] || ENV['HTTP_PROXY']

        URI.parse(proxy_env) if proxy_env != nil && proxy_env != ''
      end

      def verify_ssl?(verify_ssl_setting)
        verify_ssl_setting ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
      end
    end
  end
end
