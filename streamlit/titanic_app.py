import streamlit as st
import requests

# Config de la page
st.set_page_config(page_title="Titanic Predictor", page_icon="🚢")

# Titre de l'appli
st.title("🎫 Titanic Survivor Predictor")
st.subheader("🌊 Serais-tu restée à bord ou montée dans un canot ?")

# Description
st.markdown("Remplis les informations ci-dessous pour estimer tes chances de survie à bord du Titanic.")

# Formulaire avec les 5 paramètres
pclass = st.selectbox("🛏️ Classe du billet", [1, 2, 3], format_func=lambda x: f"{x}ère classe" if x == 1 else f"{x}ème classe")
# Encode le sexe en int
sex = st.radio("👤 Sexe", ["female", "male"])
sex_encoded = 1 if sex == "female" else 0

age = st.slider("🎂 Âge", min_value=0, max_value=100, value=25)
sibsp = st.number_input("🧒 Nombre de frères/sœurs/conjoint(s)", min_value=0, max_value=10, step=1)
parch = st.number_input("👪 Nombre de parents/enfants", min_value=0, max_value=10, step=1)

# Quand on clique sur "Prédire"
if st.button("🚀 Prédire ma survie"):
    # Données envoyées à l'API
    payload = {
        "Pclass": pclass,
        "Sex": sex_encoded-,
        "Age": age,
        "SibSp": sibsp,
        "Parch": parch
    }

    try:
        # Appel à l'API (doit tourner sur localhost:8000)
        response = requests.post("http://localhost:8000/predict", json=payload)

        if response.status_code == 200:
            prediction = response.json()["prediction"]
            prob = response.json().get("probability", None)

            if prediction == 1:
                st.success("🎉 Tu aurais **survécu** ! Le destin était avec toi !")
            else:
                st.error("💀 Tu n’aurais **pas survécu**... mais au moins t'étais bien habillée.")

            if prob is not None:
                st.info(f"🧮 Probabilité estimée : **{prob * 100:.1f}%**")
        else:
            st.warning("⚠️ Une erreur s’est produite lors de la prédiction. Vérifie que l’API fonctionne.")
    except Exception as e:
        st.error(f"Erreur de connexion à l'API : {e}")
