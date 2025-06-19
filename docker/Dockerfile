# We need it to get a required file
FROM ghcr.io/immich-app/base-server-dev:202505131114@sha256:cf4507bbbf307e9b6d8ee9418993321f2b85867da8ce14d0a20ccaf9574cb995 AS immich_base

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    make \
    sudo \
    make \
    ca-certificates \
    gnupg \
    apt-transport-https \
    lsb-release \
    nano \
    zsh

# Install Node.js (LTS version) using NodeSource repositories
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Install Docker CLI within the container
# This allows the container to interact with the host's Docker daemon.
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
    "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Create a non-root user for security best practices
# The user will have a home directory and will be part of the 'docker' and 'sudo' group

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

ENV HOME=/home/$USERNAME

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd -s /usr/bin/zsh --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    groupadd docker && \
    usermod -aG sudo $USERNAME && \
    usermod -aG docker $USERNAME && \    
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-sudo-nopasswd && \
    chmod 0440 /etc/sudoers.d/90-sudo-nopasswd && \
    rm -rf /var/lib/apt/lists/*

# Copy required files from Immich image
COPY --from=immich_base /build/geodata /build/geodata

# Set the default user
USER $USERNAME

WORKDIR $HOME

# Install Oh My Zsh and Powerlevel10k
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && \
    mkdir -p ~/.zsh && cd ~/.zsh && \
    curl -O 'https://raw.githubusercontent.com/minhanhhere/developer-tools/main/powerlevel10k/git-completion.bash' && cd -

COPY config/* .

ENTRYPOINT [ "/usr/bin/zsh" ]