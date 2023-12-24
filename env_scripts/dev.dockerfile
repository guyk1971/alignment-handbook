FROM nvcr.io/nvidia/pytorch:23.09-py3
  RUN apt-get update
  RUN apt-get -y install nano gdb time
  RUN apt-get -y install sudo
  RUN (groupadd -g 1000 guy || true) && useradd --uid 1000 -g 1000 --no-log-init --create-home guy && (echo "guy:password" | chpasswd) && (echo "guy ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers)
  RUN mkdir -p /home/guy/code/study/git/clones/alignment-handbook/env_scripts
  RUN ln -s code/study/git/clones/alignment-handbook/env_scripts/.vscode-server /home/guy/.vscode-server
  RUN echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
  RUN sysctl -p
  USER guy
  COPY docker.bashrc /home/guy/.bashrc
  RUN source /home/guy/.bashrc
  WORKDIR /home/guy/code/study/git/clones/alignment-handbook/env_scripts/..
  CMD /bin/bash
