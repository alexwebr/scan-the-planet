#!/bin/sh

# Scan 1024 random hosts in parallel
./nmap -PN -d -T4 -F -A -oA "../data/test-data-%y-%m-%d-%H%M%S"  --log-errors --min-hostgroup 1024 -iR 1024

