" ~/.config/nvim/init.vim
" Install vim-plug if not installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Plugin management
call plug#begin('~/.config/nvim/plugged')

" LSP for JS/TS support
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" Syntax highlighting
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'

" File Explorer
Plug 'preservim/nerdtree'

" Statusline
Plug 'vim-airline/vim-airline'

" Colors
Plug 'mhartington/oceanic-next'
Plug 'dracula/vim'
Plug 'arzg/vim-colors-xcode'
Plug 'ryanoasis/vim-devicons'
call plug#end()

syntax on
set termguicolors
colorscheme dracula

" Basic settings
set number            " Show line numbers
set tabstop=2         " Set tab width to 2 spaces
set shiftwidth=2      " Set indentation width to 2 spaces
set expandtab         " Use spaces instead of tabs

" NERDTree setup
nnoremap <C-n> :NERDTreeToggle<CR>

" LSP and autocomplete configuration for JavaScript
lua << EOF
require'lspconfig'.ts_ls.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.eslint.setup{}
require 'lspconfig'.clangd.setup{
    cmd = {"clangd", "--compile-commands-dir=."}
}
require'lspconfig'.solargraph.setup {
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby" },
  root_dir = require'lspconfig'.util.root_pattern{"Gemfile", ".git"},
  settings = {
    solargraph = {
      diagnostics = true, -- Enable diagnostics
    },
  },
}
EOF

" Autocomplete with nvim-compe
set completeopt=menuone,noinsert,noselect
lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
  };
}

