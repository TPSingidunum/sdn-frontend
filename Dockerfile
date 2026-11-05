FROM node:22-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

COPY . .
ARG VITE_API_BASE_URL=/api
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
RUN npm run build

FROM httpd:alpine
COPY httpd-proxy.conf /usr/local/apache2/conf/extra/httpd-proxy.conf
RUN sed -i \
    -e 's|^#LoadModule proxy_module |LoadModule proxy_module |' \
    -e 's|^#LoadModule proxy_http_module |LoadModule proxy_http_module |' \
    /usr/local/apache2/conf/httpd.conf \
    && printf '\nInclude conf/extra/httpd-proxy.conf\n' >> /usr/local/apache2/conf/httpd.conf
COPY --from=build /app/dist /usr/local/apache2/htdocs
EXPOSE 80
