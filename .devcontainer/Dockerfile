ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

FROM alpine:3.21

RUN echo "USERNAME: $USERNAME" \
    && echo "USER_UID: $USER_UID" \
    && echo "USER_GID: $USER_GID"

ARG USERNAME
ARG USER_UID
ARG USER_GID
# Install tools
RUN apk add --no-cache \
    bash \
    git \
    curl \
    cmake \
    build-base \
    inotify-tools \
    protobuf \
    python3 \
    py3-pip \
    py3-protobuf \
    py3-grpcio \
    nodejs \
    npm

# Install TypeScript generator
RUN npm install -g google-protobuf protoc-gen-ts

# Create non-root user
RUN addgroup -g $USER_GID $USERNAME \
    && adduser -D -u $USER_UID -G $USERNAME $USERNAME

# Set the working directory
WORKDIR /workspace

USER $USERNAME

ENTRYPOINT [ "bash" ]
