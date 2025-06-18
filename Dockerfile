# Utiliser une image Python officielle légère
FROM python:3.12-slim

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires
COPY api/app.py /app/api/app.py
COPY models/model.pkl /app/models/model.pkl
COPY requirements.txt /app/requirements.txt

# Installer les dépendances
RUN pip install --no-cache-dir -r /app/requirements.txt

# Exposer le port utilisé par Uvicorn
EXPOSE 8000

# Lancer Uvicorn au démarrage du conteneur
CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8000"]
