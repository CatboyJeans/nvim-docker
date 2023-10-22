FROM debian:latest

RUN apt-get update
RUN apt-get install -y ninja-build gettext cmake unzip curl git nodejs npm python3 python3-venv python3-pip\
                       cargo default-jre

# Build Neovim
# Temp directory for building
WORKDIR /root/TMP

# Prerequisites
RUN git clone https://github.com/neovim/neovim
RUN cd neovim && make CMAKE_BUILD_TYPE=Release && make install

# packer
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim\
        ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# clone personal config
RUN git clone https://github.com/CatboyJeans/init.lua.git ~/.config/nvim

# ripgrep
RUN apt-get install -y ripgrep 

# Nvim Initialization
# Initialize Packer
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
# Install LSP's
RUN nvim --headless -c 'MasonInstall clangd cmake-language-server dockerfile-language-server groovy-language-server\
                        lua-language-server pyright rust-analyzer typescript-language-server' -c 'q'

# Create workspace directory
WORKDIR /root/workspace

# Install python packages
COPY requirements.txt ./
RUN pip3 install --break-system-packages -r requirements.txt && rm requirements.txt

# Delete TMP directory
RUN rm -rf /root/TMP

