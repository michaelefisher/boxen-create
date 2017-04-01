# boxen-create

## macOS > 10.5

```
$ make macos
```

Make sure to install MacPorts by hand. It is easier: https://www.macports.org

Bit of PATH changing:
```
$ export PATH=/opt/local/bin:/opt/local/sbin:$PATH
```

## Ubuntu 16.04 using provider VirtualBox

Sets up a basic computing environment in Ubuntu 16.04. Uses Vagrant shell and ansible provisioning to:

1. Clone repos you need
2. Install powerline shell
3. Install python (with pip)
4. Install Vagrant (and VirtualBox) inside of your VM -- VMs in VMs!

The first thing the Vagrantfile does is create a director to sync data from. You don't want to sync the directory you are in, there's vagrant files in there.

You will also want to modify line 52, substituting in your data folder. Also make sure to add your private and public key path under the ssh settings.

Memory for the box can be adjusted on line 73.

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
