# api/app.py

from fastapi import FastAPI
from pydantic import BaseModel
import mlflow
import mlflow.sklearn
import numpy as np
from typing import Dict

# URL de tracking
MLFLOW_TRACKING_URI = "http://mlflow-tracking:5000"

# Nom du modèle dans le Registry
MODEL_NAME = "titanic-mlops-registry"

# On initialise MLflow
mlflow.set_tracking_uri(MLFLOW_TRACKING_URI)

# Créer l'API
app = FastAPI(title="Titanic Survival Probability API")

# Définir le format d'entrée attendu
class Passenger(BaseModel):
    Pclass: int
    Sex: int
    Age: float
    SibSp: int
    Parch: int

# Charger le modèle au démarrage de l'API
@app.on_event("startup")
def load_model():
    global model
    try:
        print("🚀 Loading model from MLflow Registry...")
        model = mlflow.sklearn.load_model(f"models:/{MODEL_NAME}/latest")
        print("✅ Model loaded successfully.")
    except Exception as e:
        print(f"❌ Failed to load model: {e}")
        model = None

# Endpoint de prédiction
@app.post("/predict", response_model=Dict[str, float])
def predict(passenger: Passenger):
    if model is None:
        return {"error": "Model not loaded. Please train a model first."}
    
    data = np.array([[passenger.Pclass, passenger.Sex, passenger.Age,
                      passenger.SibSp, passenger.Parch]])
    
    probability = model.predict_proba(data)[0][1]  # proba de survie (classe 1)
    
    return {"probability_survival": round(probability, 4)}
