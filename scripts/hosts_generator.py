#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
servers = {"bls": range(201, 209),
           "pa": range(151, 179)}
pre_servers = {"bls": range(53, 56),
               "pa": range(56, 62)}
int_servers = {"bls": range(41, 43),
               "pa": range(46, 48)}

dcs = {"1": "uk1",
       "2": "uk2",
       "3": "sg1",
       "4": "hk1"}

pre_dcs = {"2": "uk2"}
intrev_dcs = {"1": "uk1"}


def write(stuff, srv):
    if srv == pre_servers:
        rel = "pre"
        datacenters = pre_dcs
    elif srv == int_servers:
        rel = "int"
        datacenters = intrev_dcs
    else:
        rel = "pro"
        datacenters = dcs

    for i, dc in datacenters.items():
        for j, s_id in enumerate(srv[stuff], 1):
            line = '10.10{0}.192.{1} '.format(i, s_id) + '{3}-{0}-{2}{1}\n'.format(dc, j, stuff, rel)
            with open("/etc/hosts", "a") as fp:
                fp.write(line)

write("bls", servers)
write("pa", servers)
write("bls", pre_servers)
write("pa", pre_servers)
write("bls", int_servers)
write("pa", int_servers)
