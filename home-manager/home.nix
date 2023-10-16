# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
     #./nvim.nix
  ];
  
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "jonathan";
    homeDirectory = "/home/jonathan";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
    home.packages = with pkgs; [ keepassxc firefox thunderbird tmux fzf eza];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.waybar.enable = true;
  programs.wofi.enable = true;
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
    ];
  };
 programs.zsh = {
  shellAliases = {
    ll = "ls -l";
    lsa ="exa -lah --no-permissions";
    ls = "exa -a --icons  -h --time-style=iso";
    lsr="exa --tree --level=3";
  };
 oh-my-zsh = {
    enable = true;
    plugins = [ "git" "zsh-autosuggestions" "zsh-syntax-highlighting" "history-substring-search" "fzf-tab" ];
    theme = "powerlevel10k/powerlevel10k";
  };
};
  wayland.windowManager.hyprland.extraConfig = ''
    $mod = SUPER
    bind = $mod, F, exec, firefox
        ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
                  ''
      )
      10)}

      exec-once = waybar
      bind=SUPER,R,exec,wofi

  '';

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
