#!/bin/bash

# Let's Encrypt SSL Certificate Management Script with DNS-01 Challenge
# This script handles initial certificate generation and renewal

set -e

# Configuration
DOMAIN_NAME=${DOMAIN_NAME:-"example.com"}
EMAIL=${EMAIL:-"admin@example.com"}
DNS_PROVIDER=${DNS_PROVIDER:-"cloudflare"}
STAGING=${STAGING:-"false"}

# Path configurations
LETSENCRYPT_DIR="/etc/letsencrypt"
CERTBOT_CONFIG_DIR="/etc/certbot"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_message() {
    echo -e "${2}${1}${NC}"
}

# Function to check if certificate exists
check_certificate() {
    if [ -f "${LETSENCRYPT_DIR}/live/${DOMAIN_NAME}/fullchain.pem" ]; then
        return 0
    else
        return 1
    fi
}

# Function to get certificate expiry
get_cert_expiry() {
    if check_certificate; then
        openssl x509 -enddate -noout -in "${LETSENCRYPT_DIR}/live/${DOMAIN_NAME}/fullchain.pem" | cut -d= -f2
    else
        echo "No certificate found"
    fi
}

# Function to check if renewal is needed (30 days before expiry)
needs_renewal() {
    if ! check_certificate; then
        return 0 # No cert, needs generation
    fi

    expiry_date=$(openssl x509 -enddate -noout -in "${LETSENCRYPT_DIR}/live/${DOMAIN_NAME}/fullchain.pem" | cut -d= -f2)
    expiry_epoch=$(date -d "${expiry_date}" +%s)
    current_epoch=$(date +%s)
    days_until_expiry=$(( (expiry_epoch - current_epoch) / 86400 ))

    if [ $days_until_expiry -lt 30 ]; then
        return 0 # Needs renewal
    else
        return 1 # Still valid
    fi
}

# Function to obtain certificate
obtain_certificate() {
    local staging_flag=""
    if [ "${STAGING}" = "true" ]; then
        staging_flag="--staging"
        print_message "Using Let's Encrypt staging environment" "$YELLOW"
    fi

    print_message "Obtaining certificate for ${DOMAIN_NAME}..." "$GREEN"

    case "${DNS_PROVIDER}" in
        cloudflare)
            certbot certonly \
                --dns-cloudflare \
                --dns-cloudflare-credentials ${CERTBOT_CONFIG_DIR}/cloudflare.ini \
                --email ${EMAIL} \
                --agree-tos \
                --no-eff-email \
                --force-renewal \
                -d ${DOMAIN_NAME} \
                -d "*.${DOMAIN_NAME}" \
                ${staging_flag}
            ;;
        route53)
            certbot certonly \
                --dns-route53 \
                --email ${EMAIL} \
                --agree-tos \
                --no-eff-email \
                --force-renewal \
                -d ${DOMAIN_NAME} \
                -d "*.${DOMAIN_NAME}" \
                ${staging_flag}
            ;;
        google)
            certbot certonly \
                --dns-google \
                --dns-google-credentials ${CERTBOT_CONFIG_DIR}/google.json \
                --email ${EMAIL} \
                --agree-tos \
                --no-eff-email \
                --force-renewal \
                -d ${DOMAIN_NAME} \
                -d "*.${DOMAIN_NAME}" \
                ${staging_flag}
            ;;
        digitalocean)
            certbot certonly \
                --dns-digitalocean \
                --dns-digitalocean-credentials ${CERTBOT_CONFIG_DIR}/digitalocean.ini \
                --email ${EMAIL} \
                --agree-tos \
                --no-eff-email \
                --force-renewal \
                -d ${DOMAIN_NAME} \
                -d "*.${DOMAIN_NAME}" \
                ${staging_flag}
            ;;
        ovh)
            certbot certonly \
                --dns-ovh \
                --dns-ovh-credentials ${CERTBOT_CONFIG_DIR}/ovh.ini \
                --email ${EMAIL} \
                --agree-tos \
                --no-eff-email \
                --force-renewal \
                -d ${DOMAIN_NAME} \
                -d "*.${DOMAIN_NAME}" \
                ${staging_flag}
            ;;
        manual)
            print_message "Manual DNS mode - you will need to add TXT records" "$YELLOW"
            certbot certonly \
                --manual \
                --preferred-challenges dns \
                --email ${EMAIL} \
                --agree-tos \
                --no-eff-email \
                --force-renewal \
                -d ${DOMAIN_NAME} \
                -d "*.${DOMAIN_NAME}" \
                ${staging_flag}
            ;;
        *)
            print_message "Unknown DNS provider: ${DNS_PROVIDER}" "$RED"
            exit 1
            ;;
    esac
}

