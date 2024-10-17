FROM node:14 as builder
WORKDIR /yapi
ENV VERSION=1.12.0
RUN wget https://github.com/YMFE/yapi/archive/v${VERSION}.zip
RUN unzip v${VERSION}.zip && mv yapi-${VERSION} vendors
COPY ./config.json .
RUN cd /yapi/vendors && rm -rf package-lock.json config_example.json
WORKDIR /yapi/vendors
RUN npm install --registry=https://registry.npmmirror.com

FROM node:16-alpine as runner
ENV TZ="Asia/Shanghai"
WORKDIR /yapi/vendors
COPY --from=builder /yapi /yapi
EXPOSE 3000
CMD ["node","server/app.js"]