{ ... }: {
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
      init-kube = "mkdir -p ~/.kube && op document get \"kubeconfig\" > ~/.kube/config";
      init-talos = "mkdir -p ~/.talos && op document get \"talosconfig\" > ~/.talos/config";
    };
  };
}
