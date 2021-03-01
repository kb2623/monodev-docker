FROM debian:buster-slim

ARG AUSER=muser
ARG AUSER_ID=1001
ARG AGROUP=musers
ARG AGROUP_ID=1001
ARG AHOME=/home/$AUSER

ENV CXX=clang++
ENV CC=clang

# Install programs ############################################################################################################
RUN apt update \
 && apt install --no-install-recommends -y dirmngr ca-certificates vim-gtk3 git bash curl tmux universal-ctags fonts-firacode llvm gdb make gnupg \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb https://download.mono-project.com/repo/debian vs-buster main" | tee /etc/apt/sources.list.d/mono-official-vs.list \
 && apt update \
 && apt install --no-install-recommends -y mono-complete monodevelop nuget \
 && apt clean

# Make skel dir ################################################################################################################
COPY .vimrc /etc/skel/.vimrc
COPY .bashrc /etc/skel/.bashrc
COPY .tmux.conf /etc/skel/.tmux.conf
RUN curl -fLo /etc/skel/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create a user ##################################################################################################################
RUN addgroup -gid $AGROUP_ID $AGROUP \
 && adduser --disabled-password --uid $AUSER_ID --ingroup $AGROUP --shell /bin/bash --home $AHOME $AUSER 
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
ENTRYPOINT ["/bin/bash"]
