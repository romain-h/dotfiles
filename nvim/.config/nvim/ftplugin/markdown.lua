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

-- Copy visual selection as rich text (RTF) to system clipboard
vim.keymap.set("v", "<leader>rc", function()
  vim.cmd('normal! "zy')
  local text = vim.fn.getreg("z")
  local tmpfile = vim.fn.tempname() .. ".md"
  local f = io.open(tmpfile, "w")
  f:write(text)
  f:close()
  vim.fn.system(
    "pandoc " .. vim.fn.shellescape(tmpfile) .. " -f gfm -t html"
      .. " | textutil -stdin -format html -convert rtf -stdout"
      .. " | pbcopy"
  )
  os.remove(tmpfile)
  vim.notify("Copied as rich text")
end, { buffer = true, desc = "Copy selection as rich text" })

-- Paste clipboard HTML content as Markdown
vim.keymap.set("n", "<leader>rp", function()
  local jxa = [[
    ObjC.import('AppKit');
    var pb = $.NSPasteboard.generalPasteboard;
    var html = pb.stringForType($.NSPasteboardTypeHTML);
    (html && !html.isNil()) ? html.js : '';
  ]]
  local html = vim.fn.system("osascript -l JavaScript -e " .. vim.fn.shellescape(jxa))

  if vim.v.shell_error ~= 0 or html:match("^%s*$") then
    html = vim.fn.system("pbpaste")
  end

  local tmpfile = vim.fn.tempname() .. ".html"
  local f = io.open(tmpfile, "w")
  f:write(html)
  f:close()

  local result = vim.fn.system(
    "pandoc " .. vim.fn.shellescape(tmpfile) .. " -f html -t gfm-raw_html --wrap=none"
  )
  os.remove(tmpfile)

  result = result:gsub("\n$", "")
  local lines = vim.split(result, "\n")
  vim.api.nvim_put(lines, "l", true, true)
end, { buffer = true, desc = "Paste clipboard as Markdown" })
