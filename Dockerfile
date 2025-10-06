FROM node:alpine3.18 as build

# providing runtime variables
ARG REACT_APP_API_URL

#env

ENV REACT_APP_API_URL=$REACT_APP_API_URL
# Build App
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Serve with Nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/build .
# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]