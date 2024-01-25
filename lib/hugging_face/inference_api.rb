module HuggingFace
  class InferenceApi < BaseApi
    HOST = "https://api-inference.huggingface.co"

    # Retry connecting to the model for 1 minute
    MAX_RETRY = 60

    # Default models that can be overriden by 'model' param
    QUESTION_ANSWERING_MODEL = 'distilbert-base-cased-distilled-squad'
    SUMMARIZATION_MODEL = "sshleifer/distilbart-xsum-12-6"
    GENERATION_MODEL = "distilgpt2"
    EMBEDING_MODEL = "sentence-transformers/all-MiniLM-L6-v2"
    SENTIMENT_MODEL = "distilbert-base-uncased-finetuned-sst-2-english"

    def call(input:, model:)
      request(connection: connection(model), input: input)
    end

    def question_answering(question:, context:, model: QUESTION_ANSWERING_MODEL)
      input = { question: question, context: context }

      request connection: connection(model), input: input
    end

    def summarization(input:, model: SUMMARIZATION_MODEL)
      request connection: connection(model), input: { inputs: input }
    end

    def text_generation(input:, model: GENERATION_MODEL)
      request connection: connection(model), input: { inputs: input }
    end

    def embedding(input:, model: EMBEDING_MODEL)
      request connection: connection(model), input: { inputs: input }
    end

    def sentiment(input:, model: SENTIMENT_MODEL)
      request connection: connection(model), input: { inputs: input }
    end    
        

    private

    def connection(model)
      if model == EMBEDING_MODEL
        build_connection "#{HOST}/pipeline/feature-extraction/#{model}"
      else
        build_connection "#{HOST}/models/#{model}"
      end
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
