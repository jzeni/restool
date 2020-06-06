module Restool
  class OperationRequest

    attr_accessor :http_request, :method, :path, :params, :headers

    def initialize(http_request, method, path, params, headers)
      @http_request = http_request
      @method = method
      @path = path
      @params = params
      @headers = headers
    end

  end
end
