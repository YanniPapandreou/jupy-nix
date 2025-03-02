# Declarative Jupyter Lab dev environment using Nix

In this repo I include a Nix Flake to setup a development environment with Jupyter Lab and custom Jupyter kernels:

1. A Python kernel with specific Python packages installed.
2. An R kernel based on the `IRkernel` package with specific R packages installed.
3. An R kernel based on the recent `RKernel` package.
4. A Rust kernel based on the `evcxr` package.

To try out the templates one can run:

```
# for the default template with just a Python and IRkernel
nix flake new my-project -t github:YanniPapandreou/jupy-nix
# For all 4 kernels included
nix flake new my-project -t github:YanniPapandreou/jupy-nix#full
```

For more details on this flake I have a blog post on my personal website [here](https://yannipapandreou.github.io/posts/jupyter-kernels-nix/).
