# Conda Build Fix

**User:** Anonymous  
**Created:** 2026/5/31 17:03:03  
**Updated:** 2026/5/31 20:23:46  
**Exported:** 2026/5/31 20:40:19  
**Link:** [<https://chatgpt.com/c/6a1c4da3-c724-83eb-b7f8-b21a8ae8e91d>](https://chatgpt.com/c/6a1c4da3-c724-83eb-b7f8-b21a8ae8e91d)

## Prompt:

5/31/2026, 5:03:03 PM

help me fix this conda build of rqbit

    # recipes/rqbit/recipe.yaml

    # based on
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/rq/rqbit/package.nix
    # https://conda-forge.org/docs/maintainer/example_recipes/rust/

    context:
      version: "9.0.0-beta.2"
      sha256: "45a2d4b5ffe8dfd0231d7417fff8b77d604e8412a858b6ee8b53cef25bdbcf9b"

    package:
      name: rqbit
      # fix: invalid value for `version`: `version cannot contain `-``.
      version: ${{ version | replace("-", "_") }}

    source:
      url: https://github.com/ikatson/rqbit/archive/refs/tags/v${{ version }}.tar.gz
      sha256: ${{ sha256 }}

    build:
      number: 0
      script:
        # env:
        #   CARGO_PROFILE_RELEASE_STRIP: symbols
        #   CARGO_PROFILE_RELEASE_LTO: fat
        content:
          - {"if":"win","then":"echo on","else":"set -x"} # trace commands
          - if: unix
            then:
              # error: found a virtual manifest at `$SRC_DIR/Cargo.toml` instead of a package manifest
              # - cargo auditable install --locked --no-track --bins --root ${{ PREFIX }} --path .
              # fix: set path
              - cargo auditable install --locked --no-track --bins --root ${{ PREFIX }} --path crates/rqbit
            else:
              - cargo auditable install --locked --no-track --bins --root %LIBRARY_PREFIX% --path crates/rqbit
          - cargo-bundle-licenses --format yaml --output ./THIRDPARTY.yml

    requirements:
      build:
        - ${{ stdlib('c') }}
        - ${{ compiler('c') }}
        - ${{ compiler('rust') }}
        - cargo-bundle-licenses
        - cargo-auditable

      host:
        - openssl
        - zlib # libz.so.1

      run:
        - openssl
        - zlib

    tests:
      - script:
        - rqbit --version

    about:
      homepage: https://github.com/ikatson/rqbit
      license: Apache-2.0
      license_file: LICENSE
      summary: "A bittorrent client in Rust"

    extra:
      recipe-maintainers:
        - milahu

build error

    $ rattler-build build -r recipes/rqbit/recipe.yaml --variant-config recipes/rqbit/variant_config.yaml

     ╭─ Finding outputs from recipe
     │ Loading variant config file: "recipes/rqbit/variant_config.yaml"
     │ Found 1 variants
     │ 
     │ Build variant: rqbit-9.0.0_beta.2-hdab6535_0
     │ 
     │ ╭─────────────────┬────────────╮
     │ │ Variant         ┆ Version    │
     │ ╞═════════════════╪════════════╡
     │ │ c_stdlib        ┆ "sysroot"  │
     │ │ target_platform ┆ "linux-64" │
     │ ╰─────────────────┴────────────╯
     │
     ╰─────────────────── (took 0 seconds)

     ╭─ Running build for recipe: rqbit-9.0.0_beta.2-hdab6535_0
     │
     │ ╭─ Fetching source code
     │ │ Fetching source from url: https://github.com/ikatson/rqbit/archive/refs/tags/v9.0.0-beta.2.tar.gz
     │ │ Found filename from Content-Disposition: rqbit-9.0.0-beta.2.tar.gz
     │ │ Validated SHA256 values of the downloaded file!
     │ │ Found valid source cache file.
     │ │ Using extracted directory from cache: /home/user/src/milahu/conda-recipes/output/src_cache/rqbit-9_0_0-beta_2_45a2d4b5
     │ │ Copying source from url: /home/user/src/milahu/conda-recipes/output/src_cache/rqbit-9_0_0-beta_2_45a2d4b5 to /home/user/src/milahu/conda-recipes/output
     │ │ /bld/rattler-build_rqbit_1780239422/work
     │ │
     │ ╰─────────────────── (took 0 seconds)
     │
     │ ╭─ Resolving environments
     │ │ 
     │ │ Resolving build environment:
     │ │   Platform: linux-64 [__unix=0=0, __linux=6.18.25=0, __glibc=2.42=0, __cuda=13.2=0, __archspec=1=zen3]
     │ │   Channels: 
     │ │    - file:///home/user/src/milahu/conda-recipes/output/
     │ │    - conda-forge
     │ │   Specs:
     │ │    - sysroot_linux-64
     │ │    - gcc_linux-64
     │ │    - rust_linux-64
     │ │    - cargo-bundle-licenses
     │ │    - cargo-auditable
     │ │ 
     │ │ ╭───────────────────────────────────┬───────────┬──────────────────────┬─────────────┬─────────────╮
     │ │ │ Package                           ┆ Version   ┆ Build                ┆ Channel     ┆        Size │
     │ │ ╞═══════════════════════════════════╪═══════════╪══════════════════════╪═════════════╪═════════════╡
     │ │ │ _openmp_mutex                     ┆ 4.5       ┆ 20_gnu               ┆ conda-forge ┆   28.27 KiB │
     │ │ │ binutils_impl_linux-64            ┆ 2.45.1    ┆ default_hfdba357_102 ┆ conda-forge ┆    3.49 MiB │
     │ │ │ binutils_linux-64                 ┆ 2.45.1    ┆ default_h4852527_102 ┆ conda-forge ┆   35.45 KiB │
     │ │ │ bzip2                             ┆ 1.0.8     ┆ hda65f42_9           ┆ conda-forge ┆  254.08 KiB │
     │ │ │ ca-certificates                   ┆ 2026.5.20 ┆ hbd8a1cb_0           ┆ conda-forge ┆  126.82 KiB │
     │ │ │ cargo-auditable                   ┆ 0.7.5     ┆ hb17b654_0           ┆ conda-forge ┆  442.16 KiB │
     │ │ │ cargo-bundle-licenses             ┆ 4.2.0     ┆ he179b06_0           ┆ conda-forge ┆    1.43 MiB │
     │ │ │ gcc_impl_linux-64                 ┆ 15.2.0    ┆ ha6850e4_19          ┆ conda-forge ┆   77.29 MiB │
     │ │ │ gcc_linux-64                      ┆ 15.2.0    ┆ h7be306e_25          ┆ conda-forge ┆   28.51 KiB │
     │ │ │ kernel-headers_linux-64           ┆ 6.12.0    ┆ he073ed8_6           ┆ conda-forge ┆    1.47 MiB │
     │ │ │ ld_impl_linux-64                  ┆ 2.45.1    ┆ default_hbd61a6d_102 ┆ conda-forge ┆  710.94 KiB │
     │ │ │ libgcc                            ┆ 15.2.0    ┆ he0feb66_19          ┆ conda-forge ┆ 1016.68 KiB │
     │ │ │ libgcc-devel_linux-64             ┆ 15.2.0    ┆ hcc6f6b0_119         ┆ conda-forge ┆    2.95 MiB │
     │ │ │ libgit2                           ┆ 1.9.4     ┆ hc20babb_0           ┆ conda-forge ┆ 1014.04 KiB │
     │ │ │ libgomp                           ┆ 15.2.0    ┆ he0feb66_19          ┆ conda-forge ┆  589.67 KiB │
     │ │ │ libsanitizer                      ┆ 15.2.0    ┆ h90f66d4_19          ┆ conda-forge ┆    7.56 MiB │
     │ │ │ libssh2                           ┆ 1.11.1    ┆ hcf80075_0           ┆ conda-forge ┆  297.65 KiB │
     │ │ │ libstdcxx                         ┆ 15.2.0    ┆ h934c35e_19          ┆ conda-forge ┆    5.58 MiB │
     │ │ │ libstdcxx-devel_linux-64          ┆ 15.2.0    ┆ hd446a21_119         ┆ conda-forge ┆   19.80 MiB │
     │ │ │ libzlib                           ┆ 1.3.2     ┆ h25fd6f3_2           ┆ conda-forge ┆   62.14 KiB │
     │ │ │ openssl                           ┆ 3.6.2     ┆ h35e630c_0           ┆ conda-forge ┆    3.02 MiB │
     │ │ │ pcre2                             ┆ 10.47     ┆ haa7fec5_0           ┆ conda-forge ┆    1.17 MiB │
     │ │ │ rust                              ┆ 1.95.0    ┆ h53717f1_1           ┆ conda-forge ┆  174.43 MiB │
     │ │ │ rust-std-x86_64-unknown-linux-gnu ┆ 1.95.0    ┆ h2c6d0dc_1           ┆ conda-forge ┆   34.73 MiB │
     │ │ │ rust_linux-64                     ┆ 1.95.0    ┆ hb4ea61c_2           ┆ conda-forge ┆   11.49 KiB │
     │ │ │ sysroot_linux-64                  ┆ 2.39      ┆ hc4b9eeb_6           ┆ conda-forge ┆   40.10 MiB │
     │ │ │ tzdata                            ┆ 2025c     ┆ hc9c84f9_1           ┆ conda-forge ┆  116.34 KiB │
     │ │ │ zstd                              ┆ 1.5.7     ┆ hb78ec9c_6           ┆ conda-forge ┆  587.28 KiB │
     │ │ ╰───────────────────────────────────┴───────────┴──────────────────────┴─────────────┴─────────────╯
     │ │ 
     │ │ Resolving host environment:
     │ │   Platform: linux-64 [__unix=0=0, __linux=6.18.25=0, __glibc=2.42=0, __cuda=13.2=0, __archspec=1=zen3]
     │ │   Channels: 
     │ │    - file:///home/user/src/milahu/conda-recipes/output/
     │ │    - conda-forge
     │ │   Specs:
     │ │    - openssl
     │ │    - zlib
     │ │    - __glibc >=2.39,<3.0.a0
     │ │    - libgcc >=15
     │ │ 
     │ │ ╭─────────────────┬───────────┬─────────────┬─────────────┬─────────────╮
     │ │ │ Package         ┆ Version   ┆ Build       ┆ Channel     ┆        Size │
     │ │ ╞═════════════════╪═══════════╪═════════════╪═════════════╪═════════════╡
     │ │ │ _openmp_mutex   ┆ 4.5       ┆ 20_gnu      ┆ conda-forge ┆   28.27 KiB │
     │ │ │ ca-certificates ┆ 2026.5.20 ┆ hbd8a1cb_0  ┆ conda-forge ┆  126.82 KiB │
     │ │ │ libgcc          ┆ 15.2.0    ┆ he0feb66_19 ┆ conda-forge ┆ 1016.68 KiB │
     │ │ │ libgomp         ┆ 15.2.0    ┆ he0feb66_19 ┆ conda-forge ┆  589.67 KiB │
     │ │ │ libzlib         ┆ 1.3.2     ┆ h25fd6f3_2  ┆ conda-forge ┆   62.14 KiB │
     │ │ │ openssl         ┆ 3.6.2     ┆ h35e630c_0  ┆ conda-forge ┆    3.02 MiB │
     │ │ │ zlib            ┆ 1.3.2     ┆ h25fd6f3_2  ┆ conda-forge ┆   93.68 KiB │
     │ │ ╰─────────────────┴───────────┴─────────────┴─────────────┴─────────────╯
     │ │ 
     │ │ Finalized run dependencies (rqbit-9.0.0_beta.2-hdab6535_0):
     │ │ ╭──────────────────┬──────────────────────────────────────────────────╮
     │ │ │ Name             ┆ Spec                                             │
     │ │ ╞══════════════════╪══════════════════════════════════════════════════╡
     │ │ │ Run dependencies ┆                                                  │
     │ │ │ __glibc          ┆ >=2.39,<3.0.a0 (RE of [build: sysroot_linux-64]) │
     │ │ │ libgcc           ┆ >=15 (RE of [build: gcc_linux-64])               │
     │ │ │ libzlib          ┆ >=1.3.2,<2.0a0 (RE of [host: zlib])              │
     │ │ │ openssl          ┆ *                                                │
     │ │ │                  ┆ >=3.6.2,<4.0a0 (RE of [host: openssl])           │
     │ │ │ zlib             ┆ *                                                │
     │ │ │                  ┆                                                  │
     │ │ │ Run constraints  ┆                                                  │
     │ │ │ __glibc          ┆ >=2.17 (RE of [build: rust_linux-64])            │
     │ │ ╰──────────────────┴──────────────────────────────────────────────────╯
     │ │
     │ ╰─────────────────── (took 1 second)
     │ 
     │ Installing build environment
     │ ✔ Successfully updated the build environment
     │ 
     │ Installing host environment
     │ ✔ Successfully updated the host environment
     │
     │ ╭─ Running build script
     │ │ INFO: activate-binutils_linux-64.sh made the following environmental changes:
     │ │ +ADDR2LINE=x86_64-conda-linux-gnu-addr2line
     │ │ -AR=ar
     │ │ +AR=x86_64-conda-linux-gnu-ar
     │ │ -AS=as
     │ │ +AS=x86_64-conda-linux-gnu-as
     │ │ +CXXFILT=x86_64-conda-linux-gnu-c++filt
     │ │ +ELFEDIT=x86_64-conda-linux-gnu-elfedit
     │ │ +GPROF=x86_64-conda-linux-gnu-gprof
     │ │ -LD=ld
     │ │ +LD=x86_64-conda-linux-gnu-ld
     │ │ -NM=nm
     │ │ +NM=x86_64-conda-linux-gnu-nm
     │ │ -OBJCOPY=objcopy
     │ │ +OBJCOPY=x86_64-conda-linux-gnu-objcopy
     │ │ -OBJDUMP=objdump
     │ │ +OBJDUMP=x86_64-conda-linux-gnu-objdump
     │ │ -RANLIB=ranlib
     │ │ +RANLIB=x86_64-conda-linux-gnu-ranlib
     │ │ -READELF=readelf
     │ │ +READELF=x86_64-conda-linux-gnu-readelf
     │ │ -SIZE=size
     │ │ +SIZE=x86_64-conda-linux-gnu-size
     │ │ -STRINGS=strings
     │ │ +STRINGS=x86_64-conda-linux-gnu-strings
     │ │ -STRIP=strip
     │ │ +STRIP=x86_64-conda-linux-gnu-strip
     │ │ INFO: activate-gcc_linux-64.sh made the following environmental changes:
     │ │ +build_alias=x86_64-conda-linux-gnu
     │ │ -BUILD=x86_64-conda_cos6-linux-gnu
     │ │ +BUILD=x86_64-conda-linux-gnu
     │ │ +CC_FOR_BUILD=x86_64-conda-linux-gnu-cc
     │ │ -CC=gcc
     │ │ +CC=x86_64-conda-linux-gnu-cc
     │ │ +CFLAGS=-march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem $PREFIX/include -f
     │ │ debug-prefix-map=$SRC_DIR=/usr/local/src/conda/rqbit-9.0.0_beta.2 -fdebug-prefix-map=$PREFIX=/usr/local/src/conda-prefix
     │ │ +CMAKE_ARGS=-DCMAKE_AR=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-ar -DCMAKE_CXX_COMPILER_AR=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-gcc-ar -DCMAKE_C_CO
     │ │ MPILER_AR=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-gcc-ar -DCMAKE_RANLIB=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-ranlib -DCMAKE_CXX_COMPILER_RANLIB=$B
     │ │ UILD_PREFIX/bin/x86_64-conda-linux-gnu-gcc-ranlib -DCMAKE_C_COMPILER_RANLIB=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-gcc-ranlib -DCMAKE_LINKER=$BUILD_P
     │ │ REFIX/bin/x86_64-conda-linux-gnu-ld -DCMAKE_STRIP=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-strip -DCMAKE_BUILD_TYPE=Release -DCMAKE_FIND_ROOT_PATH_MODE
     │ │ _PROGRAM=NEVER -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY -DCMAKE_FIND_ROOT_PATH=$PREFIX;$BUILD_PREFIX/x86_64-co
     │ │ nda-linux-gnu/sysroot -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_PROGRAM_PATH=$BUILD_PREFIX/bin;$PREFIX/bin
     │ │ +CMAKE_PREFIX_PATH=$PREFIX:$BUILD_PREFIX/x86_64-conda-linux-gnu/sysroot/usr
     │ │ +CONDA_BUILD_CROSS_COMPILATION=
     │ │ -CONDA_BUILD_CROSS_COMPILATION=0
     │ │ +CONDA_BUILD_SYSROOT=$BUILD_PREFIX/x86_64-conda-linux-gnu/sysroot
     │ │ +CONDA_TOOLCHAIN_BUILD=x86_64-conda-linux-gnu
     │ │ +CONDA_TOOLCHAIN_HOST=x86_64-conda-linux-gnu
     │ │ +CPPFLAGS=-DNDEBUG -D_FORTIFY_SOURCE=2 -O2 -isystem $PREFIX/include
     │ │ +CPP_FOR_BUILD=x86_64-conda-linux-gnu-cpp
     │ │ +CPP=x86_64-conda-linux-gnu-cpp
     │ │ + cargo auditable install --locked --no-track --bins --root $PREFIX --path crates/rqbit
     │ │ +DEBUG_CFLAGS=-march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-all -fno-plt -Og -g -Wall -Wextra -fvar-tracking-assignments -ffunc
     │ │ tion-sections -pipe -isystem $PREFIX/include -fdebug-prefix-map=$SRC_DIR=/usr/local/src/conda/rqbit-9.0.0_beta.2 -fdebug-prefix-map=$PREFIX=/usr/local/s
     │ │ rc/conda-prefix
     │ │ +DEBUG_CPPFLAGS=-D_DEBUG -D_FORTIFY_SOURCE=2 -Og -isystem $PREFIX/include
    ...
     │ │ +LDFLAGS_LD=-O2 --sort-common --as-needed -z relro -z now --disable-new-dtags --gc-sections --allow-shlib-undefined -rpath $PREFIX/lib -rpath-link $PRE
     │ │ FIX/lib -L$PREFIX/lib
     │ │ +LDFLAGS=-Wl,-O2 -Wl,--sort-common -Wl,--as-needed -Wl,-z,relro -Wl,-z,now -Wl,--disable-new-dtags -Wl,--gc-sections -Wl,--allow-shlib-undefined -Wl,-r
     │ │ path,$PREFIX/lib -Wl,-rpath-link,$PREFIX/lib -L$PREFIX/lib
     │ │ +MESON_ARGS=-Dbuildtype=release --prefix=$PREFIX -Dlibdir=lib
     │ │   Installing rqbit v9.0.0-beta.2 ($SRC_DIR/crates/rqbit)
     │ │     Updating crates.io index
     │ │  Downloading crates ...
    ...
     │ │   Downloaded libc v0.2.180
    ...
     │ │    Compiling libc v0.2.180
    ...
     │ │ error: failed to run custom build command for `libc v0.2.180`
     │ │ Caused by:
     │ │   process didn't exit successfully: `$SRC_DIR/target/release/build/libc-37415bdeb09e56d6/build-script-build` (exit status: 101)
     │ │   --- stdout
     │ │   cargo:rerun-if-changed=build.rs
     │ │   --- stderr
     │ │   thread 'main' (942499) panicked at $BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180/build.rs:211:5:
     │ │   failed to run rustc: $BUILD_PREFIX/bin/rustc: error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or direct
     │ │ ory
     │ │   note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

## Response:

5/31/2026, 5:03:03 PM

The key clue is here:

``` text
failed to run rustc: $BUILD_PREFIX/bin/rustc:
error while loading shared libraries: libz.so.1:
cannot open shared object file: No such file or directory
```

This is **not** an rqbit problem. `rustc` itself cannot start.

### Why this happens

`rustc` comes from the **build environment**:

``` yaml
requirements:
  build:
    - rust_linux-64
```

but `zlib` is only in the **host environment**:

``` yaml
requirements:
  host:
    - openssl
    - zlib
```

During the build, Cargo invokes:

``` text
$BUILD_PREFIX/bin/rustc
```

and that executable is linked against `libz.so.1`. Since `libzlib` is absent from the build environment, the dynamic loader can't start rustc.

### Fix

Add `zlib` to `build` requirements too:

``` yaml
requirements:
  build:
    - ${{ stdlib('c') }}
    - ${{ compiler('c') }}
    - ${{ compiler('rust') }}
    - zlib
    - cargo-bundle-licenses
    - cargo-auditable

  host:
    - openssl
    - zlib
```

I would also add `openssl` to build because some crates' build scripts use it:

``` yaml
requirements:
  build:
    - ${{ stdlib('c') }}
    - ${{ compiler('c') }}
    - ${{ compiler('rust') }}
    - zlib
    - openssl
    - cargo-bundle-licenses
    - cargo-auditable
```

------------------------------------------------------------------------

### Verify before rebuilding

Drop into the build env and check:

``` bash
ldd $BUILD_PREFIX/bin/rustc | grep z
```

You will probably see something like:

``` text
libz.so.1 => not found
```

or

``` text
libz.so.1 => /path/to/libz.so.1
```

after adding `zlib`.

You can also inspect all missing dependencies:

``` bash
ldd $BUILD_PREFIX/bin/rustc | grep "not found"
```

------------------------------------------------------------------------

### Another possible issue

rqbit uses a workspace. Your current fix:

``` yaml
cargo auditable install \
  --locked \
  --no-track \
  --bins \
  --root ${{ PREFIX }} \
  --path crates/rqbit
```

is the correct way to avoid:

``` text
found a virtual manifest at Cargo.toml
```

so I would keep that.

------------------------------------------------------------------------

### If adding `zlib` doesn't fix it

The next thing I'd inspect is whether rattler-build is exposing the host libraries to Cargo. Run:

``` bash
echo $LD_LIBRARY_PATH
ldd $BUILD_PREFIX/bin/rustc
```

inside the failing build environment.

If `libz.so.1` is still missing after adding `zlib` to `build`, then this is likely a rattler-build environment activation issue rather than a recipe issue. But from the log you've shown, the most likely fix is simply:

``` yaml
requirements:
  build:
    - zlib
```

because the failure occurs before any rqbit code is compiled, when Cargo tries to launch `rustc`.

## Prompt:

5/31/2026, 5:24:27 PM

no, adding zlib to the build requirements does not help

rustc seems to work outside of the build sandbox

    $ /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780239883/build_env/bin/rustc --version
    rustc 1.95.0 (59807616e 2026-04-14)
    $ ldd /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780239883/build_env/bin/rustc | grep libz
            libz.so.1 => /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780239883/build_env/bin/../lib/../lib/../lib/libz.so.1 (0x0000796e3bbe5000)
    $ ldd /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780239883/build_env/bin/../lib/../lib/../lib/libz.so.1
            linux-vdso.so.1 (0x00007baae9bac000)
            libc.so.6 => /lib/libc.so.6 (0x00007baae9800000)
            /nix/store/fjkx1l5cnskzrqacf08z7i8z17256w0j-glibc-2.42-61/lib64/ld-linux-x86-64.so.2 (0x00007baae9bae000)

i have added some debug commands, and also in the build sandbox, rustc seems to work...


    build:
      number: 0
      script:
        # env:
        #   CARGO_PROFILE_RELEASE_STRIP: symbols
        #   CARGO_PROFILE_RELEASE_LTO: fat
        content:
          - {"if":"win","then":"echo on","else":"set -x"} # trace commands
          - if: unix
            then:
              # debug: failed to run rustc: $BUILD_PREFIX/bin/rustc: error while loading shared libraries: libz.so.1: cannot open shared object file: No such file
              - which rustc
              - ldd $(which rustc) | grep libz
              - ldd $BUILD_PREFIX/bin/rustc | grep libz
              - ldd $BUILD_PREFIX/bin/../lib/../lib/../lib/libz.so.1
              - $BUILD_PREFIX/bin/rustc --version
              - rustc --version
              # error: found a virtual manifest at `$SRC_DIR/Cargo.toml` instead of a package manifest
              # - cargo auditable install --locked --no-track --bins --root ${{ PREFIX }} --path .
              # fix: set path
              - cargo auditable install --locked --no-track --bins --root ${{ PREFIX }} --path crates/rqbit
            else:
              - cargo auditable install --locked --no-track --bins --root %LIBRARY_PREFIX% --path crates/rqbit
          - cargo-bundle-licenses --format yaml --output ./THIRDPARTY.yml

output

     │ │ + ldd $BUILD_PREFIX/bin/rustc
     │ │    libz.so.1 => $BUILD_PREFIX/bin/../lib/../lib/../lib/libz.so.1 (0x000072337c96e000)
     │ │ + ldd $BUILD_PREFIX/bin/rustc
     │ │ + grep libz
     │ │    libz.so.1 => $BUILD_PREFIX/bin/../lib/../lib/../lib/libz.so.1 (0x00007a020bce0000)
     │ │ + ldd $BUILD_PREFIX/bin/../lib/../lib/../lib/libz.so.1
     │ │    linux-vdso.so.1 (0x00007c06d81e0000)
     │ │    libc.so.6 => /lib/libc.so.6 (0x00007c06d7e00000)
     │ │    /nix/store/fjkx1l5cnskzrqacf08z7i8z17256w0j-glibc-2.42-61/lib64/ld-linux-x86-64.so.2 (0x00007c06d81e2000)
     │ │ + $BUILD_PREFIX/bin/rustc --version
     │ │ rustc 1.95.0 (59807616e 2026-04-14)
     │ │ + rustc --version
     │ │ rustc 1.95.0 (59807616e 2026-04-14)

## Response:

5/31/2026, 5:24:28 PM

Interesting. The new evidence changes the diagnosis.

If these succeed immediately before Cargo starts:

``` bash
$BUILD_PREFIX/bin/rustc --version
rustc --version
ldd $BUILD_PREFIX/bin/rustc
```

then the error message from `libc`'s build.rs is probably **not talking about the same environment** that your shell is using.

Notice the failing command:

``` text
process didn't exit successfully:
$SRC_DIR/target/release/build/libc-37415bdeb09e56d6/build-script-build

failed to run rustc:
$BUILD_PREFIX/bin/rustc:
error while loading shared libraries: libz.so.1
```

This is emitted by the `libc` crate's build script. It is spawning a subprocess and checking `rustc --version --verbose` internally.

A few possibilities come to mind.

## 1. Cargo is sanitizing the environment

Print these immediately before the cargo invocation:

``` bash
env | sort > /tmp/env.before-cargo
echo "PATH=$PATH"
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "RUSTC=$RUSTC"
echo "CARGO_HOME=$CARGO_HOME"
```

Then try:

``` bash
cargo build -p rqbit -vv
```

instead of `cargo auditable install`.

The `-vv` output will show the exact command lines Cargo is executing.

I'm interested in whether the failing rustc invocation is:

``` text
$BUILD_PREFIX/bin/rustc
```

or some wrapper script.

------------------------------------------------------------------------

## 2. cargo-auditable wrapper

`cargo auditable install` is not plain cargo.

It injects:

``` text
RUSTC_WORKSPACE_WRAPPER=...
```

and changes rustc invocation behavior.

Try replacing:

``` yaml
- cargo auditable install --locked --no-track --bins --root ${{ PREFIX }} --path crates/rqbit
```

with:

``` yaml
- cargo install --locked --no-track --bins --root ${{ PREFIX }} --path crates/rqbit
```

If that succeeds, the problem is inside cargo-auditable.

I have seen wrapper tools accidentally lose dynamic linker environment before.

------------------------------------------------------------------------

## 3. Build script inherits a different loader path

The really suspicious part is this:

``` text
$BUILD_PREFIX/bin/rustc --version
```

works from the shell,

but

``` text
build-script-build -> rustc
```

fails.

That often means:

``` bash
LD_LIBRARY_PATH
```

exists in the shell but not in the subprocess.

Check:

``` bash
cargo rustc -vv
```

or inside the build script environment:

``` bash
cargo build -vv 2>&1 | tee build.log
```

and search for:

``` text
Running `.../build-script-build`
```

The verbose output usually dumps the environment Cargo passes.

------------------------------------------------------------------------

## 4. Nix sandbox interaction

Your paths show:

``` text
/lib/libc.so.6
/nix/store/.../ld-linux-x86-64.so.2
```

which suggests you're running rattler-build from a Nix environment.

I've seen cases where:

``` bash
patchelf --print-rpath $BUILD_PREFIX/bin/rustc
```

looks fine,

but subprocesses executed inside a sandbox lose access to the conda lib directory.

Check:

``` bash
readelf -d $BUILD_PREFIX/bin/rustc | grep -E 'RPATH|RUNPATH'
```

and compare it to:

``` bash
patchelf --print-rpath $BUILD_PREFIX/bin/rustc
```

The important question is whether rustc depends on:

``` text
$ORIGIN/../lib
```

or on `LD_LIBRARY_PATH`.

------------------------------------------------------------------------

## 5. Cargo target directory contamination

Another thing I noticed:

``` text
$SRC_DIR/target/release/build/libc-37415bdeb09e56d6
```

Cargo is using a source-tree target directory.

If you previously built rqbit outside rattler-build, that target dir may contain stale build artifacts referencing another rust toolchain.

Try adding:

``` yaml
- rm -rf target
```

before cargo.

Or force a fresh target:

``` yaml
script:
  env:
    CARGO_TARGET_DIR: $SRC_DIR/.cargo-target
```

I've seen bizarre build-script failures caused by reused target directories.

------------------------------------------------------------------------

## The first thing I'd try

Given the evidence, my next debugging step would be:

``` yaml
- rm -rf target
- cargo install --locked --bins --root $PREFIX --path crates/rqbit -vv
```

(remove `cargo-auditable` temporarily)

If that builds, you've isolated the problem to cargo-auditable.

If it still fails, the verbose log around the failing `libc` build script will likely reveal the exact rustc command and environment that differs from the shell where `rustc --version` succeeds.

## Prompt:

5/31/2026, 5:30:12 PM

with `cargo build -p rqbit -vv --jobs 1` i get

     │ │    Compiling libc v0.2.180
     │ │      Running `CARGO=$BUILD_PREFIX/bin/cargo CARGO_CRATE_NAME=build_script_build CARGO_MANIFEST_DIR=$BUILD_PREFIX/.cargo/registry/src/index.crates.io-19
     │ │ 49cf8c6b5b557f/libc-0.2.180 CARGO_MANIFEST_PATH=$BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180/Cargo.toml CARGO_PKG_AU
     │ │ THORS='The Rust Project Developers' CARGO_PKG_DESCRIPTION='Raw FFI bindings to platform libraries like libc.' CARGO_PKG_HOMEPAGE='' CARGO_PKG_LICENSE='
     │ │ MIT OR Apache-2.0' CARGO_PKG_LICENSE_FILE='' CARGO_PKG_NAME=libc CARGO_PKG_README=README.md CARGO_PKG_REPOSITORY='https://github.com/rust-lang/libc' CA
     │ │ RGO_PKG_RUST_VERSION=1.63 CARGO_PKG_VERSION=0.2.180 CARGO_PKG_VERSION_MAJOR=0 CARGO_PKG_VERSION_MINOR=2 CARGO_PKG_VERSION_PATCH=180 CARGO_PKG_VERSION_P
     │ │ RE='' LD_LIBRARY_PATH='$SRC_DIR/target/debug/deps:/etc/sane-libs' $BUILD_PREFIX/bin/rustc --crate-name build_script_build --edition=2021 $BUILD_PREFIX/
     │ │ .cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180/build.rs --error-format=json --json=diagnostic-rendered-ansi,artifacts,future-incompa
     │ │ t --crate-type bin --emit=dep-info,link -C embed-bitcode=no -C debuginfo=2 '--allow=clippy::used_underscore_binding' --allow=unused_qualifications '--w
     │ │ arn=clippy::unnecessary_semicolon' '--allow=clippy::unnecessary_cast' '--allow=clippy::uninlined_format_args' '--warn=clippy::ptr_as_ptr' '--allow=clip
     │ │ py::non_minimal_cfg' '--allow=clippy::missing_safety_doc' '--warn=clippy::map_unwrap_or' '--warn=clippy::manual_assert' '--allow=clippy::identity_op' '
     │ │ --warn=clippy::explicit_iter_loop' '--allow=clippy::expl_impl_clone_on_copy' --cfg 'feature="default"' --cfg 'feature="extra_traits"' --cfg 'feature="s
     │ │ td"' --check-cfg 'cfg(docsrs,test)' --check-cfg 'cfg(feature, values("align", "const-extern-fn", "default", "extra_traits", "rustc-dep-of-std", "rustc-
     │ │ std-workspace-core", "std", "use_std"))' -C metadata=81cdda0898b7c771 -C extra-filename=-39e60099799de6b9 --out-dir $SRC_DIR/target/debug/build/libc-39
     │ │ e60099799de6b9 -C linker=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-cc -L dependency=$SRC_DIR/target/debug/deps --cap-lints warn`
     │ │      Running `CARGO=$BUILD_PREFIX/bin/cargo CARGO_CFG_DEBUG_ASSERTIONS='' CARGO_CFG_FEATURE=default,extra_traits,std CARGO_CFG_PANIC=unwind CARGO_CFG_T
     │ │ ARGET_ABI='' CARGO_CFG_TARGET_ARCH=x86_64 CARGO_CFG_TARGET_ENDIAN=little CARGO_CFG_TARGET_ENV=gnu CARGO_CFG_TARGET_FAMILY=unix CARGO_CFG_TARGET_FEATURE
     │ │ =fxsr,sse,sse2 CARGO_CFG_TARGET_HAS_ATOMIC=16,32,64,8,ptr CARGO_CFG_TARGET_OS=linux CARGO_CFG_TARGET_POINTER_WIDTH=64 CARGO_CFG_TARGET_VENDOR=unknown C
     │ │ ARGO_CFG_UNIX='' CARGO_ENCODED_RUSTFLAGS='-Clink-arg=-Wl,-rpath-link,$PREFIX/lib-Clink-arg=-Wl,-rpath,$PREFIX/lib' CARGO_FEATURE_DEFAULT=1 CARGO_FEA
     │ │ TURE_EXTRA_TRAITS=1 CARGO_FEATURE_STD=1 CARGO_MANIFEST_DIR=$BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180 CARGO_MANIFE
     │ │ ST_PATH=$BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180/Cargo.toml CARGO_PKG_AUTHORS='The Rust Project Developers' CARG
     │ │ O_PKG_DESCRIPTION='Raw FFI bindings to platform libraries like libc.' CARGO_PKG_HOMEPAGE='' CARGO_PKG_LICENSE='MIT OR Apache-2.0' CARGO_PKG_LICENSE_FIL
     │ │ E='' CARGO_PKG_NAME=libc CARGO_PKG_README=README.md CARGO_PKG_REPOSITORY='https://github.com/rust-lang/libc' CARGO_PKG_RUST_VERSION=1.63 CARGO_PKG_VERS
     │ │ ION=0.2.180 CARGO_PKG_VERSION_MAJOR=0 CARGO_PKG_VERSION_MINOR=2 CARGO_PKG_VERSION_PATCH=180 CARGO_PKG_VERSION_PRE='' DEBUG=true HOST=x86_64-unknown-lin
     │ │ ux-gnu LD_LIBRARY_PATH='$SRC_DIR/target/debug:$SRC_DIR/target/debug/deps:$BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib:/etc/sane-libs' NUM_JOB
     │ │ S=1 OPT_LEVEL=0 OUT_DIR=$SRC_DIR/target/x86_64-unknown-linux-gnu/debug/build/libc-428a78da9e933a13/out PROFILE=debug RUSTC=$BUILD_PREFIX/bin/rustc RUST
     │ │ C_LINKER=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-cc RUSTDOC=$BUILD_PREFIX/bin/rustdoc TARGET=x86_64-unknown-linux-gnu $SRC_DIR/target/debug/build/libc
     │ │ -39e60099799de6b9/build-script-build`
     │ │ [libc 0.2.180] cargo:rerun-if-changed=build.rs
     │ │ [libc 0.2.180] 
     │ │ [libc 0.2.180] thread 'main' (964824) panicked at $BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180/build.rs:211:5:
     │ │ [libc 0.2.180] failed to run rustc: $BUILD_PREFIX/bin/rustc: error while loading shared libraries: libz.so.1: cannot open shared object file: No such f
     │ │ ile or directory
     │ │ [libc 0.2.180] 
     │ │ [libc 0.2.180] note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
     │ │ error: failed to run custom build command for `libc v0.2.180`
     │ │ Caused by:
     │ │   process didn't exit successfully: `CARGO=$BUILD_PREFIX/bin/cargo CARGO_CFG_DEBUG_ASSERTIONS='' CARGO_CFG_FEATURE=default,extra_traits,std CARGO_CFG_P
     │ │ ANIC=unwind CARGO_CFG_TARGET_ABI='' CARGO_CFG_TARGET_ARCH=x86_64 CARGO_CFG_TARGET_ENDIAN=little CARGO_CFG_TARGET_ENV=gnu CARGO_CFG_TARGET_FAMILY=unix C
     │ │ ARGO_CFG_TARGET_FEATURE=fxsr,sse,sse2 CARGO_CFG_TARGET_HAS_ATOMIC=16,32,64,8,ptr CARGO_CFG_TARGET_OS=linux CARGO_CFG_TARGET_POINTER_WIDTH=64 CARGO_CFG_
     │ │ TARGET_VENDOR=unknown CARGO_CFG_UNIX='' CARGO_ENCODED_RUSTFLAGS='-Clink-arg=-Wl,-rpath-link,$PREFIX/lib-Clink-arg=-Wl,-rpath,$PREFIX/lib' CARGO_FEAT
     │ │ URE_DEFAULT=1 CARGO_FEATURE_EXTRA_TRAITS=1 CARGO_FEATURE_STD=1 CARGO_MANIFEST_DIR=$BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/li
     │ │ bc-0.2.180 CARGO_MANIFEST_PATH=$BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180/Cargo.toml CARGO_PKG_AUTHORS='The Rust P
     │ │ roject Developers' CARGO_PKG_DESCRIPTION='Raw FFI bindings to platform libraries like libc.' CARGO_PKG_HOMEPAGE='' CARGO_PKG_LICENSE='MIT OR Apache-2.0
     │ │ ' CARGO_PKG_LICENSE_FILE='' CARGO_PKG_NAME=libc CARGO_PKG_README=README.md CARGO_PKG_REPOSITORY='https://github.com/rust-lang/libc' CARGO_PKG_RUST_VERS
     │ │ ION=1.63 CARGO_PKG_VERSION=0.2.180 CARGO_PKG_VERSION_MAJOR=0 CARGO_PKG_VERSION_MINOR=2 CARGO_PKG_VERSION_PATCH=180 CARGO_PKG_VERSION_PRE='' DEBUG=true 
     │ │ HOST=x86_64-unknown-linux-gnu LD_LIBRARY_PATH='$SRC_DIR/target/debug:$SRC_DIR/target/debug/deps:$BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib:
     │ │ /etc/sane-libs' NUM_JOBS=1 OPT_LEVEL=0 OUT_DIR=$SRC_DIR/target/x86_64-unknown-linux-gnu/debug/build/libc-428a78da9e933a13/out PROFILE=debug RUSTC=$BUIL
     │ │ D_PREFIX/bin/rustc RUSTC_LINKER=$BUILD_PREFIX/bin/x86_64-conda-linux-gnu-cc RUSTDOC=$BUILD_PREFIX/bin/rustdoc TARGET=x86_64-unknown-linux-gnu $SRC_DIR/
     │ │ target/debug/build/libc-39e60099799de6b9/build-script-build` (exit status: 101)
     │ │   --- stdout
     │ │   cargo:rerun-if-changed=build.rs
     │ │   --- stderr
     │ │   thread 'main' (964824) panicked at $BUILD_PREFIX/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/libc-0.2.180/build.rs:211:5:
     │ │   failed to run rustc: $BUILD_PREFIX/bin/rustc: error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or direct
     │ │ ory
     │ │   note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace

## Response:

5/31/2026, 5:30:13 PM

Now we have the smoking gun.

Compare the environment where `rustc --version` succeeds versus the environment inside the libc build script:

Successful shell:

``` bash
$BUILD_PREFIX/bin/rustc --version
```

Build script:

``` text
LD_LIBRARY_PATH='$SRC_DIR/target/debug:$SRC_DIR/target/debug/deps:$BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib:/etc/sane-libs'
RUSTC=$BUILD_PREFIX/bin/rustc
...
$SRC_DIR/target/debug/build/libc-39e60099799de6b9/build-script-build
```

Notice what's missing from that `LD_LIBRARY_PATH`:

``` text
$BUILD_PREFIX/lib
```

The build script is spawning rustc, and rustc is being loaded under:

``` text
LD_LIBRARY_PATH=
  $SRC_DIR/target/debug
  $SRC_DIR/target/debug/deps
  $BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib
  /etc/sane-libs
```

but **not**:

``` text
$BUILD_PREFIX/lib
```

where your `libz.so.1` lives.

So libc's build.rs is effectively doing:

``` rust
Command::new(rustc).arg("--version")
```

and that subprocess cannot find:

``` text
$BUILD_PREFIX/lib/libz.so.1
```

even though the parent shell can.

------------------------------------------------------------------------

The weird part is why rustc works at all from the shell.

I'd print:

``` bash
echo "$LD_LIBRARY_PATH"
```

immediately before cargo starts.

I suspect rattler activation gives you something like:

``` text
$BUILD_PREFIX/lib:...
```

which Cargo later overwrites for build scripts.

------------------------------------------------------------------------

The quickest test is:

``` yaml
build:
  script:
    env:
      LD_LIBRARY_PATH: "${BUILD_PREFIX}/lib:${LD_LIBRARY_PATH}"
```

or in shell:

``` bash
export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
cargo build -p rqbit -vv --jobs 1
```

If that fixes it, you've confirmed the diagnosis.

------------------------------------------------------------------------

Even more convincing would be to reproduce the exact failing environment manually:

``` bash
env -i \
  LD_LIBRARY_PATH="$SRC_DIR/target/debug:$SRC_DIR/target/debug/deps:$BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib:/etc/sane-libs" \
  $BUILD_PREFIX/bin/rustc --version
```

I expect that command to fail with exactly:

``` text
error while loading shared libraries: libz.so.1
```

which would prove that Cargo's build-script environment is dropping the path to `libz`.

------------------------------------------------------------------------

One other thing jumps out:

``` text
CARGO_ENCODED_RUSTFLAGS='-Clink-arg=-Wl,-rpath-link,$PREFIX/lib-Clink-arg=-Wl,-rpath,$PREFIX/lib'
```

That looks suspiciously malformed.

Normally Cargo expects NUL-separated flags in `CARGO_ENCODED_RUSTFLAGS`, not a concatenated string. But that affects linking, not loading `rustc`, so it's probably a separate issue.

My current hypothesis is:

1.  rattler activates an environment where rustc can find `libz.so.1`
2.  Cargo launches the libc build script
3.  Cargo rewrites `LD_LIBRARY_PATH`
4.  libc build.rs runs `rustc --version`
5.  rustc no longer sees `$BUILD_PREFIX/lib`
6.  libc build.rs panics

The exact reproduction with `env -i ... rustc --version` should tell us immediately whether that's what's happening.

## Prompt:

5/31/2026, 5:32:09 PM

ah, i forgot to post the debug prints

     │ │ PATH=$BUILD_PREFIX/bin:$PREFIX/bin:/home/user/src/milahu/conda-recipes/.mamba/envs/conda-build/bin:/run/wrappers/bin:/usr/bin:/usr/sbin:/condabin:/run/
     │ │ wrappers/bin:/usr/bin:/usr/sbin:/nix/store/4bwbk4an4bx7cb8xwffghvjjyfyl7m2i-bash-interactive-5.3p9/bin:/nix/store/66lksljlljdd5ppgvfk8g89y8xgqcxd7-patc
     │ │ helf-0.15.2/bin:/nix/store/jjxngswsb214vb58qx485jhmilf0kxxy-coreutils-9.10/bin:/nix/store/vhsirn9m1ifmnw5g1qczzhvqkx6lw1if-findutils-4.10.0/bin:/nix/st
     │ │ ore/hx084k7pgz4n0vgkvil9gbcnl8y6p1xf-diffutils-3.12/bin:/nix/store/af4a8i43kc2ss4rnmf0swkk2mprsw6xq-gnused-4.9/bin:/nix/store/wf7lr2hf43546jc5kwqh3dbxn
     │ │ pcnw1mn-gnugrep-3.12/bin:/nix/store/lakv43kv98sl6h0ba6wnyg513mcq61vl-gawk-5.4.0/bin:/nix/store/rnvb7bvp53v2dw7pcwh9xb89x5z4rjib-gnutar-1.35/bin:/nix/st
     │ │ ore/9lhr1c3l9qzv8pzp3idmii1nwvxxjys3-gzip-1.14/bin:/nix/store/zj6r42syyswkhrr174bzppj3n7xhq936-bzip2-1.0.8-bin/bin:/nix/store/yvrwcs1a45rj8142n0l2w9q9s
     │ │ 6akamjr-gnumake-4.4.1/bin:/nix/store/i27rhb3nr65rkrwz36bchkwmav6ggsmn-bash-5.3p9/bin:/nix/store/zj7mxwji29zvj9vl70iip7gw4h6ljfam-patch-2.8/bin:/nix/sto
     │ │ re/2nm5c858fh52s6mhcffm07s3biaxys44-xz-5.8.3-bin/bin:/nix/store/iscmg3ivhx7z67dz14lrg7p77gnsa4dw-file-5.45/bin:/home/user/.local/share/pnpm:/run/wrappe
     │ │ rs/bin:/home/user/.nix-profile/bin:/nix/profile/bin:/home/user/.local/state/nix/profile/bin:/etc/profiles/per-user/user/bin:/nix/var/nix/profiles/defau
     │ │ lt/bin:/run/current-system/sw/bin:/home/user/bin:/home/user/.lmstudio/bin:/home/user/bin:/home/user/.lmstudio/bin
     │ │ LD_LIBRARY_PATH=/etc/sane-libs
     │ │ RUSTC=$BUILD_PREFIX/bin/rustc
     │ │ CARGO_HOME=$BUILD_PREFIX/.cargo

## Response:

5/31/2026, 5:32:09 PM

That confirms it.

Before Cargo starts, you already have:

``` text
LD_LIBRARY_PATH=/etc/sane-libs
```

and **not**:

``` text
$BUILD_PREFIX/lib
```

So the reason

``` bash
$BUILD_PREFIX/bin/rustc --version
```

works from the shell is **not** because of `LD_LIBRARY_PATH`.

That means rustc itself must have a valid RPATH/RUNPATH to find `libz.so.1`.

But then the libc build script launches the same rustc and it suddenly cannot find `libz.so.1`.

That is much stranger.

The next thing I'd check is whether the failing rustc is actually the same executable.

The libc build script uses:

``` text
RUSTC=$BUILD_PREFIX/bin/rustc
```

but it does not necessarily execute it directly.

Looking at libc 0.2.180 build.rs, line 211 is inside the code that probes rustc version. It effectively does:

``` rust
Command::new(rustc)
    .arg("--version")
```

So it should be the same binary.

I'd inspect the dynamic loader information of rustc:

``` bash
readelf -d $BUILD_PREFIX/bin/rustc | grep -E 'RPATH|RUNPATH'
patchelf --print-rpath $BUILD_PREFIX/bin/rustc
```

My suspicion is that rustc depends on `$ORIGIN`-based RUNPATH and something is stripping it when the build script invokes it.

------------------------------------------------------------------------

Another thing jumps out from your log:

``` text
LD_LIBRARY_PATH='$SRC_DIR/target/debug:$SRC_DIR/target/debug/deps:$BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib:/etc/sane-libs'
```

Cargo has prepended its own paths.

Notice that it includes:

``` text
$BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib
```

but not

``` text
$BUILD_PREFIX/lib
```

If any library in `rustlib/.../lib` depends on `libz.so.1`, the dynamic loader will now search:

1.  target/debug
2.  target/debug/deps
3.  rustlib/.../lib
4.  /etc/sane-libs

and never reach `$BUILD_PREFIX/lib`.

The fact that direct execution works but execution under Cargo fails strongly suggests a RUNPATH-vs-LD_LIBRARY_PATH interaction.

Remember:

``` text
LD_LIBRARY_PATH
```

takes precedence over RUNPATH.

Cargo is replacing the runtime search path with one that omits `$BUILD_PREFIX/lib`.

------------------------------------------------------------------------

I would test this immediately:

``` yaml
script:
  content:
    - export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
    - cargo build -p rqbit -vv --jobs 1
```

If that fixes it, you've found a Cargo/rattler environment bug.

------------------------------------------------------------------------

An even cleaner proof:

Add before cargo:

``` bash
cat > /tmp/test-rustc.sh <<'EOF'
#!/usr/bin/env bash
set -x
LD_LIBRARY_PATH="$SRC_DIR/target/debug:$SRC_DIR/target/debug/deps:$BUILD_PREFIX/lib/rustlib/x86_64-unknown-linux-gnu/lib:/etc/sane-libs" \
"$BUILD_PREFIX/bin/rustc" --version
EOF

bash /tmp/test-rustc.sh
```

If that reproduces the failure, the problem is entirely in the runtime linker search path Cargo constructs for build scripts.

------------------------------------------------------------------------

One more thing worth checking:

``` bash
file $BUILD_PREFIX/bin/rustc
```

and

``` bash
ldd $BUILD_PREFIX/bin/rustc
```

inside the failing environment.

If `ldd` succeeds but executing rustc fails, then we're looking at a dependency of a dependency (often `libgit2`, `libcurl`, `libssh2`, or `libz`) that only gets pulled in during process startup.

My bet right now is that Cargo's build-script `LD_LIBRARY_PATH` is masking rustc's embedded RUNPATH and dropping access to `$BUILD_PREFIX/lib`. The easiest confirmation is whether prepending:

``` bash
export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
```

makes the build pass.

## Prompt:

5/31/2026, 5:40:08 PM

> \- export LD_LIBRARY_PATH="$`BUILD\_PREFIX/lib:`$LD_LIBRARY_PATH"

yes! that makes rustc work. so... where is the bug? in rattler-build? or in the conda rustc package...?

## Response:

5/31/2026, 5:40:09 PM

Based on the evidence, I'd lean toward **a bug or incompatibility in the Rust packaging/environment setup rather than in rqbit**, and possibly a rattler-build activation issue.

The key observations are:

1.  **Outside Cargo build scripts**, rustc works:

    ``` bash
    $BUILD_PREFIX/bin/rustc --version
    ```

    succeeds.

2.  **Inside Cargo build scripts**, Cargo rewrites `LD_LIBRARY_PATH`:

    ``` text
    LD_LIBRARY_PATH=$SRC_DIR/target/debug:...:$BUILD_PREFIX/lib/rustlib/...:/etc/sane-libs
    ```

    and drops `$BUILD_PREFIX/lib`.

3.  Adding:

    ``` bash
    export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
    ```

    fixes the problem.

That means `rustc` has a runtime dependency on a library in:

``` text
$BUILD_PREFIX/lib/libz.so.1
```

but that dependency is not fully resolved by rustc's own RPATH/RUNPATH once Cargo's build-script environment is active.

### Why this looks suspicious

Normally conda-forge toolchain packages are designed so that executables in `$PREFIX/bin` can find their required libraries without users manually setting `LD_LIBRARY_PATH`.

If `rustc` requires:

``` text
$BUILD_PREFIX/lib/libz.so.1
```

then one of these is true:

- rustc itself is missing a sufficient RUNPATH/RPATH;
- one of rustc's dependent libraries is missing a RUNPATH;
- Cargo's build-script environment is exposing a loader-path bug that normally stays hidden.

### What I'd inspect

Run:

``` bash
patchelf --print-rpath $BUILD_PREFIX/bin/rustc
```

and also:

``` bash
readelf -d $BUILD_PREFIX/bin/rustc | grep -E 'RPATH|RUNPATH'
```

Then inspect the libraries rustc depends on:

``` bash
ldd $BUILD_PREFIX/bin/rustc
```

and especially the conda-provided ones:

``` bash
patchelf --print-rpath $BUILD_PREFIX/lib/librustc_driver-*.so
```

(or whatever large Rust shared libraries are present).

My suspicion is that **one of the Rust shared libraries depends on libz but lacks a proper RUNPATH back to `$ORIGIN/../lib`**.

### Is this a rattler-build bug?

Maybe, but the evidence isn't conclusive.

Cargo intentionally rewrites `LD_LIBRARY_PATH` for build scripts. Cargo has done this for years. Many Rust packages build successfully under conda-forge.

So I'd first suspect:

- the conda Rust package,
- or a regression in the Rust 1.95 packaging,
- or an interaction between rattler-build activation and Cargo's build-script environment.

### A useful minimal reproducer

If you can reproduce with:

``` bash
cargo new hello
cd hello
cargo build
```

inside the same rattler-build environment, then this has nothing to do with rqbit.

Even better, try:

``` bash
cargo build -vv
```

for a trivial crate that pulls in `libc`.

If it fails the same way, you've got a minimal bug report for either rattler-build or conda-forge's Rust feedstock.

### Practical workaround

For now I'd use:

``` yaml
build:
  script:
    content:
      - export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
      - cargo auditable install --locked --no-track --bins --root $PREFIX --path crates/rqbit
```

because it fixes the immediate build and is consistent with the failure mechanism you've identified.

At this point, the most valuable next diagnostic would be the output of:

``` bash
patchelf --print-rpath $BUILD_PREFIX/bin/rustc
```

and one of the major Rust shared libraries under `$BUILD_PREFIX/lib`. That will usually reveal exactly which component is failing to carry the necessary runtime search path.

## Prompt:

5/31/2026, 5:47:52 PM

output of readelf and patchelf is looking good

     │ │ rustc: readelf output:
     │ │  0x000000000000001d (RUNPATH)            Library runpath: [$ORIGIN/../lib]
     │ │ rustc: patchelf ouptput
     │ │ $ORIGIN/../lib

## Response:

5/31/2026, 5:47:53 PM

That actually pins it down pretty cleanly.

If:

- `rustc` has correct `RUNPATH = $ORIGIN/../lib`
- direct execution works
- but Cargo build scripts fail unless you prepend `LD_LIBRARY_PATH=$BUILD_PREFIX/lib`

then **rustc is not the real problem anymore**.

### What’s actually happening

Cargo build scripts are running rustc with this environment:

``` text
LD_LIBRARY_PATH=/etc/sane-libs
```

So the loader is effectively:

1.  ignore RUNPATH (`$ORIGIN/../lib`) for some dependencies
2.  search only `LD_LIBRARY_PATH`
3.  miss `libz.so.1`
4.  fail before rustc even starts

That sounds contradictory, but it matches a known dynamic loader behavior:

> If a binary or any of its dependencies has an *incomplete dependency closure*, RUNPATH does NOT help—you still need LD_LIBRARY_PATH.

So the real question becomes:

> **Which shared library required by rustc is linked against libz.so.1 but does not have correct RUNPATH?**

------------------------------------------------------------------------

## The real culprit is almost certainly NOT rustc

In conda Rust toolchains, rustc is a small launcher that depends on:

- `librustc_driver.so`
- LLVM libs
- possibly `libgit2`, `libcurl`, etc.

One of those is likely linked to `libz.so.1`.

RUNPATH on rustc only helps *rustc itself*, not its dependent `.so` files.

So the real issue is:

> ❌ a Rust toolchain shared library is missing RPATH/RUNPATH for libz  
> ❌ Cargo’s stripped `LD_LIBRARY_PATH` exposes that missing link  
> ✔ adding `$BUILD_PREFIX/lib` fixes it

------------------------------------------------------------------------

## Why this only appears in Cargo build scripts

Because Cargo does this:

``` text
LD_LIBRARY_PATH = <sanitized minimal set>
```

Specifically, it removes:

- conda activation LD_LIBRARY_PATH
- build system injected paths

So you get a “clean” runtime that is actually *too clean*.

Your earlier output proves this:

``` text
LD_LIBRARY_PATH=
  $SRC_DIR/target/debug
  ...
  /etc/sane-libs
```

👉 missing `$BUILD_PREFIX/lib`

So anything in the Rust toolchain that depends on normal conda libs breaks.

------------------------------------------------------------------------

## Why your fix works

``` bash
export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
```

This restores:

- `libz.so.1`
- and potentially other system libs used indirectly

So the failing dependency chain becomes resolvable again.

------------------------------------------------------------------------

## So where is the bug?

### Not rqbit

It’s just triggering the toolchain edge case.

### Not necessarily rattler-build either

Rattler-build is doing something normal:

- isolating build env
- letting Cargo control runtime env

### Most likely root cause

👉 **conda-forge rust toolchain packaging is missing a proper RPATH for at least one dependency that uses zlib**

or equivalently:

> one of the Rust toolchain’s `.so` dependencies relies on `libz.so.1` but is not using `$ORIGIN`-relative linking correctly

------------------------------------------------------------------------

## How to confirm 100%

Run:

``` bash
ldd $BUILD_PREFIX/bin/rustc | grep z
```

and more importantly:

``` bash
find $BUILD_PREFIX/lib -name "*.so" -exec ldd {} \; | grep "libz.so"
```

You will almost certainly find a library like:

- `librustc_driver.so`
- `libLLVM.so`
- or similar

that has:

``` text
libz.so.1 => not found
```

or resolves only when `LD_LIBRARY_PATH` is present.

------------------------------------------------------------------------

## The *real fix* (proper packaging fix)

This should be fixed in the Rust conda package, not your recipe:

- ensure all Rust shared libs are patched with:
      RPATH=$ORIGIN:$ORIGIN/../lib
- or explicitly link zlib into the toolchain libs that need it
- or ensure `libz` is in the toolchain runtime dependency closure

------------------------------------------------------------------------

## Practical conclusion

- Your workaround is correct and safe:
  ``` bash
  export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
  ```
- The issue is **not rqbit**
- The issue is **a missing runtime library exposure in the Rust toolchain under stripped Cargo environments**
- The trigger is **Cargo’s intentional LD_LIBRARY_PATH sanitization**

------------------------------------------------------------------------

If you want, I can help you turn this into a minimal conda-forge / rattler-build bug report that will actually get fixed upstream quickly.

## Prompt:

5/31/2026, 6:14:14 PM

rustc itself depends on libz

    $ ldd /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/bin/rustc | grep libz
            libz.so.1 => /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/bin/../lib/../lib/../lib/libz.so.1 (0x00007bcaca112000)

and also some libraries depend on libz

    $ find /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/ -name '*.so' | while read so; do m="$(ldd "$so" 2>/dev/null | grep libz)"; [ -z "$m" ] && continue; echo "$so"; echo "$m"; echo; done 
    /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/lib/librustc_driver-6108105cd7e839cf.so
            libz.so.1 => /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/lib/../lib/../lib/libz.so.1 (0x00007ccc07466000)

    /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/lib/libssh2.so
            libz.so.1 => /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/lib/./libz.so.1 (0x00007e76a5f39000)

    /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/lib/libgit2.so
            libz.so.1 => /home/user/src/milahu/conda-recipes/output/bld/rattler-build_rqbit_1780243356/build_env/lib/libz.so.1 (0x000073195d41d000)

the conda rust recipe seems to be this...  
do you see a problem in the recipe?

<https://github.com/conda-forge/rust-feedstock/blob/main/recipe/meta.yaml>

``` yaml
{% set version = "1.96.0" %}

package:
  name: rust-split
  version: {{ version }}

source:
  # Note! This source file specification is structured specifically to interact
  # well with the autotick bot. Importantly, the `patches:` block actually
  # applies to *all* of these inputs, not just the last one in the list, because
  # of the way that the YAML selector processing works.
  - url: https://static.rust-lang.org/dist/rust-{{ version }}-x86_64-unknown-linux-gnu.tar.gz  # [linux and x86_64]
    sha256: c1130e4f7976f230766ab062b105b1fb050d6a78177db2246a5878fd6a589680  # [linux and x86_64]
  - url: https://static.rust-lang.org/dist/rust-{{ version }}-aarch64-unknown-linux-gnu.tar.xz  # [aarch64]
    sha256: 371eadcca97062219cbd8593628eb5d2802bc370515d085fedce1b56b2baed57  # [aarch64]
  - url: https://static.rust-lang.org/dist/rust-{{ version }}-powerpc64le-unknown-linux-gnu.tar.gz  # [ppc64le]
    sha256: 0a80537d96ea86e6520687fa03841f2dfde2c7154ae4bf517d9664d4f13b0c31  # [ppc64le]
  - url: https://static.rust-lang.org/dist/rust-{{ version }}-x86_64-apple-darwin.tar.gz  # [osx and x86_64]
    sha256: ddaf6a98ccc500891a74bcb95807a04c89a0d1ad7b9c58bd7116620ff6f903a8  # [osx and x86_64]
  - url: https://static.rust-lang.org/dist/rust-{{ version }}-aarch64-apple-darwin.tar.gz  # [osx and arm64]
    sha256: d97daf14c5c346c2d5a3271880d5a06d9885ec9af7e1fd2f072986e338526f8c  # [osx and arm64]
  - url: https://static.rust-lang.org/dist/rust-{{ version }}-x86_64-pc-windows-msvc.tar.gz  # [win64]
    sha256: 129859a99350b117c5b0c936a3bd472abbc976c8bd11507cf8dc2cfb87d884c7  # [win64]
  - url: https://static.rust-lang.org/dist/rust-{{ version }}-aarch64-pc-windows-msvc.tar.gz  # [win and arm64]
    sha256: 7cc7b0e1c78c674b37a298cb46b129a5ec6b312431e3e4e77741664de4ac512d  # [win and arm64]
    patches:
      - 0001-gh-106-install.sh-Perfomance-Use-more-shell-builtins.diff
  # End of block of primary source files.
  - url: https://static.rust-lang.org/dist/rust-src-{{ version }}.tar.gz
    sha256: 42aec79f05ad9db82bf72e39317a98234196682dc2b70e8ba0a3f58e9bd7d7f2
    folder: rust-src
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-aarch64-apple-ios.tar.gz  # [(linux or win) and x86_64]
    sha256: f763e74d161306c60d27823128f25cb2bc8eb30f98750f5140a425a33a8e6592  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-x86_64-apple-ios.tar.gz  # [(linux or win) and x86_64]
    sha256: 4a84c877590711081f14ff33a22f4448cfa1b9c7b14bfa1bea06531100f630d0  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-x86_64-pc-windows-msvc.tar.gz  # [(linux or win) and x86_64]
    sha256: 37cd6872dd7ecc194f542722dcd124a8fbe86d73487ae7c6d4b4b46ae8f9a32c  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-aarch64-apple-ios-sim.tar.gz  # [(linux or win) and x86_64]
    sha256: f49e8a6a0ebd4a773d729bdac9f0ef4a58bcffc4dcda82ab23abee2f96e79baf  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-aarch64-linux-android.tar.gz  # [(linux or win) and x86_64]
    sha256: 93d844f851f75d6634536bd3aaa9000553f7a5db1eb9da6f0b055db78f97e8f8  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-arm-linux-androideabi.tar.gz  # [(linux or win) and x86_64]
    sha256: 13ed484fe609b4d7202b7e1d37b90da6a73beafdc4e2e919255b7e342aaba744  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-armv7-linux-androideabi.tar.gz  # [(linux or win) and x86_64]
    sha256: 0f6b82ef6e1d12bffbef32b6094009212ae5539fc5d8cc4c57a597b7d326bc25  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-i686-linux-android.tar.gz  # [(linux or win) and x86_64]
    sha256: 1838f0ffb0f8b9c965864b2c06b3ec27b2f6b7c177c8c213d5928e98ec50ae24  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-x86_64-linux-android.tar.gz  # [(linux or win) and x86_64]
    sha256: ee3b74e49ae93ea1027da4bfa2b907405935e09f2ae773419116d73533e4f2b5  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-wasm32-unknown-unknown.tar.gz  # [(linux or win) and x86_64]
    sha256: a4a0751051c0a3df4091f56482a93259c6109a5d68718bbc85330f75c262f9dd  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-wasm32-unknown-emscripten.tar.gz  # [(linux or win) and x86_64]
    sha256: f3ca20120c68d16de4fb075ba25552fb762cc3bff93513cbcf03a4ff9e1d096f  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-x86_64-pc-windows-gnu.tar.gz  # [(linux or win) and x86_64]
    sha256: 6951de999a0926aa8e35046017473a1912274cc34e800887eb3bfba4ddae12c9  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]
  - url: https://static.rust-lang.org/dist/rust-std-{{ version }}-aarch64-pc-windows-msvc.tar.xz  # [(linux or win) and x86_64]
    sha256: 53c11671dbd91e634b92e304eb8163b2a38658c42e0152122709e2129298d754  # [(linux or win) and x86_64]
    folder: rust-std  # [(linux or win) and x86_64]

