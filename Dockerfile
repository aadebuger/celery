FROM python:3.4-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user

ENV CELERY_VERSION 3.1.18

RUN pip install celery=="$CELERY_VERSION"
RUN pip install docker-py

RUN { \
	echo 'import os'; \
	echo "BROKER_URL = os.environ.get('CELERY_BROKER_URL', 'amqp://')"; \
} > celeryconfig.py

# --link some-rabbit:rabbit "just works"
ENV CELERY_BROKER_URL amqp://guest@rabbit

#USER user
CMD ["celery", "worker"]
