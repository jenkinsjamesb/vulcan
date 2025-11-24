# Vulcan

A container for portable, painless, serverside source control with Git.

### Description

Vulcan is a lite software forge package built off of Git on a server. It's built mainly for individual use as an alternative to a) Chucking everything on Github, and b) full-featured self-hosted heavyweights (Gitea, Forgejo, etc.). The idea is to keep the forge as simple and portable as possible, decrying silly things like configuration through a WebUI.

With Vulcan, you get:

- SSH publickey authorization for full read/write access to every repo (no real user management).
- The option to open any repositories on a Gitweb server and allow Git protocol pulls.
- Basic CI actions (as soon as I figure out how the hell I'm going to implement them).

### Installation

Vulcan is easiest run with a docker-compose file. An example service configuration is provided below:

```yaml
services:
  vulcan:
    container_name: vulcan
    build:
      context: /path/to/vulcan/repo
    volumes:
      - /path/to/git/storage:/home/git                                  # For storage of all the repositories. Can be anywhere, even over network.
      - /path/to/authorized_keys:/home/git/.ssh/authorized_keys         # For controlling write access.
    ports:
      - 22:22                                                           # For SSH access--it is recommended to disable SSH on the host for extra security.
      - 80:80                                                           # For gitweb.
      - 9418:9418                                                       # For git protocol pulls.
    restart: unless-stopped
```

Building the container and running with `docker run` it is also a option.

### Bugs

- A logging command that monitors each service and prints useful information is sorely needed. 
- CI, as mentioned, does not currently exist.
- Gitweb, while functional, is not pretty. I would love to add some small touch-ups, but this requires learning more Perl and CGI.
- Ideally it should be possible to have some light user management, but this requires interception of the git push commands (scary).
