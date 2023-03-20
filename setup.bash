#!/usr/bin/bash

# Ensure script is run as root.
if [[ $(whoami) != "root" ]]; then
  echo "Please run '$0' as root using sudo/doas"
  exit
fi

#region (user config variables)
mullvad_config_zip="mullvad_openvpn_linux_se_all.zip"
lan_subnet="192.168.0.0/24"
vpn_ips="
141.98.255.88
141.98.255.93
185.213.154.134
185.213.154.136
185.213.154.131
185.213.154.140
141.98.255.91
185.213.154.132
185.65.135.82
141.98.255.87
185.65.135.80
185.65.135.81
185.213.154.139 
185.65.135.83
185.213.154.137
185.213.154.138
141.98.255.85
141.98.255.92
185.213.154.133
185.213.154.141
141.98.255.90
141.98.255.86
141.98.255.83
185.213.154.135
45.83.220.92
141.98.255.84
193.138.218.132
45.83.220.90
193.138.218.131
141.98.255.89
"
vpn_port="1195"
vpn_proto="udp"
#endregion (user config variables)

function get_required_packages {
  apt-get update &&
  apt-get -y upgrade &&
  apt-get -y install $1
}

function ufw_set_rules {
  ufw disable
  ufw allow in to $1
  ufw allow out to $1
  ufw default deny outgoing
  ufw default deny incoming
  for ip in $2; do
    ufw allow out to $ip port $3 proto $4
  done
  ufw allow out on tun0 from any to any
  ufw allow in on tun0 from any to any
  ufw enable
}

function configure_openvpn {
  unzip -o $1 && mv mullvad_config*/mullvad_* /etc/openvpn/
  service openvpn start
}

required_pkgs="curl unzip openvpn ufw"

get_required_packages "$required_pkgs" &&
configure_openvpn $mullvad_config_zip &&
ufw_set_rules $lan_subnet "$vpn_ips" $vpn_port $vpn_proto &&

echo -e "\nAll done!\n"
curl "https://am.i.mullvad.net/connected"
