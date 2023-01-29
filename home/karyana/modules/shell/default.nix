{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  browser = ["firefox.desktop"];
  associations = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["google-chrome.desktop"];
    "x-scheme-handler/discord" = ["discordcanary.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
  };
in {
  imports = [
    ./zsh.nix
    ./starship.nix
    ./cli.nix
    ./git.nix
    ./nix.nix
  ];

  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/Workspace/go/bin"
    ];

    sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/Workspace/go";
      GOBIN = "${config.home.homeDirectory}/Workspace/go/bin";
    };

    file = {
      ".local/bin/updoot" = {
        # Upload and get link
        executable = true;
        text = ''
          #> Syntax: bash

          # Send to host

          [ -f "$1" ] && op="cat"
          ''${op:-echo} "''${@:-$(cat -)}" \
              | ${pkgs.curl}/bin/curl -sF file='@-' 'http://0x0.st' \
              | tee /dev/stderr \
              | tr -d '\n'      \
              | ${pkgs.xclip}/bin/xclip -sel clip
        '';
      };

      ".local/bin/preview.sh" = {
        # Preview script for fzf tab
        executable = true;
        text = ''
          #> Syntax: bash
          # Copied from Elkowar

          case "$1" in
            -*) exit 0;;
          esac

          case "$(${pkgs.file}/bin/file --mime-type "$1")" in
            *text*)
              ${pkgs.bat}/bin/bat --color always --plain "$1"
              ;;
            *image* | *pdf)
              ${pkgs.catimg}/bin/catimg -w 100 -r 2 "$1"
              ;;
            *directory*)
              ${pkgs.exa}/bin/exa --icons -1 --color=always "$1"
              ;;
            *)
              echo "unknown file format"
              ;;
          esac
        '';
      };
    };
  };

  services = {
    syncthing.enable = true;

    gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
      enableZshIntegration = true;
      enableSshSupport = true;
    };
  };

  programs = {
    ssh.enable = true;

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_DEVELOPMENT_DIR = "${config.xdg.userDirs.documents}/Dev";
      };
    };

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
