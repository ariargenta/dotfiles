-- ~/.config/nvim/init.lua

vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.cursorline     =  true
vim.opt.number         =  true
vim.opt.relativenumber =  true
vim.opt.scrolloff      =  10
vim.opt.sidescrolloff  =  10
vim.opt.wrap           =  true

vim.opt.autoindent  = true
vim.opt.expandtab   = true
vim.opt.shiftwidth  = 2
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop     = 2

vim.opt.hlsearch   =  true
vim.opt.ignorecase =  true
vim.opt.incsearch  =  true
vim.opt.smartcase  =  true

vim.opt.cmdheight     = 1
vim.opt.colorcolumn   = "80"
vim.opt.completeopt   = "menuone,noinsert,noselect"
vim.opt.concealcursor = ""
vim.opt.conceallevel  = 2
vim.opt.fillchars     = {eob = " "}
vim.opt.pumblend      = 10
vim.opt.pumheight     = 10
vim.opt.showmatch     = true
vim.opt.showmode      = false
vim.opt.signcolumn    = "yes"
vim.opt.synmaxcol     = 300
vim.opt.winblend      = 0

local undodir = vim.fn.expand("~/.local/state/nvim/undo")

if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

vim.opt.autoread    = true
vim.opt.autowrite   = false
vim.opt.backup      = false
vim.opt.swapfile    = false
vim.opt.timeoutlen  = 500
vim.opt.ttimeoutlen = 50
vim.opt.undodir     = undodir
vim.opt.undofile    = true
vim.opt.updatetime  = 300
vim.opt.writebackup = false

vim.opt.autochdir  =  false
vim.opt.backspace  =  "indent,eol,start"
vim.opt.encoding   =  "utf-8"
vim.opt.errorbells =  false
vim.opt.hidden     =  true
vim.opt.modifiable =  true
vim.opt.mouse      =  "a"
vim.opt.selection  =  "inclusive"

vim.opt.clipboard:append("unnamedplus")
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")

vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lcursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.foldexpr   =  "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod =  "expr"
vim.opt.foldlevel  =  99

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.diffopt:append("linematch:60")

vim.opt.maxmempattern = 10000
vim.opt.redrawtime    = 10000
vim.opt.wildmenu      = true
vim.opt.wildmode      = "longest:full,full"

-- ============================================================================
-- STATUSLINE
-- ============================================================================
-- Git branch with caching
local cached_branch = ""
local last_check = 0

local function git_branch()
    local now = vim.uv.now()

    if now - last_check > 5000 then
        cached_branch = vim.fn.system(
            "git branch --show-current 2>/dev/null | tr -d '\n'"
        )

        last_check = now
    end

    if cached_branch ~= "" then
        return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
    end

    return ""
end

-- File type
local function file_type()
    local ft = vim.bo.filetype

    local icons = {
        astro           = "\u{e628} ",
        bash            = "\u{f489} ",
        c               = "\u{e61e} ",
        cpp             = "\u{e61d} ",
        css             = "\u{e749} ",
        dart            = "\u{e798} ",
        docker          = "\u{f308} ",
        elixir          = "\u{e62d} ",
        gitcommit       = "\u{f418} ",
        gitconfig       = "\u{f1d3} ",
        go              = "\u{e724} ",
        haskell         = "\u{e777} ",
        html            = "\u{e736} ",
        java            = "\u{e738} ",
        javascript      = "\u{e74e} ",
        javascriptreact = "\u{e7ba} ",
        json            = "\u{e60b} ",
        kotlin          = "\u{e634} ",
        lua             = "\u{e620} ",
        markdown        = "\u{e73e} ",
        php             = "\u{e73d} ",
        python          = "\u{e73c} ",
        ruby            = "\u{e739} ",
        rust            = "\u{e7a8} ",
        sccs            = "\u{e749} ",
        sh              = "\u{f489} ",
        sql             = "\u{e706} ",
        svelte          = "\u{e697} ",
        swift           = "\u{e755} ",
        toml            = "\u{e615} ",
        typescript      = "\u{e628} ",
        typescriptreact = "\u{e7b1} ",
        vim             = "\u{e62b} ",
        vue             = "\u{fd42} ",
        xml             = "\u{f05c} ",
        yaml            = "\u{f481} ",
        zsh             = "\u{f489} ",
    }

    if ft == "" then
        return " \u{f15b} " -- nf-fa-file_o
    end

    return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- File size
