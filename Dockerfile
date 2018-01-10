FROM alpine:3.6

MAINTAINER Mohit Sharma <mohitsharma44@gmail.com>

# Get Python3
RUN apk add --no-cache python3 && \
    apk add --no-cache git && \
    apk add --no-cache bash && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    # make some useful symlinks that are expected to exist
    if [[ ! -e /usr/bin/python ]];        then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    if [[ ! -e /usr/bin/python-config ]]; then ln -sf /usr/bin/python3-config /usr/bin/python-config; fi && \
    if [[ ! -e /usr/bin/idle ]];          then ln -sf /usr/bin/idle3 /usr/bin/idle; fi && \
    if [[ ! -e /usr/bin/pydoc ]];         then ln -sf /usr/bin/pydoc3 /usr/bin/pydoc; fi && \
    if [[ ! -e /usr/bin/easy_install ]];  then ln -sf /usr/bin/easy_install-3* /usr/bin/easy_install; fi && \
    if [[ ! -e /usr/bin/pip ]]; then ln -sf /usr/bin/pip3 /usr/bin/pip; fi && \
    rm -r /root/.cache && \
    # make directory for webapp code
    mkdir -p /docker-vols && \
    git clone -b master --single-branch https://github.com/Mohitsharma44/uodashboard /docker-vols/uodashboard && \
    mkdir -p /docker-vols/uodashboard/static/timelapses

WORKDIR /docker-vols/uodashboard

# Install required packages
RUN apk add --no-cache libstdc++ lapack-dev && \
    apk add --no-cache \
        --virtual=.build-dependencies \
        python3-dev ca-certificates && \
     pip install --no-cache-dir wheel && \
     LIBRARY_PATH=/lib:/usr/lib /bin/sh -c "pip install --no-cache-dir -r requirements.txt" && \
     find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
     rm -r /root/.cache && \
     apk del .build-dependencies

# fire-up the script
CMD ["python", "/docker-vols/uodashboard/app.py"]

# expose the port where connections will be served
EXPOSE 30000
