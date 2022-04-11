FROM        --platform=$TARGETOS/$TARGETARCH debian:buster-slim

VOLUME [ "/home/container" ]

ENV BDSDIR /home/container/

LABEL       author="David Ignatenko" maintainer="aqpla"

LABEL       org.opencontainers.image.source="https://github.com/pterodactyl/yolks"
LABEL       org.opencontainers.image.licenses=MIT

WORKDIR /home/container/

RUN         apt update && apt upgrade -y \
				&& apt install -y gcc g++ libgcc1 lib32gcc1 libc++-dev gdb libc6 git wine wget curl tar zip unzip binutils xz-utils liblzo2-2 cabextract iproute2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 \
    			libfontconfig libicu63 icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libmariadbclient-dev libduktape203 locales ffmpeg gnupg2 apt-transport-https software-properties-common ca-certificates tzdata \
    			liblua5.3 libz-dev rapidjson-dev \
				&& update-locale lang=en_US.UTF-8 \
				&& dpkg-reconfigure --frontend noninteractive locales \
				&& useradd -m -d /home/container -s /bin/bash container \
				&& dpkg --add-architecture i386
				

WORKDIR ${BDSDIR}

RUN useradd -m bds -d /home/container -s /bin/bash && apt install wget unzip -y
USER bds

ENV WINEDEBUG -all

ENV         USER=container HOME=/home/container
ENV         DEBIAN_FRONTEND noninteractive


COPY        ./entrypoint.sh /entrypoint.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
