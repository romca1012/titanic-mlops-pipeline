# titanic-mlops-pipeline
FR : Pipeline MLOps complète sur le dataset Titanic : préparation des données, entraînement, suivi MLflow, packaging Docker, API REST, déploiement auto avec Terraform et Ansible. Projet end-to-end.  
EN : Full MLOps pipeline on Titanic: data prep, training, MLflow tracking, Docker, REST API, auto-deploy with Terraform &amp; Ansible. End-to-end project.

## Training the model

Run the training script to generate `models/model.pkl` and MLflow logs:

```bash
python training/train.py
```

The script expects the dataset in `data/train.csv`. During training MLflow creates a tracking directory named `mlruns/`, which is ignored in version control.
