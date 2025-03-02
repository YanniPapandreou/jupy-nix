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
      RKernel = pkgs.callPackage ./RKernel { };
      rWrapper = pkgs.rWrapper;
      RPackages = with pkgs.rPackages; [
        IRkernel
        ggplot2
      ];
      rEnv = rWrapper.override { packages = RPackages; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          RKernel
          pythonEnv
          rEnv
          evcxr
        ];

        shellHook = ''
          echo "Setting up R kernel for Jupyter..."
          mkdir -p "${KernelsDir}/ir"
          cp -r ${pkgs.rPackages.IRkernel}/library/IRkernel/kernelspec/* "${KernelsDir}/ir"
          chmod -R u+w "${KernelsDir}/ir"
          mkdir -p "${KernelsDir}/r"
          cp -r ${RKernel}/library/RKernel/kernelspec/* "${KernelsDir}/r"
          mv "${KernelsDir}/r/RKernel.json" "${KernelsDir}/r/kernel.json"
          chmod -R u+w "${KernelsDir}/r"
          evcxr_jupyter --install > /dev/null 2>&1
          mv "$HOME/.local/share/jupyter/kernels/rust" "${KernelsDir}/rust/"
          export JUPYTER_PATH="$PWD/.jupyter"
          echo "Jupyter custom kernels is ready. Run: 'jupyter lab' to launch"
        '';
      };
    };
}
