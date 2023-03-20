# Mullvad VPN UFW Killswitch

As I use this a lot, I decided I should make a primitive bash script for
setting up a killswitch using UFW and OpenVPN w/ Mullvad VPN.

Decided to upload it here as a mirror for when I deploy new VMs with it.


## Prerequisites

Debian/ Ubuntu based Linux disto with bash for the shell.

Download the Mullvad VPN OpenVPN conf
[here](https://mullvad.net/en/account/#/openvpn-config).

Update the `user config variables` region inside of 'setup.bash'to match
your LAN subnet, and the VPN port, protocol and IPs (last three found in the
Mullvad conf file).


## Use

Run the setup as root:

```bash
chmod +x setup.bash && sudo ./setup.bash
```

Test the UFW killswitch rules:

```bash
# Outputs -> ping: gnu.org: Temporary failure in name resolution -> working.
sudo service openvpn stop && ping gnu.org && sudo service openvpn start
```
