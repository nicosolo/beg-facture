FROM certbot/dns-cloudflare:latest

# Install additional DNS plugins if needed
# Common plugins: dns-route53, dns-google, dns-digitalocean, dns-ovh
# Uncomment the one you need:
# RUN pip install certbot-dns-route53
# RUN pip install certbot-dns-google
# RUN pip install certbot-dns-digitalocean
# RUN pip install certbot-dns-ovh

# Install Infomaniak DNS plugin
# https://github.com/Infomaniak/certbot-dns-infomaniak
ENTRYPOINT ["certbot"]