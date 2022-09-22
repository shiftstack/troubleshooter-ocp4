# Machine config

> oc debug node/worker0 -- chroot /host touch /run/machine-config-daemon-force

## pause mcp

oc patch --type=merge --patch='{"spec":{"paused":true}}' machineconfigpool/master