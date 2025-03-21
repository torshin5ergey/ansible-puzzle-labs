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

[`roles/base/`](ansible/roles/base/)
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

[`roles/base/`](ansible/roles/base/)
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
