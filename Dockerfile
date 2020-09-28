FROM alpine as build

RUN apk add --no-cache --virtual trilinos-build-dependencies \
    git \
    build-base \
    cmake \
    gfortran \
    lapack-dev \
    boost-dev \
    libexecinfo-dev

RUN git clone --depth 1 https://github.com/trilinos/Trilinos.git /trilinos

ADD https://www.hdfgroup.org/package/hdf5-1-12-0-tar-gz/?wpdmdl=14582&refresh=5f71ff5c470521601306460 /hdf5-1-12-0.tar.gz

RUN tar xzf hdf5-1-12-0.tar.gz

WORKDIR /hdf5-1.12.0/build

RUN cmake ..
RUN make install

WORKDIR /trilinos/build

RUN cmake \
    -DTPL_ENABLE_MPI=OFF \
    -DTPL_ENABLE_BLAS=OFF \
    -DTPL_ENABLE_Matio=OFF \
    -DTPL_ENABLE_X11=OFF \
    -DTrilinos_ENABLE_ALL_PACKAGES=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/trilinos/ \
    ..

RUN make install

