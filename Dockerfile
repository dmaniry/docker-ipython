FROM base/arch

MAINTAINER Dominique Maniry dmaniry@cs.tu-berlin.de

#RUN echo "Server = http://mirror.rit.edu/archlinux/$repo/os/$arch" > /etc/pacman.d/mirrorlist

RUN pacman -Syyu --noconfirm

#Pacman packages
RUN pacman -Sy --noconfirm \
      openssh supervisor base-devel vim curl git htop nmap dnsutils zeromq zsh jshon \
      grml-zsh-config python2 ipython2 python2-pip python2-setuptools python2-numpy \
      python2-scipy python2-yaml python2-requests python2-biopython python2-jinja \
      python2-scikit-learn python2-numexpr python2-pytables python2-pyzmq \
      cython2 python2-tornado python2-pygments python2-sympy python2-nltk python2-networkx \
      python2-matplotlib python2-pillow opencv eigen2 r nodejs && yes | pacman -Scc

RUN export PIP_DEFAULT_TIMEOUT=600
#matplotlib needs latest distribute
#RUN pip2 install -U distribute

#Pandas
RUN pip2 install pandas
#Bokeh
RUN pip2 install bokeh

# Parakeet (numba alternative)
RUN pip2 install dsltools
RUN pip2 install parakeet

#Rmagic
RUN pip2 install rpy2

#Optional
#RUN pip2 install bottleneck 
#RUN pip2 install pymc
#RUN pip2 install patsy
#RUN pip2 install statsmodels
#RUN pip2 install beautifulsoup4 html5lib
#RUN pip2 install pattern
#RUN pip2 install vincent

#Cleanup
RUN rm -rf /tmp/*

#user ipy
RUN useradd -D --shell=/bin/zsh
RUN useradd -m -G users ipy

ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown root:root /root/.ssh/authorized_keys
RUN chsh -s /bin/zsh

ENV IPYTHONDIR /home/ipy/.ipython
ENV IPYTHON_PROFILE nbserver
RUN ipython2 profile create nbserver

# Adding script necessary to start ipython notebook server.
#ADD ./notebooks /home/ipy/ipynotebooks
ADD ./profile_nbserver /home/ipy/.ipython/profile_nbserver

ADD mycert.pem /home/ipy/.ipython/profile_nbserver/mycert.pem

RUN chown -R ipy:ipy /home/ipy

# generate host keys
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN echo "HostKey /etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
# make zsh work in urxvt
RUN echo "TERM=xterm" >> /root/.zshrc
RUN echo "TERM=xterm" >> /home/ipy/.zshrc


ADD ./conf /etc/supervisor.d/

EXPOSE 22 8888

CMD ["/usr/bin/supervisord"]