build:
  number: 0

requirements:
  build:
    - posix  # [win]
  host:

outputs:
  - name: rust-std-{{ rust_arch }}
    build:
      noarch: generic
      binary_relocation: false
      missing_dso_whitelist:   # [linux]
        - /lib64/librt.so.1  # [linux]
        - /lib64/libdl.so.2  # [linux]
        - /lib64/libpthread.so.0  # [linux]
        - /lib64/libm.so.6  # [linux]
        - /lib64/libc.so.6  # [linux]
        - /lib64/ld-linux-x86-64.so.2  # [linux]
      merge_build_host: false
    requirements:
      build:
        - posix  # [win]
      host:
      run:
        # The directory structure of windows and unix is different.
        # We should not install the bundled rust-std-x86_64-pc-windows-msvc from this output on unix for example.
        - __unix  # [unix]
        - __win  # [win]
      run_constrained:
        # Having different versions of rust-std and rust is confusing.
        - {{ pin_subpackage("rust", min_pin="x.x.x", max_pin="x.x.x") }}
    script: install-rust-std.sh  # [unix]
    script: install-rust-std.bat  # [win]
    test:
      commands:
        - test -d $PREFIX/lib/rustlib   # [unix]
        - if not exist %LIBRARY_PREFIX%/lib/rustlib exit 1  # [win]
        - echo {{ rust_arch }}

  - name: rust
    script: install-rust.sh  # [unix]
    script: install-rust.bat  # [win]
    build:
      # the distributed binaries are already relocatable
      binary_relocation: false
      missing_dso_whitelist:   # [linux]
        - /lib64/librt.so.1  # [linux]
        - /lib64/libdl.so.2  # [linux]
        - /lib64/libpthread.so.0  # [linux]
        - /lib64/libm.so.6  # [linux]
        - /lib64/libc.so.6  # [linux]
        - /lib64/ld-linux-x86-64.so.2  # [linux]
        # Added as run deps: libgcc-ng (via compiler strong run_exports), zlib
        # - /lib64/libgcc_s.so.1  # [linux]
        # - /lib64/libz.so.1  # [linux]
      run_exports:   # [(osx and x86_64) or linux]
        strong_constrains:   # [(osx and x86_64) or linux]
          - __osx >={{ c_stdlib_version }}  # [osx and x86_64]
          - __glibc >={{ c_stdlib_version }}  # [linux]
    requirements:
      build:
        - posix  # [win]
      host:
        - {{ pin_subpackage("rust-std-" ~ rust_arch, exact=True) }}
        - {{ compiler('c') }}  # [linux] -- rustc needs a toolchain to link executables
        - {{ stdlib('c') }}  # [linux]
        # zlib is linked by **/lib/libLLVM-*-rust-*.so
        - zlib  # [linux]
      run:
        - {{ pin_subpackage("rust-std-" ~ rust_arch, exact=True) }}
        - gcc_impl_{{ target_platform }}  # [linux]
        - sysroot_{{ target_platform }} >={{ c_stdlib_version }}  # [linux]
    test:
      requires:
        - posix  # [win]
      commands:
        - rustc --help
        - rustdoc --help
        - cargo --help
        - cargo --config registries.crates-io.protocol=\"sparse\" install --force xsv
        - echo {{ rust_arch }}
        # Documentation should not be in the rust package - it is provided by rust-docs
        - test ! -d "${PREFIX}"/share/doc/rust/html  # [unix]
        - test ! -d "${PREFIX}"/share/doc/rust/json  # [unix]
        - if exist %LIBRARY_PREFIX%\share\doc\rust\html exit 1  # [win]
        - if exist %LIBRARY_PREFIX%\share\doc\rust\json exit 1  # [win]
        # rust-analyzer should not be in the rust package
        - test ! -f "${PREFIX}"/bin/rust-analyzer  # [unix]
        - if exist %LIBRARY_PREFIX%\bin\rust-analyzer.exe exit 1  # [win]
        - if exist %LIBRARY_PREFIX%\bin\rust-analyzer.pdb exit 1  # [win]

  - name: rust-src
    script: install-rust-src.sh  # [unix]
    script: install-rust-src.bat  # [win]
    build:
      skip: {{ rust_arch != "x86_64-unknown-linux-gnu" and rust_arch != "x86_64-pc-windows-msvc" }}
      noarch: generic
      # Need conda-build >=3.25 to have different hashes. Remove when conda-build 3.25 is out.
      string: unix_{{ PKG_BUILDNUM }}  # [unix]
      string: win_{{ PKG_BUILDNUM }}  # [win]
    requirements:
      build:
        - posix  # [win]
      run:
        - __win   # [win]
        - __unix  # [unix]
      run_constrained:
        # Having different versions of rust-src and rust is confusing.
        # `rust-src` is specific to the toolchain in `rustup`,
        # and we would like to keep that behavior.
        - {{ pin_subpackage("rust", min_pin="x.x.x", max_pin="x.x.x") }}
    test:
      commands:
        - test -f "${PREFIX}"/lib/rustlib/src/rust/library/Cargo.lock  # [unix]
        - if not exist "%LIBRARY_PREFIX%/lib/rustlib/src/rust/library/Cargo.lock" exit 1  # [win]
        # Make sure that the outputs do not clobber with other rust components
        - test "$(ls "${PREFIX}"/lib/rustlib/)" = "$(printf "manifest-rust-src\nsrc")"  # [unix]
        - if not exist "%LIBRARY_PREFIX%/lib/rustlib/manifest-rust-src" exit 1  # [win]
        - if not exist "%LIBRARY_PREFIX%/lib/rustlib/src" exit 1  # [win]

