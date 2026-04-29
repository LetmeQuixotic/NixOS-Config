{ config, lib, pkgs, ... }:

{
  # Basic aliases: use 'vi' or 'vim' command to launch Neovim
  viAlias = true;
  vimAlias = true;

  # Neovim options (equivalent to vim.opt)
  opts = {
    tabstop = 4;                  # Number of spaces a <Tab> in the file counts for
    shiftwidth = 4;               # Number of spaces to use for each step of (auto)indent
    expandtab = true;             # Use spaces instead of tabs (modern standard)
    number = true;                # Show absolute line numbers
    relativenumber = true;        # Show relative line numbers (useful for navigation)
    smartindent = true;           # Automatically indent new lines intelligently
    clipboard = "unnamedplus";    # Use system clipboard for yank/paste
    mouse = "a";                  # Enable mouse support in all modes
    signcolumn = "yes";           # Always show the sign column (for git/lsp signs)
    cursorline = true;            # Highlight the line where the cursor is
    termguicolors = true;         # Enable 24-bit RGB colors in the terminal
    ignorecase = true;            # Ignore case when searching
    smartcase = true;             # Override ignorecase if search pattern contains uppercase
    incsearch = true;             # Show search matches as you type
    hlsearch = true;              # Highlight all search matches
  };

  # Color scheme (using gruvbox as an example)
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";          # Options: "latte", "frappe", "macchiato", "mocha"
      transparent_background = true;
    };
  };

  # Plugins section – only the most essential ones for a functional setup
  plugins = {

    # Startup screen (AstroNvim uses alpha-nvim)
    alpha = {
      enable = true;
      theme = "theta";
    };

    # Lsp
    lsp = {
      enable = true;
      servers = {
        csharp_ls.enable = true;
        gopls.enable = true;
      };
    };

    # auto indentation
    sleuth.enable = true;

    # Enable mini icon
    mini = {
      enable = true;
      modules = {
        pairs = {};
        icons = {};
      };
      mockDevIcons = true;
    };

    # Status line plugin
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";         # Automatically adapt to the colorscheme
          globalstatus = true;    # Use a single status line for all windows
        };
      };
    };

    # File explorer sidebar
    nvim-tree = {
      enable = true;
      # Additional settings can be placed here
    };

    # Fuzzy finder for files, buffers, live grep, etc.
    telescope = {
      enable = true;
      # Telescope is highly customizable; here we only enable it
    };

    # Better syntax highlighting using tree-sitter
    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;          # Enable syntax highlighting
        };
        indent = {
          enable = true;          # Enable indentation based on tree-sitter
        };
      };
    };

    # Git integration: shows added/modified/removed lines in the sign column
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add = { text = "│"; };
          change = { text = "│"; };
          delete = { text = "_"; };
          topdelete = { text = "‾"; };
          changedelete = { text = "~"; };
        };
      };
    };

    smear-cursor = {
      enable = true;
      settings = {
        fade_time = 1000;
        trail_length = 20;
        smear_between_buffers = true; # Dispaly when switching buffer/window
        smear_insert_mode = true;     # Display in insert mode 
        # cursor_color = "#d3cdc3";    # custom color
      };
    };

    # code auto fix
    cmp = {
      enable = true;
      autoEnableSources = true;
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; } # if your code use luasnip
      ];
    };

    # GitHub Copilot main plugin (Lua version, better performance and integration with Neovim)
    copilot-lua = {
      enable = false;
      settings = {
        suggestion = {
          enabled = true;
          auto_trigger = true;
          keymap = {
            accept = "<C-l>";      # Use Ctrl+l to accept AI generated code (avoids conflict with Tab in cmp menu)
            accept_word = "<M-l>"; # Use Alt+l to accept only the next word
            next = "<M-]>";        # Jump to the next suggestion
            prev = "<M-[>";        # Jump to the previous suggestion
            dismiss = "<C-]>";     # Dismiss the current suggestion
          };
        };
        panel = {
          enabled = false; # Disable the panel layout
        };
      };
    };

    # GitHub Copilot Chat (The conversational AI interface like in VS Code)
    copilot-chat = {
      enable = true;
    };
  };

  extraConfigLuaPre = ''
    local theta = require("alpha.themes.theta")
    theta.header.val = {
      " ██████  ██    ██ ██ ██   ██  ██████  ████████ ██  ██████ ",
      "██    ██ ██    ██ ██  ██ ██  ██    ██    ██    ██ ██    ██",
      "██    ██ ██    ██ ██   ███   ██    ██    ██    ██ ██      ",
      "██ ▄▄ ██ ██    ██ ██  ██ ██  ██    ██    ██    ██ ██    ██",
      " ██████   ██████  ██ ██   ██  ██████     ██    ██  ██████ ",
      "    ▀▀                                                    ",
      "                                                          ",
      "             ███    ██ ██    ██ ██ ███    ███             ",
      "             ████   ██ ██    ██ ██ ████  ████             ",
      "             ██ ██  ██ ██    ██ ██ ██ ████ ██             ",
      "             ██  ██ ██  ██  ██  ██ ██  ██  ██             ",
      "             ██   ████   ████   ██ ██      ██             ",
    }
  '';

  # Custom key mappings (similar to vim.keymap.set)
  keymaps = [
    # Toggle file tree with Ctrl+n
    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>NvimTreeToggle<CR>";
      options = { desc = "Toggle file explorer"; silent = true; };
    }

    # Find files using Telescope
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options = { desc = "Find files"; silent = true; };
    }

    # Live grep (search text) using Telescope
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options = { desc = "Live grep"; silent = true; };
    }

    # Clear search highlights with <leader>h
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>nohlsearch<CR>";
      options = { desc = "Clear search highlights"; silent = true; };
    }

    # Open GitHub Copilot Chat with <leader>cc
    {
      mode = ["n" "v"];
      key = "<leader>cc";
      action = "<cmd>CopilotChatToggle<CR>";
      options = { desc = "Toggle Copilot Chat"; silent = true; };
    }
  ];

  # Set the leader key to Space (must be set before keymaps are defined)
  globals = {
    mapleader = " ";              # <leader> key is now Space
    maplocalleader = " ";         # <localleader> is also Space (can be changed)
  };
}
