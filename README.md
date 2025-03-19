# ansible.puzzle.ch labs

My solutions to [Ansible Puzzle labs](https://ansible.puzzle.ch/) with VirtualBox and Terraform

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

