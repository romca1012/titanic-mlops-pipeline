# 🚀 Titanic MLOps Pipeline

## 🎯 Objectif

Développer et déployer une solution MLOps complète sur AWS :

- API REST pour les prédictions
- Instance pour l'entraînement du modèle
- Suivi des expériences avec **MLflow**
- Automatisation complète avec :
  - **Terraform / OpenTofu** (infrastructure)
  - **Ansible** (configuration et déploiement)
  - **Docker** (containerisation)

---

## 🖥️ Architecture

```text
         +------------------+
         | Client (curl/UI) |
         +--------+---------+
                  |
                  v
         +--------+---------+         +-----------------------------+
         |   EC2 Instance   |         |        EC2 Instance         |
         |     API REST     | <-----> |   MLflow + Training server  |
         | (FastAPI + Docker)         | (MLflow + scikit-learn)     |
         +--------+---------+         +-----------------------------+
         Port 8000 : /predict              Port 5000 : MLflow UI


```

Instances utilisées :
titanic-mlops-api : API REST (FastAPI, uvicorn)

mlflow-tracking-training : MLflow server + entraînement du modèle

🔨 Technologies
AWS EC2 (instances t3.small)

OpenTofu (Terraform)

Ansible

Docker & Docker Compose

FastAPI (API REST)

MLflow (tracking + model registry)

scikit-learn (modèle de classification Titanic)

Python 3.12

🌐 Réseau
VPC automatiquement provisionné

Security Groups :

✅ Port 8000 : accès à l'API

✅ Port 5000 : accès à MLflow

✅ Port 22 : SSH

📁 Structure du projet

```text

titanic-mlops-pipeline/
├── api/                 # API REST FastAPI
├── training/            # Entraînement du modèle ML
├── data/                # Fichier CSV Titanic
├── infra/
│   ├── terraform/       # Provisionnement (OpenTofu)
│   └── ansible/         # Configuration Ansible
├── docker-compose.yml   # Déploiement multi-container
└── README.md            # Documentation

```

🚀 Instructions de déploiement

1️⃣ Cloner le dépôt

```text

git clone https://github.com/romca1012/titanic-mlops-pipeline.git
cd titanic-mlops-pipeline

```

2️⃣ Lancer le déploiement complet
⚠️ Prérequis : renseigner les fichiers suivants :

infra/terraform/terraform.tfvars

Clé SSH privée dans infra/terraform/_credentials/mlops-key.pem

Puis exécuter :

```text

./launch.sh

```

Ce script fait automatiquement :

✅ Provisionnement Terraform

✅ Récupération des IPs

✅ Génération de inventory.ini pour Ansible

✅ Configuration des serveurs via Ansible

✅ Déploiement des containers Docker

3️⃣ Accéder à l'API et à MLflow
API Swagger : http://<IP_API>:8000/docs

MLflow UI : http://<IP_MLFLOW>:5000

4️⃣ Tester l'API (exemple curl)
