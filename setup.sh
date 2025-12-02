#!/bin/bash

# Apache2 Setup Script for Maali Hermes Website on AWS Lightsail
# This script automates the complete setup of Apache2 web server

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration variables
DOMAIN_NAME="maalihermes.com"
WEB_ROOT="/var/www/maalihermes"
SITE_CONFIG="/etc/apache2/sites-available/maalihermes.conf"
CURRENT_DIR=$(pwd)

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        print_error "Please run as root (use sudo)"
        exit 1
    fi
}

# Function to update system packages
update_system() {
    print_status "Updating system packages..."
    apt-get update -y
    apt-get upgrade -y
    print_status "System packages updated successfully"
}

# Function to install Apache2 and required packages
install_apache() {
    # Check if Apache2 is already installed
    if command -v apache2 &> /dev/null; then
        print_warning "Apache2 is already installed"
        return
    fi
    
    print_status "Installing Apache2 web server..."
    apt-get install -y apache2
    
    # Check if Apache2 is installed
    if ! command -v apache2 &> /dev/null; then
        print_error "Apache2 installation failed"
        exit 1
    fi
    
    print_status "Apache2 installed successfully"
}

# Function to enable Apache modules
enable_modules() {
    print_status "Enabling Apache2 modules..."
    a2enmod rewrite
    a2enmod headers
    a2enmod ssl
    print_status "Apache2 modules enabled"
}

# Function to create web directory
create_web_directory() {
    print_status "Creating web directory: $WEB_ROOT"
    
    # Remove existing directory if it exists (backup first)
    if [ -d "$WEB_ROOT" ]; then
        print_warning "Web directory already exists, backing up..."
        mv "$WEB_ROOT" "${WEB_ROOT}.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    fi
    
    mkdir -p $WEB_ROOT
    print_status "Web directory created"
}

# Function to copy website files
copy_website_files() {
    print_status "Copying website files to $WEB_ROOT..."
    
    # Check if files exist in current directory
    if [ ! -f "$CURRENT_DIR/index.html" ]; then
        print_error "index.html not found in current directory: $CURRENT_DIR"
        print_error "Please make sure you're running this script from the directory containing index.html"
        exit 1
    fi
    
    # Copy HTML file
    cp "$CURRENT_DIR/index.html" "$WEB_ROOT/index.html"
    print_status "index.html copied"
    
    # Copy CSS directory if it exists
    if [ -d "$CURRENT_DIR/css" ]; then
        cp -r "$CURRENT_DIR/css" "$WEB_ROOT/"
        print_status "CSS files copied"
    else
        print_warning "CSS directory not found, skipping..."
    fi
    
    # Copy JS directory if it exists
    if [ -d "$CURRENT_DIR/js" ]; then
        cp -r "$CURRENT_DIR/js" "$WEB_ROOT/"
        print_status "JavaScript files copied"
    else
        print_warning "JS directory not found, skipping..."
    fi
    
    # Copy images directory if it exists
    if [ -d "$CURRENT_DIR/images" ]; then
        cp -r "$CURRENT_DIR/images" "$WEB_ROOT/"
        print_status "Image files copied"
    fi
    
    print_status "Website files copied successfully"
}

# Function to set proper permissions
set_permissions() {
    print_status "Setting proper file permissions..."
    
    # Set ownership to www-data
    chown -R www-data:www-data $WEB_ROOT
    
    # Set directory permissions to 755
    find $WEB_ROOT -type d -exec chmod 755 {} \;
    
    # Set file permissions to 644
    find $WEB_ROOT -type f -exec chmod 644 {} \;
    
    print_status "Permissions set successfully"
}

# Function to create Apache virtual host configuration
create_virtual_host() {
    print_status "Creating Apache virtual host configuration..."
    
    cat > $SITE_CONFIG <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN_NAME
    ServerAlias www.$DOMAIN_NAME
    ServerAdmin webmaster@$DOMAIN_NAME
    
    DocumentRoot $WEB_ROOT
    
    <Directory $WEB_ROOT>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # Error and access logs
    ErrorLog \${APACHE_LOG_DIR}/maalihermes_error.log
    CustomLog \${APACHE_LOG_DIR}/maalihermes_access.log combined
    
    # Security headers
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
</VirtualHost>
EOF
    
    print_status "Virtual host configuration created"
}

# Function to enable site and disable default
enable_site() {
    print_status "Enabling website and disabling default site..."
    
    # Check if site config exists
    if [ ! -f "$SITE_CONFIG" ]; then
        print_error "Site configuration file not found: $SITE_CONFIG"
        exit 1
    fi
    
    # Enable the new site
    a2ensite maalihermes.conf 2>/dev/null || a2ensite maalihermes
    
    # Disable default site
    a2dissite 000-default.conf 2>/dev/null || true
    
    print_status "Site enabled successfully"
}

# Function to configure firewall
configure_firewall() {
    print_status "Configuring firewall (UFW)..."
    
    # Check if UFW is installed
    if command -v ufw &> /dev/null; then
        # Allow HTTP
        ufw allow 'Apache Full'
        ufw allow 80/tcp
        ufw allow 443/tcp
        print_status "Firewall configured"
    else
        print_warning "UFW not installed, skipping firewall configuration"
    fi
}

# Function to test Apache configuration
test_configuration() {
    print_status "Testing Apache2 configuration..."
    
    if apache2ctl configtest; then
        print_status "Apache2 configuration is valid"
    else
        print_error "Apache2 configuration test failed"
        exit 1
    fi
}

# Function to restart Apache2
restart_apache() {
    print_status "Restarting Apache2 service..."
    systemctl restart apache2
    systemctl enable apache2
    
    # Check if Apache2 is running
    if systemctl is-active --quiet apache2; then
        print_status "Apache2 is running successfully"
    else
        print_error "Apache2 failed to start"
        exit 1
    fi
}

# Function to display completion message
display_completion() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Setup Completed Successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo "Website is now available at:"
    echo "  - http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo 'your-server-ip')"
    echo "  - http://$DOMAIN_NAME"
    echo ""
    echo "Website files location: $WEB_ROOT"
    echo "Apache configuration: $SITE_CONFIG"
    echo ""
    echo "To view Apache logs:"
    echo "  - Error log: tail -f /var/log/apache2/maalihermes_error.log"
    echo "  - Access log: tail -f /var/log/apache2/maalihermes_access.log"
    echo ""
    echo "To restart Apache2: sudo systemctl restart apache2"
    echo ""
}

# Main execution
main() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Maali Hermes Website - Apache2 Setup${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    
    # Check if running as root
    check_root
    
    # Execute setup steps
    update_system
    install_apache
    enable_modules
    create_web_directory
    copy_website_files
    set_permissions
    create_virtual_host
    enable_site
    configure_firewall
    test_configuration
    restart_apache
    
    # Display completion message
    display_completion
}

# Run main function
main

