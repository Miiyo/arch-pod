#Archlinux
FROM miyouki/arch:arch-miyo

### Gitpod user ###
COPY sudoers /etc
RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # To emulate the workspace-session behavior within dazzle build env
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
COPY --chown=gitpod:gitpod bash.bashrc /home/gitpod/.bashrc

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    # create .bashrc.d folder and source it in the bashrc
    mkdir -p /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> /home/gitpod/.bashrc && \
    # create a completions dir for gitpod user
    mkdir -p /home/gitpod/.local/share/bash-completion/completions

# Update all packages
USER root
RUN pacman -Syyu --noconfirm
RUN pacman -Syyu zsh curl wget neofetch --noconfirm

# Setup git configuration
COPY git.sh /tmp/
RUN chmod +x /tmp/git.sh
USER root
RUN bash /tmp/git.sh

# Just incase the first doesn't work
RUN git config --global user.name "ekkusa"
RUN git config --global user.email "dayesofficial@gmail.com"

# CD into Workspace
RUN cd /workspace
