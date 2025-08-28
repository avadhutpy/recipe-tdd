FROM python:3.9-alpine3.13
LABEL maintainer="ava"

ENV PYTHONUNBUFFERED=1

# If you compile any wheels (psycopg2, Pillow, etc.), you'll want build deps.
# Uncomment when needed:
# RUN apk add --no-cache build-base

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser -D -H django-user

ENV PATH="/py/bin:$PATH"

USER django-user
