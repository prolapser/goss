https://github.com/shadowsocks/go-shadowsocks2
### client

your have Outline/ShadowSocks URI like this:
`ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTozcFVSdVRVZi1sRmdnNXFXZzhldUZB@147.45.51.15:1080` =>

decode Base64: `Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTozcFVSdVRVZi1sRmdnNXFXZzhldUZB` => `chacha20-ietf-poly1305:3pURuTUf-lFgg5qWg8euFA`

cipher: `chacha20-ietf-poly1305`

password: `3pURuTUf-lFgg5qWg8euFA`

server ip_port: `147.45.51.15:1080`

free port on client for socks5-proxy: `49176`

[binary executable file](https://github.com/prolapser/goss/releases) (this app): `goss`

command:
```sh
goss -c 147.45.51.15:1080 -password 3pURuTUf-lFgg5qWg8euFA -cipher chacha20-ietf-poly1305 -socks :49176 -u -verbose
```
