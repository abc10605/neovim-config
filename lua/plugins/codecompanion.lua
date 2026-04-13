---@type LazySpec
return {
  "olimorris/codecompanion.nvim",
  opts = {
    interactions = {
      chat = {
        adapter = "openrouter",
      },
      inline = {
        adapter = "openrouter",
      },
    },
    adapters = {
      http = {
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "cmd: op read 'op://Private/OpenRouter API - Neovim/credential' --no-newline",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "anthropic/claude-sonnet-4-6",
                choices = {
                  ["anthropic/claude-sonnet-4-6"] = {},
                  ["anthropic/claude-opus-4.6"] = {},
                  ["qwen/qwen3.6-plus"] = {},
                  ["z-ai/glm-5.1"] = {},
                  ["deepseek/deepseek-v3.2"] = {},
                  ["minimax/minimax-m2.7"] = {},
                  ["xiaomi/mimo-v2-pro"] = {},
                  ["moonshotai/kimi-k2.5"] = {},
                },
              },
            },
          })
        end,
      },
    },
  },
  specs = {
    {
      "HakonHarnes/img-clip.nvim",
      optional = true,
      opts = {
        filetypes = {
          codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
          },
        },
      },
    },
  },
}
