{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # fonts
    fira
    fira-mono

    # Stuff to get rmarkdown to work
    pandoc
    texlive.combined.scheme-full
    (rWrapper.override {
      packages = with rPackages; [
        rmarkdown
        shiny
      ];
    })

    # Additional tools I find useful
    xclip
    inotify-tools
  ];

  # get my fish functions
  home.file.".config/fish/functions".source =
    fetchTarball "https://github.com/avrittrohwer/fish-functions/tarball/master";

  # configure programs
  programs = {
    alacritty = {
      enable = true;
      settings = {
        colors = {
          primary = {
            background = "0x2E3440";
            foreground = "0xD8DEE9";
          };
          cursor = {
            text = "0x2E3440";
            cursor = "0xD8DEE9";
          };
          normal = {
            black = "0x3B4252";
            red = "0xBF616A";
            green = "0xA3BE8C";
            yellow = "0xEBCB8B";
            blue = "0x81A1C1";
            magenta = "0xB48EAD";
            cyan = "0x88C0D0";
            white = "0xE5E9F0";
          };
          bright = {
            black = "0x4C566A";
            red = "0xBF616A";
            green = "0xA3BE8C";
            yellow = "0xEBCB8B";
            blue = "0x81A1C1";
            magenta = "0xB48EAD";
            cyan = "0x8FBCBB";
            white = "0xECEFF4";
          };
        };
        window = {
          decorations = "none";
          padding = { x = 2; y = 0; };
        };
        tabspaces = 2;
        font =
          let
            font = type: { family = "Fira Mono"; style = type; };
          in
            {
              normal = font "Medium";
              bold = font "Bold";
              italic = font "Italic";
              size = 11.0;
            };
        visual_bell = { duration = 1; };
      };
    };

    firefox.enable = true;

    fish = {
      enable = true;
      interactiveShellInit = ''
        # use Nord colors
        set nord0 2e3440
        set nord1 3b4252
        set nord2 434c5e
        set nord3 4c566a
        set nord4 d8dee9
        set nord5 e5e9f0
        set nord6 eceff4
        set nord7 8fbcbb
        set nord8 88c0d0
        set nord9 81a1c1
        set nord10 5e81ac
        set nord11 bf616a
        set nord12 d08770
        set nord13 ebcb8b
        set nord14 a3be8c
        set nord15 b48ead

        set fish_color_normal $nord4
        set fish_color_command $nord9
        set fish_color_quote $nord14
        set fish_color_redirection $nord9
        set fish_color_end $nord6
        set fish_color_error $nord11
        set fish_color_param $nord4
        set fish_color_comment $nord3
        set fish_color_match $nord8
        set fish_color_search_match $nord8
        set fish_color_operator $nord9
        set fish_color_escape $nord13
        set fish_color_cwd $nord8
        set fish_color_autosuggestion $nord6
        set fish_color_user $nord4
        set fish_color_host $nord9
        set fish_color_cancel $nord15
        set fish_pager_color_prefix $nord13
        set fish_pager_color_completion $nord6
        set fish_pager_color_description $nord10
        set fish_pager_color_progress $nord12
        set fish_pager_color_secondary $nord1

        # start tmux for me
        if not set -q TMUX
          exec tmux
        end
      '';
    };

    git = {
      enable = true;
      userEmail = "avritt.rohwer@gmail.com";
      userName = "avrittrohwer";
    };

    home-manager = {
      enable = true;
      path = "https://github.com/rycee/home-manager/archive/release-19.03.tar.gz";
    };

    neovim = {
      enable = true;
      configure = {
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            # quality of life stuff
            vim-airline
            vim-bufferline
            auto-pairs
            (pkgs.vimUtils.buildVimPluginFrom2Nix {
                pname = "nord-vim";
                version = "2019-04-18";
                src = pkgs.fetchFromGitHub {
                  owner = "arcticicestudio";
                  repo = "nord-vim";
                  rev = "39e0742d57c8f4b5442939362942a7c5afa20a62";
                  sha256 = "0mp5mf0bzkq6rsh23s1912vwkmdhx1nc4q81nyf0y32m84lrjx1w";
                };
            })

            # language highlighters
            vim-nix
            zig-vim
          ];
        };
        customRC = ''
          "== General Settings ==
          set mouse=a  " enable mouse
          set nowrap  " don't wrap lines
          set tw=100  " auto wrap at 100 characters
          set colorcolumn=100  " show a line at 100 characters
          set formatoptions+=tcrqnj  " how text should be formatted, see :help fo-table
          set showmatch  " show matching brackets
          set splitbelow splitright  " splits go either below or to right of current pane
          set spell  " show spelling errors
          set list  " show whitespace characters
          set listchars=trail:·,tab:»-  " show these for whitespace
          set ignorecase smartcase  " searching doesn't care about case unless I do
          set gdefault  " use global replace by default
          set hidden  " don't require saving of buffers when I switch between them
          set wildmenu wildmode=longest,list,full  " make completion behave more like bash
          set expandtab  " insert spaces instead of tabs
          set tabstop=2 shiftwidth=2  " use 2 spaces for a tab

          " turn off spell check when in terminal mode
          autocmd TermOpen * setlocal nospell

          "== Keybindings ==
          " use space as leader
          let mapleader="\<space>"

          " mash `j` and `k`  (with ctrl in terminal) to exit insert mode
          inoremap jk <esc>
          inoremap kj <esc>
          tnoremap <c-j><c-k> <c-\><c-n>
          tnoremap <c-k><c-j> <c-\><c-n>

          " use `;` for commands
          nnoremap ; :
          vnoremap ; :

          " clear search matches
          nnoremap <leader>c :nohlsearch<cr>

          " repeat last substitution command
          nnoremap <leader>s :&<cr>

          " paste with a space at inserted at beginning
          nnoremap <leader>p a <esc>p

          " remove a buffer without messing up splits, if possible
          nnoremap <leader>x :bprevious\|bdelete #<cr>

          " buffer navigation
          nnoremap <leader>bn :bnext<cr>
          nnoremap <leader>bp :bprevious<cr>

          " tab navigation
          nnoremap <leader>tn :tabnext<cr>
          nnoremap <leader>tp :tabprevious<cr>

          "== vim-airline ==
          let g:airline_detect_spell=0
          let g:airline_section_b=""
          let g:airline_section_x=""
          let g:airline_section_y=""
          let g:airline_section_z="%3l/%L %3v"
          let g:airline#extensions#whitespace#symbol=""
          let g:airline#extensions#whitespace#checks=['indent', 'trailing']
          let g:airline#extensions#whitespace#mixed_indent_format="i%s"
          let g:airline#extensions#whitespace#trailing_format="s%s"

          "== vim-bufferline ==
          let g:bufferline_echo=0

          "== nord-vim ==
          colorscheme nord
          let g:nord_underline=1
          let g:nord_comment_brightness=20
        '';
      };
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      keyMode = "vi";
      shortcut = "a";
      terminal = "screen-256color";
      extraConfig = ''
        # enables scrolling with mouse
        set -g mouse on

        # split panes using `|` and `-` and have them open in current directory
        unbind '"'
        unbind %
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        # open new window in current directory
        bind c new-window -c "#{pane_current_path}"

        # easier pane selection with vim keys
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # alt + arrow key resizes a pane
        bind -n M-Left resize-pane -L
        bind -n M-Down resize-pane -D
        bind -n M-Up resize-pane -U
        bind -n M-Right resize-pane -R
      '';
    };

  };
}
