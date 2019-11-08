# build
FROM node:latest as build-env 
WORKDIR /app
COPY . . 
RUN npm install && npm run build --prod

FROM nginx:alpine
COPY --from=build-env /app/dist/proj1 /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]