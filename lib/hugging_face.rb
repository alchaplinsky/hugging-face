# frozen_string_literal: true

require_relative "hugging_face/version"
require_relative "hugging_face/base_api"
require_relative "hugging_face/inference_api"
require_relative "hugging_face/endpoints_api"

module HuggingFace
  class Error < StandardError; end
  class ServiceUnavailable < Error; end
  # Your code goes here...
end
