FROM debian:stable

# Install dependencies FIXME some webserver needed for gitweb
RUN apt-get update
RUN apt-get install -y git gitweb lighttpd openssh-server

RUN cp -Rf /usr/share/gitweb /var/www

ARG CACHEBUST
RUN echo "$CACHEBUST"

# Copy in files
COPY ./config/git-shell-commands /etc/git-shell-commands
COPY ./config/gitweb.conf /etc
COPY ./config/lighttpd.conf /etc/lighttpd

# Add git user
RUN adduser git

# Set shell for git user to git-shell
RUN chsh git -s $(which git-shell)

# Setup .ssh directory
RUN mkdir /home/git/.ssh && chmod 700 /home/git/.ssh
RUN touch /home/git/.ssh/authorized_keys && chmod 600 /home/git/.ssh/authorized_keys

# Use git home as main storage, /git-keys will be for authorized pub keys
VOLUME ["/home/git", "/home/git/.ssh/authorized_keys"]

# Expose ssh for git and 80 for gitweb (need port for http pulls?) Recommend disabling ssh on host
EXPOSE 22
EXPOSE 80

# Entrypoint
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD [ "/entrypoint.sh" ]