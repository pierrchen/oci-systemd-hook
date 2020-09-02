FROM fedora:latest AS Build
RUN yum -y install \
    autoconf \
    automake \
    gcc \
    git \
    go-md2man \
    libmount-devel \
    libselinux-devel \
    yajl-devel \
    make
RUN mkdir /oci-systemd-hook
COPY . /oci-systemd-hook
WORKDIR /oci-systemd-hook
RUN autoreconf -i && \
    ./configure --libexecdir=/usr/libexec/oci/hooks.d --disable-dependency-tracking && \
    make  && \
    make install

FROM alpine
RUN mkdir /release
COPY --from=build /oci-systemd-hook/oci-systemd-hook* /release/
