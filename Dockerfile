FROM scratch

ENV PORT 8080

EXPOSE $PORT

COPY nano-service /

CMD ["/nano-service"]