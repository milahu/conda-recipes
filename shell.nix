# https://wiki.nixos.org/wiki/Python#Using_micromamba

{ pkgs ? import <nixpkgs> {}}:
let
  fhs = pkgs.buildFHSEnv {
    name = "fhs";
    targetPkgs = _: [
      pkgs.micromamba
    ];
    profile = ''
      set -e

      # fix: bash: hash: hashing disabled
      # https://github.com/NixOS/nixpkgs/issues/69396
      # https://github.com/NixOS/nixpkgs/issues/278397
      set -h

      # set -x # debug

      eval "$(micromamba shell hook --shell=posix)" # FIXME bash: hash: hashing disabled
      # eval "$(micromamba shell hook --shell=bash)" # FIXME /etc/profile: line 145: complete: command not found
      export MAMBA_ROOT_PREFIX=${builtins.getEnv "PWD"}/.mamba
      if ! test -d $MAMBA_ROOT_PREFIX/envs/conda-build; then
          # micromamba create --yes -q -n conda-build
          micromamba create --yes -q -n conda-build conda-build boa -c conda-forge
      fi
      micromamba activate conda-build
      # micromamba install --yes -f conda-requirements.txt -c conda-forge
      set +e
    '';
    # runScript = "bash";
  };
in fhs.env