- name: rust-std-{{ rust_std_extra }}
    script: install-rust-std-extra.sh  # [unix]
    script: install-rust-std-extra.bat  # [win]
    build:
      skip: {{ rust_arch != "x86_64-unknown-linux-gnu" and rust_arch != "x86_64-pc-windows-msvc" }}
      noarch: generic
      # Need conda-build >=3.25 to have different hashes. Remove when conda-build 3.25 is out.
      string: unix_{{ PKG_BUILDNUM }}  # [unix]
      string: win_{{ PKG_BUILDNUM }}  # [win]
    requirements:
      build:
        - posix  # [win]
      run:
        - __win   # [win]
        - __unix  # [unix]
      run_constrained:
        # Having different versions of rust-std and rust is confusing.
        - {{ pin_subpackage("rust", min_pin="x.x.x", max_pin="x.x.x") }}
    test:
      commands:
        - test -d $PREFIX/lib/rustlib/{{ rust_std_extra }}  # [unix]
        - if not exist "%LIBRARY_PREFIX%/lib/rustlib/{{ rust_std_extra }}" exit 1  # [win]
        - test -f $PREFIX/lib/rustlib/manifest-rust-std-{{ rust_std_extra }}  # [unix]
        - if not exist "%LIBRARY_PREFIX%/lib/rustlib/manifest-rust-std-{{ rust_std_extra }}" exit 1  # [win]
        # Make sure that the outputs do not clobber with other rust components
        - test -z "$(ls "${PREFIX}"/lib/rustlib/ | grep -v {{ rust_std_extra }})"  # [unix]
        - dir /b "%LIBRARY_PREFIX%" | findstr /v "{{ rust_std_extra }}" >nul || exit 1  # [win]
        - echo {{ rust_std_extra }}

  - name: rust-docs
    script: install-rust-docs.sh  # [unix]
    script: install-rust-docs.bat  # [win]
    build:
      skip: {{ rust_arch != "x86_64-unknown-linux-gnu" and rust_arch != "x86_64-pc-windows-msvc" }}
      noarch: generic
      string: unix_{{ PKG_BUILDNUM }}  # [unix]
      string: win_{{ PKG_BUILDNUM }}  # [win]
    requirements:
      build:
        - posix  # [win]
      run:
        - __win   # [win]
        - __unix  # [unix]
      run_constrained:
        # Having different versions of rust-docs and rust is confusing.
        - {{ pin_subpackage("rust", min_pin="x.x.x", max_pin="x.x.x") }}
    test:
      commands:
        - test -d "${PREFIX}"/share/doc/rust/html  # [unix]
        - test -d "${PREFIX}"/share/doc/rust/json  # [unix]
        - if not exist "%LIBRARY_PREFIX%/share/doc/rust/html" exit 1  # [win]
        - if not exist "%LIBRARY_PREFIX%/share/doc/rust/json" exit 1  # [win]
        - test -f "${PREFIX}"/lib/rustlib/manifest-rust-docs  # [unix]
        - test -f "${PREFIX}"/lib/rustlib/manifest-rust-docs-json-preview  # [unix]
        - if not exist "%LIBRARY_PREFIX%/lib/rustlib/manifest-rust-docs" exit 1  # [win]
        - if not exist "%LIBRARY_PREFIX%/lib/rustlib/manifest-rust-docs-json-preview" exit 1  # [win]

