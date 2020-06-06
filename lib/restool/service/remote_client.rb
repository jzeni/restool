require 'persistent_http'

require_relative 'request_utils'
require_relative '../logger/request_logger'

module Restool
  module Service
    class RemoteClient

      def initialize(host, verify_ssl, persistent_connection, timeout, opts)
        @request_logger = Restool::RequestLogger.new(host, opts)

        @connection = if persistent_connection
                        PersistentHTTP.new(
                          pool_size:    persistent_connection.pool_size,
                          pool_timeout: timeout,
                          warn_timeout: persistent_connection.warn_timeout,
                          force_retry:  persistent_connection.force_retry,
                          url:          host,
                          read_timeout: timeout,
                          open_timeout: timeout,
                          verify_mode: verify_ssl?(verify_ssl)
                        )
                      else
                        uri               = URI.parse(host)
                        http              = Net::HTTP.new(uri.host, uri.port)
                        http.use_ssl      = uri.is_a?(URI::HTTPS)
                        http.verify_mode  = verify_ssl?(verify_ssl)
                        http.read_timeout = timeout
                        http.open_timeout = timeout
                        http.set_debug_output($stdout) if opts[:debug]
                        http
                      end
      end

      def make_request(path, method, request_params, headers, basic_auth)
        operation_request = RequestUtils.build_request(method, path, request_params, headers, basic_auth)

        @request_logger.log(operation_request) do
          @connection.request(operation_request.http_request)
        end
      end

      private

      def verify_ssl?(verify_ssl_setting)
        verify_ssl_setting ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
      end
    end
  end
end
