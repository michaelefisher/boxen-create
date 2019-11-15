# boxen-create

## Provisioning

```
$ TAGS=[tags] ./provision.sh --limit [list of machines or groups]

```
Ansible will ask for your `become` password -- that is, a password for the `ansible_user` that is in the `sudoers` group on the remote machine.

### Example Run

```
$ TAGS=appstore ./provision.sh --limit local
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
