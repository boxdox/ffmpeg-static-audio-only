FROM alpine:3.24.4 AS builder

ARG FFMPEG_VERSION=9.1

RUN apk add --no-cache \
    build-base \
    curl \
    tar \
    xz \
    nasm \
    file

WORKDIR /build

RUN curl -fsSL "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz" \
    | tar -xJ \
    && cd "ffmpeg-${FFMPEG_VERSION}" \
    && ./configure \
        --prefix=/usr/local \
        --extra-ldflags="-static" \
        --enable-static \
        --disable-shared \
        --enable-small \
        --disable-everything \
        --disable-autodetect \
        --disable-network \
        --disable-doc \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-avdevice \
        --disable-swscale \
        --enable-protocol=file,pipe \
        --enable-demuxer=flac,mov,aac \
        --enable-muxer=mp4,ipod \
        --enable-decoder=flac,alac,aac \
        --enable-encoder=aac \
        --enable-parser=flac,aac \
        --enable-filter=aresample,aformat,anull \
        --enable-bsf=aac_adtstoasc \
    && make -j"$(nproc)" \
    && make install

RUN strip /usr/local/bin/ffmpeg \
    && file /usr/local/bin/ffmpeg \
    | tee /dev/stderr \
    | grep -qE "static(ally|-pie) linked"

FROM scratch
COPY --from=builder /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
