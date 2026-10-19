FROM ubuntu:20.04
USER root
WORKDIR /TLE

RUN apt-get update
RUN apt-get install -y git apt-utils sqlite3

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    libcairo2-dev \
    libgirepository1.0-dev \
    libpango1.0-dev \
    pkg-config \
    python3-dev \
    gir1.2-pango-1.0 \
    python3.9-venv \
    libpython3.9-dev \
    libjpeg-dev \
    zlib1g-dev  \
    python3-pip \
    fonts-noto-cjk \
    fonts-noto-cjk-extra


RUN python3.9 -m pip install poetry

# COPY ./poetry.lock ./poetry.lock
COPY ./pyproject.toml ./pyproject.toml

RUN python3.9 -m poetry lock
RUN python3.9 -m poetry install

RUN mkdir -p ./data/assets/fonts

COPY ./tle ./tle
COPY ./extra/fonts.conf ./extra/fonts.conf
COPY ./run.sh ./run.sh
RUN cp \
    /usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc \
    /usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc \
    ./data/assets/fonts

ENTRYPOINT ["/TLE/run.sh"]
