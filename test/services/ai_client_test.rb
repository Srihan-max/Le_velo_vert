require 'minitest/autorun'
require_relative '../../app/services/ai_client'

module AiIntegration
  class AiClientTest < Minitest::Test
    def test_missing_api_key_raises
      env_key = ENV['OPENAI_API_KEY']
      ENV['OPENAI_API_KEY'] = ''
      assert_raises(ValidationError) { AiClient.new }
    ensure
      ENV['OPENAI_API_KEY'] = env_key
    end

    def test_empty_messages_rejected
      client = AiClient.allocate
      client.send(:initialize, api_key: 'test')
      assert_raises(ValidationError) { client.send(:validate_messages!, []) }
    end

    def test_too_long_input_rejected
      client = AiClient.allocate
      client.send(:initialize, api_key: 'test')
      long = 'a' * (AiClient::MAX_INPUT_CHARS + 1)
      messages = [{ role: 'user', content: long }]
      assert_raises(ValidationError) { client.send(:validate_messages!, messages) }
    end
  end
end
