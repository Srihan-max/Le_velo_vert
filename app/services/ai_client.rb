require 'net/http'
require 'uri'
require 'json'

module AiIntegration
  class Error < StandardError; end
  class NetworkError < Error; end
  class AuthenticationError < Error; end
  class ServerError < Error; end
  class MalformedResponseError < Error; end
  class ValidationError < Error; end

  class AiClient
    DEFAULT_TIMEOUT = 10
    MAX_INPUT_CHARS = 50_000

    def initialize(api_key: ENV['OPENAI_API_KEY'], endpoint: ENV['AI_ENDPOINT'] || 'https://api.openai.com/v1/chat/completions')
      @api_key = api_key
      raise ValidationError, 'Missing API key (ENV[OPENAI_API_KEY])' if @api_key.to_s.strip.empty?
      @endpoint = endpoint
    end

    # messages: array of {role: 'user'|'system'|'assistant', content: '...'}
    def chat(messages:, model: 'gpt-4', timeout: DEFAULT_TIMEOUT)
      validate_messages!(messages)

      uri = URI.parse(@endpoint)
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req['Authorization'] = "Bearer #{@api_key}"
      body = { model: model, messages: messages }
      req.body = JSON.generate(body)

      begin
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == 'https'
        http.read_timeout = timeout
        res = http.request(req)
      rescue Timeout::Error, Errno::ECONNREFUSED, SocketError => e
        raise NetworkError, "Network error contacting AI provider: #{e.class}: #{e.message}"
      end

      case res.code.to_i
      when 200
        parse_response(res.body)
      when 401, 403
        raise AuthenticationError, "Authentication failed (#{res.code})"
      when 400..499
        raise Error, "Client error from AI provider: #{res.code} - #{res.body}"
      when 500..599
        raise ServerError, "AI provider server error: #{res.code}"
      else
        raise Error, "Unexpected response code from AI provider: #{res.code}"
      end
    end

    private

    def validate_messages!(messages)
      unless messages.is_a?(Array) && messages.all? { |m| m.is_a?(Hash) && m['content'] || m[:content] }
        raise ValidationError, '`messages` must be an Array of Hashes with a `content` key'
      end

      total_chars = messages.map { |m| (m[:content] || m['content'] || '').to_s.length }.sum
      raise ValidationError, 'Input is empty' if total_chars == 0
      raise ValidationError, "Input too long (#{total_chars} chars)" if total_chars > MAX_INPUT_CHARS
    end

    def parse_response(body)
      begin
        data = JSON.parse(body)
      rescue JSON::ParserError => e
        raise MalformedResponseError, "Malformed JSON from AI provider: #{e.message}"
      end

      # Basic structural validation
      if data['choices'] && data['choices'].first && data['choices'].first['message']
        message = data['choices'].first['message']
        return { role: message['role'], content: message['content'], raw: data }
      end

      raise MalformedResponseError, 'AI response missing expected `choices[0].message` structure'
    end
  end
end
