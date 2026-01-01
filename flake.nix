{
  description = "infra-in-a-box development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # core
            git
            curl
            wget
            jq

            # containers & k8s
            docker
            kubectl
            k3d
            kubernetes-helm

            # languages
            jdk21_headless
            gradle
            cargo
            rustc

            # devops tools
            yq
            gnumake
          ];

          shellHook = ''
            echo "infra-in-a-box development shell"
            echo "Tools available: docker, kubectl, k3d, helm, java, gradle, cargo"
          '';
        };
      }
    );
}