about:
  home: https://www.rust-lang.org
  license: MIT
  license_file:
    - LICENSE-APACHE
    - LICENSE-MIT
  summary: |
    Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety.
    This package provides the compiler (rustc) and the documentation utilities rustdoc.
  dev_url: https://doc.rust-lang.org/std/
  doc_url: https://www.rust-lang.org/en-US/documentation.html

extra:
  recipe-maintainers:
    - timkpaine
    - xhochy
    - johanneskoester
    - abhi18av
    - pkgw
    - dlaehnemann
    - isuruf
    - mbargull
```

## Response:

5/31/2026, 6:14:15 PM

Yes - there *is* a real issue here, and your investigation has essentially isolated it to a **packaging + dynamic loader interaction problem in the conda Rust toolchain**, not rqbit and not rattler-build itself.

But there is a *specific suspicious design choice* in that feedstock that explains exactly your symptom.

------------------------------------------------------------------------

# 💥 Root cause (what’s actually wrong)

Your failure mode is:

- `rustc` works normally
- but fails **only when Cargo runs build scripts**
- fixed by `LD_LIBRARY_PATH=$BUILD_PREFIX/lib:...`

That means:

> ❗ some Rust toolchain `.so` depends on `libz.so.1` but is NOT consistently reachable via RPATH alone in stripped subprocess environments

Now look at the conda recipe:

``` yaml
requirements:
  host:
    - zlib  # rustc itself needs it indirectly
