glusterfs-keepalived
=========================

Start glusterfs and keepalived in the same machine. Modify configure in conf/base.conf such as `VIPADDR`(virtual IP Address), `C?_IP` and `C*_ROUTE` to conform with your environment.

Here is my environment

```
IFACE=eth0
IFACE_GUEST=eth10
IFACE_CONTAINER=eth10
VIPADDR=192.168.80.220
IMAGE=dorowu/glusterfs-keepalived
REPLICA=2

C1_NAME=gk1
C1_IP=192.168.80.221/23
C1_ROUTE=192.168.80.254

C2_NAME=gk2
C2_IP=192.168.80.225/23
C2_ROUTE=192.168.80.254
```

Run both containers and start volume

```
$ bin/glusterfs-keepalived start-containers
50b127fdfbdb3a442faf3c5e3d3f5d4e581570f89c5d6ebf29028b3ca0ea106b
8f5203ddf3e9592ea8416033d92ea6249d91ee27a311a451a2a73da6f7a52168
$ bin/glusterfs-keepalived start-volume
peer probe: success: on localhost not needed
peer probe: success
volume create: volume1: failed: Host 192.168.80.225 is not in 'Peer in Cluster' state
volume set: success
volume set: success
volume set: success
volume set: success
volume start: volume1: success
```

Check the result

```
$ bin/glusterfs-keepalived status
Image: dorowu/glusterfs-keepalived
Host Network Interface: eth0
VIP: 192.168.80.220
Container: gk1
  Network: 192.168.80.221/23 via 192.168.80.254
  Created: true
  Running: true
  ID: 50b127fdfbdb3a442faf3c5e3d3f5d4e581570f89c5d6ebf29028b3ca0ea106b
  Process: glusterfs                        RUNNING    pid 13, uptime 0:05:49
  Process: keepalived                       RUNNING    pid 14, uptime 0:05:49
  Keepalived State: MASTER
Container: gk2
  Network: 192.168.80.225/23 via 192.168.80.254
  Created: true
  Running: true
  ID: 8f5203ddf3e9592ea8416033d92ea6249d91ee27a311a451a2a73da6f7a52168
  Process: glusterfs                        RUNNING    pid 12, uptime 0:05:48
  Process: keepalived                       RUNNING    pid 13, uptime 0:05:48
  Keepalived State: BACKUP
```

Because the container was configure to connect with macvlan, if you would like to mount glusterfs, you should run mount command in another computer by

```
$ sudo mount.glusterfs 192.168.80.220:volume1 mnt
```

failover test
-----------------------

Stop container, then you will see Keepalived State of gk2 is switching to MASTER

```
$bin/glusterfs-keepalived stop-container gk1
gk1
$ bin/glusterfs-keepalived status
Image: dorowu/glusterfs-keepalived
Host Network Interface: eth0
VIP: 192.168.80.220
Container: gk1
  Network: 192.168.80.221/23 via 192.168.80.254
  Created: true
  Running: false
Container: gk2
  Network: 192.168.80.225/23 via 192.168.80.254
  Created: true
  Running: true
  ID: 8f5203ddf3e9592ea8416033d92ea6249d91ee27a311a451a2a73da6f7a52168
  Process: glusterfs                        RUNNING    pid 12, uptime 0:09:07
  Process: keepalived                       RUNNING    pid 13, uptime 0:09:07
  Keepalived State: MASTER
```

Swtich to gk1 again
```
$ bin/glusterfs-keepalived start-container gk1
$ bin/glusterfs-keepalived stop-container gk2
$ bin/glusterfs-keepalived start-container gk1
$ bin/glusterfs-keepalived status
Image: dorowu/glusterfs-keepalived
Host Network Interface: eth0
VIP: 192.168.80.220
Container: gk1
  Network: 192.168.80.221/23 via 192.168.80.254
  Created: true
  Running: true
  ID: 50b127fdfbdb3a442faf3c5e3d3f5d4e581570f89c5d6ebf29028b3ca0ea106b
  Process: glusterfs                        RUNNING    pid 12, uptime 0:00:49
  Process: keepalived                       RUNNING    pid 13, uptime 0:00:49
  Keepalived State: MASTER
Container: gk2
  Network: 192.168.80.225/23 via 192.168.80.254
  Created: true
  Running: true
  ID: 8f5203ddf3e9592ea8416033d92ea6249d91ee27a311a451a2a73da6f7a52168
  Process: glusterfs                        RUNNING    pid 11, uptime 0:00:37
  Process: keepalived                       RUNNING    pid 12, uptime 0:00:37
  Keepalived State: BACKUP
```
