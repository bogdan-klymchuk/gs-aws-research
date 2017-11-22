FROM node:boron
# Create app directory
WORKDIR /usr/src/app
# Install app dependencies
COPY package.json package-lock.json ./
# For npm@5 or later, copy package-lock.json as well

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY . .

CMD [ "npm", "start" ]
