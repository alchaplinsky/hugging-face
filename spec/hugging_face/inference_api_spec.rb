# frozen_string_literal: true

require 'spec_helper'
require 'support/webmock'

RSpec.describe HuggingFace::InferenceApi do
  include WebmockStubs

  let(:api) { described_class.new(api_token: 'HUGGING_FACE_TOKEN') }
  let(:content_type) { 'application/json' }

  before do
    stub_hugging_face_inference_api(
      url: url,
      input: input,
      output: output,
      content_type: content_type
    )
  end

  describe '#call' do
    let(:model) { 'distilgpt2' }
    let(:url) { "https://api-inference.huggingface.co/models/#{model}" }
    let(:input) { { inputs: 'What is the capital of France?' } }

    subject { api.call(input: input, model: model) }

    context 'when the response is JSON' do
      let(:output) { { 'answer' => 'Paris' }.to_json }

      it { is_expected.to eq({ 'answer' => 'Paris' }) }
    end

    context 'when the response is not JSON' do
      let(:output) { 'RAW_DATA' }
      let(:content_type) { 'text/plain' }

      it { is_expected.to eq('RAW_DATA') }
    end
  end

  describe '#question_answering' do
    let(:input) { { question: 'What is the capital of France?', context: 'Paris is the capital of France' } }
    let(:output) { { 'answer' => 'Paris' }.to_json }

    context 'with no model provided'  do
      let(:url) { "https://api-inference.huggingface.co/models/distilbert-base-cased-distilled-squad" }

      subject { api.question_answering(**input) }

      it { is_expected.to eq({ 'answer' => 'Paris' }) }
    end

    context 'with model provided' do
      let(:url) { "https://api-inference.huggingface.co/models/custom-model" }

      subject { api.question_answering(**input, model: 'custom-model') }

      it { is_expected.to eq({ 'answer' => 'Paris' }) }
    end
  end

  describe '#summarization' do
    let(:text)  { 'Text to summarize' }
    let(:input) { { inputs: text } }
    let(:output) { { 'summary' => 'This is summary' }.to_json }

    context 'with no model provided'  do
      let(:url) { "https://api-inference.huggingface.co/models/sshleifer/distilbart-xsum-12-6" }

      subject { api.summarization(input: text) }

      it { is_expected.to eq({ 'summary' => 'This is summary' }) }
    end

    context 'with model provided' do
      let(:url) { "https://api-inference.huggingface.co/models/custom-model" }

      subject { api.summarization(input: text, model: 'custom-model') }

      it { is_expected.to eq({ 'summary' => 'This is summary' }) }
    end
  end

  describe '#text_generation' do
    let(:text)  { 'Generate next word ' }
    let(:input) { { inputs: text } }
    let(:output) { [{ 'generated_text' => 'Generate next word for me' }].to_json }

    context 'with no model provided'  do
      let(:url) { "https://api-inference.huggingface.co/models/distilgpt2" }

      subject { api.text_generation(input: text) }

      it { is_expected.to eq([{ 'generated_text' => 'Generate next word for me' }]) }
    end

    context 'with model provided' do
      let(:url) { "https://api-inference.huggingface.co/models/custom-model" }

      subject { api.text_generation(input: text, model: 'custom-model') }

      it { is_expected.to eq([{ 'generated_text' => 'Generate next word for me' }]) }
    end
  end
end
