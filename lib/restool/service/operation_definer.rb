require_relative 'uri_utils'

module Restool
  module Service
    module OperationDefiner

      def define_operations(service_config, method_make_request, method_make_request_with_uri_params)
        service_config.operations.each do |operation|
          if operation.uri_params != []
            define_request_method_with_uri_params(operation, method_make_request_with_uri_params)
          else
            define_request_method(operation, method_make_request)
          end
        end
      end

      def define_request_method_with_uri_params(operation, method_make_request_with_uri_params)
        define_singleton_method(operation.name) do |uri_params_values, *params|
          method_make_request_with_uri_params.call(operation, uri_params_values, params[0], params[1])
        end
      end

      def define_request_method(operation, method_make_request)
        define_singleton_method(operation.name) do |*params|
          method_make_request.call(operation, params[0], params[1])
        end
      end

    end
  end
end
