# Docker container for MS Teams running on Edge
This container allows you to set up and run MS Teams in the Edge browser as a PWA App.
The purpose of this exercise is to allow Teams to stay logged in for more than 24 hours, a feat apparently impossible to achieve with teams4linux in our lab, without outright polluting your system with MS Edge installation.

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

## Migration
The persistency of the login is done via mounting a config directory `profile` generated on the host when you run the `run.sh` . Transferring your profile to another computer should therefore be as easy as copying over (or replacing it if you already ran `run.sh` on the new installation) the `profile` directory.

## Known issues
- After setting up the PWA, subsequent runs of `run.sh` don't open the PWA, but rather a normal browser window with URL field and other decorations.
  - Exitting the Edge window did not lead to the `docker exec` command cleanly returning, thus preventing the creation of the "first run" flag file.
  - Solution: create a file named `.pwa-setup-done` in the `profile` directory.
- Fonts in Teams are ugly
  - Likely caused by the container having access only to the most basic fonts installed in Ubuntu.
- The App only runs as an active window, rather than hiding into a tray icon.
  - Likely an artifact of the fact that the tray service on the host is not accessible to the container. I didn't verify wheter this is also the case with "native" installation of Edge.
