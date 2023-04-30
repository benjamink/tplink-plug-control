FROM python:3.7-alpine3.16 as build
ENV PYTHONUNBUFFERED 1
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY ./pip-requirements.txt /app/requirements.txt

RUN apk update && apk upgrade --no-cache && \
  apk add --no-cache gcc musl-dev && \
  python -m venv /opt/venv && \
  pip install --upgrade pip && \
  pip install -Ur requirements.txt

FROM python:3.7-alpine3.16 as runner
LABEL maintainer "Benjamin Krein <superbenk@gmail.com>"

WORKDIR /app
ENV PATH="/opt/venv/bin:$PATH"

COPY --from=build /opt/venv /opt/venv
COPY . /app

RUN adduser -h /app -s /bin/bash -D python

USER python

ENTRYPOINT [ "python", "tp_plug_toggle", "-c", "/app/config.json" ]