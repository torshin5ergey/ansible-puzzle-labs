# ansible.puzzle.ch labs

My solutions to [Ansible Puzzle labs](https://ansible.puzzle.ch/) with VirtualBox and Terraform

- [1. Setting up Ansible](#1-setting-up-ansible)
  - [Task 1](#task-1)
  - [Task 3](#task-3)
  - [Task 5](#task-5)
- [2. Documentation](#2-documentation)
  - [Task 1](#task-1-1)
- [3. Setup and Ad Hoc Commands](#3-setup-and-ad-hoc-commands)
  - [Task 1](#task-1-2)
  - [Task 2](#task-2)
  - [Tasks 3-4](#tasks-3-4)
  - [Task 5](#task-5-1)
  - [Task 6](#task-6)
  - [Task 7](#task-7)
- [4. Ansible Playbooks - Basics](#4-ansible-playbooks---basics)
  - [Tasks 1](#tasks-1)
  - [Task 2](#task-2-1)
  - [Task 4](#task-4)
- [4.1. Ansible Playbooks - Variables and Loops](#41-ansible-playbooks---variables-and-loops)
  - [Tasks 1-2](#tasks-1-2)
  - [Task 3-5](#task-3-5)
  - [Task 7](#task-7-1)
- [4.2. Ansible Playbooks - Templates](#42-ansible-playbooks---templates)
  - [Task 1-2](#task-1-2)
  - [Task 3](#task-3-1)
  - [Task 4](#task-4-1)
- [4.3. Ansible Playbooks - Output](#43-ansible-playbooks---output)
  - [Tasks 1-3](#tasks-1-3)
  - [Task 4](#task-4-2)
  - [Task 5](#task-5-2)
- [4.4. Ansible-Pull](#44-ansible-pull)
  - [Task 2](#task-2-2)
  - [Task 3](#task-3-2)
  - [Task 4](#task-4-3)
- [4.5. Task control](#45-task-control)
  - [Task 1](#task-1-3)
  - [Tasks 2-3](#tasks-2-3)
- [5. Ansible Roles - Basics](#5-ansible-roles---basics)
  - [Task 1](#task-1-4)
  - [Task 2](#task-2-3)
  - [Task 3](#task-3-3)
  - [Task 4](#task-4-4)
  - [Task 5](#task-5-3)
- [5.1. Ansible Roles - Handlers and Blocks](#51-ansible-roles---handlers-and-blocks)
  - [Tasks 1](#tasks-1-1)
  - [Task 2](#task-2-4)
- [6. Managing Secrets with Ansible Vault](#6-managing-secrets-with-ansible-vault)
  - [Task 1](#task-1-5)
  - [Task 2](#task-2-5)
  - [Task 3](#task-3-4)
  - [Task 4](#task-4-5)
  - [Task 5](#task-5-4)
  - [Task 6](#task-6-1)
  - [Task 7](#task-7-2)
  - [Task 8](#task-8)
- [7. Ansible Galaxy and more](#7-ansible-galaxy-and-more)
  - [Task 1](#task-1-6)
  - [Task 2](#task-2-6)
- [8. Ansible Collections](#8-ansible-collections)
  - [Task 1](#task-1-7)
  - [Task 2](#task-2-7)
  - [Task 3](#task-3-5)
  - [Task 4](#task-4-6)
  - [Task 5](#task-5-5)
  - [Task 6](#task-6-2)
  - [Task 7](#task-7-3)
- [9.1. AWX / Ascender / AAP / Installation](#91-awx--ascender--aap--installation)
  - [Task 1](#task-1-8)
  - [Tasks 2-3](#tasks-2-3-1)
  - [Task 4](#task-4-7)
- [10. Ansible-Navigator](#10-ansible-navigator)
  - [Task 1](#task-1-9)
  - [Task 2](#task-2-8)
  - [Task 3](#task-3-6)
  - [Task 4](#task-4-8)
  - [Task 5](#task-5-6)
  - [Task 6](#task-6-3)
  - [Task 7](#task-7-4)
  - [Task 8](#task-8-1)
  - [Task 9](#task-9)
  - [Task 10](#task-10)
- [10.1. Ansible-Builder](#101-ansible-builder)
  - [Task 1](#task-1-10)
  - [Task 2](#task-2-9)
  - [Tasks 3-5](#tasks-3-5)
  - [Task 6](#task-6-4)
- [10.2. Ansible Runner](#102-ansible-runner)
  - [Task 1](#task-1-11)
  - [Task 2](#task-2-10)
  - [Task 3](#task-3-7)
  - [Task 4](#task-4-9)
- [11.1. Event Driven Ansible - Basics](#111-event-driven-ansible---basics)
  - [Task 1](#task-1-12)
  - [Task 2](#task-2-11)
  - [Task 3](#task-3-8)
  - [Task 4](#task-4-10)
  - [Task 5](#task-5-7)
  - [Task 6](#task-6-5)
  - [Task 7](#task-7-5)
- [11.2. Event Driven Ansible - Events and Facts](#112-event-driven-ansible---events-and-facts)
  - [Task 1](#task-1-13)
  - [Task 2](#task-2-12)


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
ansible all:!controller -i inventory/hosts -m ping
```

### Task 5

[`hosts`](ansible/inventory/hosts)

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
ansible nodes -i inventory/hosts -m ping
```

### Task 2

- Gather all facts from `nodes`
```bash
ansible nodes -i inventory/hosts -m gather_facts
# or
ansible nodes -i inventory/hosts -m setup
```
- Gather only `ansible_default_ipv4` fact from all `nodes`
```bash
ansible nodes -i inventory/hosts -m setup -a "filter=ansible_default_ipv4"
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
ansible nodes -i inventory/hosts -b -m hostname -a "name={{ inventory_hostname }}"
ansible nodes -i inventory/hosts -a "cat /etc/hostname"
```

### Task 6

- Install `apache2` on `web`
```bash
ansible web inventory/hosts -b -m apt -a "name=apache2 state=installed"
```
- Start and enable `apache2`
```bash
ansible web inventory/hosts -b -m systemd -a "name=apache2 state=started enabled=true"
```
- Revert changes
```bash
ansible web -i inventory/hosts -b -m systemd -a "name=apache2 state=stopped enabled=false"
ansible web -i inventory/hosts -b -m apt -a "name=apache2 state=absent"
```

### Task 7

- Create file `/etc/ansible/testfile.txt` on `ap-worker-node2`
```bash
ansible ap-worker-node2 -i inventory/hosts -m file -a "path=/home/ansible/testfile.txt state=touch"
```
- Paste custom test into the file using `copy` module
```bash
ansible ap-worker-node2 -i inventory/hosts -m copy -a "dest=/home/ansible/testfile.txt content='custom text'"
```
- Remove the file
```bash
ansible ap-worker-node2 -i inventory/hosts -m file -a "path=/home/ansible/testfile.txt state=absent"
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

## 4.1. Ansible Playbooks - Variables and Loops

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

## 4.2. Ansible Playbooks - Templates

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

## 4.3. Ansible Playbooks - Output

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

## 4.5. Task control

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

## 5.1. Ansible Roles - Handlers and Blocks

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

## 9.1. AWX / Ascender / AAP / Installation

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

### Task 3

[`10-site.yaml`](ansible/playbooks/10-site.yaml)

### Task 4

- Run the playbook `site.yml` by using ansible-navigator and the configuration from Task 2.
```bash
ansible-navigator
:run playbooks/10-site.yaml
# Or
ansible-navigator run playbooks/10-site.yaml
```
- While running the playbook, check in another terminal window if the container gets startet and stopped. You can do this by issuing `watch podman container list`.
```bash
watch docker ps
```

### Task 5

- After a successful run of your playbook, we play around with the TUI. Be sure to not let ansible-navigator run in interactive mode and not stdout mode (-m stdout). Since interactive is the default, you shouldn’t have any problems with that.
```bash
ansible-navigator run playbooks/10-site.yaml
# Or
ansible-navigator run playbooks/10-site.yaml -m interactive
```

### Task 6

- Use `ansible-navigator` to see the documentation of the `file` module.
```bash
ansible-navigator
:doc file
# Or
ansible-navigator doc file
```
- Use `ansible-navigator` to see the documentation of the `dig` lookup plugin.
```bash
ansible-navigator
:doc dig -t lookup
# Or
ansible-navigator doc dig -t lookup
```

### Task 7

- Use `ansible-navigator` to see the current inventory.
```bash
ansible-navigator
:inventory
# Or
ansible-navigator inventory
```

### Task 8

- Use `ansible-navigator` to see the current ansible configuration.
```bash
ansible-navigator
:config
# Or
ansible-navigator config
```

### Task 9

- Replay the run by using `ansible-navigator` with the corresponding option.
```bash
ansible-navigator replay artifacts/10-site-artifact...
```

### Task 10

- Use `ansible-navigator` to show all available collections.
```bash
ansible-navigator
:collections
# Or
ansible-navigator collections
```
## 10.1. Ansible-Builder

https://ansible.puzzle.ch/docs/10/01/

### Task 1

```bash
ansible-builder -h
```

### Task 2

- Create a playbook `container.yml` that installs `podman` and pulls the image `docker.io/bitnami/mariadb` on all `db` servers.
[`10-continer.yaml`](ansible/playbooks/10-container.yaml)
- Run this playbook and observe how it fails because the collection `containers.podman` is not available in the demo EE `ansible-navigator-demo-ee`.
```bash
ansible-navigator run playbooks/10-container.yaml
```

### Tasks 3-5

- [`10-default-ee.yaml`](ansible/10-default-ee.yaml)
- [`10-requirements.yaml`](ansible/10-requirements.yaml)
- [`10-requirements.txt`](ansible/10-requirements.txt)
```bash
ansible-builder build -f 10-default-ee.yaml -t default-ee -vvv

ansible-navigator images
```

### Task 6

- [`ansible-navigator.yaml`](ansible/ansible-navigator.yaml)
- [`10-container.yaml`](ansible/playbooks/10-container.yaml)

## 10.2. Ansible Runner

https://ansible.puzzle.ch/docs/10/02/

### Task 1

```bash
ansible-runner --version
ansible-runner --help
```

### Task 2

- Set up the folder structure needed by ansible-runner to find your inventory and put your playbook in the correct folder as well.
https://ansible.readthedocs.io/projects/runner/en/stable/intro/
```
.
...
├── inventory
│   └── hosts # without extension
└── project
    └── 10-site.yaml
...
```
- Use ansible-runner to run the play `site.yml`.
```bash
ansible-runner run . -p 10-site.yaml
```

### Task 3

- Runner artifacts directory
https://ansible.readthedocs.io/projects/runner/en/stable/intro/#runner-artifacts-directory-hierarchy
```
artifacts/
```

### Task 4

```
.
├── env
│   ├── settings
│   └── ssh_key
├── inventory
│   └── hosts
└── project
    └── 10-site.yaml
```

## 11.1. Event Driven Ansible - Basics

https://ansible.puzzle.ch/docs/11/01/

### Task 1

https://ansible.readthedocs.io/projects/rulebook/en/latest/rulebooks.html
```bash
python3 -m pip install ansible-rulebook

ansible-rulebook -h
```

### Task 2

- [`04-webserver.yaml`](ansible/playbooks/04-webserver.yaml)
```bash

```

### Task 3

- Write a rulebook `webserver_rulebook.yml`.
[`11-webserver_rulebook.yaml`](ansible/11-webserver_rulebook.yaml)
- Install `ansible.eda` collection.
```bash
ansible-galaxy collection install ansible.eda
```

### Task 4

- Start `webserver_rulebook.yml` in verbose mode.
```bash
ansible-rulebook --rulebook 11-webserver_rulebook.yaml -i inventory/hosts --verbose
```

### Task 5

- Write the rulebook `webhook_rulebook.yml` that opens a webhook on port 5000 of the control node `control0`.
[`11-webhook_rulebook.yaml`](ansible/11-webhook_rulebook.yaml)

### Task 6

- Run the rulebook webhook_rulebook.yml in verbose mode.
```bash
ansible-rulebook --rulebook 11-webhook_rulebook.yaml -i inventory/hosts --verbose
```
- Send the string “webservers running” to the webhook.
```bash
curl -H 'Content-Type: application/json' -d "{\"message\": \"webservers running\"}" 127.0.0.1:5000/endpoint
```
- Now send the message “webservers down” to the webhook. See how the playbook webserver.yml is run.
```bash
curl -H 'Content-Type: application/json' -d "{\"message\": \"webservers down\"}" 127.0.0.1:5000/endpoint
```

### Task 7

[`11-complex_rulebook.yaml`](ansible/11-complex_rulebook.yaml)
Run with
```bash
ansible-rulebook --rulebook 11-complex_rulebook.yaml -i inventory/hosts --verbose
```
Check with
```bash
curl -H 'Content-Type: application/json' -d "{\"message\": \"webservers down\"}" 127.0.0.1:5000/endpoint
```

## 11.2. Event Driven Ansible - Events and Facts

https://ansible.puzzle.ch/docs/11/02/

### Task 1

[`11-debug_event_rulebook.yaml`](ansible/11-debug_event_rulebook.yaml)
Run with
```bash
ansible-rulebook --rulebook 11-debug_event_rulebook.yaml -i inventory/hosts --verbose
# output
...
** 2025-03-26 22:01:37.247327 [debug] ********************************************
event: {'url_check': {'url': 'http://192.168.0.26', 'status': 'down', 'error_msg': "Cannot connect to host 192.168.0.26:80 ssl:default [Connect call failed ('192.168.0.26', 80)]"}, 'meta': {'source': {'name': 'Check webserver', 'type': 'ansible.eda.url_check'}, 'received_at': '2025-03-26T19:01:37.243178Z', 'uuid': 'b7fa6fe6-8e69-4fb8-8cd8-1fc9b7e7083c'}}
...
```

### Task 2

- [`11-debug_event_rulebook.yaml`](ansible/11-debug_event_rulebook.yaml)
- [`11-sos.yaml`](ansible/playbooks/11-sos.yaml)
- Run with
```bash
ansible-rulebook --rulebook 11-debug_event_rulebook.yaml -i inventory/hosts --verbose
```
- sosreports will be at `/tmp/` on node
