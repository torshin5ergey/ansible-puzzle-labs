# ansible.puzzle.ch labs

My solutions to [Ansible Puzzle labs](https://ansible.puzzle.ch/) with VirtualBox and Terraform

## 1. Setting up Ansible

https://ansible.puzzle.ch/docs/01/

### Task 1

- Install Ansible on controller (localhost)
```bash
sudo apt update && sudo apt install ansible -y
```

### Task 3

- Ping hosts
```bash
ansible all:!controller -i inventory/hosts.ini -m ping
```

### Task 5

[`hosts.ini`](ansible/inventory/hosts.ini)

## 2. Documentation

https://ansible.puzzle.ch/docs/02/

### Task 1

- List all ansible modules
```bash
ansible-doc --list
```

## 3. Setup and Ad Hoc Commands

https://ansible.puzzle.ch/docs/03/

### Task 1

- Ping all `nodes` with `ansible.builtin.ping`
```bash
ansible nodes -i inventory/hosts.ini -m ping
```

### Task 2

- Gather all facts from `nodes`
```bash
ansible nodes -i inventory/hosts.ini -m gather_facts
# or
ansible nodes -i inventory/hosts.ini -m setup
```
- Gather only `ansible_default_ipv4` fact from all `nodes`
```bash
ansible nodes -i inventory/hosts.ini -m setup -a "filter=ansible_default_ipv4"
```

### Tasks 3-4

- Find module with `hostname`
```bash
ansible-doc -l | grep hostname
ansible-doc -s hostname
```

### Task 5

- Setup `hostname` on all hosts using the inventory
```bash
ansible nodes -i inventory/hosts.ini -b -m hostname -a "name={{ inventory_hostname }}"
ansible nodes -i inventory/hosts.ini -a "cat /etc/hostname"
```

### Task 6

- Install `apache2` on `web`
```bash
ansible web inventory/hosts.ini -b -m apt -a "name=apache2 state=installed"
```
- Start and enable `apache2`
```bash
ansible web inventory/hosts.ini -b -m systemd -a "name=apache2 state=started enabled=true"
```
- Revert changes
```bash
ansible web -i inventory/hosts.ini -b -m systemd -a "name=apache2 state=stopped enabled=false"
ansible web -i inventory/hosts.ini -b -m apt -a "name=apache2 state=absent"
```

### Task 7

- Create file `/etc/ansible/testfile.txt` on `ap-worker-node2`
```bash
ansible ap-worker-node2 -i inventory/hosts.ini -m file -a "path=/home/ansible/testfile.txt state=touch"
```
- Paste custom test into the file using `copy` module
```bash
ansible ap-worker-node2 -i inventory/hosts.ini -m copy -a "dest=/home/ansible/testfile.txt content='custom text'"
```
- Remove the file
```bash
ansible ap-worker-node2 -i inventory/hosts.ini -m file -a "path=/home/ansible/testfile.txt state=absent"
```

## 4. Ansible Playbooks - Basics

https://ansible.puzzle.ch/docs/04/

### Tasks 1

[`04-webserver.yaml`](ansible/playbooks/04-webserver.yaml)

### Task 2

- Create user config file
```bash
echo "[defaults]\ninventory = /home/ansible/techlab/inventory/hosts" > ansible.cfg
```

### Task 4

[`04-tempfolder.yaml`](ansible/playbooks/04-tempfolder.yaml)

## 4.1 Ansible Playbooks - Variables and Loops

https://ansible.puzzle.ch/docs/04/01/

### Tasks 1-2

[`04-webserver.yaml`](ansible/playbooks/04-webserver.yaml)

### Task 3-5

[`04-motd.yaml`](ansible/playbooks/04-motd.yaml)

- Set variable via command line
```bash
ansible-playbook playbooks/04-motd.yaml --extra-vars motd_content="new text\n"
```
- Play playbook and limit nodes to `ap-worker-node1` and `ap-worker-node2`
```bash
ansible-playbook playbooks/04-motd.yaml -l ap-worker-node1,ap-worker-node2
```

### Task 7

[`04-takemehome.yaml`](ansible/playbooks/04-takemehome.yaml)

## 4.2 Ansible Playbooks - Templates

https://ansible.puzzle.ch/docs/04/02/

### Task 1-2

- [`04-motd.yaml`](ansible/playbooks/04-motd.yaml)
- [`motd.j2`](ansible/playbooks/motd.j2)

### Task 3

- [`04-userplay.yaml`](ansible/playbooks/04-userplay.yaml)
- [`userplay.j2`](ansible/playbooks/userplay.j2)

### Task 4

- [`04-serverinfo.yaml`](ansible/playbooks/04-serverinfo.yaml)
- [`serverinfo.j2`](ansible/playbooks/serverinfo.j2)

## 4.3 Ansible Playbooks - Output

https://ansible.puzzle.ch/docs/04/03/

### Tasks 1-3

[`04-output.yaml`](ansible/playbooks/04-output.yaml)

### Task 4

- Ensure `httpd` is stopped on the group `web` by using an Ansible ad hoc command.
```bash
ansible web -b -a "systemctl stop apache2"
```

[`04-servicehandler.yaml`](ansible/playbooks/04-servicehandler.yaml)

### Task 5

- By using an ansible ad hoc command, place an invalid configuration file `/etc/httpd/conf/httpd.conf` and backup the file before. Use the `ansible.builtin.copy` module to do this in ad hoc command.
[ansible.builtin.copy](https://docs.ansible.com/ansible/2.9/modules/copy_module.html#copy-module)
```bash
ansible web -b -m copy -a "content='invalid config' dest=/etc/apache2/apache2.conf backup=true"
```

- Restart `httpd` by using an Ansible ad hoc command. This should fail since the config file is not valid.
```bash
ansible web -b -m systemd -a "name=apache2 state=restarted"
```

[`04-servicehandler.yaml`](ansible/playbooks/04-servicehandler.yaml)

## 4.4. Ansible-Pull

https://ansible.puzzle.ch/docs/04/04/

### Task 2

[`04-install-ansible-pull.yaml`](ansible/playbooks/04-install-ansible-pull.yaml)

- Use an ansible-pull command that uses the resources in the folder resources/ansible-pull/ of our GitHub repository located at https://github.com/puzzle/ansible-techlab. Apply the playbook local.yml located at the resource/ansible-pull folder and run it on all hosts in the inventory file hosts
```bash
ansible-pull --url https://github.com/puzzle/ansible-techlab -i resources/ansible-pull/hosts resources/ansible-pull/local.yml
```
- Show the content of /etc/motd and verify, that the file was copied using ansible-pull
```bash
cat /etc/motd
```
- Also verify, that no content of the git repository was copied to the local folder.
```bash
ls -l
```

### Task 3

- Cron job
```
# /etc/cron.d/ansible-pull
* * * * * vagrant ansible-pull -U https://github.com/puzzle/ansible-techlab -i resources/ansible-pull/hosts resources/ansible-pull/local.yml
```
- Command `watch` to show the content of `/etc/motd` every second
```bash
watch -n 1 cat /etc/motd
```

### Task 4

[`04-revert_motd.yaml`](ansible/playbooks/04-revert_motd.yaml)

## 4.5 Task control

https://ansible.puzzle.ch/docs/04/05/

### Task 1

- Write an ad-hoc command that sleeps for 1000 seconds and runs on `node1`. Ensure that the command times out after 10 seconds if not completed by then.
```bash
ansible ap-worker-node1 -B 10 -a "sleep 1000"
```
- Use the `time` command to see how long your ad-hoc command had to run. Use `man time` to see how `time` works.
```bash
# -B, --background run asynchronously, failing after N seconds
time ansible ap-worker-node1 -B 10 -a "sleep 1000"
```
- Now add a polling interval of 30 seconds. Run the task, and ensure with the `time` command, that it had a longer runtime.
```bash
# -P, --poll poll interval for background tasks
time ansible ap-worker-node1 -B 10 -P 30 -a "sleep 1000"
```

### Tasks 2-3

[`04-async.yaml`](ansible/playbooks/04-async.yaml)

## 5. Ansible Roles - Basics

https://ansible.puzzle.ch/docs/05/

### Task 1

[`ansible.cfg`](ansible/ansible.cfg)

### Task 2

[`roles/apache2/`](ansible/roles/apache2/)
```
roles/apache2
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml #
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

### Task 3

[`05-webserver.yaml`](ansible/playbooks/05-webserver.yaml)

### Task 4

- [`05-prod.yaml`](ansible/playbooks/05-prod.yaml)
- [`roles/base/`](ansible/roles/base/)
```
roles/base
├── defaults
│   └── main.yml #
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   ├── main.yml #
│   ├── motd.yaml #
│   └── packages.yaml #
├── templates
│   └── motd.j2 #
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

### Task 5

- [`05-prod.yaml`](ansible/playbooks/05-prod.yaml)
- [`roles/base/`](ansible/roles/base/)
```
roles/base
├── defaults
│   └── main.yml #
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml #
├── README.md
├── tasks
│   ├── main.yml #
│   ├── motd.yaml #
│   └── packages.yaml #
├── templates
│   └── motd.j2 #
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

## 5.1 Ansible Roles - Handlers and Blocks

https://ansible.puzzle.ch/docs/05/01/

### Tasks 1

- [`05-myhandler.yaml`](ansible/playbooks/05-myhandler.yaml)
- [`roles/handlerrole/`](ansible/roles/handlerrole/)
```
roles/handlerrole
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml #
├── meta
│   └── main.yml
├── README.md
├── tasks
│   ├── main.yml #
│   └── timestamp.yaml #
├── templates
│   └── readme.j2 #
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml
```

### Task 2

- [`05-download.yaml`](ansible/playbooks/05-download.yaml)
- [`roles/downloader/`](ansible/roles/downloader/)
roles/downloader
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   ├── downloadfile.yaml #
│   └── main.yml #
├── templates
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml

## 6. Managing Secrets with Ansible Vault

https://ansible.puzzle.ch/docs/06/

### Task 1

- [`06-secretservice.yaml`](ansible/playbooks/06-secretservice.yaml)
- [`mi6.j2`](ansible/playbooks/mi6.j2)
- Check
```bash
ansible nodes -a "cat /etc/MI6"
```

### Task 2

- [`06-secretservice.yaml`](ansible/playbooks/06-secretservice.yaml)
- [`secret_vars.yaml`](ansible/playbooks/secret_vars.yaml)
- [`mi6.j2`](ansible/playbooks/mi6.j2)

### Task 3

- Encrypt the `secret_vars.yaml` file by using `ansible-vault` with the password *goldfinger*.
```bash
ansible-vault encrypt playbooks/secret_vars.yaml
# New Vault password:
# Confirm New Vault password:
```
- Rerun the playbook providing the password for decrypting `secret_vars.yaml` at the command prompt.
```bash
ansible-playbook playbooks/06-secretservice.yaml --ask-vault-pass
```
- Rerun the playbook providing the password for decrypting `secret_vars.yaml` from the file `vaultpassword`.
[`vaultpassword`](ansible/vaultpassword)
```bash
# decrypt
ansible-vault decrypt playbooks/secret_vars.yaml

# encrypt with vault id
ansible-vault encrypt playbooks/secret_vars.yaml --vault-id vaultpassword
# run with vault id
ansible-playbook playbooks/06-secretservice.yaml --vault-id vaultpassword
```

### Task 4

[`ansible.cfg`](ansible/ansible.cfg)

### Task 5

- Decrypt the file `secret_vars.yaml`.
```bash
ansible-vault decrypt playbooks/secret_vars.yaml
# Decryption successful
```
- Encrypt the values of the variables `username` and `password` and put them into the `secret_vars.yaml` file.
```bash
ansible-vault encrypt_string jamesbond -n var_username
# Encryption successful
ansible-vault encrypt_string miss_moneypenny -n var_password
# Encryption successful

ansible-playbook playbooks/06-secretservice.yaml
```
[`secret_vars.yaml`](ansible/playbooks/secret_vars.yaml)

### Task 6

- Remove the `/etc/MI6` file on the nodes using an ad hoc command.
```bash
ansible nodes -b -a "rm /etc/MI6"
# or
ansible nodes -b -m file -a "path=/etc/MI6 state=absent"
```

### Task 7

- Encrypt another file `secret_vars2.yaml`. Ensure it is encrypted with your vault password file `vaultpassword`
```bash
ansible-vault encrypt playbooks/secret_vars2.yaml
```
[`secret_vars2.yaml`](ansible/playbooks/secret_vars2.yaml)
- Change the encryption of the file: encrypt it with another password provided at the command line.
```bash
ansible-vault rekey playbooks/secret_vars2.yaml --new-vault-id @prompt
# New vault password (default): test
# Confirm new vault password (default): test
# Rekey successful

# Test
ansible-vault decrypt playbooks/secret_vars2.yaml --output - --vault-id @prompt
# or
ansible-vault view playbooks/secret_vars2.yaml --vault-id @prompt

# Vault password (default): test
# ---
# var_username: jamesbond
# var_password: miss_moneypenny
```

### Task 8

- Avoid to print out sensitive data at runtime with `no_log: true`
[`06-secretservice.yaml`](ansible/playbooks/06-secretservice.yaml)

## 7. Ansible Galaxy and more

https://ansible.puzzle.ch/docs/07/

### Task 1

- Search the Ansible Galaxy for a nginx role.
https://galaxy.ansible.com/ui/
```bash
ansible-galaxy search nginx | grep nginxinc
```
- Install such a nginx role using `ansible-galaxy`.
```bash
ansible-galaxy install nginxinc.nginx
```
- Create a tar.gz file nginx.tar.gz with the content of the role using an Ansible ad hoc command.
```bash
ansible controller -m archive -a "path=$HOME/ansible-puzzle-labs/ansible/roles/nginxinc.nginx dest=$HOME/ansible-puzzle-labs/ansible/nginx.tar.gz"
```

### Task 2

- Remove the nginx role using `ansible-galaxy`.
```bash
ansible-galaxy remove nginxinc.nginx
```
- [`07-requirements.yaml`](ansible/roles/07-requirements.yaml)
- Install the role by using an appropriate `ansible-galaxy` command and the `requirements.yml` file.
```bash
ansible-galaxy install -r roles/07-requirements.yaml
```
- Remove the role mynginx using `ansible-galaxy`.
```bash
ansible-galaxy remove mynginx
```
- Remove the file `nginx.tar.gz` and `roles/requirements.yml` by using an ad hoc command for each.
```bash
ansible controller -m file -a "path=$HOME/ansible-puzzle-labs/ansible/nginx.tar.gz state=absent"

ansible controller -m file -a "path=$HOME/ansible-puzzle-labs/ansible/roles/07-requirements.yaml state=absent"
```

## 8. Ansible Collections

https://ansible.puzzle.ch/docs/08/

### Task 1

- Create a collection with the `ansible-galaxy collection` command. Choose a namespace and a collection name of your liking.
```bash
ansible-galaxy collection init --init-path collections puzzle.mycollection
```
[`/collections/puzzle/mycollection/`](ansible/collections/puzzle/mycollection/)

### Task 2

- Build a collection from your newly initialized collection-skeleton. Have a close look at the name that was set.
```bash
ansible-galaxy collection build collections/puzzle/mycollection --output-path collections
```
- Change the namespace and collection name in the file `galaxy.yml` in the skeleton.
[`galaxy.yml`](ansible/collections/puzzle/mycollection/galaxy.yml)
- Rebuild the collection and see the new name.
```bash
ansible-galaxy collection build collections/puzzle/mycollection --output-path collections
```

### Task 3

- Install one of your newly built collections from the `tar.gz` file. See where it was installed.
```bash
ansible-galaxy collection install collections/puzzle-mycollection-1.0.0.tar.gz
# ...
# Installing 'puzzle.mycollection:1.0.0' to '/home/sergey/.ansible/collections/ansible_collections/puzzle/mycollection'
# ...
```
- Change the ansible configuration so that the collection gets installed at `/home/ansible/techlab/collections`.
[`ansible.cfg`](ansible/ansible.cfg) `collections_paths`

### Task 4

- Use `ansible-config dump` to see what default galaxy server is configured
```bash
ansible-config dump
# ...
# GALAXY_SERVER_LIST(default) = None
# ...
```
- Add another galaxy server to your `GALAXY_SERVER_LIST`. This entry can point to a nonexistent galaxy server.
[`ansible.cfg`](ansible/ansible.cfg) `server_list`
- Set it explicitly to galaxy.ansible.com in the `ansible.cfg` file, even though this is the default value.
[`ansible.cfg`](ansible/ansible.cfg) `[galaxy_server.mygalaxyserver]`

### Task 5

- Install the collection `nginxinc.nginx_controller` using the `ansible-galaxy` command.
```bash
ansible-galaxy collection install nginxinc.nginx_controller
```
- Write a requirements file `requirements.yml` that ensures the collection `cloud` from `cloudscale_ch` is installed. Install the collection by using this requirements file.
[`08-requirements.yaml`](ansible/collections/08-requirements.yaml)
```bash
ansible-galaxy collection install --requirements-file collections/08-requirements.yaml
```

### Task 6

- Install the collection podman from namespace containers using any of the methods you know.
```bash
ansible-galaxy collection install containers.podman --force
```
- Write a playbook `collection.yml`
[`08-collection.yaml`](ansible/playbooks/08-collection.yaml)
```bash
ansible-playbook playbooks/08-collection.yaml --ask-become-pass

sudo podman ps
```

### Task 7

- Remove podman with an ad-hoc command to not interfere with the next labs.
```bash
ansible controller -b -m apt -a "name=podman state=absent purge=true autoremove=true" --ask-become-pass
```

## 9.1 AWX / Ascender / AAP / Installation

https://ansible.puzzle.ch/docs/09/01/

### Task 1

- Ascender https://github.com/ctrliq/ascender-install:
  - install with `ascender-install` script
  - available without subscription
- AAP (Ansible Automation Platform) https://access.redhat.com/documentation/en-us/red_hat_ansible_automation_platform/:
  - install with RPM
  - only available when you have valid subscription

### Tasks 2-3

https://ansible-community.github.io/awx-operator-helm/

```bash
helm repo add awx-operator https://ansible-community.github.io/awx-operator-helm/

kubectl apply -f awx/00-namespace.yaml

helm install awx-operator awx-operator/awx-operator -n awx

mkdir /mnt/awx-storage
chown -R 26:26 /mnt/awx-storage
chmod -R 750 /mnt/awx-storage

kubectl apply -f awx/
kubectl get pods -n awx
```

### Task 4

```bash
kubectl get svc ansible-awx-service -n awx

# <minikube ip>:<nodeport>

# username admin
# password
kubectl get secret ansible-awx-admin-password -o jsonpath="{.data.password}" -n awx | base64 --decode ; echo
```

## 10. Ansible-Navigator

https://ansible.puzzle.ch/docs/10/

### Task 1

https://ansible.readthedocs.io/projects/navigator/installation/
```bash
# Ready to run
ansible-navigator
```

### Task 2

- [`ansible.cfg`](ansible/ansible.cfg)
https://ansible.readthedocs.io/projects/navigator/settings/#the-ansible-navigator-settings-file
- [`ansible-navigator.yaml`](ansible/ansible-navigator.yaml)

## 11. Event Driven Ansible
