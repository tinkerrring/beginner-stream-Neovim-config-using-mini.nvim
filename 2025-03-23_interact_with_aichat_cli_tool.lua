-- prerequisite is that the aichat CLI tool is installed with some 1+ model API keys
-- https://github.com/sigoden/aichat
-- read the current line and send to aichat CLI {{{
function My_aichat_current_line()
  -- Get the current line text
  local current_line = vim.api.nvim_get_current_line()
  vim.api.nvim_command("normal o")
  local aichat_command = ':read !aichat ' .. current_line
  vim.cmd(aichat_command)
end

-- }}}
-- read the entire buffer and send to aichat CLI {{{
function My_aichat_current_file()
  -- Get all from current file
  -- `0` represents the current buffer (file).
  -- `0` is the start line (beginning of the file).
  -- `-1` is the end line (end of the file).
  -- `true` is a flag that determines whether to include the newline character (`\n`) at the end of each line. If `true`, the newline character is included.
  local current_file_table = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local current_file = vim.inspect(current_file_table)
  -- print(current_file)
  vim.api.nvim_command("normal Go")
  local aichat_command = ':read !aichat ' .. current_file
  vim.cmd(aichat_command)
end

-- }}}
-- read the selection and send to aichat CLI {{{
function My_aichat_visual_select()
  local vstart = vim.fn.getpos "'<"
  local vend = vim.fn.getpos "'>"
  local line_start = vstart[2]
  local line_end = vend[2]
  -- or maybe use of api.nvim_buf_get_lines is better the vim.fn.getline?
  local lines = vim.fn.getline(line_start, line_end)
  local result = ""
  for i = 1, #lines, 1 do
    result = result .. lines[i] .. " "
  end
  local aichat_command = ':read !aichat ' .. result
  vim.cmd('normal Go')
  vim.cmd(aichat_command)
end

-- }}}
-- create a menu to select from different LLM models for which I have an API key {{{
-- please adjust this to what you have and like!
function My_show_menu()
  local options = {
    "groq:llama-3.1-8b-instant",
    "gemini:gemini-1.5-flash-8b-latest",
    "openrouter:qwen/qwen-2.5-coder-32b-instruct:free",
    "openrouter:deepseek/deepseek-r1:free",
    "openrouter:mistral/mistral-small-24b-instrunt-2501:free",
  }
  -- Display the menu and handle selected option
  vim.ui.select(options, {
    prompt = "Select an Option:",
    format_item = function(item)
      return "> " .. item
    end,
  }, function(choice)
    if choice then
      print("You selected: " .. choice)
      Selected_choice = choice -- stores it in variable
    else
      print("no selection")
    end
  end)
end

-- }}}
-- read the entire buffer, select model then send to aichat CLI {{{
function My_aichat_current_file2()
  -- Get all from current file
  -- `0` represents the current buffer (file).
  -- `0` is the start line (beginning of the file).
  -- `-1` is the end line (end of the file).
  -- `true` is a flag that determines whether to include the newline character (`\n`) at the end of each line. If `true`, the newline character is included.
  local current_file_table = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local current_file = vim.inspect(current_file_table)
  My_show_menu()
  -- print(current_file)
  vim.api.nvim_command("normal Go")
  local aichat_command = ':read !aichat --model ' .. Selected_choice .. " " .. current_file
  vim.cmd(aichat_command)
end

-- }}}
-- }}}
