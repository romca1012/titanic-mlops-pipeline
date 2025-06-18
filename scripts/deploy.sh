#!/usr/bin/env bash
set -e

# 0. Région et profil AWS
export AWS_DEFAULT_REGION=us-east-1

export AWS_PROFILE=default

# 1. Vérifier prérequis
for cmd in aws terraform ansible-playbook ssh-keygen; do
  if ! command -v "$cmd" >/dev/null; then
    echo "Erreur : la commande '$cmd' est introuvable."
    exit 1
  fi
done

# 2. Chemins credentials & clé SSH
CRED_DIR="$(dirname "$0")/../infra/credentials"
AWS_CREDS="$CRED_DIR/aws_credentials"
SSH_KEY="$CRED_DIR/my-key.pem"
SSH_PUB="$CRED_DIR/my-key.pub"

[[ -r "$AWS_CREDS" ]] || { echo "Fichier AWS introuvable : $AWS_CREDS"; exit 1; }
[[ -f "$SSH_KEY" ]]   || { echo "Clé SSH introuvable : $SSH_KEY"; exit 1; }
chmod 400 "$SSH_KEY"

export AWS_SHARED_CREDENTIALS_FILE="$AWS_CREDS"
export ANSIBLE_PRIVATE_KEY_FILE="$SSH_KEY"

# 3. Importer la clé SSH si besoin
if ! aws ec2 describe-key-pairs --key-names my-key \
     --region "$AWS_DEFAULT_REGION" >/dev/null 2>&1; then
  echo "Import de la clé 'my-key' dans AWS (${AWS_DEFAULT_REGION})…"
  ssh-keygen -y -f "$SSH_KEY" > "$SSH_PUB"
  aws ec2 import-key-pair \
    --key-name my-key \
    --public-key-material fileb://"$SSH_PUB" \
    --region "$AWS_DEFAULT_REGION"
  echo "Clé importée."
else
  echo "La clé 'my-key' existe déjà en ${AWS_DEFAULT_REGION}."
fi

# 4. Terraform
cd "$(dirname "$0")/../infra"
terraform init
terraform apply -auto-approve

# 5. Récupérer IPs
TRAIN_IP=$(terraform output -raw training_ip)
API_IP=$(terraform output -raw api_ip)

# 6. Inventaire Ansible
INV_FILE="$(dirname "$0")/../ansible/inventory.ini"
cat > "$INV_FILE" <<EOF
[training]
training ansible_host=$TRAIN_IP ansible_user=ubuntu ansible_ssh_private_key_file=$ANSIBLE_PRIVATE_KEY_FILE

[api]
api      ansible_host=$API_IP  ansible_user=ubuntu ansible_ssh_private_key_file=$ANSIBLE_PRIVATE_KEY_FILE

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF

# 7. Playbook Ansible
cd "$(dirname "$0")/../ansible"
ansible-playbook -i inventory.ini playbook.yml

# 8. Fin
echo "Déploiement terminé !"
echo "API      : http://$API_IP:8000/predict"
echo "MLflow UI: http://$TRAIN_IP:5000"
