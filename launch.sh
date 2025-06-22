#!/bin/bash

set -e

# Chemin vers la clé SSH
SSH_KEY="infra/terraform/_credentials/mlops-key.pem"

# 1 - Provisioning de l'infra
echo "🚀 1/5 - Provisioning de l'infrastructure avec OpenTofu..."
cd infra/terraform
tofu init
tofu apply -auto-approve

# 2 - Extraction des IPs
API_IP=$(tofu output -raw api_mlops_ip)
MLFLOW_IP=$(tofu output -raw mlflow_tracking_training_ip)

echo "✅ IP API : $API_IP"
echo "✅ IP MLFLOW : $MLFLOW_IP"

cd ../..

# 3 - Génération inventory.ini
echo "🚀 2/5 - Génération du fichier inventory.ini pour Ansible..."
cat <<EOF > infra/ansible/inventory.ini
[mlflow_tracking_training]
$MLFLOW_IP ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY

[api_mlops]
$API_IP ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY
EOF

echo "✅ inventory.ini mis à jour :"
cat infra/ansible/inventory.ini

# 4 - Attente automatique SSH ready
echo "⏳ 3/5 - Attente que les instances EC2 soient prêtes pour SSH..."

# Petite fonction d'attente
wait_for_ssh() {
    IP=$1
    echo "⏳ Attente SSH pour $IP ..."
    while ! ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i "$SSH_KEY" ubuntu@"$IP" 'echo "SSH OK"' 2>/dev/null; do
        echo "🔄 ... toujours en attente pour $IP ..."
        sleep 5
    done
    echo "✅ SSH OK pour $IP"
}

# Appel de la fonction pour chaque IP
wait_for_ssh $API_IP
wait_for_ssh $MLFLOW_IP

# 5 - Run Ansible
echo "🚀 4/5 - Configuration des instances avec Ansible..."
ansible-playbook -i infra/ansible/inventory.ini infra/ansible/site.yml

echo "🚀 5/5 - Déploiement terminé 🎉"
