set -e

# 0. Charger les credentials AWS depuis infra/aws_credentials
export AWS_SHARED_CREDENTIALS_FILE="$(dirname "$0")/../infra/aws_credentials"

# 1. Terraform
cd "$(dirname "$0")/../infra"
terraform init
terraform apply -auto-approve

# 2. Récupérer les IPs
TRAIN_IP=$(terraform output -raw training_ip)
API_IP=$(terraform output -raw api_ip)

# 3. Générer inventory Ansible
cat > "$(dirname "$0")/../ansible/inventory.ini" <<EOF
[training]
training ansible_host=$TRAIN_IP ansible_user=ubuntu

[api]
api ansible_host=$API_IP ansible_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

# 4. Exécuter Ansible
cd "$(dirname "$0")/../ansible"
ansible-playbook -i inventory.ini playbook.yml

# 5. Résumé
echo "Déploiement terminé !"
echo "API: http://$API_IP:8000/predict"
echo "MLflow UI: http://$TRAIN_IP:5000"