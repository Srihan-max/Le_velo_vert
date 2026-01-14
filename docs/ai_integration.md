# AI Integration — Error handling, validation, tests, and integration

This document summarizes required improvements and gives concrete artifacts added to the repository.

**1. Error handling**
- Network errors: `AiClient` rescues `Timeout::Error`, `Errno::ECONNREFUSED`, `SocketError` and raises `AiIntegration::NetworkError`.
- Authentication errors: HTTP 401/403 map to `AiIntegration::AuthenticationError`.
- Server errors: HTTP 5xx map to `AiIntegration::ServerError`.
- Malformed JSON: parsed response errors raise `AiIntegration::MalformedResponseError`.
- Unexpected structure: missing `choices[0].message` raises `MalformedResponseError`.

Why it matters: calls to external AI providers fail; explicit exceptions allow the web app to show friendly errors and log incidents.

**2. Input validation**
- Reject empty input and non-string prompts.
- Enforce a maximum character limit (`MAX_INPUT_CHARS`) to avoid huge requests.
- `AiClient#validate_messages!` verifies message shape and total length.

Why it matters: prevents crashes and accidental high-cost or abusive calls.

**3. Clear test criteria (evaluation matrix)**
- Relevance: answer uses bike-related vocabulary (VTT, vélo électrique, tarif, réservation).
- Accuracy: no invented services (e.g., "livraison de vélos")—answers must not invent features.
- Tone: professional and friendly (customer-facing).
- Context respect: answers mention Le Vélo Vert when appropriate and follow locale/language (French).
- Off-topic resistance: for unrelated queries, reply with a gentle redirect or refusal.

Acceptance rule: an AI reply is acceptable if it mentions at least one bike-related term and does not invent new services.

**4. Test cases**

| Test case | Input | Expected behavior |
|---|---:|---|
| Normal | "Quels vélos proposez-vous ?" | List known bike types (VTT, vélo de ville, électrique) |
| Edge time | "Location à 3h du matin" | Explain typical opening hours or how to contact admin |
| Empty | "" | Reject locally with validation error, do not call AI |
| Very long | 100k chars | Reject locally as too long |
| Off-topic | "Relativité" | Redirect: "Je peux aider sur la location de vélos..." |
| Malformed JSON (simulated) | N/A | System logs error, returns friendly "service indisponible" message |

**5. Separation of concerns**
- `app/services/ai_client.rb` — low-level HTTP, error handling, JSON parsing.
- `app/services/ai_service.rb` — business wrapper (prompt validation, system context, sanitized output).
- Controllers/views should call `AiIntegration::AiService` and handle returned `{ok: true|false}` accordingly.

**6. Security & ethics**
- Store API keys in environment variables (`OPENAI_API_KEY`). Do not commit keys.
- Log minimal metadata only (status codes, error classes), avoid logging full user-submitted personal data.
- GDPR: treat prompts as potentially personal data; document retention policy and provide an option to not store prompts.
- Hallucinations: never let AI invent contractual or legal claims; validate critical facts server-side.

**7. Integration with the website (conceptual)**
- Architecture: User → Rails controller → `AiIntegration::AiService` → `AiIntegration::AiClient` → AI provider.
- Controller example pseudocode:

```ruby
service = AiIntegration::AiService.new
result = service.ask(prompt: params[:q])
if result[:ok]
  render json: { answer: result[:content] }
else
  render json: { error: result[:error] }, status: 503
end
```

**Files added**
- `app/services/ai_client.rb`
- `app/services/ai_service.rb`
- `test/services/ai_client_test.rb`

**Run tests**
```
bundle install
rails test test/services/ai_client_test.rb
```

Next steps: add controller integration, acceptance tests (integration / system), and optional request-mocking (WebMock) for deeper test coverage.
