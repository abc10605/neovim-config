return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>pr"] = {
            function()
              local plugins = require("lazy").plugins()
              local items = vim.tbl_map(function(p)
                return {
                  text = p.name,
                  name = p.name,
                  file = p.dir or "", -- snacks needs a `file` field
                }
              end, plugins)

              table.sort(items, function(a, b) return a.text < b.text end)

              require("snacks").picker.pick(
                ---@type snacks.picker.Config
                {
                  title = "Plugins",
                  items = items,
                  format = function(item, _)
                    return {
                      { item.name, "Function" },
                    }
                  end,
                  preview = "none",
                  layout = {
                    preset = "select", -- compact dropdown style, no preview pane
                  },
                  confirm = function(picker, item)
                    picker:close()
                    require("lazy.core.loader").reload(item.text)
                    vim.notify("Reloaded: " .. item.text, vim.log.levels.INFO)
                  end,
                }
              )
            end,
            desc = "Reload plugin",
          },
        },
      },
    },
  },
}
