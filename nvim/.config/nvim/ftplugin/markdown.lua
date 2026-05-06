vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"

vim.opt_local.conceallevel = 2

local function copy_as_rich_text()
  local tmpfile = vim.fn.tempname() .. ".md"
  local f = io.open(tmpfile, "w")
  f:write(vim.fn.getreg('"'))
  f:close()
  vim.fn.system(
    "pandoc " .. vim.fn.shellescape(tmpfile) .. " -f gfm -t html"
      .. " | textutil -stdin -format html -convert rtf -stdout"
      .. " | pbcopy"
  )
  os.remove(tmpfile)
end

local function paste_as_markdown(after)
  local jxa = [[
    ObjC.import('AppKit');
    var pb = $.NSPasteboard.generalPasteboard;
    var html = pb.stringForType($.NSPasteboardTypeHTML);
    (html && !html.isNil()) ? html.js : '';
  ]]
  local html = vim.fn.system("osascript -l JavaScript -e " .. vim.fn.shellescape(jxa))

  -- No HTML on clipboard — fall back to default paste
  if vim.v.shell_error ~= 0 or html:match("^%s*$") then
    vim.cmd("normal! " .. (after and "p" or "P"))
    return
  end

  local tmpfile = vim.fn.tempname() .. ".html"
  local f = io.open(tmpfile, "w")
  f:write(html)
  f:close()

  local result = vim.fn.system(
    "pandoc " .. vim.fn.shellescape(tmpfile) .. " -f html -t gfm --wrap=none"
  )
  os.remove(tmpfile)

  result = result:gsub("\n$", "")
  local lines = vim.split(result, "\n")
  vim.api.nvim_put(lines, "l", after, true)
end

-- yy yanks and also copies as rich text to system clipboard
vim.keymap.set("n", "yy", function()
  vim.cmd('normal! "0yy')
  vim.fn.setreg('"', vim.fn.getreg("0"))
  copy_as_rich_text()
end, { buffer = true, desc = "Yank line + copy as rich text" })

-- y in visual mode yanks and also copies as rich text
vim.keymap.set("v", "y", function()
  vim.cmd('normal! "0y')
  vim.fn.setreg('"', vim.fn.getreg("0"))
  copy_as_rich_text()
end, { buffer = true, desc = "Yank selection + copy as rich text" })

-- p/P paste from clipboard as markdown when HTML is available
vim.keymap.set("n", "p", function() paste_as_markdown(true) end,
  { buffer = true, desc = "Paste (after) as Markdown" })

vim.keymap.set("n", "P", function() paste_as_markdown(false) end,
  { buffer = true, desc = "Paste (before) as Markdown" })
