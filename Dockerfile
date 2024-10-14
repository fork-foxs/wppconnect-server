# Use the official Node.js 16 as a parent image
FROM node:lts-alpine3.18 AS base

# Set the working directory
WORKDIR /usr/src/wpp-server

# Set environment variables
ENV NODE_ENV=production PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Install dependencies
COPY package.json ./
RUN apk update && \
    apk add --no-cache \
    vips-dev \
    fftw-dev \
    gcc \
    g++ \
    make \
    libc6-compat \
    && rm -rf /var/cache/apk/*
RUN yarn install --production --pure-lockfile && \
    yarn add sharp --ignore-engines && \
    yarn cache clean

# Begin build stage
FROM base AS build
WORKDIR /usr/src/wpp-server
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
COPY package.json  ./
RUN yarn install --production=false --pure-lockfile
RUN yarn cache clean
COPY . .
RUN yarn build


FROM base
WORKDIR /usr/src/wpp-server/

# Add necessary libraries for Chromium and Sharp
RUN apk --no-cache add chromium vips-dev fftw-dev gcc g++ make libc6-compat

# Clean the yarn cache
RUN yarn cache clean

# Copy the built application from the 'build' stage

COPY . .
COPY --from=build /usr/src/wpp-server/ /usr/src/wpp-server/

# Expose the port the app runs on
EXPOSE 21465

# Define the Docker container's entrypoint as the application start command
ENTRYPOINT ["node", "dist/server.js"]
