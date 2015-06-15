# Cuba skeleton

A cuba web template application.

## Development setup

### Provisioning

For running the project on the development environment we use vagrant.
Make sure you have VirtualBox, Vagrant and ansible installed.
* VirtualBox can be installed with [the intaller provided by the VirtualBox
website](https://www.virtualbox.org/wiki/Downloads).
* Vagrant can be installed with [the installer provided by the Vagrant
website](http://www.vagrantup.com/downloads.html)
* Ansible can be installed with brew: `brew install ansible` or by any other
  method [listed here](http://docs.ansible.com/intro_installation.html).

To setup the vagrant machine, first clone the repo, add the settings and then
run `vagrant up`:
```
$ git clone git@github.com:citrusbyte/cuba-skeleton
$ cd cuba-skeleton
$ cp ansible/group_vars/development.yml{.sample,}
$ vagrant up
```

Make sure no errors come up before proceeding.

You may now get into the VM by running `vagrant ssh`. Vagrant access the repo
from `/vagrant`. However, an easier way to start the server is with the
included script:
```
$ ./bin/start-server
```

### Installing new gems

Whenever new gems are added to the `ansible/roles/deploy/tasks/gems.yml` file,
you can update them inside the vagrant VM by running the provisioning:
```
$ vagrant provision
```

### Adding new settings

Whenever new setting variables are added, add them to the
`roles/deploy/templates/settings.json.j2` template as well as to the development
group vars (`group_vars/development.yml`). Also, remember to add them to the
group var sample files.

If necessary, add them as a constant on `config/settings.rb` to be used on the
ruby application.

You should now run the provisioning:
```
$ vagrant provision
```

## Staging/Production setup

### Provisioning

Once you have ansible, you can proceed to provision different Ubuntu hosts.

To do so, you first need to edit the inventory file on `ansible/` with the group
name (production or staging) and update the group with the list of hosts.
```
[staging]
staging1.staging.com
staging2.staging.com
staging3.staging.com
```

Update the group variables in case you need to do so under
`ansible/group_vars/` by using `ansible/group_vars/production.yml.sample` as
the sample:
```
$ cp ansible/group_vars/production.yml{.sample,}
$ ansible-vault encrypt ansible/group_vars/production.yml
$ ansible-vault edit ansible/group_vars/production.yml
```

Make sure you have the `~/.ssh/authorized_keys` file with your public key on the
root user first.

Also, make sure you add the public key from the config to the GitHub deploy
keys.

You should now run the provision playbook on production. Since we're using an
encrypted file as the group settings, you're going to be asked the password to
decrypt it.

```
$ make provision
```

### Deploying

To deploy to production:

```
$ make deploy
```

## About Citrusbyte

![Citrusbyte](http://i.imgur.com/W6eISI3.png)

This software is lovingly maintained and funded by Citrusbyte.
At Citrusbyte, we specialize in solving difficult computer science problems for startups and the enterprise.

At Citrusbyte we believe in and support open source software.
* Check out more of our open source software at Citrusbyte Labs.
* Learn more about [our work](https://citrusbyte.com/portfolio).
* [Hire us](https://citrusbyte.com/contact) to work on your project.
* [Want to join the team?](http://careers.citrusbyte.com)

*Citrusbyte and the Citrusbyte logo are trademarks or registered trademarks of Citrusbyte, LLC.*
