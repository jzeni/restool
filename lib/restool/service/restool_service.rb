require_relative 'remote_client'
require_relative 'remote_connector'
require_relative 'operation_definer'

module Restool
  module Service
    class RestoolService
      include Restool::Service::OperationDefiner

      def initialize(service_config, response_handler)
        @service_config = service_config
        @response_handler = response_handler
        @remote_client = Restool::Service::RemoteClient.new(service_config.host, service_config.verify_ssl,
                                                            service_config.persistent, service_config.timeout)

        define_operations(
          @service_config, method(:make_request), method(:make_request_with_uri_params)
        )
      end

      private

      # this methods are called directly from the client though the OperationDefiner

      def make_request(operation, params, headers = {})
        path = Restool::Service::UriUtils.build_path(operation)

        Restool::Service::RemoteConnector.execute(
          @remote_client, operation, path, params, headers, @response_handler,
          @service_config.representations, @service_config.basic_auth
        )
      end

      def make_request_with_uri_params(operation, uri_params_values, params, headers = {})
        path = Restool::Service::UriUtils.build_path(operation, uri_params_values)

        Restool::Service::RemoteConnector.execute(
          @remote_client, operation, path, params, headers, @response_handler,
          @service_config.representations, @service_config.basic_auth
        )
      end
    end
  end
end
