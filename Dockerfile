# Build the gpx library
FROM node:18-alpine AS gpx-builder

RUN npm install -g typescript

WORKDIR /app/gpx
COPY gpx/package*.json ./
COPY gpx .
RUN npm install typescript
RUN npm install
RUN npm run build

# Build the SvelteKit website
FROM node:18-alpine AS website-builder
WORKDIR /app/website

# Copy and install website dependencies
COPY website/package*.json ./
RUN npm install

# Copy gpx build from previous stage
COPY --from=gpx-builder /app/gpx/dist ../gpx/dist
COPY website .

# Set dummy token for build (you will override it at runtime or inject at build time)
ARG PUBLIC_MAPBOX_TOKEN=__dummy__
ENV PUBLIC_MAPBOX_TOKEN=$PUBLIC_MAPBOX_TOKEN

RUN npm run build

# Serve using NGINX
FROM nginx:stable-alpine
COPY --from=website-builder /app/website/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]