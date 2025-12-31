{ pkgs ? import <nixpkgs> { config = { cudaSupport = true; allowUnfree = true; }; } }:

let
  python = pkgs.python311;

  pythonWithPkgs = python.withPackages (ps:
    with ps; [
      pip
      setuptools
      wheel
      ipython
      jupyter
      (catppuccin.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ])
          ++ [ pygments ];
      }))
      pygments
      pyqt6
      opencv4
    ]);

  deps = with pkgs; [
    clang
    llvmPackages_16.bintools
    rustup
    linuxPackages.nvidia_x11
    freeglut
    zlib
    gcc
    stdenv.cc.cc.lib
    stdenv.cc
    libGLU
    libGL
    glib
    pango
    fontconfig
    python311Packages.matplotlib
    libsForQt5.qt5.qtwayland
    opencv
  ];

  lib-path = with pkgs; lib.makeLibraryPath deps;
  extra-ldflags = "-L${pkgs.linuxPackages.nvidia_x11}/lib";

in pkgs.mkShell {
  name = "segcam";

  buildInputs = deps ++ [
    pythonWithPkgs
    pkgs.readline
    pkgs.libffi
    pkgs.openssl
    pkgs.git
    pkgs.openssh
    pkgs.rsync
  ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${lib-path}
    export CUDA_PATH=${pkgs.cudatoolkit}
    export EXTRA_LDFLAGS=${extra-ldflags}
    export TZ="America/Toronto"
    if [[ ! -f .venv ]] && [[ ! -d .venv ]]; then
      setvenv
      VENV=$(cat .venv)
      source $VIRTUALENV_HOME/$VENV/bin/activate
      deactivate
    fi
  '';
}
