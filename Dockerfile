FROM node:22-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
ARG VITE_API_BASE_URL=http://localhost:3000
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
RUN npm run build

FROM httpd:alpine
COPY --from=build /app/dist/ /usr/local/apache2/htdocs/
EXPOSE 80
