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

  describe '#sentiment' do
    let(:text)  { 'Text to analyse' }
    let(:input) { { inputs: text } }
    let(:output) { [{"label"=>"NEGATIVE", "score"=>0.999495267868042}, {"label"=>"POSITIVE", "score"=>0.0005046788137406111}].to_json }

    context 'with no model provided'  do
      let(:url) { "https://api-inference.huggingface.co/models/sshleifer/distilbart-xsum-12-6" }

      subject { api.sentiment(input: text) }

      it { is_expected.to eq([{"label"=>"NEGATIVE", "score"=>0.999495267868042}, {"label"=>"POSITIVE", "score"=>0.0005046788137406111}]) }
    end

    context 'with model provided' do
      let(:url) { "https://api-inference.huggingface.co/models/custom-model" }

      subject { api.sentiment(input: text, model: 'custom-model') }

      it { is_expected.to eq([{"label"=>"NEGATIVE", "score"=>0.999495267868042}, {"label"=>"POSITIVE", "score"=>0.0005046788137406111}]) }
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

  describe '#embedding' do
    let(:text)  { 'Generate an embedding' }
    let(:input) { { inputs: text } }
    let(:output) do
      [[0.05994785204529762,
        0.10895846039056778,
        0.03463876247406006,]
      ].to_json
    end

    context 'with default provided'  do
      let(:url) { "https://api-inference.huggingface.co/pipeline/feature-extraction/sentence-transformers/all-MiniLM-L6-v2" }

      subject { api.embedding(input: text) }

      it { is_expected.to eq([[0.05994785204529762, 0.10895846039056778,0.03463876247406006]]) }
    end
  end
end
