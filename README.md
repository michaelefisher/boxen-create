# boxen-create

## Provisioning

```
$ ./provision.sh -h

Ansible provisioning wrapper

Usage:

./provision.sh -r main --tags $1 --limit $2

You can add multiple comma-separated tags and limits. Add a role using the -r or --roles flag.

Example:

./provision.sh -r main -t files -l kermit-the-frog
```


Ansible will ask for your `become` password -- that is, a password for the `ansible_user` that is in the `sudoers` group on the remote machine.

### Example Run

```
$ ./provision.sh -r main -t files -l cookie-monster
Running: main for tags=files, limit=cookie-monster
BECOME password:

PLAY [local] ****************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************
ok: [cookie-monster]

TASK [common : Install snaps] ***********************************************************************************
skipping: [cookie-monster]

TASK [common : delete things that we don't want] ****************************************************************
ok: [cookie-monster] => (item=.bashrc)
changed: [cookie-monster] => (item=.vim/)
changed: [cookie-monster] => (item=.vimrc)
ok: [cookie-monster] => (item=.npmrc)
changed: [cookie-monster] => (item=.gitignore)
changed: [cookie-monster] => (item=.gitconfig)
changed: [cookie-monster] => (item=.tmux.conf)
ok: [cookie-monster] => (item=.gitmodules)
changed: [cookie-monster] => (item=.gnupg/gpg.conf)
changed: [cookie-monster] => (item=.zshrc)
ok: [cookie-monster] => (item=/Users/michael/.oh-my-zsh/custom)

TASK [common : Make some dirs] **********************************************************************************
ok: [cookie-monster] => (item=/Users/michael/git)
changed: [cookie-monster] => (item=/Users/michael/.vim)
ok: [cookie-monster] => (item=/Users/michael/.gnupg)
ok: [cookie-monster] => (item=/opt/michael)
ok: [cookie-monster] => (item=/Users/michael/.config/pgcli)

TASK [common : Read encrypted ssh config] ***********************************************************************
ok: [cookie-monster]

TASK [common : Read in databases config] ************************************************************************
ok: [cookie-monster]

TASK [common : Read encrypted s3cfg] ****************************************************************************
ok: [cookie-monster]

TASK [common : Template out ssh config] *************************************************************************
ok: [cookie-monster]

TASK [common : Delete ssh known hosts] **************************************************************************
changed: [cookie-monster]

TASK [common : Template out s3cfg content] **********************************************************************
ok: [cookie-monster]

TASK [common : install oh-my-zsh] *******************************************************************************
ok: [cookie-monster]

TASK [common : Install powerlevel10k zsh theme] *****************************************************************
changed: [cookie-monster]

TASK [common : Symlink powerlevel10k into place] ****************************************************************
ok: [cookie-monster]

TASK [common : Install Tmux plugin manager] *********************************************************************
ok: [cookie-monster]

TASK [common : Template out home directory files] ***************************************************************
ok: [cookie-monster] => (item={'src': '.aliases.j2', 'dest': '/Users/michael/.aliases', 'owner': 'michael', 'mode': '0644'})
changed: [cookie-monster] => (item={'src': '.gitconfig.j2', 'dest': '/Users/michael/.gitconfig', 'owner': 'michael', 'mode': '0644'})
changed: [cookie-monster] => (item={'src': '.gitignore.j2', 'dest': '/Users/michael/.gitignore', 'owner': 'michael', 'mode': '0644'})
changed: [cookie-monster] => (item={'src': '.tmux.conf.j2', 'dest': '/Users/michael/.tmux.conf', 'owner': 'michael', 'mode': '0644'})
changed: [cookie-monster] => (item={'src': '.vimrc.j2', 'dest': '/Users/michael/.vimrc', 'owner': 'michael', 'mode': '0644'})
changed: [cookie-monster] => (item={'src': '.zshrc.j2', 'dest': '/Users/michael/.zshrc', 'owner': 'michael', 'mode': '0644'})
ok: [cookie-monster] => (item={'src': '.inputrc.j2', 'dest': '/Users/michael/.inputrc', 'owner': 'michael', 'mode': '0644'})
changed: [cookie-monster] => (item={'src': 'gpg.conf.j2', 'dest': '/Users/michael/.gnupg/gpg.conf', 'owner': 'michael', 'mode': '0644'})
ok: [cookie-monster] => (item={'src': 'install_nvm.sh.j2', 'dest': '/opt/michael/install_nvm.sh', 'owner': 'michael', 'mode': '0700'})
ok: [cookie-monster] => (item={'src': '.config/pgcli/config', 'dest': '/Users/michael/.config/pgcli/config', 'owner': 'michael', 'mode': '0644'})
ok: [cookie-monster] => (item={'src': '.ssh/rc.j2', 'dest': '/Users/michael/.ssh/rc', 'owner': 'michael', 'mode': '0644'})

TASK [common : Copy zshrc-mini into ~/Documents dir] ************************************************************
ok: [cookie-monster]

TASK [common : Copy into place .p10k file] **********************************************************************
ok: [cookie-monster]

TASK [common : Copy rmvim file into place] **********************************************************************
skipping: [cookie-monster]

TASK [common : Clone some repos] ********************************************************************************
ok: [cookie-monster] => (item={'org': 'powerline', 'name': 'fonts', 'version': 'HEAD'})

TASK [common : Install Vundle] **********************************************************************************
changed: [cookie-monster]

TASK [common : Install nvm] *************************************************************************************
ok: [cookie-monster]

TASK [common : Bundle some vundle (and other things)] ***********************************************************
changed: [cookie-monster]

TASK [common : Compile YouCompleteMe] ***************************************************************************
changed: [cookie-monster]

TASK [common : Write out POSIX-compatible .profile] *************************************************************
ok: [cookie-monster]

TASK [common : Install powerline shell fonts] *******************************************************************
changed: [cookie-monster]

PLAY RECAP ******************************************************************************************************
cookie-monster             : ok=23   changed=9    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

```

## Adding SSL to webservers

If a droplet has a tag of webserver in `hosts`, then it will need SSL.
Everything is configured with one exception:

SSH into machine and run the following interactive command:
```
$ ssh website
$ sudo certbot --nginx -d <domain here> -d <another domain here>
```

Provided each hostname above has an authoritative DNS record pointing to the
droplet's IP, SSL certificate issuance should proceed.

# TODOs
1. Automate issuance of SSL certificates
