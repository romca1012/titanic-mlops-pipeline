# api/Dockerfile

FROM python:3.12-slim

WORKDIR /app

COPY api/app.py /app/api/app.py
COPY requirements.txt /app/requirements.txt

# Installer setuptools + requirements
RUN pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 8000

CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8000"]
