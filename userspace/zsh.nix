{ pkgs, ... }:
let
  syncClusterConfigs = pkgs.writeShellApplication {
    name = "sync-cluster-configs";
    runtimeInputs = [
      pkgs._1password-cli
      pkgs.coreutils
    ];
    text = ''
      set -euo pipefail

      kube_document="''${OP_KUBECONFIG_DOCUMENT:-kubeconfig}"
      talos_document="''${OP_TALOSCONFIG_DOCUMENT:-talosconfig}"

      sync_document() {
        local document="$1"
        local target="$2"
        local target_dir
        local tmp

        target_dir="$(dirname "$target")"
        mkdir -p "$target_dir"

        tmp="$(mktemp "$target_dir/.sync-cluster-config.XXXXXX")"
        trap 'rm -f "$tmp"' RETURN

        op document get "$document" > "$tmp"
        chmod 600 "$tmp"
        mv "$tmp" "$target"
        trap - RETURN

        printf 'Updated %s from 1Password document "%s"\n' "$target" "$document"
      }

      case "''${1:-all}" in
        all)
          sync_document "$kube_document" "$HOME/.kube/config"
          sync_document "$talos_document" "$HOME/.talos/config"
          ;;
        kube | kubeconfig)
          sync_document "$kube_document" "$HOME/.kube/config"
          ;;
        talos | talosconfig | talfile)
          sync_document "$talos_document" "$HOME/.talos/config"
          ;;
        *)
          printf 'Usage: sync-cluster-configs [all|kube|talos]\n' >&2
          exit 64
          ;;
      esac
    '';
  };
in
{
  home.packages = [ syncClusterConfigs ];

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "nix flake update --flake /home/saul/sauls-framework-13-nixos";
      switch = "sudo nixos-rebuild switch --impure --flake /home/saul/sauls-framework-13-nixos#sauls-laptop";
      config = "code /home/saul/sauls-framework-13-nixos";
      init-kube = "sync-cluster-configs kube";
      init-talos = "sync-cluster-configs talos";
      sync-cluster = "sync-cluster-configs";
    };
  };
}
