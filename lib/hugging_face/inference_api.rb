module HuggingFace
  class InferenceApi < BaseApi
    HOST = "https://api-inference.huggingface.co"
    MAX_RETRY = 20

    QUESTION_ANSWERING_MODEL = 'distilbert-base-cased-distilled-squad'
    SUMMARIZATION_MODEL = "sshleifer/distilbart-xsum-12-6"
    GENERATION_MODEL = "distilgpt2"

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

    def connection(model)
      super "#{HOST}/models/#{model}"
    end

    def request(connection:, input:)
      retries = 0

      begin
        return super(connection: connection, input: input)
      rescue ServiceUnavailable => exception

        if retries < MAX_RETRY
          logger.debug('Service unavailable, retrying...')
          retries += 1
          sleep 1
          retry
        else
          raise exception
        end
      end
    end
  end
end