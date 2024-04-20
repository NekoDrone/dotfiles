vim.api.nvim_create_user_command('WQQ', function ()
	vim.cmd.wq()
	vim.cmd.q()
end, {})

vim.api.nvim_create_user_command('QQ', function ()
	vim.cmd.q()
	vim.cmd.q()
end, {})