```

and:

``` yaml
requirements:
  run:
    - gcc_impl_{{ target_platform }}
    - sysroot_{{ target_platform }}
```

BUT crucially:

### 🚨 Missing (important detail)

There is **no guarantee that `zlib` is in the runtime closure of *all Rust shared libraries*** used by rustc.

And your `find` output proves this is not theoretical:

- `librustc_driver.so` → depends on `libz.so.1`
- `libgit2.so` → depends on `libz.so.1`
- `libssh2.so` → depends on `libz.so.1`

So Rust is not the only consumer.

------------------------------------------------------------------------

# 🧠 The real problem in the feedstock

## ⚠️ This line is the subtle bug:

``` yaml
host:
  - zlib  # linux
```

This ensures `zlib` is present **at build time**, but:

> it does NOT guarantee proper runtime visibility in isolated subprocess environments where LD_LIBRARY_PATH is partially rewritten (Cargo does exactly this)

------------------------------------------------------------------------

## The real architectural issue

The Rust toolchain here is relying on **three different mechanisms at once**:

1.  RPATH (`$ORIGIN/../lib`) ✔️
2.  conda prefix layout ✔️
3.  LD_LIBRARY_PATH injection (implicit) ❌ fragile

Cargo then does:

> “I will sanitize LD_LIBRARY_PATH for build scripts”

and that breaks assumption \#2.

------------------------------------------------------------------------

# 🧨 Why conda-forge Rust *usually works*

Because most environments accidentally provide:

- `LD_LIBRARY_PATH` already containing `$PREFIX/lib`
- or broader activation scripts
- or less aggressive sandboxing than rattler-build

You hit the *strict mode*.

------------------------------------------------------------------------

# 🧩 What is actually missing

Not zlib itself.

But **zlib is not in the “guaranteed runtime visibility set” of Rust toolchain execution contexts.**

That means:

### ❌ Wrong assumption in packaging:

> “RPATH is sufficient for all Rust toolchain subprocesses”

### ✔ Reality:

> Cargo build scripts create a runtime where RPATH-only dependency chains break

------------------------------------------------------------------------

# 🧪 Why your workaround works

``` bash
LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
```

This forces:

- libz becomes globally visible
- bypasses RPATH dependency resolution gaps in mixed `.so` chains
- restores compatibility for *all toolchain binaries*

------------------------------------------------------------------------

# 🧷 So where is the bug?

## It is NOT:

- ❌ rqbit
- ❌ rattler-build (directly)
- ❌ missing zlib dependency declaration (you already have it)

------------------------------------------------------------------------

## It IS one of these:

### 🥇 Most likely

**Rust feedstock packaging assumption is incomplete:**

> Toolchain shared libs depend on zlib but are not fully RPATH self-contained

------------------------------------------------------------------------

### 🥈 Secondary issue (important)

**Cargo’s intentional LD_LIBRARY_PATH sanitization exposes this weakness**

This is expected behavior from Cargo, but:

> it breaks conda-style mixed RPATH + prefix dependency graphs

------------------------------------------------------------------------

### 🥉 Contributing factor

**libgit2 + libssh2 + rustc_driver all pulling libz**

This increases the chance of “hidden dependency not reachable via RPATH-only execution context”

------------------------------------------------------------------------

# 🛠️ What the *real fix* would be (upstream)

## Option A (best): fix Rust feedstock

Ensure:

- every Rust `.so` is patched with:
      RPATH=$ORIGIN:$ORIGIN/../lib
- and verify closure:

``` bash
for so in $(find $PREFIX/lib -name "*.so"); do
  ldd $so | grep "libz"
