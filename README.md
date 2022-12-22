# OpenLiteSpeed Docker Container
[![Build Status](https://github.com/ndigitals/ols-dockerfiles/workflows/docker-build/badge.svg)](https://github.com/ndigitals/ols-dockerfiles/actions/new)
[![docker pulls](https://img.shields.io/docker/pulls/ndigitals/openlitespeed?style=flat&color=blue)](https://hub.docker.com/r/ndigitals/openlitespeed)

Install a lightweight OpenLiteSpeed container using the Stable version in Ubuntu 22.04 Linux on arm64.

### Prerequisites
*  [Install Docker](https://www.docker.com/)

## Build Components
The system will regulary build the OpenLiteSpeed Latest stable version, along with at least two PHP versions, currently only PHP 8.x.

|Component|Version|
| :-------------: | :-------------: |
|Linux|Ubuntu 22.04|
|OpenLiteSpeed|[Latest stable version](https://openlitespeed.org/release-log/version-1-7-x)|
|PHP|[Latest stable version](https://www.php.net/downloads)|

## Usage
### Download an image
Download the openlitespeed image, we can use latest for latest version
```
docker pull ndigitals/openlitespeed:latest
```
or specify the OpenLiteSpeed version with lsphp version
```
docker pull ndigitals/openlitespeed:1.7.11-lsphp74
```
### Start a Container
```
docker run --name openlitespeed -p 7080:7080 -p 80:80 -p 443:443 -it ndigitals/openlitespeed:latest
```
You can also run with Detached mode, like so:
```
docker run -d --name openlitespeed -p 7080:7080 -p 80:80 -p 443:443 -it ndigitals/openlitespeed:latest
```
Tip, you can get rid of `-p 7080:7080` from the command if you don’t need the web admin access.  

### Add a sample page
The server should start running successfully, and you should be able to log into the container. Add some files you want to display with the following command:
```
docker exec -it openlitespeed bash
```
Your default `WORKDIR` should be `/var/www/vhosts/`, since the default document root path is `/var/www/vhosts/localhost/html`. Simply add the following command to `index.php`, then we can verify it from the browser with a public server IP address on both HTTP and HTTPS. 
```
echo '<?php phpinfo();' > localhost/html/index.php
```

### Stop a Container
Feel free to substitute the "openlitespeed" to the "Container_ID" if you did not define any name for the container.
```
docker stop openlitespeed
```

## Support & Feedback
If you still have a question after using OpenLiteSpeed Docker, you have a few options.
* Join [the GoLiteSpeed Slack community](https://litespeedtech.com/slack) for real-time discussion
* Post to [the OpenLiteSpeed Forums](https://forum.openlitespeed.org/) for community support
* Reporting any issue on [Github ols-dockerfiles](https://github.com/ndigitals/ols-dockerfiles/issues) project

**Pull requests are always welcome** 
