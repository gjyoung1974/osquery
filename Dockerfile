# should we build this on Ubuntu 18.04
FROM ubuntu:18.04

# Get add-apt-repository
RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-get install apt-transport-https

# get current
RUN apt-get -y update

# Install the prerequisites
RUN apt-get -y install --no-install-recommends git python3 bison flex make wget binutils dpkg-dev

# Optional: install python tests prerequisites
RUN apt-get -y install --no-install-recommends python3-pip python3-setuptools python3-psutil python3-six python3-wheel
RUN pip3 install timeout_decorator thrift==0.11.0 osquery pexpect==3.3

# Download and install the osquery toolchain
RUN wget https://github.com/osquery/osquery-toolchain/releases/download/1.1.0/osquery-toolchain-1.1.0-x86_64.tar.xz
RUN tar xvf osquery-toolchain-1.1.0-x86_64.tar.xz -C /usr/local

# Download and install a newer CMake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.6/cmake-3.14.6-Linux-x86_64.tar.gz
RUN tar xvf cmake-3.14.6-Linux-x86_64.tar.gz -C /usr/local --strip 1

# Clone the osquery source
# RUN git clone https://github.com/gjyoung1974/osquery.git
# Copy osquery source from local repo
RUN mkdir -p /osquery
COPY .  /osquery

# TODO: patch the source code to mount /host/proc vs /proc as procfs to read from 
# Build OSQuery and build debian package
RUN cd osquery  \
  && mkdir -p /osquery/build; cd /osquery/build \
  && cmake -DOSQUERY_TOOLCHAIN_SYSROOT=/usr/local/osquery-toolchain .. \
  && cmake -DPACKAGING_SYSTEM=DEB ..  \
  && cmake --build . --target package -j10

# hold the container open
CMD ["tail", "-f", "/dev/null"]

# Deb file output will be at:
# /osquery/build/osquery_4.4.0-3-g8636dca-1.linux_amd64.deb
