# 1. Use official Node.js image
FROM node:18-alpine
RUN npm install -g typescript

# 2. Create app directory
WORKDIR /app

# 3. Copy gpx and build it
COPY ./gpx ./gpx
WORKDIR /app/gpx
RUN npm install && npm run build

# 4. Copy website and install dependencies
WORKDIR /app
COPY ./website ./website
WORKDIR /app/website
RUN npm install

# 5. Add ENV vars (or set at runtime in DigitalOcean UI)
ENV PUBLIC_MAPBOX_TOKEN=pk.eyJ1Ijoia2Fyb29rYSIsImEiOiJjbTlzNnQyN2YxcWFkMmpyN2V6bDU4Y2VzIn0.HqJOQtRbr-XchebCkmhnsA

# 6. Build static site
ENV NODE_OPTIONS=--max-old-space-size=4096
RUN npm run build

# 7. Use a minimal web server to serve the static content
# We’ll use `http-server` or `serve`
RUN npm install -g serve

# 8. Expose port & start server
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]