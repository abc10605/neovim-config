local function is_vault(bufnr)
  local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
  return first_line:match "^%$ANSIBLE_VAULT" ~= nil
end

local function decrypt(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local result = vim.fn.system {
    "ansible-vault",
    "decrypt",
    "--output",
    "-",
    file,
  }

  if vim.v.shell_error ~= 0 then
    vim.notify("Decrypt failed: " .. result, vim.log.levels.ERROR)
    return
  end

  local lines = vim.split(result, "\n", { trimempty = true })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modified = false
  vim.b[bufnr].is_vault = true -- mark for later encryption
end

local function encrypt(bufnr)
  local file = vim.api.nvim_buf_get_name(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local tmp = vim.fn.tempname() .. ".yml"

  vim.fn.writefile(lines, tmp)

  vim.fn.system {
    "ansible-vault",
    "encrypt",
    "--output",
    file,
    tmp,
  }

  vim.fn.delete(tmp)

  if vim.v.shell_error ~= 0 then
    vim.notify("Encrypt failed!", vim.log.levels.ERROR)
    return
  end

  vim.bo[bufnr].modified = false
  vim.notify("🔒 Vault saved and encrypted", vim.log.levels.INFO)
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      AnsibleVault = {
        {
          event = "BufReadPost",
          desc = "Decrypt vault",
          pattern = { "*.yml", "*.yaml" },
          callback = function(args)
            if is_vault(args.buf) then decrypt(args.buf) end
          end,
        },
        {
          event = "BufWriteCmd",
          desc = "Save and encrypt vault",
          pattern = { "*.yml", "*.yaml" },
          callback = function(args)
            if vim.b[args.buf].is_vault then
              encrypt(args.buf)
            else
              vim.cmd "noautocmd write"
            end
          end,
        },
      },
    },
  },
}
