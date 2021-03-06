# [Choice] Python version: 3, 3.9, 3.8, 3.7, 3.6
ARG VARIANT=3
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT} as base-builder

# Copy library scripts to execute
COPY .devcontainer/library-scripts/wrap_chrome_binary /opt/bin/wrap_chrome_binary
COPY .devcontainer/library-scripts/*.sh /tmp/library-scripts/
COPY .devcontainer/packages/*.*         /tmp/packages-tmp/
COPY .devcontainer/tests                /tests

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN set -ex \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
    && apt-get purge -y imagemagick imagemagick-6-common nano \
    # Install common packages, non-root user
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    # Use Docker script from script library to set things up
    && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
    # Clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

# shellspec, kcov, gh, geckodriver
FROM shellspec/shellspec-debian:kcov as shellspec-kov-gh

ENV GH_VER=2.3.0
ENV GH_CLI=https://github.com/cli/cli/releases/download/v${GH_VER}/gh_${GH_VER}_linux_amd64.tar.gz
RUN set -ex \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends  wget tar \
    && wget -q $GH_CLI -O - | tar xz -C ./ --strip-components 1 \
    && wget -q $GECKO_DRIVER -O - | tar xz -C /usr/local/bin \
    && apt-get autoremove -y  \
    && apt-get clean -y \
    && rm -r /var/cache/* /var/lib/apt/lists/*

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

# Install Node.js
FROM base-builder as node-builder
ARG INSTALL_NODE="true"
ARG NODE_VERSION="none"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
RUN set -ex \
    && if [ "$INSTALL_NODE" = "true" ]; then bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}"; fi \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Global node packages.
RUN set -ex \
    && CMD="npm install -g npm commitizen commitlint release-it npm" \
    && su vscode -c "source /usr/local/share/nvm/nvm.sh && $CMD" 2>&1
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

# Python packages
FROM node-builder as python-builder
RUN set -ex \
    && pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/packages-tmp/requirements.txt

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

# OS packages + go + goss validator + tips
FROM python-builder as dev-container

ENV GIT_URL="https://raw.githubusercontent.com/"
ENV GO_INSTAL_SCRIPT="$GIT_URL/canha/golang-tools-install-script/master/goinstall.sh"
ENV TIPS_INSTALL_SCRIPT="https://raw.githubusercontent.com/rajasoun/tips/main/install.sh"
RUN set -ex \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && wget -O- -q "$GO_INSTAL_SCRIPT" | bash \
    && bash /tmp/library-scripts/install_os_dependencies.sh "install" \
    && curl -fsSL "$TIPS_INSTALL_SCRIPT" | bash \
    && apt-get autoremove -y  \
    && apt-get clean -y \
    && rm -r /var/cache/* /var/lib/apt/lists/*

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# Dev Container
FROM dev-container
# shellspec
COPY --from=shellspec-kov-gh   /opt/shellspec                         /opt/shellspec
# kcov
COPY --from=shellspec-kov-gh   /usr/local/bin/kcov*                   /usr/local/bin/
COPY --from=shellspec-kov-gh   /usr/local/share                       /usr/local/share/doc/kcov
# gh
COPY --from=shellspec-kov-gh   /src                                    /usr/local
# geckodriver
COPY --from=shellspec-kov-gh   /usr/local/bin/geckodriver              /usr/local/bin

ENV PATH="/opt/shellspec:/tools:$PATH"

COPY .devcontainer/dotfiles/.zshrc /home/$USERNAME/

# Remove library scripts for final image
RUN set -ex \
    && apt-get autoremove --assume-yes \
    && apt-get clean --assume-yes \
    && rm -rf /var/lib/apt/lists/*  \
    && rm -rf /tmp/library-scripts \
    && rm -rf /tmp/packages-tmp
