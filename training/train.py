# training/train.py

import pandas as pd
import numpy as np
import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

DATA_PATH = "./data/train.csv"

def preprocess(df):
    # Remplacer les valeurs manquantes
    df['Age'].fillna(df['Age'].median(), inplace=True)
    # Encoder le sexe
    df['Sex'] = df['Sex'].map({'male': 0, 'female': 1}).astype(int)
    return df

def main():


    print("🚀 Setting MLflow Tracking URI...")
    mlflow.set_tracking_uri("http://mlflow-tracking:5000")
    mlflow.set_experiment("titanic-mlops")

    
    print(" Loading data...")
    df = pd.read_csv(DATA_PATH)
    df = preprocess(df)

    features = ['Pclass', 'Sex', 'Age', 'SibSp', 'Parch']
    X = df[features]
    y = df['Survived']

    print(" Splitting data...")
    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    # print(" Starting MLflow run...")
    # mlflow.set_tracking_uri("http://mlflow-tracking:5000")
    # mlflow.set_experiment("titanic-mlops")
    with mlflow.start_run() as run:
        clf = RandomForestClassifier(
            n_estimators=100,
            max_depth=5,
            random_state=42
        )
        
        clf.fit(X_train, y_train)
        y_pred = clf.predict(X_val)
        acc = accuracy_score(y_val, y_pred)

        print(f" Accuracy on validation set: {acc:.4f}")

        mlflow.log_param("n_estimators", 100)
        mlflow.log_param("max_depth", 5)
        mlflow.log_metric("accuracy", acc)

        print(" Logging model...")
        mlflow.sklearn.log_model(clf, "model")

        print("Registering model in MLflow Registry...")
        mlflow.register_model(
            f"runs:/{run.info.run_id}/model",
            "titanic-mlops-registry"
        )

        print("Training complete. Model registered in MLflow Registry.")

if __name__ == "__main__":
    main()