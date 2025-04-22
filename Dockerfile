FROM node:18-alpine

WORKDIR /app

RUN npm install -g typescript

COPY ./gpx ./gpx
WORKDIR /app/gpx
RUN npm install
RUN npm run build

WORKDIR /app
COPY ./website ./website

WORKDIR /app/website
RUN npm install

EXPOSE 5173

CMD ["npm", "run", "dev"]
