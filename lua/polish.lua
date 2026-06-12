-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- UPSC Note Jump Functionality
local function goto_upsc_note()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local word

  -- Check for wiki-link [[Topic]] or [[Topic|Alias]]
  local link_pattern = "%[%[([^%]]+)%]%]"
  local start_pos, end_pos, link_text = 0, 0, nil
  while true do
    start_pos, end_pos, link_text = line:find(link_pattern, end_pos + 1)
    if not start_pos then break end
    if col >= start_pos and col <= end_pos then
      -- Handle aliases [[Topic|Alias]]
      word = link_text:match "([^|]+)"
      break
    end
  end

  -- Fallback to word under cursor
  if not word then word = vim.fn.expand "<cword>" end
  if not word or word == "" then return end

  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- Only run in the UPSC directory
  if not bufname:match "study/prep/upsc" then
    if pcall(vim.lsp.buf.definition) then return end
    vim.notify("Not in UPSC directory and no LSP definition found.", vim.log.levels.INFO)
    return
  end

  local search_dir = "/home/abhishek/study/prep/upsc"
  local graph_path = search_dir .. "/graphify-out/graph.json"
  local files = {}

  -- 1. Try Graphify Search (Robust for long/descriptive labels)
  if vim.fn.filereadable(graph_path) == 1 then
    local python_cmd = string.format(
      [[python3 -c "import json, sys; d = json.load(open('%s')); word = sys.argv[1].lower(); print('\n'.join(set(n['source_file'] for n in d['nodes'] if 'label' in n and (word in n['label'].lower() or n['label'].lower() in word))))" "%s"]],
      graph_path,
      word:gsub('"', '\\"'):gsub("`", "")
    )
    local handle = io.popen(python_cmd)
    local result = handle:read "*a"
    handle:close()
    for file in result:gmatch "[^\r\n]+" do
      if file:match "%.md$" then table.insert(files, search_dir .. "/" .. file) end
    end
  end

  -- 2. Fallback to Filename Search (refined)
  if #files == 0 then
    -- Clean up word: replace spaces with underscores, remove special chars that break find/filenames
    local clean_word = word:gsub(" ", "_"):gsub("[%:%?%!%']", "")
    local shell_word = clean_word:gsub("'", "'\\''")
    local pattern = "*" .. shell_word .. "*"

    -- Use find to get matching .md files, limit depth for performance
    local cmd = string.format('find %s -maxdepth 4 -type f -name "%s.md" -o -name "%s_notes.md"', search_dir, pattern, pattern)
    local handle = io.popen(cmd)
    local result = handle:read "*a"
    handle:close()

    for file in result:gmatch "[^\r\n]+" do
      -- Avoid duplicates from graph search
      local found = false
      for _, f in ipairs(files) do
        if f == file then
          found = true
          break
        end
      end
      if not found then table.insert(files, file) end
    end
  end

  if #files == 0 then
    -- Ask to create note
    vim.ui.input({ prompt = "Note not found. Create? (y/n/LSP): " }, function(input)
      if input == "y" then
        -- Default to 10_Current_Affairs
        local new_file = search_dir .. "/10_Current_Affairs/" .. word:gsub(" ", "_"):gsub("[%:%?%!%']", "") .. ".md"
        vim.cmd("edit " .. vim.fn.fnameescape(new_file))
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# " .. word, "", "**Context:** ", "**Relevance:** ", "" })
      elseif input == "LSP" or input == "" then
        if not pcall(vim.lsp.buf.definition) then vim.notify("No definition found.", vim.log.levels.INFO) end
      end
    end)
  elseif #files == 1 then
    vim.cmd("edit " .. vim.fn.fnameescape(files[1]))
  else
    if pcall(require, "snacks") then
      local items = {}
      for _, f in ipairs(files) do
        local rel_path = f:sub(#search_dir + 2)
        table.insert(items, { text = rel_path, file = f })
      end
      require("snacks").picker.select(items, {
        prompt = "Select Note",
        format = function(item) return { { item.text, "SnacksPickerLabel" } } end,
      }, function(item) vim.cmd("edit " .. vim.fn.fnameescape(item.file)) end)
    else
      local options = { "Multiple notes found:" }
      for i, f in ipairs(files) do
        table.insert(options, i .. ". " .. f:sub(#search_dir + 2))
      end
      local choice = vim.fn.inputlist(options)
      if choice > 0 and choice <= #files then vim.cmd("edit " .. vim.fn.fnameescape(files[choice])) end
    end
  end
end

-- Map gd in markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "gd", goto_upsc_note, { buffer = true, desc = "Jump to UPSC Note" })
    -- Add /quiz functionality: it will send the content to Gemini via a notification/command
    vim.keymap.set("n", "<Leader>qz", function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if not bufname:match "study/prep/upsc" then
        vim.notify("Not a UPSC note!", vim.log.levels.ERROR)
        return
      end
      vim.cmd("split | term python3 /home/abhishek/study/prep/upsc/scripts/quiz_gen.py " .. vim.fn.fnameescape(bufname))
    end, { buffer = true, desc = "Generate UPSC Quiz for this note" })
  end,
})
