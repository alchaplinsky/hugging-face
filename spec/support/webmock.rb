require 'webmock/rspec'

module WebmockStubs
  def stub_hugging_face_inference_api(url:, input:, output:, content_type: 'application/json')
    stub_request(:post, url).
      with(
        body: input.to_json,
        headers: {
          'Authorization' => "Bearer HUGGING_FACE_TOKEN",
          'Content-Type' => 'application/json'
        }
      ).
      to_return(
        status: 200,
        body: output,
        headers: { 'Content-Type' => content_type }
      )
  end
end
