FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Add nanopb C sources to a known path (for future use)
ENV NANOPB_PATH=/opt/nanopb

# Install tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    cmake \
    build-essential \
    protobuf-compiler \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install TypeScript generator
RUN npm install -g protoc-gen-ts

# Clone nanopb and build the plugin
RUN git clone --depth 1 https://github.com/nanopb/nanopb.git "${NANOPB_PATH}" \
    && cd "${NANOPB_PATH}/generator/protoc-gen-nanopb" \
    && cmake . \
    && make \
    && cp protoc-gen-nanopb /usr/local/bin/

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get clean

USER $USERNAME
