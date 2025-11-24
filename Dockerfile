FROM debian:stable

# Install dependencies FIXME some webserver needed for gitweb
RUN apt-get update
RUN apt-get install -y git gitweb lighttpd openssh-server

# Suppress PAM's MOTD print
RUN sed -i -e '/motd/s/^/#/' /etc/pam.d/sshd

# Copy gitweb cgi to /var/www
RUN cp -Rf /usr/share/gitweb /var/www

# Copy in gitweb config files
COPY --chown=root --chmod=744 ./src/gitweb.conf /etc
COPY --chown=root --chmod=700 ./src/lighttpd.conf /etc/lighttpd

# Copy in ssh server config files
COPY --chown=root --chmod=700 ./src/issue /etc
COPY --chown=root --chmod=700 ./src/sshd_config /etc/ssh

# Add git user
RUN adduser git

# Set shell for git user to git-shell
RUN chsh git -s $(which git-shell)

# Copy in git shell commands and add to /home/git
COPY --chown=git --chmod=755 ./src/git-shell-commands /tmp/git-shell-commands
RUN cp -r /tmp/git-shell-commands /home/git

# Copy in man pages for use in git shell
COPY --chown=root --chmod=744 ./src/man /tmp/man

# Setup .ssh directory
RUN mkdir /home/git/.ssh && chmod 700 /home/git/.ssh

# Volume mount git home and authorized_keys file. Also a volume for git-shell-commands that can be mapped, but shouldn't to preserve vulcanctl
VOLUME ["/home/git", "/home/git/.ssh/authorized_keys", "/home/git/git-shell-commands"]

# Expose ssh for git and 80 for gitweb (need port for http/unauthenticated pulls?) Recommend disabling ssh on host
EXPOSE 22
EXPOSE 80
EXPOSE 9418

# Entrypoint
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD [ "/entrypoint.sh" ]