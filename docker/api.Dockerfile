FROM python:3.12-slim
WORKDIR /app
COPY api/app.py ./api/app.py
COPY models/model.pkl ./models/model.pkl
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 8000
CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8000"]