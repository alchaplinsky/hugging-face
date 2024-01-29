# hugging-face

🤗 HuggingFace API wrapper for Ruby

## Installation

Install the gem and add to the application's Gemfile by executing:

```
$ bundle add hugging-face
```

If bundler is not being used to manage dependencies, install the gem by executing:

```
$ gem install hugging-face
```

## Usage


### Inference API

The inference API is a free Machine Learning API from Hugging Face. It is meant for prototyping and not produciton use, see below for Inference Endpoints, the product for use with production LLMs.

```ruby
require "hugging_face"
```

Instantiate a HuggingFace Inference API client:

```ruby
client = HuggingFace::InferenceApi.new(api_token: ENV['HUGGING_FACE_API_TOKEN'])
```

Question answering:

```ruby
client.question_answering(
  question: 'What is my name?',
  context: 'I am the only child. My father named his son John.'
)
```

Text generation:

```ruby
client.text_generation(input: 'Can you please let us know more details about your ')
```

Summarization:

```ruby
client.summarization(input: 'The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris. Its base is square, measuring 125 metres (410 ft) on each side. During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, a title it held for 41 years until the Chrysler Building in New York City was finished in 1930.')
```

Embedding:

```ruby
client.embedding(input: ['How to build a ruby gem?', 'How to install ruby gem?'])
```

Sentiment:

```ruby
client.sentiment(input: ['My life sucks', 'Life is a miracle'])
```

### Inference Endpoints

With this same gem, you can also access endpoints, which are best described by Hugging Face: "[Inference Endpoints](https://huggingface.co/docs/inference-endpoints/index) provides a secure production solution to easily deploy models on a dedicated and autoscaling infrastructure managed by Hugging Face. An Inference Endpoint is built from a model from the Hub."

Once you've created an endpoint by choosing a model and desired infrastructure, you'll be given an endpoint URL, something like: https://eyic1edp3ah0g5ln.us-east-1.aws.endpoints.huggingface.cloud

You'll need your token to access your endpoint if you've chosen for it to be protected. You can also choose to have a public endpoint.

Since you choose the LLM task in your endpoint config (e.g. Text Classification, Summarisation, Question answering), there is no need to pass that argument.

To access from the gem. instantiate a HuggingFace Endpoint API client:

```ruby
endpoint = HuggingFace::EndpointsApi.new(api_token: ENV['HUGGING_FACE_API_TOKEN'])
```

Example with input from question answering task:

```ruby
endpoint.request(endpoint_url: "https://your-end-point.us-east-1.aws.endpoints.huggingface.cloud", input: { context: some_text, question: question } 
```

Example call to an endpoint configured for summarisation, including passing params:

```ruby
endpoint.request(endpoint_url: "https://your-end-point.us-east-1.aws.endpoints.huggingface.cloud", input: some_text, params: { min_length:  32, max_length: 64 } )
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alchaplinsky/hugging-face. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/alchaplinsky/hugging-face/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the HuggingFace project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/alchaplinsky/hugging-face/blob/main/CODE_OF_CONDUCT.md).

