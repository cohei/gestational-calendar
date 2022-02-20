{
  description = "Gestational Calendar";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        unfree = import nixpkgs { inherit system; config.allowUnfree = true; };
      in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              google-cloud-sdk
              unfree.terraform
            ];
          };
        }
    );
}
