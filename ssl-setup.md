# SSL Certificate Setup Guide

This guide explains how to set up SSL certificates using Let's Encrypt with DNS-01 challenge.

## Prerequisites

1. A domain name pointing to your server
2. Access to your DNS provider's API (for automated DNS-01 challenge)
3. Docker and Docker Compose installed

## Configuration Steps

### 1. Choose Your DNS Provider

The setup supports multiple DNS providers:
- Cloudflare (recommended)
- AWS Route53
- Google Cloud DNS
- DigitalOcean
- OVH
- Manual (for any provider)

### 2. Set Up DNS Provider Credentials

#### For Cloudflare:
1. Copy the example configuration:
   ```bash
   cp provision/certbot/cloudflare.ini.example provision/certbot/cloudflare.ini
   ```

2. Get your Cloudflare API token:
   - Go to https://dash.cloudflare.com/profile/api-tokens
   - Create a token with permissions:
     - Zone:DNS:Edit
     - Zone:Zone:Read

3. Edit `provision/certbot/cloudflare.ini` and add your token:
   ```ini
   dns_cloudflare_api_token = YOUR_API_TOKEN_HERE
   ```

#### For Other Providers:
Create the appropriate configuration file in `provision/certbot/`:
- AWS Route53: Uses IAM credentials (no file needed if using EC2 instance profile)
- Google: `google.json` with service account credentials
- DigitalOcean: `digitalocean.ini` with API token
- OVH: `ovh.ini` with application credentials

### 3. Set Environment Variables

Create or update your `.env` file:
```bash
# Required
DOMAIN_NAME=yourdomain.com
EMAIL=admin@yourdomain.com
DNS_PROVIDER=cloudflare  # or route53, google, digitalocean, ovh, manual

# Optional
STAGING=false  # Set to true for testing with Let's Encrypt staging
```

### 4. Initial Certificate Generation

```bash
# Start the services with SSL support
docker compose -f compose.yml -f compose.ssl.yml up -d

# Generate initial certificate
docker compose -f compose.yml -f compose.ssl.yml exec certbot sh -c "cd /etc/certbot && ./certbot-dns.sh init"
```

### 5. Verify Certificate

```bash
# Check certificate status
docker compose -f compose.yml -f compose.ssl.yml exec certbot sh -c "cd /etc/certbot && ./certbot-dns.sh status"
```

## Certificate Management

### Manual Renewal
```bash
docker compose -f compose.yml -f compose.ssl.yml exec certbot sh -c "cd /etc/certbot && ./certbot-dns.sh renew"
```

### Force Regeneration
```bash
docker compose -f compose.yml -f compose.ssl.yml exec certbot sh -c "cd /etc/certbot && ./certbot-dns.sh force"
```

### Automatic Renewal

The certbot container automatically checks for renewal every 12 hours. You can also set up a cron job on the host:

```bash
# Add to crontab (crontab -e)
0 2 * * * cd /path/to/beg-facture && docker compose -f compose.yml -f compose.ssl.yml exec -T certbot sh -c "cd /etc/certbot && ./certbot-dns.sh cron"
```

## Testing with Staging Environment

For testing, use Let's Encrypt's staging environment to avoid rate limits:

1. Set `STAGING=true` in your `.env` file
2. Generate a test certificate
3. Once everything works, set `STAGING=false` and regenerate

## Troubleshooting

### Certificate Not Found
- Ensure DNS records are properly configured
- Check DNS propagation: `dig _acme-challenge.yourdomain.com TXT`
- Verify API credentials are correct

### Rate Limits
- Let's Encrypt has rate limits (50 certificates per week per domain)
- Use staging environment for testing

### Permission Issues
- Ensure the certbot script is executable: `chmod +x provision/certbot/certbot-dns.sh`
- Check Docker volume permissions

## Security Notes

1. **Never commit credentials**: The `.gitignore` file excludes credential files
2. **Use API tokens** instead of global API keys when possible
3. **Restrict API token permissions** to minimum required
4. **Regular renewal**: Certificates expire after 90 days, renewal runs automatically

## Production Deployment

For production:
1. Use `compose.prod.yml` with `compose.ssl.yml`
2. Ensure firewall allows ports 80 and 443
3. Set up monitoring for certificate expiry
4. Configure backup of `/etc/letsencrypt` directory