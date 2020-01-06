FROM debian:buster-slim

ARG AUSER=muser
ARG AUSER_ID=1001
ARG AGROUP=musers
ARG AGROUP_ID=1001
ARG AHOME=/home/$AUSER

# Install programs ############################################################################################################
USER root
WORKDIR /root

RUN apt update \
 && apt install -y dirmngr ca-certificates vim-gtk3 git bash curl tmux universal-ctags fonts-firacode llvm \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb https://download.mono-project.com/repo/debian vs-buster main" | tee /etc/apt/sources.list.d/mono-official-vs.list \
 && apt update \
 && apt install -y mono-complete monodevelop nuget \
 && apt autoremove \
 && apt clean

# Make skel dir ################################################################################################################
USER root
WORKDIR /etc/skel
SHELL ["/bin/bash", "-c"]

ADD .vimrc .
ADD .bashrc .
ADD .tmux.conf .
RUN curl -fLo .vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create a user ##################################################################################################################
USER root
WORKDIR /root
SHELL ["/bin/bash", "-c"]

ADD createuser.sh /root
RUN chmod a+x createuser.sh \
 && ./createuser.sh $AUSER $AUSER_ID $AGROUP $AGROUP_ID $AHOME \
 && rm createuser.sh
RUN mkdir -p /mnt/data \
 && chown -R $AUSER:$AGROUP /mnt/data \
 && ln -s /mnt/data $AHOME/data \
 && chown $AUSER:$AGROUP $AHOME/data

# ENTRYPOINT #####################################################################################################################
USER $AUSER
WORKDIR $AHOME
SHELL ["/bin/bash", "-c"]
VOLUME /tmp/.X11-unix
VOLUME /mnt/data
ENTRYPOINT bash
