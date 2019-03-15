# copying via LAN

steps:
1. Set your computers
* IP address: 192.168.1.10
* netmark: 255.255.255.0
* gateway: 192.168.1.11
1. Set others computers
the above with "IP address" and "gateway" exchanged

On senders side:
run this in the terminal within the required directory `python3 -m http.server` or `python2 -m SimpleHTTPServer`

On receivers side:
run this in the terminal within the required directory `wget --recursive --no-parent --reject "index.html*" url`



