#!/usr/bin/env bash
set -euo pipefail

# This script must be run from the host and requires Docker and docker-compose to be installed.
# It builds and starts containers, then copies the master pubkey to the three nodes using sshpass inside the master.
#
# Usage: ./scripts/setup-ssh-from-master.sh

docker-compose up -d --build

echo "Waiting a few seconds for SSH services to come up..."
sleep 5

# copy master's public key into master container variable
PUBKEY=$(docker exec ansible-master cat /root/.ssh/id_rsa.pub)

for n in node1 node2 node3; do
  echo "Copying key to $n..."
  # Use sshpass from master to copy key to node (master can reach node hostnames via Docker network)
  docker exec ansible-master bash -lc "sshpass -p 'ansible' ssh-copy-id -o StrictHostKeyChecking=no ansible@${n} || true"
done

echo "Done. You can now 'docker exec -it ansible-master bash' and run: ansible all -m ping"
