FROM alpine as build

RUN apk add --no-cache --virtual trilinos-build-dependencies \
    git \
    build-base \
    cmake \
    gfortran \
    lapack-dev \
    boost-dev \
    libexecinfo-dev \
    zlib-dev \
    gettext-dev \
    curl-dev \
    m4 \
    perl \
    bash

ADD https://www.hdfgroup.org/package/hdf5-1-12-0-tar-gz/?wpdmdl=14582&refresh=5f71ff5c470521601306460 /hdf5-1-12-0.tar.gz

RUN tar xzf hdf5-1-12-0.tar.gz

WORKDIR /hdf5-1.12.0/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/hdf5 \
    -DDEFAULT_API_VERSION:STRING=v110 \
    -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DHDF5_BUILD_CPP_LIB:BOOL=ON \
    -DHDF5_BUILD_FORTRAN:BOOL=ON \
    -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=OFF \
    ..
RUN make install

RUN apk add autoconf automake libtool flex
ADD https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.5.tar.gz /openmpi-4.0.5.tar.gz
WORKDIR /
RUN tar xzf openmpi-4.0.5.tar.gz

WORKDIR /openmpi-4.0.5

RUN chmod +x ./configure
RUN ./configure --prefix=/usr
RUN make
RUN make install

RUN git clone --depth 1 https://github.com/Unidata/netcdf-c.git /netcdf-c

WORKDIR /netcdf-c/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_UNIT_TESTS=OFF \
    -DBUILD_TESTSETS=OFF \
    -DHDF5_INCLUDE_DIRS=/opt/hdf5/include/ \
    -DHDF5_LIBRARIES=/opt/hdf5/lib/ \
    -DHDF5_HL_LIBRARIES=/opt/hdf5/lib/ \
    ..
RUN make
RUN make install

RUN git clone --depth 1 https://github.com/Unidata/netcdf-fortran.git /netcdf-fortran

WORKDIR /netcdf-fortran/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DHDF5_INCLUDE_DIRS=/opt/hdf5/include/ \
    -DHDF5_LIBRARIES=/opt/hdf5/lib/ \
    -DHDF5_HL_LIBRARIES=/opt/hdf5/lib/ \
    ..
RUN make
RUN make install

RUN git clone --depth 1 https://github.com/trilinos/Trilinos.git /trilinos

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

