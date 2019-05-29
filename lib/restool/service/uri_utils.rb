module Restool
  module Service
    module UriUtils

      def self.build_path(operation, uri_params_values = nil)
        path = operation.path

        if uri_params_values
          operation.uri_params.each_with_index do |uri_param, i|
            path.sub!(/#{uri_param}/, uri_params_values[i].to_s)
          end
        end

        path
      end

    end

  end
end