local function file_size()
    local size = vim.fn.getfsize(vim.fn.expand("%"))

    if size < 0 then
        return ""
    end

    local size_str

    if size < 1024 then
        size_str = size .. "B"
    elseif size < 1024 * 1024 then
        size_str = string.format("%.1fK", size / 1024)
    else
        size_str = string.format("%.1fM", size / 1024 / 1024)
    end

    return " \u{f016} " .. size_str .. " "  -- nf-fa-file_o
end

-- Mode indicators
local function mode_icon()
    local mode = vim.fn.mode()
    
    local modes = {
        ["!"]   = " \u{f489} SHELL",
        ["\19"] = " \u{f0c5} S-BLOCK",
        ["\22"] = " \u{f0168} V-BLOCK",
        c       = " \u{f120} COMMAND",
        i       = " \u{f11c} INSERT",
        n       = " \u{f121} NORMAL",
        r       = " \u{f044} REPLACE",
        R       = " \u{f044} REPLACE",
        s       = " \u{f0c5} SELECT",
        S       = " \u{f0c5} S-LINE",
        t       = " \u{f120} TERMINAL",
        v       = " \u{f0168} VISUAL",
        V       = " \u{f0168} V-LINE",
    }

    return modes[mode] or (" \u{f059} " .. mode)
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[highlight StatusLineBold gui=bold cterm=bold]])

-- Change statusline based on window focus
local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
        callback = function()
            vim.opt_local.statusline = table.concat({
                "%#StatusLineBold#",
                "%{v:lua.mode_icon()}",
                "%#StatusLine#",
                " \u{e0b1} %f %h%m%r",  -- nf-pl-left_hard_divider
                "%{v:lua.git_branch()}",
                "\u{e0b1} ",
                "%{v:lua.file_type()}",
                "\u{e0b1} ",
                "%{v:lua.file_size()}",
                "%=", -- Right-align everything after this
                " \u{f017} %l_%c %P ", -- nf-fa-clock_o
            })
        end,
    })

    vim.api.nvim_set_hl(0, "StatusLineBold", {bold = true})

    vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
        callback = function()
            vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
        end,
    })
end

setup_dynamic_statusline()

-- ============================================================================
-- KEYMAPS
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set(
    "n",
    "j",
    function()
        return vim.v.count == 0 and "gj" or "j"
    end,

    {expr = true, silent = true, desc = "Down (wrap-aware)"}
)

vim.keymap.set(
    "n",
    "k",
    function()
        return vim.v.count == 0 and "gk" or "k"
    end,

    {expr = true, silent = true, desc = "Up (wrap-aware)"}
)

vim.keymap.set(
    "n",
    "<leader>c",
    ":nohlsearch<CR>",
    {desc = "Clear search highlights"}
)

vim.keymap.set("n", "n", "nzzzv", {desc = "Next search result (centered)"})
vim.keymap.set("n", "N", "Nzzzv", {desc = "Previous search result (centered)"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc = "Half page down (centered)"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc = "Half page up (centered)"})

vim.keymap.set("x", "<leader>p", '"_dP', {desc = "Paste without yanking"})
vim.keymap.set({"n", "v"}, "<leader>x", '"_d', {desc = "Delete without yanking"})

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", {desc = "Next buffer"})
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", {desc = "Previous buffer"})

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", {desc = "Move to left window/pane"})
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", {desc = "Move to bottom window/pane"})
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", {desc = "Move to top window/pane"})
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", {desc = "Move to right window/pane"})

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", {desc = "Split window vertically"})
vim.keymap.set("n", "<leader>sh", ":split<CR>", {desc = "Split window horizontally"})
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", {desc = "Increase window height"})
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", {desc = "Decrease window height"})
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", {desc = "Decrease window width"})
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", {desc = "Increase window width"})

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", {desc = "Move line down"})
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", {desc = "Move line up"})
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", {desc = "Move selection down"})
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", {desc = "Move selection up"})

