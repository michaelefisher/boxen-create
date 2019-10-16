#! /usr/bin/env python

import os
import configparser
import digitalocean

DROPLETS = []


def read_config():
    config = configparser.ConfigParser()
    config.read('hosts')
    for key in config['do']:
        key_name = key.split(' ')[0]
        droplet = {'name': key_name}
        DROPLETS.append(droplet)

def droplet_manager_api():
    manager = digitalocean.Manager(token=os.getenv('DIGITAL_OCEAN_TOKEN'))

    return manager


def droplet_droplet_api(name):
    keys = droplet_manager_api().get_all_sshkeys()

    droplet = digitalocean.Droplet(token=os.getenv('DIGITAL_OCEAN_TOKEN'),
                                   name=name,
                                   region='nyc2',  # New York 2
                                   image='ubuntu-18-04-x64',  # Ubuntu 14.04 x64
                                   size_slug='4gb',
                                   backups=True,
                                   ssh_keys=keys,
                                   private_networking=True,
                                   monitoring=True,
                                   ipv6=True)

    return droplet


def get_current_droplets_api():
    current_droplets_api_list = droplet_manager_api().get_all_droplets()

    return current_droplets_api_list


def droplet_dict(current_droplets_api, full_dict=False):
    droplet_list = []
    for droplet in current_droplets_api:
        if full_dict:
            droplet = {'name': droplet.name, 'id': droplet.id}
        else:
            droplet = {'name': droplet.name}
        droplet_list.append(droplet)

    return droplet_list


def should_create_droplet(remote_droplet_list, local_droplets_list):
    list_to_create = [i for i in local_droplets_list if i not in remote_droplet_list]
    return list_to_create


def should_shutdown_droplet(remote_droplet_list, local_droplets_list):
    list_to_shutdown = [i for i in remote_droplet_list if i not in local_droplets_list]
    return list_to_shutdown


def shutdown_droplet(list_to_shutdown, delete=False):
    full_list = droplet_dict(get_current_droplets_api(), full_dict=True)
    for droplet in list_to_shutdown:
        for dictionary in full_list:
            if droplet['name'] == dictionary['name']:
                print("Shutting down: %s because it doesn\'t exist in current list" % droplet['name'])
                droplet_manager_api().get_droplet(dictionary['id']).shutdown()
                if delete:
                    droplet_manager_api().get_droplet(dictionary['id']).destroy()


def create_droplet(list_to_create):
    for droplet in list_to_create:
        print("Creating: %s because it doesn\'t exist in current list" % droplet['name'])
        droplet_droplet_api(droplet['name']).create()


if __name__ == '__main__':
    read_config()
    create = should_create_droplet(droplet_dict(get_current_droplets_api()), DROPLETS)
    shutdown = should_shutdown_droplet(droplet_dict(get_current_droplets_api()), DROPLETS)
    if create:
        create_droplet(create)
    elif shutdown:
        shutdown_droplet(shutdown, delete=True)
    else:
        print("Nothing to create!")
