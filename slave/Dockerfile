FROM postgres:9.6-alpine
RUN apk add build-base
RUN apk add make
RUN apk add curl
RUN curl -L https://github.com/ncopa/su-exec/archive/dddd1567b7c76365e1e0aac561287975020a8fad.tar.gz | tar xvz && \
cd su-exec-* && make && mv su-exec /usr/local/bin && cd .. && rm -rf su-exec-*
RUN apk add --update iputils

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["su-exec", "postgres", "postgres"]