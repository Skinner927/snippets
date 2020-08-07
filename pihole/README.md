# Pi-Hole

Installed Pi-Hole on dietpi. Install was standard, but there was one misconfig
that made it so visiting the IP directly would not show the redirect page
to login to the dashboard and blocked pages just showed blank pages.

## Wildcard DNS

Edit this for wildcard DNS: /etc/dnsmasq.d/05-my-dns.conf

If the file does not exist, create it. Filename doesn't actually matter
but `05` is the next highest unused number. It can be assumed our custom
DNS should likely be last.

```
# http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html
address=/dicker.home/192.168.10.10
host-record=emby.home,192.168.10.10
```