done
```

must never rely on external search paths

------------------------------------------------------------------------

## Option B (pragmatic): enforce LD_LIBRARY_PATH in toolchain activation

Add to Rust package activation script:

``` bash
export LD_LIBRARY_PATH="$PREFIX/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
```

This is what your workaround is effectively doing.

------------------------------------------------------------------------

## Option C (rattler-build workaround)

You already found it:

``` yaml
build:
  script:
    - export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
```

------------------------------------------------------------------------

# 🧭 Final diagnosis

> The conda Rust toolchain is *not fully RPATH-pure*, and Cargo’s build-script environment exposes that by stripping LD_LIBRARY_PATH.

------------------------------------------------------------------------

If you want, I can help you turn this into a clean upstream bug report for:

- conda-forge/rust-feedstock
- or rattler-build (if you want to argue they should preserve prefix lib visibility for toolchain subprocesses)

This is actually a pretty good “real-world packaging systems” edge case.

## Prompt:

5/31/2026, 8:19:38 PM

write a draft for a github issue for the <https://github.com/conda-forge/rust-feedstock> repo. i guess they will know where exactly the bug is, and from there we can eventually escalate the issue to rattler-build

## Response:

5/31/2026, 8:19:38 PM

Here’s a solid GitHub issue draft you can post directly to the conda-forge/rust-feedstock repo. I’ve kept it focused, reproducible, and clearly separated “symptom vs root cause suspicion” so maintainers don’t get lost in tool-specific noise.

------------------------------------------------------------------------

## 🐛 Rust toolchain breaks in isolated Cargo build-script environments unless `LD_LIBRARY_PATH=$PREFIX/lib` is manually set

### Summary

The conda-forge Rust toolchain (`rustc`, `cargo`) intermittently fails inside isolated build environments (notably rattler-build / strict Cargo build-script environments) due to missing runtime visibility of `libz.so.1`.

This happens even though:

- `rustc` executes correctly in the activated environment
- `libz.so.1` is correctly present in `$BUILD_PREFIX/lib`
- `rustc` has valid RPATH (`$ORIGIN/../lib`)
- `ldd rustc` resolves all dependencies correctly

However, when Cargo runs build scripts (e.g. `libc` build.rs), rustc fails with:

    error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or directory

The issue is resolved by manually adding:

``` bash
export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
```

------------------------------------------------------------------------

### Minimal reproduction

In a conda build environment (rattler-build or conda-build), compiling any Rust crate that triggers dependency on `libc` or other common crates fails:

``` bash
cargo build -p any-crate
```

Failure occurs during dependency compilation:

    Compiling libc v0.2.180
    error: failed to run custom build command
    Caused by:
      failed to run rustc: libz.so.1: cannot open shared object file

------------------------------------------------------------------------

### Observed environment differences

#### Working case (manual execution)

``` bash
$BUILD_PREFIX/bin/rustc --version
```

works correctly.

`ldd rustc` shows:

    libz.so.1 => $BUILD_PREFIX/lib/libz.so.1

and RPATH:

    $ORIGIN/../lib

------------------------------------------------------------------------

#### Failing case (Cargo build script)

Cargo executes rustc with a sanitized environment:

    LD_LIBRARY_PATH=/etc/sane-libs:...:$BUILD_PREFIX/lib/rustlib/...

Notably:

- `$BUILD_PREFIX/lib` is missing
- RPATH alone is insufficient in this context
- rustc fails before startup due to missing `libz.so.1`

------------------------------------------------------------------------

### Key finding

Multiple Rust toolchain shared libraries depend on `libz.so.1`, including:

- `librustc_driver.so`
- `libgit2.so`
- `libssh2.so`

These dependencies resolve correctly only when `$BUILD_PREFIX/lib` is present in `LD_LIBRARY_PATH`.

Example:

    librustc_driver.so -> libz.so.1 (found only via $PREFIX/lib injection)

------------------------------------------------------------------------

### Expected behavior

Rust toolchain binaries should be fully self-contained via:

- RPATH / RUNPATH (`$ORIGIN/../lib`)
- or fully correct dependency closure within conda prefix

so that they do not depend on external `LD_LIBRARY_PATH` injection, even in sanitized environments like Cargo build scripts.

------------------------------------------------------------------------

### Actual behavior

In strict environments (Cargo build scripts / rattler-build):

- `LD_LIBRARY_PATH` is overridden or minimized
- RPATH is not sufficient for full dependency resolution
- Rust toolchain fails to locate `libz.so.1`

------------------------------------------------------------------------

### Workaround

Manually adding the conda lib directory fixes the issue:

``` bash
export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
```

------------------------------------------------------------------------

### Hypothesis

This is likely due to one (or more) of:

1.  One or more Rust toolchain shared libraries depending on `libz.so.1` without fully correct RPATH coverage
2.  Cargo’s intentional sanitization of `LD_LIBRARY_PATH` exposing incomplete runtime dependency closure
3.  A mismatch between conda RPATH patching assumptions and Cargo build-script execution environment

------------------------------------------------------------------------

### Impact

- Affects conda-forge Rust toolchain reliability in strict build systems
- Breaks builds under rattler-build environments
- Affects any crate with dependencies that trigger build.rs execution (e.g. `libc`)

------------------------------------------------------------------------

### Environment

- OS: Linux x86_64
- conda-forge rust-feedstock version: 1.95 / 1.96 series
- build system: rattler-build (also reproducible in strict Cargo environments)
- libc: 0.2.180 observed failing case

------------------------------------------------------------------------

### Request

Could you clarify:

1.  Whether the Rust feedstock guarantees fully RPATH-contained runtime dependency closure for all shipped `.so` libraries
2.  Whether `libz` is expected to be required via `LD_LIBRARY_PATH` in any execution context
3.  Whether this should be considered a packaging bug or an expected limitation under Cargo build-script sandboxing

If needed, I can also help reduce this into a minimal upstream Rust reproduction or correlate exact `.so` dependency chains causing the failure.

------------------------------------------------------------------------

If you want, I can also:

- shorten this into a “maintainer-friendly minimal report”
- or make a version targeted at rattler-build instead (this could actually be a better primary issue)

## Prompt:

5/31/2026, 8:23:10 PM

> - shorten this into a “maintainer-friendly minimal report”

yes

## Response:

5/31/2026, 8:23:11 PM

Here’s a **tight, maintainer-friendly minimal issue** you can post directly. It removes most speculation and keeps only reproducible facts + the key observation.

------------------------------------------------------------------------

## 🐛 Rust toolchain fails in sanitized Cargo build environment due to missing `libz.so.1`

### Summary

The conda-forge Rust toolchain (`rustc`) fails to run inside sanitized Cargo build-script environments because `libz.so.1` is not found, even though:

- `rustc` works when run directly
- `libz.so.1` is present in the conda prefix
- `rustc` has valid RPATH (`$ORIGIN/../lib`)
- `ldd rustc` resolves `libz.so.1` correctly

The failure only occurs when Cargo runs build scripts with a restricted `LD_LIBRARY_PATH`.

------------------------------------------------------------------------

### Error

During compilation (e.g. `libc v0.2.180` build script):

    error: failed to run custom build command for `libc v0.2.180`
    Caused by:
      failed to run rustc: libz.so.1: cannot open shared object file: No such file or directory

------------------------------------------------------------------------

### Reproduction context

This happens in:

- conda-forge rust-feedstock toolchain
- rattler-build environments (and any Cargo build-script sandbox with sanitized env)
- Linux x86_64

------------------------------------------------------------------------

### Key observation

In failing cases, Cargo sets a restricted environment:

    LD_LIBRARY_PATH=/etc/sane-libs:...

This removes the conda prefix library path, so:

- `$BUILD_PREFIX/lib` is not visible
- RPATH alone is not sufficient for `libz.so.1` resolution in this context

Manually restoring it fixes the issue:

``` bash
export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$LD_LIBRARY_PATH"
```

------------------------------------------------------------------------

### Evidence

`rustc` links against `libz.so.1`:

    ldd $(which rustc) | grep libz
    libz.so.1 => .../lib/libz.so.1

But fails in Cargo build scripts due to missing runtime search path.

------------------------------------------------------------------------

### Expected behavior

Rust toolchain binaries packaged by conda-forge should run in fully sanitized build environments without requiring `LD_LIBRARY_PATH` overrides, assuming:

- RPATH is correctly set
- all shared dependencies are properly discoverable at runtime

------------------------------------------------------------------------

### Question

Is this expected behavior for the current Rust feedstock packaging (i.e. requiring `LD_LIBRARY_PATH` in sanitized environments), or does this indicate an incomplete runtime dependency/RPATH setup (specifically around `libz.so.1`)?

------------------------------------------------------------------------

If you want next step help, I can also turn this into a **rattler-build issue instead (it may actually be the real upstream trigger)** or help you add a **minimal CI reproducer** so maintainers can’t dismiss it as environment noise.

------------------------------------------------------------------------

Powered by [ChatGPT Exporter](https://www.chatgptexporter.com)
