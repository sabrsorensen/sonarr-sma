FROM hotio/sonarr:phantom
LABEL maintainer=825813+sabrsorensen@users.noreply.github.com

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=${VCS_URL}

# Install sickbeard_mp4_automator package dependencies
RUN apt-get update && \
    apt-get install --yes \
        ffmpeg \
        git \
        python3-pip && \
    apt-get clean && \
    ln /usr/bin/pip3 /usr/bin/pip && \
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
