# FROM otel/opentelemetry-collector-opampsupervisor:latest AS supervisor
FROM ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-opampsupervisor:latest AS supervisor

# FROM otel/opentelemetry-collector-contrib:latest AS col

FROM alpine:latest

RUN mkdir -p /blah/opamp

COPY --from=supervisor / /blah/opamp
# COPY --from=supervisor /usr/local/bin/opampsupervisor ./opampsupervisor
# COPY --from=col / /blah/opamp
# COPY --from=supervisor /otelcol-contrib /otelcol-contrib

CMD [ "sh" ]

# FROM otelcontribcol AS col
# FROM otel/opentelemetry-collector-contrib:latest AS col

# FROM alpine:latest AS prep
# # RUN apk --update add ca-certificates
# RUN mkdir -p /etc/otel/supervisor-data/

# FROM scratch

# ARG USER_UID=10001
# ARG USER_GID=10001
# USER ${USER_UID}:${USER_GID}

# # COPY --from=prep /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
# COPY --from=prep --chmod=777 --chown=${USER_UID}:${USER_GID} /etc/otel/supervisor-data /etc/otel/supervisor-data
# COPY --chmod=755 opampsupervisor /
# COPY ./supervisor.yaml /etc/otel/supervisor.yaml
# COPY --from=col --chmod=755 /otelcontribcol /otelcontribcol

# EXPOSE 4317 55680 55679
# CMD ["sh"]
# # ENTRYPOINT ["/opampsupervisor"]
# # CMD ["--config", "/etc/otel/supervisor.yaml"]