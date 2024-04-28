#!/bin/bash

container="<YOUR OpenVPN CONTAINER NAME>"

echo " "

jp2a --color https://raw.githubusercontent.com/freddy1301/ovpn-clientmanager/main/openvpn_logo.png

echo " "

echo "Registered Clients:"

sudo docker exec -it $container ovpn_listclients

echo " "

while true; do
    echo "1) Add a new Client"
    echo "2) Revoke a Client"
    echo "3) Export a Client Configuration"
    echo "0) Exit"

    read option

    case $option in
        1)
            echo "Client Name:"
            read client_name
            echo " "
            
            echo "Generating Client Certifcate (You need to enter you root_ca privatkey passphrase)"
            sudo docker run -v /opt/openvpn:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $client_name nopass
            echo "Exporting Client Configuration File to /opt/openvpn/clients/xxx"
            sudo docker exec $container ovpn_getclient $client_name > /opt/openvpn/clients/$client_name.ovpn
            
            unset client_name
            exit 0
            ;;
        2)
            echo "Client Name:"
            read client_name
            echo " "

            sudo docker exec -it $container ovpn_revokeclient $client_name

            echo "Looking for leftover Client Configurations..."
            files=$(find / -type f -name "$client_name.ovpn" 2>/dev/null)

            if [ -z "$files" ]; then
                echo "No files named '$client_name.ovpn' have been found."
                exit 0
            fi

            echo "Following files have been found:"
            echo "$files"
            echo

            read -p "Do you want do delete them? (Y/N): " answer

            if [ "$answer" == "Y" ]; then
                echo "Deleting files..."
                echo "$files" | xargs rm -f
                echo "Files deleted!"
            else
                echo "No files have been deleted!"
            fi

            unset client_name
            exit 0
            ;;
        3)
            echo "Client Name:"
            read client_name
            echo " "

            sudo docker exec $container ovpn_getclient $client_name > $client_name.ovpn

            echo " "
            echo "File exported! ($client_name.ovpn)"
            echo " "

            unset client_name
            exit 0
            ;;
        0)
            echo "Exiting.."
            exit 0
            ;;
        *)
            echo "Unknown option. Please try again"
            ;;
    esac
done
