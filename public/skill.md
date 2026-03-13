# BMBL AI — Agent Onboarding

You are configuring a developer's machine to connect to the BMBL AI gateway.
Follow these steps exactly. Ask the user for input where indicated.

## Prerequisites

- The user must have [OpenCode](https://opencode.ai) installed
- The user must have [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode) installed

If either is missing, install them:
```bash
curl -fsSL https://opencode.ai/install | bash
bunx oh-my-opencode install
```

## Step 1: Get the API key

Ask the user:
> "What is your BMBL LiteLLM API key? (Get it from your lab admin if you don't have one.)"

Store the key they provide as `$USER_API_KEY`.

## Step 2: Set the environment variable

Add the API key to the user's shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
export BMBL_LITELLM_API_KEY="$USER_API_KEY"
```

Then reload the shell: `source ~/.zshrc` (or equivalent).

## Step 3: Configure OpenCode provider

Read `~/.config/opencode/opencode.json`. Add or update the `bmbl-litellm` provider in the `provider` object:

```json
{
  "bmbl-litellm": {
    "npm": "@ai-sdk/openai-compatible",
    "name": "BMBL LiteLLM",
    "options": {
      "name": "bmbl-litellm",
      "apiKey": "{env:BMBL_LITELLM_API_KEY}",
      "baseURL": "https://bmblx.bmi.osumc.edu/ai/v1"
    },
    "models": {
      "minimax-m2.5": {
        "name": "MiniMax M2.5 (BMBL)",
        "limit": { "context": 196608, "output": 16384 },
        "modalities": { "input": ["text"], "output": ["text"] }
      },
      "glm-5": {
        "name": "GLM-5 (BMBL)",
        "limit": { "context": 131072, "output": 8192 },
        "modalities": { "input": ["text"], "output": ["text"] }
      },
      "gpt-4o": {
        "name": "GPT-4o (BMBL)",
        "limit": { "context": 128000, "output": 16384 },
        "modalities": { "input": ["text", "image"], "output": ["text"] }
      },
      "gpt-5.2": {
        "name": "GPT-5.2 (BMBL)",
        "limit": { "context": 128000, "output": 16384 },
        "modalities": { "input": ["text", "image"], "output": ["text"] }
      },
      "kimi-k2.5": {
        "name": "Kimi-K2.5 (BMBL)",
        "limit": { "context": 131072, "output": 8192 },
        "modalities": { "input": ["text"], "output": ["text"] }
      },
      "gpt-5.3-codex": {
        "name": "GPT-5.3 Codex (BMBL)",
        "limit": { "context": 192000, "output": 32768 },
        "modalities": { "input": ["text", "image"], "output": ["text"] }
      }
    }
  }
}
```

Also set the default model in the top-level config:
```json
{
  "model": "bmbl-litellm/minimax-m2.5"
}
```

## Step 4: Configure oh-my-opencode agent routing

Read `~/.config/opencode/oh-my-opencode.json`. Set all agents and categories to use BMBL models:

```json
{
  "agents": {
    "sisyphus": { "model": "bmbl-litellm/minimax-m2.5", "variant": "default" },
    "oracle": { "model": "bmbl-litellm/minimax-m2.5", "variant": "default" },
    "librarian": { "model": "bmbl-litellm/minimax-m2.5" },
    "explore": { "model": "bmbl-litellm/minimax-m2.5" },
    "multimodal-looker": { "model": "bmbl-litellm/minimax-m2.5" },
    "prometheus": { "model": "bmbl-litellm/gpt-5.3-codex", "variant": "max" },
    "metis": { "model": "bmbl-litellm/gpt-5.3-codex", "variant": "max" },
    "momus": { "model": "bmbl-litellm/gpt-5.3-codex", "variant": "max" },
    "atlas": { "model": "bmbl-litellm/minimax-m2.5" },
    "frontend-ui-ux-engineer": { "model": "bmbl-litellm/minimax-m2.5" },
    "document-writer": { "model": "bmbl-litellm/minimax-m2.5" }
  },
  "categories": {
    "visual-engineering": { "model": "bmbl-litellm/gpt-5.3-codex", "variant": "max" },
    "ultrabrain": { "model": "bmbl-litellm/gpt-5.3-codex", "variant": "max" },
    "quick": { "model": "bmbl-litellm/minimax-m2.5" },
    "unspecified-low": { "model": "bmbl-litellm/minimax-m2.5" },
    "unspecified-high": { "model": "bmbl-litellm/gpt-5.3-codex", "variant": "max" },
    "writing": { "model": "bmbl-litellm/minimax-m2.5" }
  }
}
```

## Step 5: Verify connection

Run this command to verify the API key works:

```bash
curl -s -H "Authorization: Bearer $BMBL_LITELLM_API_KEY" https://bmblx.bmi.osumc.edu/ai/v1/models | head -20
```

You should see a JSON response listing available models. If you get an auth error, the API key is wrong — ask the user to double-check.

## Step 6: Test a completion

Send a quick test message:

```bash
curl -s https://bmblx.bmi.osumc.edu/ai/v1/chat/completions \
  -H "Authorization: Bearer $BMBL_LITELLM_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "minimax-m2.5", "messages": [{"role": "user", "content": "Say hello"}], "max_tokens": 50}'
```

If you get a valid response, tell the user:
> "You're all set! BMBL AI is configured. Your default model is MiniMax M2.5. Run `opencode` to start coding."

## Available Models

| Model | Best for | Pricing (per M tokens) |
|-------|----------|----------------------|
| minimax-m2.5 | General use, default | $0.30 in / $1.20 out |
| gpt-5.3-codex | Code generation | $2.50 in / $10.00 out |
| glm-5 | Reasoning, analysis | $0.50 in / $2.00 out |
| gpt-4o | Multimodal (text+image) | $2.50 in / $10.00 out |
| gpt-5.2 | Complex reasoning | $2.50 in / $10.00 out |
| kimi-k2.5 | Math, reasoning | $0.60 in / $2.40 out |

## Troubleshooting

- **Auth error**: API key is wrong or expired. Contact lab admin.
- **Model not found**: Check spelling. Model names are case-sensitive.
- **Timeout**: The gateway is at `bmblx.bmi.osumc.edu` — requires OSU network or VPN.
