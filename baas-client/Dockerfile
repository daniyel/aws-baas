FROM node:8.11.2

WORKDIR /app
COPY . .

RUN npm i && \
    npm i auth0/node-baas && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3000

CMD ["npm", "start"]