vim.keymap.set("v", "<", "<gv", {desc = "Indent left and reselect"})
vim.keymap.set("v", ">", ">gv", {desc = "Indent right and reselect"})

vim.keymap.set("n", "J", "mzK`z", {desc = "Join lines and keep cursor position"})

vim.keymap.set(
    "n",
    "<leader>pa",
    function()
        local path = vim.fn.expand("%:p")
        vim.fn.setreg("+", path)
        print("file:", path)
    end,
    {desc = "Copy full file path"}
)

vim.keymap.set(
    "n",
    "<leader>td",
    function()
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end,
    {desc = "Toogle diagnostics"}
)

-- ============================================================================
-- AUTOCMDS
-- ============================================================================
local augroup = vim.api.nvim_create_augroup("UserConfig", {clear = true})

-- Format on save, only real file buffers when efm is attached
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = {
        "*.bash",
        "*.c",
        "*.css",
        "*.cpp",
        "*.go",
        "*.h",
        "*.hpp",
        "*.html",
        "*.js",
        "*.json",
        "*.jsx",
        "*.lua",
        "*.py",
        "*.scss",
        "*.sh",
        "*.ts",
        "*.tsx",
        "*.zsh",
    },
    callback = function(args) -- Avoid formatting non-file buffers
        if vim.bo[args.buf].buftype ~= "" then
            return
        end

        if not vim.bo[args.buf].modifiable then
            return
        end

        if vim.api.nvim_buf_get_name(args.buf) == "" then
            return
        end

        local has_efm = false

        for _, c in ipairs(vim.lsp.get_clients({bufnr = args.buf})) do
            if c.name == "efm" then
                has_efm = true

                break
            end
        end

        if not has_efm then
            return
        end

        pcall(vim.lsp.buf.format, {
            bufnr = args.buf,
            timeout_ms = 2000,
            filter = function(c)
                return c.name == "efm"
            end,
        })
    end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,

    callback = function()
        vim.hl.on_yank()
    end,
})

-- Return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore last cursor position",
    callback = function()
        if vim.o.diff then
            return
        end

        local last_pos = vim.api.nvim_buf_get_mark(0, '"')  -- {line, column}
        local last_line = vim.api.nvim_buf_line_count(0)
        local row = last_pos[1]

        if row < 1 or row > last_line then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
})

-- Linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = {"markdown", "text", "gitcommit"},
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})

-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
vim.pack.add({
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/nvim-tree/nvim-tree.lua",
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
    },
    -- Language server protocols
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/creativenull/efmls-configs-nvim",
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("1.*"),
    },
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/obsidian-nvim/obsidian.nvim",
    "https://github.com/mrcjkb/rustaceanvim",
    "https://github.com/christoomey/vim-tmux-navigator",
})

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================
local setup_treesitter = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup({})

    local ensure_installed = {
        "bash",
        "c",
        "css",
        "cpp",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "svelte",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
    }

    local config = require("nvim-treesitter.config")
    local already_installed = config.get_installed()
    local parsers_to_install = {}

    for _, parser in ipairs(ensure_installed) do
        if not vim.tbl_contains(already_installed, parser) then
            table.insert(parsers_to_install, parser)
        end
    end

    if #parsers_to_install > 0 then
        treesitter.install(parsers_to_install)
    end

    local group = vim.api.nvim_create_augroup("TreeSitterConfig", {clear = true})

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
            if vim.list_contains(
                config.get_installed(),
                vim.treesitter.language.get_lang(args.match)
            ) then
                vim.treesitter.start(args.buf)
            end
        end,
    })
end

setup_treesitter()

local function get_notes_path()
    local os_release = vim.fn.system("cat /etc/os-release")

    if os_release:match("Arch") then
        return vim.fn.expand("~/Documents/Notes")
    elseif os_release:match("Ubuntu") then
        return "mnt/c/Users/Rad/Documents/Notes"
    else
        error("Unsupported OS: No notes path configured")
    end
