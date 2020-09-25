#make genconfig host=vpn.example.com
genconfig:
	docker-compose run --rm openvpn ovpn_genconfig -u udp://$(host)
	docker-compose run --rm openvpn touch /etc/openvpn/vars

initpki:
	docker-compose run --rm openvpn ovpn_initpki

#make new_cert username=test
new_cert:
	docker-compose run --rm openvpn easyrsa build-client-full $(username) nopass
	docker-compose run --rm openvpn ovpn_getclient $(username) > client_configs/$(username).ovpn
new: new_cert

#make revoke_cert username=test
revoke_cert:
	docker-compose run --rm openvpn ovpn_revokeclient $(username) remove
	rm client_configs/$(username).ovpn
revoke: revoke_cert

up:
	docker-compose up -d

ps:
	docker-compose ps

stop:
	docker-compose stop
st: stop
