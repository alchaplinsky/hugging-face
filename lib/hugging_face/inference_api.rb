require 'faraday'

module HuggingFace
  class InferenceApi
    HOST = "https://api-inference.huggingface.co"
    MAX_RETRY = 2
    HTTP_SEVICE_UNAVAILABLE = 503

    QUESTION_ANSWERING_MODEL = 'distilbert-base-cased-distilled-squad'
    SUMMARIZATION_MODEL = "sshleifer/distilbart-xsum-12-6"
    GENERATION_MODEL = "distilgpt2"

    def initialize(api_token:)
      @headers = {
        'Authorization' => 'Bearer ' + api_token,
        'Content-Type' => 'application/json'
      }
    end

    def call(input:, model:)
      request(connection: connection(model), input: input)
    end

    def question_answering(question:, context:, model: QUESTION_ANSWERING_MODEL)
      input = { question: question, context: context }

      request(connection: connection(model), input: input)
    end

    def summarization(input:, model: SUMMARIZATION_MODEL)
      request(connection: connection(model), input: { inputs: input })
    end

    def text_generation(input:, model: GENERATION_MODEL)
      request(connection: connection(model), input: { inputs: input })
    end

    private

    def request(connection:, input:)
      retries = 0
      while retries < MAX_RETRY
        response = connection.post { |req| req.body = input.to_json }

        break if response.success?

        if response.status == HTTP_SEVICE_UNAVAILABLE
          retries += 1
          sleep 1
          redo
        end

        raise "Error: #{response.body}"
      end

      return JSON.parse(response.body)
    end

    def connection(model)
      Faraday.new(url: "#{HOST}/models/#{model}" , headers: @headers)
    end
  end
end
