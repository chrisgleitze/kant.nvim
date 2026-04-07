local M = {}
local kant = require("kant")

--- Volltextsuche ueber alle Kant-Texte via ripgrep
---@param query string|nil Suchbegriff (nil oeffnet leeren Picker)
function M.search(query)
  local texts_dir = kant.config.texts_dir
  local picker = kant.config.picker

  if picker == "fzf-lua" then
    M._search_fzf(query, texts_dir)
  elseif picker == "telescope" then
    M._search_telescope(query, texts_dir)
  else
    vim.notify("[kant.nvim] Unbekannter Picker: " .. picker, vim.log.levels.ERROR)
  end
end

function M._search_fzf(query, texts_dir)
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("[kant.nvim] fzf-lua nicht installiert.", vim.log.levels.ERROR)
    return
  end

  fzf.grep({
    search = query or "",
    cwd = texts_dir,
    prompt = "Kant> ",
    no_esc = false,
    file_ignore_patterns = { "%.git/" },
    winopts = {
      title = " Kant-Quelltexte ",
      title_pos = "center",
      preview = {
        title = " Vorschau ",
        title_pos = "center",
      },
    },
    actions = {
      ["default"] = function(selected, opts)
        -- Datei read-only oeffnen wenn konfiguriert
        local action = require("fzf-lua.actions")
        action.file_edit(selected, opts)
        if kant.config.readonly then
          vim.bo.readonly = true
          vim.bo.modifiable = false
        end
      end,
    },
  })
end

function M._search_telescope(query, texts_dir)
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("[kant.nvim] telescope.nvim nicht installiert.", vim.log.levels.ERROR)
    return
  end

  builtin.live_grep({
    cwd = texts_dir,
    default_text = query or "",
    prompt_title = "Kant-Suche",
  })
end

return M
