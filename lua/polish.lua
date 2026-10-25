-- This will run last in the setup process.
-- Anything that doesn't fit in normal config locations goes here.

-- NOTE: on this machine $HOME points at E:\Cadence\SPB_Data (set by Cadence
-- SPB_Data), so vim.fn.expand("~") is NOT the user profile. Resolve the
-- hermes venv from %USERPROFILE% first and only fall back to "~".
local function first_existing(candidates)
  for _, path in ipairs(candidates) do
    if path and path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
  end
  return nil
end

local profile = vim.env.USERPROFILE or vim.env.HomeDrive .. vim.env.HomePath
local venv_python = first_existing({
  profile and (profile .. "/.hermes/hermes-agent/venv/Scripts/python.exe") or nil,
  vim.fn.expand("~/.hermes/hermes-agent/venv/Scripts/python.exe"),
  vim.fn.expand("~/.hermes/hermes-agent/venv/bin/python"),
})

if venv_python then
  vim.g.python3_host_prog = venv_python
end

-- jupytext.nvim shells out to the `jupytext` CLI, so the venv's Scripts dir
-- must be on PATH no matter how nvim was launched.
-- The ipykernel spec we use launches a bare "python", so the venv has to win
-- on PATH for the kernel to run in the same interpreter.
local venv_bin = venv_python and vim.fn.fnamemodify(venv_python, ":h") or nil
if venv_bin then
  local current_path = vim.env.PATH or ""
  if not current_path:find(venv_bin, 1, true) then
    -- ";" on Windows, ":" on POSIX
    local sep = package.config:sub(1, 1)
    vim.env.PATH = venv_bin .. sep .. current_path
  end
end

-- Molten UX tweaks
vim.g.molten_enter_output_behavior = "open_and_enter"
vim.g.molten_output_win_border = { "", "─", "", "", "", "─", "", "" }
vim.g.molten_use_border_highlights = true
