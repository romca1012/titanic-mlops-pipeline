from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import pandas as pd

app = FastAPI()

# Charger le modèle
with open('../models/model.pkl', 'rb') as f:
    model = joblib.load(f)

# Schéma des données entrantes
class Passenger(BaseModel):
    Pclass: int
    Sex: int     # 0 = male, 1 = female
    Age: float
    SibSp: int
    Parch: int

@app.post("/predict")
def predict_survival(passenger: Passenger):
    input_data = pd.DataFrame([{
        "Pclass": passenger.Pclass,
        "Sex": passenger.Sex,
        "Age": passenger.Age,
        "SibSp": passenger.SibSp,
        "Parch": passenger.Parch
    }])

    prediction = model.predict(input_data)[0]

    # Probabilité (optionnel)
    probability = None
    if hasattr(model, "predict_proba"):
        probability = model.predict_proba(input_data)[0][1]

    return {
        "prediction": int(prediction),
        "probability": round(float(probability), 3) if probability is not None else None
    }
