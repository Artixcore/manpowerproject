#!/bin/bash

# Apache2 Setup Script for Eastern Top Companys Website on AWS Lightsail
# This script automates the complete setup of Apache2 web server

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration variables
DOMAIN_NAME="easterntopcompanys.com"
WEB_ROOT="/var/www/easterntopcompanys"
SITE_CONFIG="/etc/apache2/sites-available/easterntopcompanys.conf"
CURRENT_DIR=$(pwd)
UPDATE_SCRIPT="/usr/local/bin/update-website.sh"
CRON_LOG="/var/log/website-update.log"

# GitHub Configuration
# IMPORTANT: Update these variables with your GitHub repository details before running setup
# Example: GITHUB_REPO_URL="https://github.com/username/repo-name.git"
GITHUB_REPO_URL="https://github.com/Artixcore/manpowerproject.git"  # e.g., "https://github.com/username/repo-name.git" or leave empty to use local files
GITHUB_BRANCH="master"  # Branch to pull from (master or main)
GITHUB_USERNAME=""  # Optional: GitHub username for private repos
GITHUB_TOKEN=""  # Optional: Personal access token for private repos (create at: https://github.com/settings/tokens)

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

# Function to install required packages
install_packages() {
    print_status "Installing required packages (Apache2, Git)..."
    
    # Install Apache2 if not installed
    if ! command -v apache2 &> /dev/null; then
        apt-get install -y apache2
        if ! command -v apache2 &> /dev/null; then
            print_error "Apache2 installation failed"
            exit 1
        fi
        print_status "Apache2 installed successfully"
    else
        print_warning "Apache2 is already installed"
    fi
    
    # Install Git if not installed
    if ! command -v git &> /dev/null; then
        apt-get install -y git
        if ! command -v git &> /dev/null; then
            print_error "Git installation failed"
            exit 1
        fi
        print_status "Git installed successfully"
    else
        print_warning "Git is already installed"
    fi
}

