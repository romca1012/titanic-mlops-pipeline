# training/train.py

import pandas as pd
import numpy as np
import mlflow
import mlflow.sklearn
import os
import pickle
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

DATA_PATH = "./data/train.csv"
MODEL_PATH = "./models/model.pkl"

def preprocess(df):
    # Delete missing value
    df['Age'].fillna(df['Age'].median(), inplace=True)
    
    # Encode Sex male 0 female 1
    df['Sex'] = df['Sex'].map({'male': 0, 'female': 1}).astype(int)
    
    return df

def main():
    print("Loading data...")
    df = pd.read_csv(DATA_PATH)
    df = preprocess(df)

    features = ['Pclass', 'Sex', 'Age', 'SibSp', 'Parch']
    X = df[features]
    y = df['Survived']

    print(" Split data...")
    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    print(" Starting MLflow run...")
    mlflow.set_experiment("titanic-mlops")
    with mlflow.start_run():
        clf = RandomForestClassifier(
            n_estimators=100,
            max_depth=5,
            random_state=42
        )
        
        clf.fit(X_train, y_train)
        y_pred = clf.predict(X_val)
        acc = accuracy_score(y_val, y_pred)

        print(f"Accuracy on validation set: {acc:.4f}")

        mlflow.log_param("n_estimators", 100)
        mlflow.log_param("max_depth", 5)
        mlflow.log_metric("accuracy", acc)
        mlflow.sklearn.log_model(clf, "model")

        print("Saving model...")
        os.makedirs(os.path.dirname(MODEL_PATH), exist_ok=True)
        with open(MODEL_PATH, "wb") as f:
            pickle.dump(clf, f)

        print("Training complete. Model saved to models/model.pkl")

if __name__ == "__main__":
    main()
