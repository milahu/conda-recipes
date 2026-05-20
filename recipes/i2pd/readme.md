# recipes/i2pd



## example use

```sh
# install micromamba
# based on https://github.com/mamba-org/micromamba-releases
bash <(curl -L https://micro.mamba.pm/install.sh)
source ~/.bashrc

# create the "conda-build" env
micromamba create -n conda-build

# enter the "conda-build" env
micromamba activate conda-build

# build a dependency for i2pd
conda build recipes/miniupnpc

# build i2pd
conda build recipes/i2pd

# create a conda channel with our built packages
micromamba install conda-build -c conda-forge
mkdir -p conda-channel-i2pd/linux-64
mv -v {i2pd,miniupnpc}-*.tar.bz2 conda-channel-i2pd/linux-64
# generate repodata.json (dependency tree)
conda index conda-channel-i2pd

# leave the "conda-build" env
micromamba deactivate

# create the "i2pd" env
# note: we cannot re-use the "conda-build"
# because there we have boost 1.85 and python 3.14
# but i2pd requires boost 1.82 and python 3.9 (FIXME why?)
micromamba create -n i2pd

# enter the "i2pd" env
micromamba activate i2pd

# install i2pd from our channel
micromamba install -c file://"$PWD"/conda-channel-i2pd i2pd

# now we can use i2pd
i2pd --version
i2pd --loglevel error --sam.port 7656 --sam.portudp 7656

# leave the "i2pd" env
micromamba deactivate
```
