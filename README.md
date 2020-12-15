# boxen-create

## Provisioning

```
$ pipenv run ./main.yml -i hosts.yml -l [list of hosts]
```
- or -

```
$ TAGS=[tags] ./provision.sh --limit [list of hosts]
```
Ansible will ask for your `become` password -- that is, a password for the `ansible_user` that is in the `sudoers` group on the remote machine.

### Example Run

```
$ pipenv run ./main.yml -i hosts.yml -l [list of hosts]
BECOME password:

PLAY [all] *************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [dr-bunsen-honeydew]

TASK [Install Mac App Store updates] ***********************************************************************************
changed: [dr-bunsen-honeydew]

TASK [Print mas updates] ***********************************************************************************************
ok: [dr-bunsen-honeydew] => {
    "mas": {
        "changed": true,
        "cmd": [
            "mas",
            "upgrade"
        ],
        "delta": "0:00:00.058533",
        "end": "2019-11-15 10:11:46.950008",
        "failed": false,
        "rc": 0,
        "start": "2019-11-15 10:11:46.891475",
        "stderr": "",
        "stderr_lines": [],
        "stdout": "Everything is up-to-date",
        "stdout_lines": [
            "Everything is up-to-date"
        ]
    }
}

PLAY RECAP *************************************************************************************************************
dr-bunsen-honeydew         : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Adding SSL to webservers

If a droplet has a tag of webserver in `hosts`, then it will need SSL.
Everything is configured with one exception:

SSH into machine and run the following interactive command:
```
$ ssh website
$ sudo certbot --nginx -d <domain here> -d < another domain here>
```

Provided each hostname above has an authoritative DNS record pointing to the
droplet's IP, SSL certificate issuance should proceed.

#TODOs:
1. Automate issuance of SSL certificates
2. Better automatically configure HTTP 301 redirects in `nginx` configuration
3. Automate creation and maintenance of DigitalOcean firewalls
