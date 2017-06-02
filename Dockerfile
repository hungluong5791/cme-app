FROM node:6.6.0

# TODO remove before commit
# ENV http_proxy "http://HungLK1:fsoftPasswordNo3@fsoft-proxy:8080"
# ENV https_proxy "http://HungLK1:fsoftPasswordNo3@fsoft-proxy:8080"

ADD package.json /tmp/package.json

# Use NPM http registry instead of https
RUN npm config set registry http://registry.npmjs.org/

RUN cd /tmp && npm install

WORKDIR /app

RUN cp -a /tmp/node_modules /app

COPY . /app

EXPOSE 80

CMD ["npm", "start"]