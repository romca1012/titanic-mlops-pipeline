# api/app.py

from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import numpy as np
from typing import Dict

# Chemin vers le modèle
MODEL_PATH = "./models/model.pkl"

# Charger le modèle
with open(MODEL_PATH, "rb") as f:
    model = pickle.load(f)

# Créer l'API
app = FastAPI(title="Titanic Survival Probability API")

# Définir le format des entrées (JSON attendu)
class Passenger(BaseModel):
    Pclass: int
    Sex: int
    Age: float
    SibSp: int
    Parch: int

# Endpoint de prédiction
@app.post("/predict", response_model=Dict[str, float])
def predict(passenger: Passenger):
    data = np.array([[passenger.Pclass, passenger.Sex, passenger.Age,
                      passenger.SibSp, passenger.Parch]])
    
    probability = model.predict_proba(data)[0][1]  # proba de survie (classe 1)
    
    return {"probability_survival": round(probability, 4)}
