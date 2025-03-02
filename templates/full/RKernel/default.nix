{ pkgs }:
pkgs.rPackages.buildRPackage {
  name = "RKernel";
  src = pkgs.fetchFromGitHub {
    owner = "melff";
    repo = "RKernel";
    rev = "de236287f62bf3cdeddeac4753fcffb7915dde4e";
    sha256 = "sha256-F/W+1OFbjIWHCVgy0b5uAI/RSgyI6mb3PFiDD4tDmvA=";
  };

  propagatedBuildInputs = with pkgs.rPackages; [
    R6
    base64enc
    callr
    crayon
    curl
    digest
    evaluate
    htmltools
    htmlwidgets
    httpgd
    jsonlite
    pbdZMQ
    processx
    repr
    svglite
    unigd
    uuid
  ];

  sourceRoot = "source/pkg";

}
