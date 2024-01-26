module HuggingFace
  class EndpointsApi < BaseApi

    def request(endpoint_url:, input:)
      retries = 0

      endpoint_connection = build_connection endpoint_url

      begin
        return super(connection: endpoint_connection, input: { inputs: input })
      rescue ServiceUnavailable => exception

        if retries < MAX_RETRY
          logger.debug('Service unavailable, retrying...')
          retries += 1
          sleep 5
          retry
        else
          raise exception
        end
      end
    end  
        

    private


  end
end
