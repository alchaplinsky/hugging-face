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


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alchaplinsky/hugging-face. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/alchaplinsky/hugging-face/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the HuggingFace project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/alchaplinsky/hugging-face/blob/main/CODE_OF_CONDUCT.md).

