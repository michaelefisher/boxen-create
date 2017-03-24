# vagrant-setup

Sets up a basic computing environment in Ubuntu 16.04. Uses Vagrant shell and ansible provisioning to:

1. Clone repos you need
2. Install powerline shell
3. Install rvm
4. Install python (with pip)
5. Install Vagrant (and VirtualBox) inside of your VM -- VMs in VMs!

To run:

```
$ make vagrant
```

To slay drags:

```
$ make destroy
```

You made some changes to provisioning and want to re-run:

```
$ make provision
```
