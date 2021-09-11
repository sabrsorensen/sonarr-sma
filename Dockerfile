FROM ghcr.io/hotio/sonarr:release
LABEL maintainer=825813+sabrsorensen@users.noreply.github.com

ARG BUILD_DATE
ARG COMMIT_AUTHOR
ARG VCS_REF
ARG VCS_URL
ARG SMA_REF
ARG BASE_REF

LABEL maintainer=${COMMIT_AUTHOR} \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.source=${VCS_URL} \
    org.opencontainers.image.base.digest=${BASE_REF} \
    sma_revision=${SMA_REF}

# Install sickbeard_mp4_automator package dependencies
RUN apt-get update && \
    apt-get install --yes \
    ffmpeg \
    git \
    python3-pip && \
    apt-get clean && \
    pip install --no-cache-dir --upgrade pip

# clone sickbeard_mp4_automator and install Python module dependencies
RUN git clone --depth 1 --single-branch git://github.com/mdhiggins/sickbeard_mp4_automator /opt/sma
WORKDIR /opt/sma
RUN pip install --no-cache-dir --upgrade -r setup/requirements.txt

# expose .../config for mounting in autoProcess.ini and .../post_process for mounting in any post_process scripts
VOLUME /opt/sma/config
VOLUME /opt/sma/post_process

# add and configure healthcheck
ADD healthcheck-sonarr.sh /
RUN chmod +x /healthcheck-sonarr.sh
HEALTHCHECK --interval=20s --timeout=10s --start-period=60s --retries=5 \
    CMD /healthcheck-sonarr.sh
