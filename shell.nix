{ pkgs ? import <nixpkgs> { config = { allowUnfree = true; }; } }:

let
  # Get Python with proper packages
  python = pkgs.python310;
  
  # Create a Python with site-packages that includes numpy
  pythonWithPackages = python.withPackages (ps: with ps; [
    # Add packages you want available system-wide
    pip 
    setuptools
    wheel
    virtualenv
  ]);
  
in pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python
    pythonWithPackages
    
    # CUDA
    cudatoolkit
    
    # Essential libraries for building Python packages
    stdenv.cc.cc.lib  # This provides libstdc++
    zlib
    
    # Other common dependencies
    glib
    libGL
    libGLU
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXi
    xorg.libXfixes
  ];

  shellHook = ''
    # Create our virtual environment if it doesn't exist
    if [ ! -d ".venv" ]; then
      echo "Creating new virtual environment..."
      ${pythonWithPackages}/bin/python -m venv .venv
    fi
    
    # Set LD_LIBRARY_PATH to include all the libraries we need
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.zlib}/lib:${pkgs.cudatoolkit}/lib:${pkgs.libGL}/lib:$LD_LIBRARY_PATH
    
    # Make sure pip can find the C compiler
    export CC=${pkgs.stdenv.cc}/bin/cc
    export CXX=${pkgs.stdenv.cc}/bin/c++
    
    # Set CUDA environment variables
    export CUDA_HOME=${pkgs.cudatoolkit}
    export CUDA_PATH=${pkgs.cudatoolkit}
    
    # NIX_LDFLAGS helps find libraries during pip install
    export NIX_LDFLAGS="-L${pkgs.stdenv.cc.cc.lib}/lib $NIX_LDFLAGS"
  '';
}
