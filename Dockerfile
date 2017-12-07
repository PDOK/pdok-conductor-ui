#build conductor UI for pdok
#
# conductor:ui - Netflix conductor UI
#
FROM node:6-alpine as builder
MAINTAINER Netflix OSS <conductor@netflix.com>

#install git and packages needed for the node build on alpine
RUN apk update
RUN apk add git \
  autoconf \
  automake \
  libtool \
  build-base \
  libstdc++ \
  gcc \
  abuild \
  binutils \
  nasm \
  libpng \
  libpng-dev \
  libjpeg-turbo \
  libjpeg-turbo-dev 

RUN git clone --branch v1.8.1  https://github.com/Netflix/conductor /src

# Get and install conductor UI
RUN cd /src/ui \
  && npm install \
  && npm run build --server

#final image
FROM node:6-alpine 

# Make app folders
RUN mkdir -p /app/ui

# Copy the ui files onto the final image
COPY --from=builder /src/docker/ui/bin/startup.sh /app
COPY --from=builder /src/ui /app/ui
RUN chmod +x /app/startup.sh

EXPOSE 5000

CMD [ "/app/startup.sh" ]
ENTRYPOINT ["/bin/sh"]

