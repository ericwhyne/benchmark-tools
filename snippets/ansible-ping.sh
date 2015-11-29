#!/bin/bash
ansible -i sl.hosts all -u root -m ping
