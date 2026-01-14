require_relative 'ai_client'

module AiIntegration
  class AiService
    MAX_PROMPT_CHARS = 50_000

    def initialize(client: AiClient.new)
      @client = client
    end

    # prompt: String user prompt
    # context: optional system prompt or hash
    # returns a Hash with :ok, :content or :error
    def ask(prompt:, context: nil)
      raise ValidationError, 'Prompt must be a String' unless prompt.is_a?(String)
      trimmed = prompt.to_s.strip
      raise ValidationError, 'Prompt is empty' if trimmed.empty?
      raise ValidationError, "Prompt too long (#{trimmed.length} chars)" if trimmed.length > MAX_PROMPT_CHARS

      system_msg = if context.is_a?(String) && !context.strip.empty?
                     { role: 'system', content: context }
                   else
                     { role: 'system', content: "You are an assistant for Le Vélo Vert, a French bike rental service. Answer concisely and stay on-topic about bikes, routes, and reservations." }
                   end

      messages = [system_msg, { role: 'user', content: trimmed }]

      begin
        res = @client.chat(messages: messages)
        { ok: true, content: res[:content], role: res[:role], raw: res[:raw] }
      rescue Error => e
        { ok: false, error: e.message, class: e.class.name }
      end
    end
  end
end
