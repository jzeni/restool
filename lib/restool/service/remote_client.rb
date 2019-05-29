require 'persistent_http'

require_relative 'request_utils'

module Restool
  module Service
    class RemoteClient

      def initialize(host, verify_ssl, persistent_connection, timeout)
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
                        http.use_ssl      = ssl_implied?(uri)
                        http.verify_mode  = verify_ssl?(verify_ssl)
                        http.read_timeout = timeout
                        http.open_timeout = timeout
                        # http.set_debug_output($stdout)
                        http
                      end
      end

      def make_request(path, method, request_params, headers, basic_auth)
        request = RequestUtils.build_request(method, path, request_params, headers, basic_auth)

        @connection.request(request)
      end

      private

      def ssl_implied?(uri)
        uri.port == 443 || uri.scheme == 'https'
      end

      def verify_ssl?(verify_ssl_setting)
        verify_ssl_setting ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
      end
    end
  end
end
