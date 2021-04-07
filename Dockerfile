FROM debian:buster-slim

ARG AUSER=muser
ARG AUSER_ID=1001
ARG AHOME=/home/$AUSER
ARG AUSER_PASSWORD=test1234
ARG AGROUP=musers
ARG AGROUP_ID=1001

ENV CXX=clang++
ENV CC=clang

# Install programs ----------------------------------------------------------------------------------------------------------
RUN apt update \
 && apt install --no-install-recommends -y dirmngr ca-certificates vim-gtk3 git bash curl tmux universal-ctags fonts-firacode llvm gdb make gnupg unrar-free unzip \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb https://download.mono-project.com/repo/debian vs-buster main" | tee /etc/apt/sources.list.d/mono-official-vs.list \
 && apt update \
 && apt install --no-install-recommends -y mono-complete monodevelop nuget \
 && apt clean

# Make skel dir -------------------------------------------------------------------------------------------------------------
COPY rootfs/.vimrc /etc/skel/.vimrc
COPY rootfs/.bashrc /etc/skel/.bashrc
COPY rootfs/.tmux.conf /etc/skel/.tmux.conf
RUN curl -fLo /etc/skel/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
 && git clone https://github.com/chris-marsh/pureline.git /etc/skel/.config/pureline

# Create a user -------------------------------------------------------------------------------------------------------------
RUN groupadd -f --gid $AGROUP_ID $AGROUP \
 && useradd --uid $AUSER_ID --groups $AGROUP --shell /bin/bash --create-home --skel /etc/skel --home-dir $AHOME --password $(openssl passwd -1 $AUSER_PASSWORD) $AUSER 
RUN mkdir -p /mnt/data \
 && chown -R $AUSER:$AGROUP /mnt/data \
 && chmod 777 /mnt/data \
 && ln -s /mnt/data $AHOME/data \
 && chown -R $AUSER:$AGROUP $AHOME/data

# ENTRYPOINT ----------------------------------------------------------------------------------------------------------------
USER $AUSER
WORKDIR $AHOME
SHELL ["/bin/bash", "-c"]
VOLUME /tmp/.X11-unix
VOLUME /mnt/data
ENTRYPOINT ["/bin/bash"]
