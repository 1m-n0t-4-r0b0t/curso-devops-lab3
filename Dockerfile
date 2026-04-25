FROM node:24 AS build
WORKDIR /lab3
COPY . .
RUN npm install
RUN npm run build 

FROM node:24-alpine 
WORKDIR /lab3
COPY --from=build /lab3/dist ./dist
COPY --from=build /lab3/package*.json ./
RUN npm install --only=production

EXPOSE 3000

CMD ["node", "dist/main.js"]