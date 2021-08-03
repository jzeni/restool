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

        # Enumerable class does not have to_h in Ruby 1.9
        header = header_to_hash(remote_response.each_header)

        response = response_handler.call(remote_response.body, remote_response.code,
                                         header)

        return response if operation.response.nil?

        Restool::Traversal::Converter.convert(response, operation.response, representations)
      end

      private

      def self.header_to_hash(header)
        header.inject({}) do |memo, (key, value)|
          memo[key] = value
          memo
        end
      end

    end
  end
end
