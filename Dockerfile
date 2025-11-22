FROM debian:stable

# Install dependencies FIXME some webserver needed for gitweb
RUN apt-get update
RUN apt-get install -y git gitweb lighttpd openssh-server

# Copy gitweb cgi to /var/www
RUN cp -Rf /usr/share/gitweb /var/www

# Copy in gitweb config files
COPY ./config/gitweb.conf /etc
COPY ./config/lighttpd.conf /etc/lighttpd

# Add git user
RUN adduser git

# Set shell for git user to git-shell
RUN chsh git -s $(which git-shell)

# Copy in essential git shell commands
COPY --chown=git --chmod=755 ./config/git-shell-commands /home/git/git-shell-commands

# Setup .ssh directory
RUN mkdir /home/git/.ssh && chmod 700 /home/git/.ssh
RUN touch /home/git/.ssh/authorized_keys && chmod 600 /home/git/.ssh/authorized_keys

# Volume mount git home and authorized_keys file
VOLUME ["/home/git", "/home/git/.ssh/authorized_keys"]

# Expose ssh for git and 80 for gitweb (need port for http/unauthenticated pulls?) Recommend disabling ssh on host
EXPOSE 22
EXPOSE 80

# Entrypoint
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD [ "/entrypoint.sh" ]