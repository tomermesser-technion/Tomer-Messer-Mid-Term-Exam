FROM python:3.12-slim

RUN useradd --create-home appuser

WORKDIR /app

RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false

COPY pyproject.toml ./

RUN poetry install --no-root --only main

COPY --chown=appuser:appuser app.py ./
COPY --chown=appuser:appuser templates/ ./templates/
COPY --chown=appuser:appuser static/ ./static/

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
