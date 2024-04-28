# ovpn-clientmanager

### What do I need?
1. A working OpenVPN Docker Installation of https://hub.docker.com/r/kylemanna/openvpn
2. OpenVPN Docker Data at /opt/openvpn (-v /opt/openvpn:/etc/openvpn)
3. The /opt/openvpn/clients folder (you can also put your script there)
4. Sudo and Docker Privileges on your system

### How to Install
Just download the file straight from the main branch and run it on your OpenVPN Server.

It will work as a normal user with sudo privileges but wont be able to put your configurations into /opt/openvpn/clients

```
wget https://raw.githubusercontent.com/freddy1301/ovpn-clientmanager/main/clients.sh && chmod +x clients.sh && ./clients.sh
```
