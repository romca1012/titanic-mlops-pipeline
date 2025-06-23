🚀 Titanic MLOps Pipeline - Projet DevOps / MLOps
🎯 Objectif
Développer et déployer une solution MLOps complète sur AWS :

API REST pour les prédictions

Instance training pour entraîner le modèle

Suivi des expériences avec MLflow

Automatisation avec :

Terraform / OpenTofu (infra)

Ansible (config / déploiement)

Docker (containerisation)

🖥️ Architecture

[ Client (curl / navigateur) ]
          |
    +-----------+
    | EC2 API   |  --->  uvicorn FastAPI  + Docker
    +-----------+         (port 8000)
          |
          V
[ EC2 MLflow + training ]  
    - MLflow tracking server (port 5000)  
    - Model registry  
    - Training pipeline (Python)  
Instances :

titanic-mlops-api : API REST (FastAPI, uvicorn)

mlflow-tracking-training : MLflow server + model training

🔨 Technologies
AWS EC2 (instances t3.small)

OpenTofu (Terraform)

Ansible

Docker & Docker Compose

FastAPI (API)

MLflow (tracking, registry)

scikit-learn (modèle ML)

Python 3.12

📁 Structure du projet

titanic-mlops-pipeline/
├── api/                 # API REST FastAPI
├── training/            # Code d'entraînement
├── data/                # Données d'entraînement (CSV)
├── infra/
│   ├── terraform/       # Terraform (OpenTofu)
│   └── ansible/         # Playbooks Ansible
├── docker-compose.yml   # Déploiement multi-container
└── README.md            # Documentation

🚀 Instructions de déploiement

1️⃣ Cloner le repo

git clone https://github.com/romca1012/titanic-mlops-pipeline.git
cd titanic-mlops-pipeline


2️⃣ Provisionner l'infra (AWS)
remplir ces infos de connexions dans le fichier terraform.tfvars et dans _credentials/mlops-key.pem
./launch.sh
➡️ Ce script fait automatiquement :
✅ Provisionnement Terraform
✅ Génération des IPs
✅ Génération du inventory.ini pour Ansible
✅ Configuration Ansible
✅ Déploiement Docker

3️⃣ Accéder aux interfaces
API (FastAPI / Swagger) :
http:// <IP-API> :8000/docs

MLflow Tracking UI :
http:// <IP-MLFLOW> :5000

4️⃣ Tester l'API (exemple curl) (si besoin ou faire directement les tests via l api)
curl -X POST http:// <IP-API>:8000 /predict \
-H "Content-Type: application/json" \
-d '{"Pclass": 3, "Sex": 1, "Age": 22, "Fare": 7.25, "SibSp": 1, "Parch": 0}'


5️⃣ Connexion SSH aux machines (optionnel)
# API instance
ssh -i infra/terraform/_credentials/mlops-key.pem ubuntu@ <IP-API> 

# MLflow + training instance
ssh -i infra/terraform/_credentials/mlops-key.pem ubuntu@ <IP-MLFLOW> 

6️⃣ Vérification des containers (optionnel)

docker ps -a
Logs de l'API :

docker logs titanic-mlops-pipeline-titanic-mlops-api-1
Logs MLflow :

docker logs titanic-mlops-pipeline-mlflow-tracking-1
🧑‍🏫 Ce qu'il faut faire manuellement ✅
✅ Une fois le déploiement terminé :

1️⃣ Se connecter en SSH sur l'API : (optionnel)

ssh -i infra/terraform/_credentials/mlops-key.pem ubuntu@ <IP-API> 

2️⃣ Tester l'API avec curl ou navigateur :
http:// <IP-API>:8000 /docs

3️⃣ Vérifier le suivi des modèles sur MLflow UI :
http://<IP-MLFLOW>:5000
