FROM node:22-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
ARG VITE_API_URL=http://192.168.49.2:30888
ENV VITE_API_URL=${VITE_API_URL}
RUN chmod +x start.sh
CMD ["sh", "start.sh"]