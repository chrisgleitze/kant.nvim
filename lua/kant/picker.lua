local M = {}
local kant = require("kant")

--- Show list of works — select a work, then open or search it
function M.werke()
  local texts_dir = kant.config.texts_dir
  local picker = kant.config.picker

  -- Collect subdirectories as works
  local werke = {}
  local handle = vim.loop.fs_scandir(texts_dir)
  if not handle then
    vim.notify("[kant.nvim] Text directory not readable: " .. texts_dir, vim.log.levels.ERROR)
    return
  end
  while true do
    local name, typ = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if typ == "directory" and not name:match("^%.") then
      table.insert(werke, name)
    end
  end
  table.sort(werke)

  if #werke == 0 then
    vim.notify("[kant.nvim] No works found in " .. texts_dir, vim.log.levels.WARN)
    return
  end

  if picker == "fzf-lua" then
    M._werke_fzf(werke, texts_dir)
  else
    M._werke_select(werke, texts_dir)
  end
end

function M._werke_fzf(werke, texts_dir)
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    M._werke_select(werke, texts_dir)
    return
  end

  -- Format titles nicely
  local display = {}
  for _, w in ipairs(werke) do
    table.insert(display, w:gsub("-", " "):gsub("^%l", string.upper))
  end

  fzf.fzf_exec(display, {
    prompt = "Werk> ",
    winopts = {
      title = " Kant's Works ",
      title_pos = "center",
    },
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then return end
        local idx = nil
        for i, d in ipairs(display) do
          if d == selected[1] then idx = i; break end
        end
        if idx then
          local search = require("kant.search")
          -- Open search within the selected work
          local werk_dir = texts_dir .. "/" .. werke[idx]
          local orig_dir = kant.config.texts_dir
          kant.config.texts_dir = werk_dir
          search.search("")
          kant.config.texts_dir = orig_dir
        end
      end,
    },
  })
end

function M._werke_select(werke, texts_dir)
  vim.ui.select(werke, {
    prompt = "Select work:",
    format_item = function(w)
      return w:gsub("-", " "):gsub("^%l", string.upper)
    end,
  }, function(choice)
    if not choice then return end
    local search = require("kant.search")
    local orig_dir = kant.config.texts_dir
    kant.config.texts_dir = texts_dir .. "/" .. choice
    search.search("")
    kant.config.texts_dir = orig_dir
  end)
end

--- Open a random passage from a random work
function M.zufall()
  local texts_dir = kant.config.texts_dir

  -- Collect all text files
  local files = vim.fn.globpath(texts_dir, "**/*.txt", false, true)
  if #files == 0 then
    vim.notify("[kant.nvim] No text files found.", vim.log.levels.WARN)
    return
  end

  math.randomseed(os.time())
  local file = files[math.random(#files)]
  local lines = vim.fn.readfile(file)

  -- Skip metadata header (--- ... ---)
  local start = 1
  if lines[1] and lines[1]:match("^%-%-%-") then
    for i = 2, #lines do
      if lines[i]:match("^%-%-%-") then
        start = i + 1
        break
      end
    end
  end

  -- Collect non-empty lines
  local content_lines = {}
  for i = start, #lines do
    if lines[i] and lines[i]:match("%S") then
      table.insert(content_lines, i)
    end
  end

  if #content_lines == 0 then
    vim.notify("[kant.nvim] Empty file: " .. file, vim.log.levels.WARN)
    return
  end

  local line_nr = content_lines[math.random(#content_lines)]

  -- Open file and jump to line
  vim.cmd("edit " .. vim.fn.fnameescape(file))
  vim.api.nvim_win_set_cursor(0, { line_nr, 0 })
  vim.cmd("normal! zz")

  if kant.config.readonly then
    vim.bo.readonly = true
    vim.bo.modifiable = false
  end
end

return M
