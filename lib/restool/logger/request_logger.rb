module Restool
  class RequestLogger

    def initialize(host, opts)
      @host = host
      @opts = opts
    end

    def log(request, &http_request)
      log_request(request) if log?
      response = http_request.call
      log_response(response) if log?

      response
    rescue StandardError => e
      log_error(e) if log?

      raise
    end

    def logger
      @opts[:logger]
    end

    def log?
      if @opts[:log] != nil
        @opts[:log]
      else
        @opts[:logger] != nil
      end
    end

    private

    def log_request(request)
      logger.info  { "Restool Service #{@host}" }
      logger.info  { "#{request.method.upcase} #{request.path}" }
      logger.info  { "Headers: { #{format_hash(request.headers)} }" }
      logger.debug { "Params: { #{format_hash(request.params)} }" }
    end

    def log_response(response)
      logger.info  { "Restool response (status #{response.code}):" }
      logger.debug { response.body }
    end

    def log_error(error)
      logger.error { "Restool error: #{error}" }
    end

    def format_hash(headers)
      headers.map { |key, value| "#{key}: #{value}" }.join(", ")
    end
  end
end
