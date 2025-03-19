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

### Tasks 1-3

https://ansible.puzzle.ch/docs/04/03/#task-1

[`04-output.yaml`](ansible/playbooks/04-output.yaml)

### Task 4

https://ansible.puzzle.ch/docs/04/03/#task-4-advanced

- Ensure `httpd` is stopped on the group `web` by using an Ansible ad hoc command.
```bash
ansible web -b -a "systemctl stop apache2"
```

[`04-servicehandler.yaml`](ansible/playbooks/04-servicehandler.yaml)

### Task 5

https://ansible.puzzle.ch/docs/04/03/#task-5-advanced

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

### Task 1

https://ansible.puzzle.ch/docs/04/04/#task-1
