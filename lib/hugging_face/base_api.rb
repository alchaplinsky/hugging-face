require 'json'
require 'logger'
require 'faraday'

module HuggingFace
  class BaseApi
    HTTP_SERVICE_UNAVAILABLE = 503
    JSON_CONTENT_TYPE = 'application/json'

    # Retry connecting to the model for 1 minute
    MAX_RETRY = 60

    def initialize(api_token:)
      @headers = {
        'Authorization' => 'Bearer ' + api_token,
        'Content-Type' => JSON_CONTENT_TYPE
      }
    end

    private

    def build_connection(url)
      Faraday.new(url, headers: @headers)
    end

    def request(connection:, input:, params: nil)
      response = connection.post { |req| 
        req.body = input.to_json 
        req.params = params if params
      }
      
      if response.success?
        return parse_response response
      else
        raise ServiceUnavailable.new response.body if response.status == HTTP_SERVICE_UNAVAILABLE
        raise Error.new response.body
      end
    end

    def parse_response(response)
      if response.headers['Content-Type'] == JSON_CONTENT_TYPE
        JSON.parse(response.body)
      else
        response.body
      end
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end

