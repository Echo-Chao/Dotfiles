local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- 保存此文件自动更新安装软件
-- PackerCompile改成了PackerSync
-- plugins.lua改成了plugins-setup.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
  ]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
--  use {'lervag/vimtex', opt= true, ft = 'tex'}
  use 'folke/tokyonight.nvim'
  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
      'nvim-tree/nvim-tree.lua',
      requires = { 
          'nvim-tree/nvim-web-devicons',
      }
  }
  use "christoomey/vim-tmux-navigator" -- 用ctl-hjkl来定位窗口
  use "nvim-treesitter/nvim-treesitter" -- 语法高亮
  use "p00f/nvim-ts-rainbow" -- 配合treesitter，不同括号颜色区分
  -- use 'foo1/bar1.nvim'
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",  -- 这个相当于mason.nvim和lspconfig的桥梁
    "neovim/nvim-lspconfig"
  }
    -- 自动补全
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "L3MON4D3/LuaSnip" -- snippets引擎，不装这个自动补全会出问题
  use "saadparwaiz1/cmp_luasnip"
  use "rafamadriz/friendly-snippets"
  use "hrsh7th/cmp-path" -- 文件路径

  use "numToStr/Comment.nvim" -- gcc和gc注释
  use "windwp/nvim-autopairs" -- 自动补全括号

  use "akinsho/bufferline.nvim" -- buffer分割线
  use "lewis6991/gitsigns.nvim" -- 左则git提示

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',  -- 文件检索
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
        'lervag/vimtex',
        opt = true,
        config = function ()
            vim.g.vimtex_view_general_viewer = 'zathura'
            vim.g.vimtex_view_method = 'zathura'
            vim.g.vimtex_compiler_latexmk_engines = {
                _ = '-pdflatex'
            }
            vim.g.vimtex_compiler_progname = 'nvr'
            vim.g.tex_comment_nospell = 1
            vim.g.vimtex_quickfix_mode = 0
            --vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
            --vim.g.vimtex_view_general_options_latexmk = '--unique'
            --vim.g.vimtex_view_general_options_latexmk = '-reuse-instance'
        end,
        ft = 'tex'
    }
      -- use 'foo2/bar2.nvim'
--  use "simrat39/rust-tools.nvim"


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
