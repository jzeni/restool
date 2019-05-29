module Restool
  module Service
    module RequestUtils

      def self.build_request(method, path, params, headers, basic_auth)
        if ['post', 'put', 'patch'].include?(method)
          request = build_base_request(method, path)

          if params && params.is_a?(Hash)
            request.set_form_data(params)
          else
            request.body = params
          end

        else
          uri = URI(path)
          uri.query = URI.encode_www_form(params) if params

          request = build_base_request(method, uri.to_s)
        end

        request.basic_auth(basic_auth.user, basic_auth.password) if basic_auth

        headers.each { |k, v| request[k] = v } if headers

        request
      end

      def self.build_base_request(method, path)
        case method.to_s.downcase
        when 'get'
          Net::HTTP::Get.new(path)
        when 'post'
          Net::HTTP::Post.new(path)
        when 'put'
          Net::HTTP::Put.new(path)
        when 'delete'
          Net::HTTP::Delete.new(path)
        when 'patch'
          Net::HTTP::Patch.new(path)
        end
      end

    end
  end
end
