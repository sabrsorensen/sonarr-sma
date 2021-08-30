# sonarr-phantom-sma

![Image OS](https://img.shields.io/badge/Image_OS-Ubuntu-orange)
[![Base Image](https://img.shields.io/badge/Base_Image-hotio/sonarr:phantom-orange)](https://ghcr.io/hotio/sonarr)

## Upstreams

[![Upstream](https://img.shields.io/badge/upstream-Sonarr-blue)](https://github.com/Sonarr/Sonarr)
[![Upstream](https://img.shields.io/badge/upstream-sickbeard__mp4__automator-blue)](https://github.com/mdhiggins/sickbeard_mp4_automator)
[![Upstream](https://img.shields.io/badge/upstream-hotio/sonarr-blue)](https://github.com/hotio/docker-sonarr)

## docker run

```sh
docker run --rm --name sonarr \
    -p 8989:8989 \
    -v /docker/host/configs/sonarr:/config/app \
    -v /docker/host/configs/sickbeard_mp4_automator/config:/opt/sma/config \
    -v /docker/host/configs/sickbeard_mp4_automator/post_process:/opt/sma/post_process \
    -v /docker/host/media:/data \
    ghcr.io/sabrsorensen/sonarr-phantom-sma
```

From [hotio/sonarr's documentation](https://github.com/hotio/docker-sonarr/blob/master/README.md#starting-the-container):
The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=002
-e TZ="Etc/UTC"
-e ARGS=""
-e DEBUG="no"
```

## docker-compose.yml example

```yaml
sonarr:
  ...
  image: ghcr.io/sabrsorensen/sonarr-phantom-sma
  container_name: sonarr
  environment:
    - PUID=1000
    - PGID=1000
    - TZ="Etc/UTC"
    - ARGS=""
    - DEBUG="no"
  ports:
    - 8989:8989
  volumes:
    - /docker/host/configs/sonarr:/config/app                                           # Sonarr config, database, logs, etc
    - /docker/host/configs/sickbeard_mp4_automator/config:/opt/sma/config               # sickbeard_mp4_automator's autoProcess.ini
    - /docker/host/configs/sickbeard_mp4_automator/post_process:/opt/sma/post_process   # sickbeard_mp4_automator's post-processing scripts
    - /docker/host/media:/data                                                          # The location of your media library
  labels:
    com.centurylinklabs.watchtower.enable: "false"                                      # Disable autoupdates to prevent interrupted conversions
  ...
```

## Additional documentation

Refer to the respective documentations for additional information on configuring and using
[Sonarr](https://github.com/Sonarr/Sonarr),
[sickbeard_mp4_automator](https://github.com/mdhiggins/sickbeard_mp4_automator), and
[hotio/sonarr](https://github.com/hotio/docker-sonarr).

sickbeard_mp4_automator's `postSonarr.py` can be located at `/opt/sma/postSonarr.py`, use this path in your Sonarr->Connect->Custom Script location.
