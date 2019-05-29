require_relative '../traversal/converter'

module Restool
  module Service
    module RemoteConnector
      # The RemoteConnector module makes the requests using the RemoteClient,
      # calls the response_handler with the response, and finally executes
      # the object traversal

      def self.execute(remote_client, operation, path, params, headers,
                      response_handler, representations, basic_auth)
        remote_response = remote_client.make_request(path, operation.method, params, headers,
                                                    basic_auth)

        response = response_handler.call(remote_response.body, remote_response.code)

        return response if operation.response.nil?

        Restool::Traversal::Converter.convert(response, operation.response, representations)
      end

    end
  end
end
