{
  description = "Jupyter Env using Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Adjust for your architecture if needed
      pkgs = import nixpkgs { inherit system; };
      pythonPackages =
        ps: with ps; [
          ipykernel
          jupyterlab
          matplotlib
          numpy
        ];
      pythonEnv = pkgs.python3.withPackages pythonPackages;
      # Where we want to install the IRkernel kernel files
      KernelsDir = ".jupyter/kernels";
      rWrapper = pkgs.rWrapper;
      RPackages = with pkgs.rPackages; [
        IRkernel
        ggplot2
      ];
      rEnv = rWrapper.override { packages = RPackages; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pythonEnv
          rEnv
        ];

        shellHook = ''
          echo "Setting up R kernel for Jupyter..."
          # Ensure an 'ir' folder exists in 'KernelsDir':
          mkdir -p "${KernelsDir}/ir"
          # Copy the files using interpolation
          cp -r ${pkgs.rPackages.IRkernel}/library/IRkernel/kernelspec/* "${KernelsDir}/ir"
          # Add write permission
          chmod -R u+w "${KernelsDir}/ir"
          # set up Jupyter to look for kernels in the '.kernels' dir:
          export JUPYTER_PATH="$PWD/.jupyter"
          echo "Jupyter custom kernels is ready. Run: 'jupyter lab' to launch"
        '';
      };
    };
}
