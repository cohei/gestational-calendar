{
  description = "Gestational Calendar";

  inputs = {
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unfree, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        unfree = nixpkgs-unfree.legacyPackages.${system};
      in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              google-cloud-sdk
              pkgs.zlib
              unfree.terraform
            ];
          };
        }
    );
}
