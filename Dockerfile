FROM debian:latest

RUN apt-get update

# Build Neovim --------------------------------------------------
# Temp directory for building
RUN mkdir -p /root/TMP
RUN cd /root/TMP

# Prerequisites
RUN apt-get install -y ninja-build gettext cmake unzip curl git
RUN git clone https://github.com/neovim/neovim

#RUN make CMAKE_BUILD_TYPE=Release && make install

