FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    git \
    build-base \
    cmake \
    gfortran \
    lapack-dev \
    boost-dev \
    libexecinfo-dev \
    hdf5-dev \
    netcdf-fortran-dev \
    openmpi-dev

RUN git clone --depth 1 https://github.com/trilinos/Trilinos.git /trilinos

RUN mkdir /trilinos/build/
WORKDIR /trilinos/build

RUN cmake \
    -DTPL_ENABLE_MPI=ON \
    -DTPL_ENABLE_BLAS=OFF \
    -DTPL_ENABLE_Matio=OFF \
    -DTPL_ENABLE_X11=OFF \
    -DTrilinos_ENABLE_ALL_PACKAGES=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/trilinos/ \
    ..

# FIXME
#RUN make install

#FROM alpine:3.12.0

#COPY --from=builder /opt/trilinos/ /opt/trilinos/

