#! /usr/bin/env python

import os
import sys
import time
import logging
import yaml
import digitalocean

DROPLETS = []
DIGITAL_OCEAN_TOKEN = os.getenv('DIGITAL_OCEAN_TOKEN')
DEFAULT_SIZE = 's-1vcpu-1gb'

def read_config():
    with open('hosts.yml') as file:
        data = yaml.load(file, Loader=yaml.FullLoader)

        droplets = []

        try:
            for name, attributes in data['all']['children']['digitalocean']['hosts'].items():
                droplets.append({'name': name, 'size': attributes['size'],
                                 'tags': [attributes['type']]})
        except AttributeError as e:
            logging.warning('Received %s, no hosts available' % e)
            droplets = []

    return droplets


def read_secrets():
    digital_ocean_token = input("DIGITAL OCEAN TOKEN: ")
    if digital_ocean_token and len(digital_ocean_token) > 0:
        print("First five characters of token entered are %s" % digital_ocean_token[0:5])

    return digital_ocean_token


def droplet_manager_api():
    manager = digitalocean.Manager(token=DIGITAL_OCEAN_TOKEN)

    return manager


def droplet_droplet_api(name, size=DEFAULT_SIZE, tags=[]):
    keys = droplet_manager_api().get_all_sshkeys()

    with open(sys.argv[1], 'r') as f:
        user_data = f.read()
    logging.warning('Adding user data...\n %s' % user_data)

    droplet = digitalocean.Droplet(token=DIGITAL_OCEAN_TOKEN,
                                   name=name,
                                   region='nyc3',  # New York 3
                                   image='ubuntu-20-04-x64',  # Ubuntu 20.04 x64
                                   size_slug=size,
                                   backups=False,
                                   ssh_keys=keys,
                                   private_networking=True,
                                   monitoring=True,
                                   ipv6=False,
                                   user_data=user_data,
                                   tags=tags)

    droplet.create()
    return droplet


def get_current_droplets_api():
    current_droplets_api_list = droplet_manager_api().get_all_droplets()

    return current_droplets_api_list


def droplet_dict(current_droplets_api, full_dict=False):
    droplet_list = []
    for droplet in current_droplets_api:
        if full_dict:
            droplet = {'name': droplet.name, 'size': droplet.size_slug, 'tags':
                       droplet.tags,
                       'id': droplet.id}
        else:
            droplet = {'name': droplet.name, 'size': droplet.size_slug,
                       'tags': droplet.tags}
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
                logging.warning("Shutting down: %s because it doesn\'t exist in current list" % droplet['name'])
                drop = droplet_manager_api().get_droplet(dictionary['id'])
                if drop.status != 'shutdown' and drop.status != 'errored':
                    #if droplet isn't shutdown, shut it down
                    res = drop.shutdown()
                if delete:
                    #if droplet is shutdown, destroy it
                    res = drop.destroy()
                    if res:
                        logging.warning('Droplet is deleted')


def create_droplet(list_to_create):
    for droplet in list_to_create:
        logging.warning("Creating: %s because it doesn\'t exist in current list" % droplet['name'])
        drop = droplet_droplet_api(droplet['name'], droplet['size'],
                                   droplet['tags'])
        actions = drop.get_actions()
        for action in actions:
            while action.status == 'in-progress':
                action.load()
                if action.status == 'completed':
                    logging.warning('Droplet creation %s' % action.status)
                    break
                logging.warning('Droplet creation %s' % action.status)
                time.sleep(5)

        new_drop = droplet_manager_api().get_droplet(drop.id)
        logging.warning('Droplet IP address: %s' % new_drop.ip_address)

if __name__ == '__main__':
    DROPLETS = read_config()
    DIGITAL_OCEAN_TOKEN = read_secrets()
    create = should_create_droplet(droplet_dict(get_current_droplets_api()), DROPLETS)
    print(create)
    shutdown = should_shutdown_droplet(droplet_dict(get_current_droplets_api()), DROPLETS)
    if create:
        logging.warning('Creating the following resources...%s' % [x for x in
                                                                     create])
        input("Press Enter/Return to continue...")
        create_droplet(create)
    if shutdown:
        logging.warning('Deleting the following resources...%s' % [x for x in
                                                                   shutdown])
        input("Press Enter/Return to continue...")
        shutdown_droplet(shutdown, delete=True)
    else:
        logging.info('Existing Droplets:')
        for droplet in get_current_droplets_api():
            logging.info('Name: %s, id: %s' % (droplet.name,
                  droplet.id))
        logging.info("Nothing to create!")
