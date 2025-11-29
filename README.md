# Ansible-in-Docker lab (1 master + 3 nodes)

Minimal repository to run an Ansible master in a container that manages three Ubuntu node containers over SSH.

## What is included
- `Dockerfile.master` — Ansible master (Ubuntu + Ansible + sshpass)
- `Dockerfile.node` — Managed node image (Ubuntu + openssh-server + user `ansible`)
- `docker-compose.yml` — Brings up 4 containers on a user-defined bridge network
- `hosts` & `ansible.cfg` — Inventory and config for the master (copied into the master image)
- `playbooks/site.yml` — Simple test playbook
- `scripts/setup-ssh-from-master.sh` — Convenience script to build, run and copy master's public key into nodes.

## Quick start (Linux / macOS)
1. Build & run:
   ```bash
   chmod +x scripts/setup-ssh-from-master.sh
   ./scripts/setup-ssh-from-master.sh
   ```
2. Enter master:
   ```bash
   docker exec -it ansible-master bash
   ```
3. Test Ansible connectivity:
   ```bash
   ansible all -m ping
   ```
4. Run the example playbook:
   ```bash
   ansible-playbook /ansible/playbooks/site.yml
   ```

## Notes & troubleshooting
- The node user is `ansible` with password `ansible`. You can change this in `Dockerfile.node`.
- `setup-ssh-from-master.sh` uses `sshpass` inside the master to copy keys. If your environment disallows ssh-copy-id you can run manual commands:
  ```bash
  docker exec -it ansible-master bash
  # inside master
  ssh-copy-id ansible@node1
  ```
- If `ansible all -m ping` fails, check:
  - Are containers running? `docker ps`
  - Is SSH listening inside each node? `docker logs node1`
  - Hostnames resolve within the Docker network (compose network provides DNS)

## License
MIT
