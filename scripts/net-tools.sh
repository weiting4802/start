#!/bin/bash

sudo apt update

sudo apt install -y \
  dnsutils \
  iputils-ping \
  net-tools \
  iproute2 \
  traceroute \
  mtr \
  nmap \
  tcpdump \
  whois \
  curl \
  wget \
  bind9-host \
  resolvconf \
  netcat \
  lsof \
  conntrack \
  ebtables \
  arptables \
  ethtool

echo "all tools is installed"
