# titanic-mlops-pipeline
FR : Pipeline MLOps complète sur le dataset Titanic : préparation des données, entraînement, suivi MLflow, packaging Docker, API REST, déploiement auto avec Terraform et Ansible. Projet end-to-end.  
EN : Full MLOps pipeline on Titanic: data prep, training, MLflow tracking, Docker, REST API, auto-deploy with Terraform &amp; Ansible. End-to-end project.

## Overview

This repository contains a small end‑to‑end example of an MLOps workflow on the
Titanic data set. The project is organised as three Docker services:

* **mlflow-tracking** – an MLflow server used to store experiments and models.
* **titanic-mlops-training** – a container running `training/train.py` which
  trains a RandomForest model and registers it in the MLflow Model Registry.
* **titanic-mlops-api** – a FastAPI service exposing a `/predict` endpoint. At
  start‑up it loads the latest registered model.

All MLflow artefacts are stored in the `mlruns` directory which is mounted as a
shared volume for the services.

## Local testing with docker-compose

1. Build the Docker images:

   ```bash
   docker-compose build
   ```

2. Start the stack (this will also run the training container once):

   ```bash
   docker-compose up
   ```

The API is then available on `http://localhost:8000` and the MLflow UI on
`http://localhost:5000`.

## Example request

Querying the prediction endpoint with `curl`:

```bash
curl -X POST http://localhost:8000/predict \
     -H "Content-Type: application/json" \
     -d '{"Pclass":3, "Sex":0, "Age":22, "SibSp":1, "Parch":0}'
```

Typical JSON response:

```json
{"probability_survival": 0.8}
```

## Environment variables

The API expects the `MLFLOW_TRACKING_URI` environment variable to point to the
MLflow tracking server. This is configured in `docker-compose.yml`, but if you
run the API manually you must export it yourself, e.g.:

```bash
export MLFLOW_TRACKING_URI=http://localhost:5000
```