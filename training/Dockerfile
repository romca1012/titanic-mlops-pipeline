# training/Dockerfile

FROM python:3.12-slim

WORKDIR /app

COPY training/train.py /app/training/train.py
COPY data/train.csv /app/data/train.csv
COPY requirements.txt /app/requirements.txt

# La bonne façon : installer setuptools en pip (sinon pas de pkg_resources !)
RUN pip install --no-cache-dir setuptools && \
    pip install --no-cache-dir -r /app/requirements.txt

CMD ["python", "training/train.py"]