end

local function setup_obsidian()
    require("obsidian").setup({
        legacy_commands = false,
        workspaces = {{name = "Notes", path = get_notes_path()}},
        picker = {name = "fzf-lua"},
    })

    vim.keymap.set(
        "n",
        "<leader>nn",
        function()
            vim.cmd("Obsidian workspace")
            vim.defer_fn(
                function()
                    vim.cmd("Obsidian new")
                end,
                500
            )
        end,
        {desc = "New note"}
    )

    vim.keymap.set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", {desc = "Find note"})
    vim.keymap.set("n", "<leader>ns", "<cmd>Obsidian search<cr>", {desc = "Search notes"})
    vim.keymap.set("n", "<leader>nt", "<cmd>Obsidian today<cr>", {desc = "Today's daily note"})
    vim.keymap.set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>", {desc = "Switch workspace"})
end

setup_obsidian()

require("nvim-tree").setup({
    view = {
        width = 35,
    },
    filters = {
        dotfiles = false,
    },
    renderer = {
        group_empty = true,
    },
})

vim.keymap.set(
    "n",
    "<leader>e",
    function()
        require("nvim-tree.api").tree.toggle()
    end,
    {desc = "Toogle NvimTree"}
)

vim.api.nvim_set_hl(0, "NvimTreeNormalNC", {bg = "none"})
vim.api.nvim_set_hl(0, "SignColumn", {bg = "none"})
vim.api.nvim_set_hl(0, "NvimTreeSignColumn", {bg = "none"})
vim.api.nvim_set_hl(0, "NvimTreeNormal", {bg = "none"})
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", {fg = "#2a2a2a", bg = "none"})
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", {bg = "none"})

require("fzf-lua").setup({})

vim.keymap.set(
    "n",
    "<leader>ff",
    function()
        require("fzf-lua").files()
    end,
    {desc = "FZF files"}
)

vim.keymap.set(
    "n",
    "<leader>fg",
    function()
        require("fzf-lua").live_grep()
    end,
    {desc = "FZF live grep"}
)

vim.keymap.set(
    "n",
    "<leader>fb",
    function()
        require("fzf-lua").buffers()
    end,
    {desc = "FZF buffers"}
)

vim.keymap.set(
    "n",
    "<leader>fh",
    function()
        require("fzf-lua").help_tags()
    end,
    {desc = "FZF help tags"}
)

vim.keymap.set(
    "n",
    "<leader>fx",
    function()
        require("fzf-lua").diagnostics_document()
    end,
    {desc = "FZF diagnostics document"}
)

vim.keymap.set(
    "n",
    "<leader>fX",
    function()
        require("fzf-lua").diagnostics_workspace()
    end,
    {desc = "FZF diagnostics workspace"}
)

require("mini.ai").setup({})
require("mini.bufremove").setup({})
require("mini.comment").setup({})
require("mini.cursorword").setup({})
require("mini.git").setup({})
require("mini.icons").setup({})
require("mini.indentscope").setup({})
require("mini.move").setup({})
require("mini.notify").setup({})
require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.trailspace").setup({})

require("mini.diff").setup({
    view = {
        style = "sign",
        signs = {add = "▎", change = "▎", delete = "▎"},
    },
})

local MiniDiff = require("mini.diff")

vim.keymap.set(
    "n",
    "]h",
    function()
        MiniDiff.goto_hunk("next")
    end,
    {desc = "Next git hunk"}
)

vim.keymap.set(
    "n",
    "[h",
    function()
        MiniDiff.goto_hunk("prev")
    end,
    {desc = "Previous git hunk"}
)

vim.keymap.set("n", "<leader>hs", MiniDiff.operator, {desc = "Stage hunk"})

vim.keymap.set(
    "n",
    "<leader>hp",
    function()
        MiniDiff.toogle_overlay()
    end,
    {desc = "Preview diff overlay"}
)

vim.keymap.set(
    "n",
    "<leader>hb",
    function()
        require("mini.git").show_at_cursor()
    end,
    {desc = "Git blame/show"}
)

require("mason").setup({})
