#!/bin/bash

virt-install --connect qemu:///system --name=tester1 --ram=1536 --vcpus=1 --os-type=linux --os-variant=centos8 --disk path=/var/lib/libvirt/images/tester1-1.qcow2,size=16 --disk path=/var/lib/libvirt/images/tester1-2.qcow2,size=2 --disk path=/var/lib/libvirt/images/tester1-3.qcow2,size=2 --network network=insider --location=ftp://192.168.122.1/pub/inst --extra-args="ks=ftp://192.168.122.1/pub/ks.cfg" --extra-args="repo=ftp://192.168.122.1/pub/inst" --extra-args="ip=192.168.122.150::192.168.122.1:255.255.255.0:tester1.example.com:enp1s0:none" --extra-args="dns=192.168.122.1"
