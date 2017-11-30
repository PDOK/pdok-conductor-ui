#build conductor UI for pdok
#
# conductor:ui - Netflix conductor UI
#
FROM node:alpine as builder
MAINTAINER Netflix OSS <conductor@netflix.com>

RUN apk update
RUN apk add git
RUN git clone https://github.com/Netflix/conductor /src

# Install the required packages for the node build
# to run on alpine
RUN apk add \
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

# Make app folders
RUN mkdir -p /app/ui

# Copy the ui files onto the image
COPY /src/docker/ui/bin /app
COPY /src/ui /app/ui

# Copy the files for the server into the app folders
RUN chmod +x /app/startup.sh

# Get and install conductor UI
RUN cd /app/ui \
  && npm install \
  && npm run build --server


FROM node:alpine
COPY --from=builder /app /app


EXPOSE 5000

CMD [ "/app/startup.sh" ]
ENTRYPOINT ["/bin/sh"]

