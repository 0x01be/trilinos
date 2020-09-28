FROM alpine as build

RUN apk add --no-cache --virtual trilinos-build-dependencies \
    git \
    build-base \
    cmake \
    gfortran \
    lapack-dev \
    boost-dev \
    libexecinfo-dev

RUN apk add --no-cache --virtual trilinos-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    netcdf-fortran-dev \
    openmpi-dev

RUN git clone --depth 1 https://github.com/trilinos/Trilinos.git /trilinos

ADD https://www.hdfgroup.org/package/hdf5-1-12-0-tar-gz/?wpdmdl=14582&refresh=5f71ff5c470521601306460 /hdf5-1-12-0.tar.gz

RUN tar xzf hdf5-1-12-0.tar.gz

RUN ls -alh

WORKDIR /hdf5-1.12.0/build

RUN cmake ..
RUN make install

WORKDIR /trilinos/build

RUN cmake \
    -DTPL_ENABLE_MPI=ON \
    -DTPL_ENABLE_BLAS=OFF \
    -DTPL_ENABLE_Matio=OFF \
    -DTPL_ENABLE_X11=OFF \
    -DTrilinos_ENABLE_ALL_PACKAGES=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/trilinos/ \
    ..

RUN make install