# Function to install Apache2 and required packages (kept for backward compatibility)
install_apache() {
    install_packages
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

# Function to clone or copy website files
copy_website_files() {
    print_status "Setting up website files..."
    
    # If GitHub repo is configured, clone from GitHub
    if [ -n "$GITHUB_REPO_URL" ]; then
        print_status "Cloning website from GitHub repository..."
        
        # Configure Git credentials if provided
        if [ -n "$GITHUB_USERNAME" ] && [ -n "$GITHUB_TOKEN" ]; then
            # Use token authentication
            REPO_URL_WITH_AUTH=$(echo "$GITHUB_REPO_URL" | sed "s|https://|https://${GITHUB_TOKEN}@|")
        else
            REPO_URL_WITH_AUTH="$GITHUB_REPO_URL"
        fi
        
        # Clone repository
        if [ -d "$WEB_ROOT/.git" ]; then
            print_warning "Git repository already exists, pulling latest changes..."
            cd "$WEB_ROOT"
            git fetch origin
            git reset --hard "origin/$GITHUB_BRANCH"
            git clean -fd
            print_status "Repository updated successfully"
        else
            # Remove existing directory if it exists
            if [ -d "$WEB_ROOT" ]; then
                print_warning "Web directory already exists, backing up..."
                mv "$WEB_ROOT" "${WEB_ROOT}.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
            fi
            
            git clone -b "$GITHUB_BRANCH" "$REPO_URL_WITH_AUTH" "$WEB_ROOT"
            if [ $? -eq 0 ]; then
                print_status "Repository cloned successfully"
            else
                print_error "Failed to clone repository. Falling back to local files..."
                copy_local_files
            fi
        fi
    else
        # Fall back to copying local files
        print_warning "GitHub repository not configured, copying local files..."
        copy_local_files
    fi
}

# Function to copy website files from local directory
copy_local_files() {
    print_status "Copying website files from local directory..."
    
    # Check if files exist in current directory
    if [ ! -f "$CURRENT_DIR/index.html" ]; then
        print_error "index.html not found in current directory: $CURRENT_DIR"
        print_error "Please configure GITHUB_REPO_URL or ensure files are in current directory"
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
    ErrorLog \${APACHE_LOG_DIR}/easterntopcompanys_error.log
    CustomLog \${APACHE_LOG_DIR}/easterntopcompanys_access.log combined
    
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
    a2ensite easterntopcompanys.conf 2>/dev/null || a2ensite easterntopcompanys
    
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

# Function to create update script
create_update_script() {
    print_status "Creating website update script..."
    
    cat > $UPDATE_SCRIPT <<'UPDATE_SCRIPT_EOF'
#!/bin/bash
# Website Update Script - Pulls latest changes from GitHub and restarts Apache

set -e

# Configuration
WEB_ROOT="/var/www/easterntopcompanys"
GITHUB_BRANCH="master"
LOG_FILE="/var/log/website-update.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log_message() {
    echo "[$DATE] $1" >> "$LOG_FILE"
}

log_message "Starting website update check..."

# Check if web root is a git repository
if [ ! -d "$WEB_ROOT/.git" ]; then
    log_message "ERROR: $WEB_ROOT is not a git repository. Update skipped."
    exit 1
fi

# Change to web root directory
cd "$WEB_ROOT" || exit 1

# Fetch latest changes
log_message "Fetching latest changes from GitHub..."
git fetch origin >> "$LOG_FILE" 2>&1

# Check if there are updates
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$GITHUB_BRANCH")

if [ "$LOCAL" = "$REMOTE" ]; then
    log_message "No updates available. Website is up to date."
    exit 0
fi

log_message "Updates found. Pulling latest changes..."

# Pull latest changes
git reset --hard "origin/$GITHUB_BRANCH" >> "$LOG_FILE" 2>&1
git clean -fd >> "$LOG_FILE" 2>&1

# Set proper permissions
chown -R www-data:www-data "$WEB_ROOT"
find "$WEB_ROOT" -type d -exec chmod 755 {} \;
find "$WEB_ROOT" -type f -exec chmod 644 {} \;

# Restart Apache
log_message "Restarting Apache2..."
systemctl restart apache2 >> "$LOG_FILE" 2>&1

if systemctl is-active --quiet apache2; then
    log_message "SUCCESS: Website updated and Apache restarted successfully."
else
    log_message "ERROR: Apache failed to restart after update."
    exit 1
fi

log_message "Update completed successfully."
UPDATE_SCRIPT_EOF
    
    # Make update script executable
    chmod +x $UPDATE_SCRIPT
    
    # Update the script with actual branch name and web root
    sed -i "s|GITHUB_BRANCH=\"master\"|GITHUB_BRANCH=\"$GITHUB_BRANCH\"|" $UPDATE_SCRIPT
    sed -i "s|WEB_ROOT=\"/var/www/easterntopcompanys\"|WEB_ROOT=\"$WEB_ROOT\"|" $UPDATE_SCRIPT
    
    print_status "Update script created at $UPDATE_SCRIPT"
}

# Function to setup cron job for automatic updates
setup_cron_job() {
    print_status "Setting up automatic update cron job..."
    
    # Check if GitHub repo is configured
    if [ -z "$GITHUB_REPO_URL" ]; then
        print_warning "GitHub repository not configured. Skipping cron job setup."
        print_warning "To enable automatic updates, configure GITHUB_REPO_URL in setup.sh"
        return
    fi
    
    # Check if web root is a git repository
    if [ ! -d "$WEB_ROOT/.git" ]; then
        print_warning "Web directory is not a git repository. Skipping cron job setup."
        return
    fi
    
    # Create cron job to run update script every hour
    CRON_JOB="0 * * * * $UPDATE_SCRIPT"
    
    # Check if cron job already exists (check root's crontab)
    if crontab -l -u root 2>/dev/null | grep -q "$UPDATE_SCRIPT"; then
        print_warning "Cron job already exists, skipping..."
    else
        # Add cron job to root's crontab
        (crontab -l -u root 2>/dev/null; echo "$CRON_JOB") | crontab -u root -
        print_status "Cron job added: Updates will be checked every hour"
        print_status "Cron job runs as root user"
    fi
    
    print_status "Cron job setup completed"
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
    
    if [ -n "$GITHUB_REPO_URL" ]; then
        echo "GitHub Integration:"
        echo "  - Repository: $GITHUB_REPO_URL"
        echo "  - Branch: $GITHUB_BRANCH"
        echo "  - Update script: $UPDATE_SCRIPT"
        echo "  - Update log: $CRON_LOG"
        echo ""
        echo "To manually update website:"
        echo "  sudo $UPDATE_SCRIPT"
        echo ""
        echo "Automatic updates:"
        echo "  - Cron job configured to check for updates every hour"
        echo "  - View update logs: tail -f $CRON_LOG"
    else
        echo "GitHub Integration:"
        echo "  - Not configured"
        echo "  - To enable automatic updates, edit setup.sh and set GITHUB_REPO_URL"
    fi
    
    echo ""
    echo "To view Apache logs:"
    echo "  - Error log: tail -f /var/log/apache2/easterntopcompanys_error.log"
    echo "  - Access log: tail -f /var/log/apache2/easterntopcompanys_access.log"
    echo ""
    echo "To restart Apache2: sudo systemctl restart apache2"
    echo ""
}

# Main execution
main() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}Eastern Top Companys Website - Apache2 Setup${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    
    # Check if running as root
    check_root
    
    # Execute setup steps
    update_system
    install_packages
    enable_modules
    create_web_directory
    copy_website_files
    set_permissions
    create_virtual_host
    enable_site
    configure_firewall
    test_configuration
    restart_apache
    create_update_script
    setup_cron_job
    
    # Display completion message
    display_completion
}

# Run main function
main

