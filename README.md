# Docker container for MS Teams running on Edge
This container allows you to set up and run MS Teams in the Edge browser as a PWA App.
The purpose of this exercise is to allow Teams to stay logged in for more than 24 hours, a feat apparently impossible to achieve with teams4linux in our lab.

## Setup
First, build the image using `./build.sh`
Then, run it using `./run.sh`.
The first run just opens MS Edge window - tell them to fuck off with telemetry, optionally install whatever browser plugins you want and navigate to ` 
https://teams.microsoft.com`.
Log in to teams, configure it as you wish and then select `... > More Tools > Apps > Install Microsoft Teams (PWA)` to add it as an "App".
Upon subsequent runs of `run.sh` you should be sent directly to the App.

If you want to have access to the host filesystem, you may add something like
```
-v /home/${USER}:/home/edgeuser/host_home \
```
to the first `docker run` command in `run.sh`.
This will expose the home directory as a `host_home` directory in the container home.

## Launcher Icon
Running `install.sh` will create and install a `.desktop` launcher file into your host system - for quick access.
