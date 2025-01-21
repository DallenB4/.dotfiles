{inputs, config, pkgs, systemSettings, ... }:

with config.lib.stylix.colors;

{
  environment.systemPackages = with pkgs; [
    ripgrep
    fd
  ];
  
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # vimdiffAlias = true;
    enableMan = true;

    clipboard.providers.wl-copy.enable = true;

    opts = {
      number = true;
      relativenumber = true;
    };

   extraConfigLua = /* lua */ ''
      vim.opt.scrolloff = 10  
      vim.keymap.set("", "<leader>e", function() vim.diagnostic.open_float() end)
      vim.keymap.set("", "<leader>p", "<cmd>Explore<CR>")
      vim.keymap.set("", "<leader>a", "gg0vG$")
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
      vim.keymap.set("", "<leader><leader>", function() vim.lsp.buf.hover() end)
      vim.keymap.set("", "<Left>", "<nop>")
      vim.keymap.set("", "<Right>", "<nop>")
      vim.keymap.set("", "<Up>", "<nop>")
      vim.keymap.set("", "<Down>", "<nop>")
      vim.keymap.set("", "<C-p>", function() 
        if vim.fn.system('git rev-parse --is-inside-work-tree'):find('true') 
          then require('telescope.builtin').git_files() 
          else require('telescope.builtin').find_files() 
        end
      end)
      vim.keymap.set("", "<leader>vca", function() vim.lsp.buf.code_action() end)
      vim.keymap.set("", "<leader>u", "<cmd>UndotreeToggle<CR>")
      vim.keymap.set("", "<Esc>", "<cmd>nohlsearch<CR>")
    '';
    
    globals.mapleader = " ";

    diagnostics = {
      float = true;
    };
  
    extraConfigVim = ''
      let g:neovide_transparency = 0.9
      hi MsgArea guibg=#${base01}
      set tabstop=2
      set shiftwidth=2
      set clipboard=unnamedplus
      set mouse= 
    '';

    colorschemes = {
      tokyonight = {
        enable = true;
        settings = {
          style = "night";
        };
      }; 
    };
    
    plugins = {
      nix.enable = true;
      # transparent.enable = true;
      lualine.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      treesitter.settings = {
        highlight.enable = true;  
        # indent.enable = true;
      };
      autoclose.enable = true;
      vim-css-color.enable = true;
      toggleterm.enable = true;
      rainbow-delimiters.enable = true;
      lsp-format.enable = true;
      undotree.enable = true;
      # otter.enable = true;
    };

    # plugins.obsidian = {
    #   enable = true;
    #   settings = {
    #     workspaces = [
    #       {
    #         name = "Obsidian";
    #         path = "~/Syncthing/Obsidian";
    #       }
    #     ];
    #   };
    # };
 
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})"; 
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
      };
    };

    plugins.lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        csharp-ls.enable = true;
        cssls.enable = true;
        gopls.enable = true;
        html.enable = true;
        nixd.enable = true;
        pylsp.enable = true;
        tailwindcss.enable = true;
        tsserver.enable = true;
      };
    };
  };
}

