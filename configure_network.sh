#!/usr/bin/env bash
set -euo pipefail

JUMP_HOST="rnp@gruppe02.rnp.lab.nm.ifi.lmu.de"

ssh -t "${JUMP_HOST}" 'bash -s' << 'OUTER_EOF'
set -euo pipefail

# -------------------------------------------------------------
# router1
# -------------------------------------------------------------
echo "==> [Intermediate] Connecting to router1..."
ssh -q -T root@router1 sh << 'INNER_EOF_ROUTER1'
set -euo pipefail

echo "==> Configuring router1..."
for iface in eth1 eth2 eth3 eth4; do
  ip link set "${iface}" up
  ip address flush dev "${iface}"
done

ip address replace 10.2.1.1/24 dev eth1
ip address replace 10.2.0.0/31 dev eth2
ip address replace 10.2.0.2/31 dev eth3
ip address replace 10.2.0.4/31 dev eth4

ip -brief address show | grep -E 'eth(1|2|3|4)'
INNER_EOF_ROUTER1

echo "==> Finished router1. Back on intermediate host."

# -------------------------------------------------------------
# router2 
# -------------------------------------------------------------
echo "==> [Intermediate] Connecting to router2..."
ssh -q -T root@router2 sh<< 'INNER_EOF_ROUTER2'
set -euo pipefail

echo "==> Configuring router2..."
for iface in eth1 eth2 eth3 eth4; do
  ip link set "${iface}" up
  ip address flush dev "${iface}"
done

ip address replace 10.2.2.1/24 dev eth1
ip address replace 10.2.0.3/31 dev eth2
ip address replace 10.2.0.6/31 dev eth3
ip address replace 10.2.0.8/31 dev eth4

ip -brief address show | grep -E 'eth(1|2|3|4)'
INNER_EOF_ROUTER2

echo "==> Finished router2. Back on intermediate host."

# -------------------------------------------------------------
# router3
# -------------------------------------------------------------
echo "==> [Intermediate] Connecting to router3..."
ssh -q -T root@router3 sh << 'INNER_EOF_ROUTER3'
set -euo pipefail

echo "==> Configuring router3..."
for iface in eth1 eth2 eth3 eth4; do
  ip link set "${iface}" up
  ip address flush dev "${iface}"
done

ip address replace 10.2.3.1/24 dev eth1
ip address replace 10.2.0.1/31 dev eth2
ip address replace 10.2.0.7/31 dev eth3
ip address replace 10.2.0.10/31 dev eth4

ip -brief address show | grep -E 'eth(1|2|3|4)'
INNER_EOF_ROUTER3

echo "==> Finished router3. Back on intermediate host."

# -------------------------------------------------------------
# router4
# -------------------------------------------------------------
echo "==> [Intermediate] Connecting to router4..."
ssh -q -T root@router4 sh << 'INNER_EOF_ROUTER4'
set -eu

echo "==> Configuring router4..."
for iface in eth1 eth2 eth3; do
  ip link set "${iface}" up
  ip address flush dev "${iface}"
done

ip address replace 10.2.0.5/31 dev eth1
ip address replace 10.2.0.11/31 dev eth2
ip address replace 10.2.0.9/31 dev eth3

ip -brief address show | grep -E 'eth(1|2|3)'
INNER_EOF_ROUTER4

echo "==> Finished router4. Back on intermediate host."

# -------------------------------------------------------------
# pc1
# -------------------------------------------------------------
echo "==> [Intermediate] Connecting to pc1..."
ssh -q -T root@pc1 sh << 'INNER_EOF_PC1'
set -eu

echo "==> Configuring pc1..."
ip link set eth1 up
ip address flush dev eth1 

ip address replace 10.2.1.2/24 dev eth1

ip -brief address show eth1
INNER_EOF_PC1

echo "==> Finished pc1. Back on intermediate host."

# -------------------------------------------------------------
# pc2
# -------------------------------------------------------------
echo "==> [Intermediate] Connecting to pc2..."
ssh -q -T root@pc2 sh << 'INNER_EOF_PC2'
set -eu

echo "==> Configuring pc2..."
ip link set eth1 up
ip address flush dev eth1 

ip address replace 10.2.2.2/24 dev eth1

ip -brief address show eth1
INNER_EOF_PC2

echo "==> Finished pc2. Back on intermediate host."

# -------------------------------------------------------------
# pc3
# -------------------------------------------------------------
echo "==> [Intermediate] Connecting to pc3..."
ssh -q -T root@pc3 sh << 'INNER_EOF_PC3'
set -eu

echo "==> Configuring pc3..."
ip link set eth1 up
ip address flush dev eth1 

ip address replace 10.2.3.2/24 dev eth1

ip -brief address show eth1
INNER_EOF_PC3

echo "==> Finished pc3. Back on intermediate host."
echo "==> All configirations done!"
OUTER_EOF