# Function to renew certificate
renew_certificate() {
    print_message "Attempting to renew certificate for ${DOMAIN_NAME}..." "$GREEN"

    certbot renew \
        --quiet \
        --no-self-upgrade \
        --post-hook "docker exec nginx nginx -s reload 2>/dev/null || true"
}

# Function to reload nginx
reload_nginx() {
    if docker ps | grep -q nginx; then
        print_message "Reloading Nginx configuration..." "$GREEN"
        docker exec nginx nginx -s reload
    else
        print_message "Nginx container not running, skipping reload" "$YELLOW"
    fi
}

# Main script logic
main() {
    case "${1:-}" in
        init)
            print_message "Initializing certificate for ${DOMAIN_NAME}" "$GREEN"
            if check_certificate; then
                print_message "Certificate already exists. Use 'force' to regenerate." "$YELLOW"
                print_message "Certificate expires: $(get_cert_expiry)" "$YELLOW"
            else
                obtain_certificate
                reload_nginx
                print_message "Certificate obtained successfully!" "$GREEN"
            fi
            ;;
        renew)
            print_message "Checking certificate renewal for ${DOMAIN_NAME}" "$GREEN"
            if needs_renewal; then
                print_message "Certificate needs renewal" "$YELLOW"
                renew_certificate
                reload_nginx
                print_message "Certificate renewed successfully!" "$GREEN"
            else
                print_message "Certificate is still valid. Expires: $(get_cert_expiry)" "$GREEN"
            fi
            ;;
        force)
            print_message "Force regenerating certificate for ${DOMAIN_NAME}" "$YELLOW"
            obtain_certificate
            reload_nginx
            print_message "Certificate regenerated successfully!" "$GREEN"
            ;;
        status)
            if check_certificate; then
                print_message "Certificate Status for ${DOMAIN_NAME}:" "$GREEN"
                print_message "Expires: $(get_cert_expiry)" "$NC"
                openssl x509 -in "${LETSENCRYPT_DIR}/live/${DOMAIN_NAME}/fullchain.pem" -noout -subject -issuer
            else
                print_message "No certificate found for ${DOMAIN_NAME}" "$RED"
            fi
            ;;
        cron)
            # Silent mode for cron - only output on errors or renewal
            if needs_renewal; then
                renew_certificate
                reload_nginx
            fi
            ;;
        *)
            echo "Usage: $0 {init|renew|force|status|cron}"
            echo ""
            echo "Commands:"
            echo "  init   - Obtain initial certificate"
            echo "  renew  - Check and renew if needed (30 days before expiry)"
            echo "  force  - Force regenerate certificate"
            echo "  status - Show certificate status"
            echo "  cron   - Silent renewal for cron jobs"
            echo ""
            echo "Environment Variables:"
            echo "  DOMAIN_NAME   - Domain to obtain certificate for (default: example.com)"
            echo "  EMAIL         - Email for Let's Encrypt account (default: admin@example.com)"
            echo "  DNS_PROVIDER  - DNS provider (cloudflare|route53|google|digitalocean|ovh|manual)"
            echo "  STAGING       - Use staging environment for testing (true|false, default: false)"
            exit 1
            ;;
    esac
}

main "$@"