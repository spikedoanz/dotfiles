nix-env -q --installed

cat installs.txt | cut -d'-' -f1 | xargs -I {} nix-env -iA nixpkgs.{}
