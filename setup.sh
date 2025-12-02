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
SERVER_IP="13.201.0.239"
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

# Function to clean Apache and system caches
clean_caches() {
    print_status "Cleaning caches..."
    
    # Clear Apache cache
    if [ -d "/var/cache/apache2" ]; then
        rm -rf /var/cache/apache2/*
        print_status "Apache cache cleared"
    fi
    
    # Clear system package cache
    apt-get clean -y
    apt-get autoclean -y
    print_status "System package cache cleared"
    
    # Clear temporary files
    if [ -d "/tmp" ]; then
        find /tmp -type f -atime +7 -delete 2>/dev/null || true
        print_status "Old temporary files cleaned"
    fi
    
    # Clear browser cache directories if they exist
    if [ -d "/var/cache/apache2/mod_cache_disk" ]; then
        rm -rf /var/cache/apache2/mod_cache_disk/*
        print_status "Apache mod_cache cleared"
    fi
    
    print_status "All caches cleaned successfully"
}

# Function to clean and rotate Apache logs
clean_logs() {
    print_status "Cleaning and rotating Apache logs..."
    
    # Backup and truncate Apache error logs
    if [ -f "/var/log/apache2/error.log" ]; then
        if [ -s "/var/log/apache2/error.log" ]; then
            cp /var/log/apache2/error.log /var/log/apache2/error.log.old.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
            truncate -s 0 /var/log/apache2/error.log
            print_status "Apache error log rotated"
        fi
    fi
    
    # Backup and truncate Apache access logs
    if [ -f "/var/log/apache2/access.log" ]; then
        if [ -s "/var/log/apache2/access.log" ]; then
            cp /var/log/apache2/access.log /var/log/apache2/access.log.old.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
            truncate -s 0 /var/log/apache2/access.log
            print_status "Apache access log rotated"
        fi
    fi
    
    # Clean site-specific logs
    if [ -f "/var/log/apache2/easterntopcompanys_error.log" ]; then
        if [ -s "/var/log/apache2/easterntopcompanys_error.log" ]; then
            cp /var/log/apache2/easterntopcompanys_error.log /var/log/apache2/easterntopcompanys_error.log.old.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
            truncate -s 0 /var/log/apache2/easterntopcompanys_error.log
            print_status "Site error log rotated"
        fi
    fi
    
    if [ -f "/var/log/apache2/easterntopcompanys_access.log" ]; then
        if [ -s "/var/log/apache2/easterntopcompanys_access.log" ]; then
            cp /var/log/apache2/easterntopcompanys_access.log /var/log/apache2/easterntopcompanys_access.log.old.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
            truncate -s 0 /var/log/apache2/easterntopcompanys_access.log
            print_status "Site access log rotated"
        fi
    fi
    
    # Remove old log files (older than 30 days)
    find /var/log/apache2 -name "*.log.old.*" -type f -mtime +30 -delete 2>/dev/null || true
    print_status "Old log files removed"
    
    print_status "Log cleanup completed successfully"
}

# Function to clean old backup files and directories
clean_old_files() {
    print_status "Cleaning old backup files and directories..."
    
    # Remove old web root backups
    if [ -d "$(dirname $WEB_ROOT)" ]; then
        find "$(dirname $WEB_ROOT)" -maxdepth 1 -type d -name "${WEB_ROOT##*/}.backup.*" -mtime +7 -exec rm -rf {} \; 2>/dev/null || true
        print_status "Old web root backups removed"
    fi
    
    # Remove old Apache configuration backups
    if [ -d "/etc/apache2/sites-available" ]; then
        find /etc/apache2/sites-available -name "*.conf.bak" -type f -mtime +30 -delete 2>/dev/null || true
        find /etc/apache2/sites-available -name "*.conf.old" -type f -mtime +30 -delete 2>/dev/null || true
        print_status "Old Apache config backups removed"
    fi
    
    # Remove old update script backups if any
    if [ -f "$UPDATE_SCRIPT.bak" ]; then
        rm -f "$UPDATE_SCRIPT.bak" 2>/dev/null || true
        print_status "Old update script backups removed"
    fi
    
    # Clean old system backups
    if [ -d "/var/backups" ]; then
        find /var/backups -name "*.old" -type f -mtime +30 -delete 2>/dev/null || true
        print_status "Old system backups cleaned"
    fi
    
    print_status "Old files cleanup completed successfully"
}

# Function to update system packages
update_system() {
    print_status "Updating system packages..."
    apt-get update -y
    apt-get upgrade -y
    apt-get autoremove -y
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
    a2enmod deflate
    a2enmod expires
    a2enmod cache
    a2enmod cache_disk
    a2enmod mime
    print_status "Apache2 modules enabled (rewrite, headers, ssl, deflate, expires, cache)"
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
<VirtualHost $SERVER_IP:80>
    ServerName $DOMAIN_NAME
    ServerAlias www.$DOMAIN_NAME
    ServerAdmin webmaster@$DOMAIN_NAME
    
    DocumentRoot $WEB_ROOT
    
    # Performance: Enable compression
    <IfModule mod_deflate.c>
        AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript application/json application/xml
        BrowserMatch ^Mozilla/4 gzip-only-text/html
        BrowserMatch ^Mozilla/4\.0[678] no-gzip
        BrowserMatch \bMSIE !no-gzip !gzip-only-text/html
    </IfModule>
    
    # Performance: Browser caching
    <IfModule mod_expires.c>
        ExpiresActive On
        ExpiresByType image/jpg "access plus 1 year"
        ExpiresByType image/jpeg "access plus 1 year"
        ExpiresByType image/gif "access plus 1 year"
        ExpiresByType image/png "access plus 1 year"
        ExpiresByType image/svg+xml "access plus 1 year"
        ExpiresByType image/x-icon "access plus 1 year"
        ExpiresByType text/css "access plus 1 month"
        ExpiresByType application/javascript "access plus 1 month"
        ExpiresByType application/json "access plus 1 month"
        ExpiresByType text/html "access plus 1 hour"
    </IfModule>
    
    <Directory $WEB_ROOT>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        
        # Performance: Enable directory caching
        <IfModule mod_cache.c>
            CacheEnable disk /
            CacheRoot /var/cache/apache2/mod_cache_disk
            CacheDefaultExpire 3600
            CacheMaxExpire 86400
            CacheLastModifiedFactor 0.5
        </IfModule>
    </Directory>
    
    # Static files caching with long expiration
    <LocationMatch "\.(css|js|json|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|webp)$">
        Header set Cache-Control "public, max-age=31536000, immutable"
        Header unset ETag
        FileETag None
    </LocationMatch>
    
    # HTML files caching
    <LocationMatch "\.(html|htm)$">
        Header set Cache-Control "public, max-age=3600"
    </LocationMatch>
    
    # Error and access logs
    ErrorLog \${APACHE_LOG_DIR}/easterntopcompanys_error.log
    CustomLog \${APACHE_LOG_DIR}/easterntopcompanys_access.log combined
    
    # Security headers
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    
    # Cloudflare compatibility headers
    Header always set CF-Connecting-IP "%{CF-Connecting-IP}i"
    Header always set CF-Ray "%{CF-Ray}i"
    
    # MIME types (ensure CSS and JS are served correctly)
    AddType text/css .css
    AddType application/javascript .js
    AddType application/json .json
    
    # Performance: Disable server signature
    ServerSignature Off
    
    # Performance: Request timeout
    Timeout 30
</VirtualHost>
EOF
    
    print_status "Virtual host configuration created with performance optimizations"
}

# Function to ensure MIME types are configured
configure_mime_types() {
    print_status "Configuring MIME types for CSS and JS files..."
    
    # Check if mime.types file exists and add CSS/JS if needed
    MIME_TYPES_FILE="/etc/apache2/mime.types"
    
    if [ -f "$MIME_TYPES_FILE" ]; then
        # Check if CSS MIME type exists
        if ! grep -q "text/css" "$MIME_TYPES_FILE" 2>/dev/null; then
            echo "text/css                    css" >> "$MIME_TYPES_FILE"
            print_status "Added CSS MIME type"
        fi
        
        # Check if JS MIME type exists
        if ! grep -q "application/javascript" "$MIME_TYPES_FILE" 2>/dev/null; then
            echo "application/javascript      js" >> "$MIME_TYPES_FILE"
            print_status "Added JavaScript MIME type"
        fi
    fi
    
    # Enable mime module if not already enabled
    a2enmod mime 2>/dev/null || true
    
    print_status "MIME types configured"
}

# Function to configure Apache listener on specific IP
configure_apache_listener() {
    print_status "Configuring Apache to listen on IP: $SERVER_IP"
    
    APACHE_PORTS_FILE="/etc/apache2/ports.conf"
    
    # Backup original ports.conf
    if [ -f "$APACHE_PORTS_FILE" ]; then
        cp "$APACHE_PORTS_FILE" "${APACHE_PORTS_FILE}.bak.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    fi
    
    # Update Listen directive to bind to specific IP
    if [ -f "$APACHE_PORTS_FILE" ]; then
        # Comment out existing Listen directives
        sed -i 's/^Listen /#Listen /g' "$APACHE_PORTS_FILE" 2>/dev/null || true
        
        # Add new Listen directive for specific IP
        if ! grep -q "Listen $SERVER_IP:80" "$APACHE_PORTS_FILE" 2>/dev/null; then
            echo "" >> "$APACHE_PORTS_FILE"
            echo "# Listen on specific IP address" >> "$APACHE_PORTS_FILE"
            echo "Listen $SERVER_IP:80" >> "$APACHE_PORTS_FILE"
            print_status "Apache configured to listen on $SERVER_IP:80"
        fi
    fi
    
    print_status "Apache listener configuration completed"
}

# Function to optimize Apache performance settings
optimize_apache_performance() {
    print_status "Optimizing Apache performance settings..."
    
    APACHE_CONF="/etc/apache2/apache2.conf"
    
    # Backup original config
    if [ -f "$APACHE_CONF" ]; then
        cp "$APACHE_CONF" "${APACHE_CONF}.bak.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    fi
    
    if [ -f "$APACHE_CONF" ]; then
        # Update timeout settings
        if grep -q "^Timeout" "$APACHE_CONF" 2>/dev/null; then
            sed -i 's/^Timeout .*/Timeout 30/' "$APACHE_CONF" 2>/dev/null || true
        else
            echo "Timeout 30" >> "$APACHE_CONF"
        fi
        
        # Update KeepAlive settings
        if grep -q "^KeepAlive" "$APACHE_CONF" 2>/dev/null; then
            sed -i 's/^KeepAlive .*/KeepAlive On/' "$APACHE_CONF" 2>/dev/null || true
        else
            echo "KeepAlive On" >> "$APACHE_CONF"
        fi
        
        if grep -q "^MaxKeepAliveRequests" "$APACHE_CONF" 2>/dev/null; then
            sed -i 's/^MaxKeepAliveRequests .*/MaxKeepAliveRequests 100/' "$APACHE_CONF" 2>/dev/null || true
        else
            echo "MaxKeepAliveRequests 100" >> "$APACHE_CONF"
        fi
        
        if grep -q "^KeepAliveTimeout" "$APACHE_CONF" 2>/dev/null; then
            sed -i 's/^KeepAliveTimeout .*/KeepAliveTimeout 5/' "$APACHE_CONF" 2>/dev/null || true
        else
            echo "KeepAliveTimeout 5" >> "$APACHE_CONF"
        fi
        
        # Add performance optimizations if not present
        if ! grep -q "# Performance optimizations" "$APACHE_CONF" 2>/dev/null; then
            echo "" >> "$APACHE_CONF"
            echo "# Performance optimizations" >> "$APACHE_CONF"
            echo "RequestTimeout 30" >> "$APACHE_CONF"
            echo "HostnameLookups Off" >> "$APACHE_CONF"
            echo "ServerTokens Prod" >> "$APACHE_CONF"
            echo "ServerSignature Off" >> "$APACHE_CONF"
        fi
        
        print_status "Apache performance settings optimized"
    fi
    
    # Configure MPM settings for better performance
    MPM_CONF="/etc/apache2/mods-available/mpm_prefork.conf"
    if [ -f "$MPM_CONF" ]; then
        # Backup MPM config
        cp "$MPM_CONF" "${MPM_CONF}.bak.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        
        # Optimize MPM settings
        sed -i 's/^\(StartServers\).*/\1 5/' "$MPM_CONF" 2>/dev/null || true
        sed -i 's/^\(MinSpareServers\).*/\1 5/' "$MPM_CONF" 2>/dev/null || true
        sed -i 's/^\(MaxSpareServers\).*/\1 10/' "$MPM_CONF" 2>/dev/null || true
        sed -i 's/^\(MaxRequestWorkers\).*/\1 150/' "$MPM_CONF" 2>/dev/null || true
        sed -i 's/^\(MaxConnectionsPerChild\).*/\1 1000/' "$MPM_CONF" 2>/dev/null || true
        
        print_status "MPM performance settings optimized"
    fi
    
    print_status "Apache performance optimization completed"
}

# Function to verify website files
verify_website_files() {
    print_status "Verifying website files..."
    
    local errors=0
    
    # Check if index.html exists
    if [ ! -f "$WEB_ROOT/index.html" ]; then
        print_error "index.html not found in $WEB_ROOT"
        errors=$((errors + 1))
    else
        print_status "✓ index.html found"
    fi
    
    # Check if CSS directory exists
    if [ ! -d "$WEB_ROOT/css" ]; then
        print_error "CSS directory not found in $WEB_ROOT"
        errors=$((errors + 1))
    else
        print_status "✓ CSS directory found"
        
        # Check if style.css exists
        if [ ! -f "$WEB_ROOT/css/style.css" ]; then
            print_error "css/style.css not found"
            errors=$((errors + 1))
        else
            print_status "✓ css/style.css found"
            
            # Check file permissions
            if [ ! -r "$WEB_ROOT/css/style.css" ]; then
                print_warning "css/style.css is not readable, fixing permissions..."
                chmod 644 "$WEB_ROOT/css/style.css"
                chown www-data:www-data "$WEB_ROOT/css/style.css"
            fi
        fi
    fi
    
    # Check if JS directory exists
    if [ ! -d "$WEB_ROOT/js" ]; then
        print_error "JS directory not found in $WEB_ROOT"
        errors=$((errors + 1))
    else
        print_status "✓ JS directory found"
        
        # Check if main.js exists
        if [ ! -f "$WEB_ROOT/js/main.js" ]; then
            print_error "js/main.js not found"
            errors=$((errors + 1))
        else
            print_status "✓ js/main.js found"
            
            # Check file permissions
            if [ ! -r "$WEB_ROOT/js/main.js" ]; then
                print_warning "js/main.js is not readable, fixing permissions..."
                chmod 644 "$WEB_ROOT/js/main.js"
                chown www-data:www-data "$WEB_ROOT/js/main.js"
            fi
        fi
    fi
    
    if [ $errors -gt 0 ]; then
        print_error "Found $errors file(s) missing. Please check the deployment."
        return 1
    else
        print_status "All website files verified successfully"
        return 0
    fi
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

# Verify critical files exist
if [ ! -f "$WEB_ROOT/index.html" ]; then
    log_message "ERROR: index.html missing after update!"
    exit 1
fi

if [ ! -f "$WEB_ROOT/css/style.css" ]; then
    log_message "ERROR: css/style.css missing after update!"
    exit 1
fi

if [ ! -f "$WEB_ROOT/js/main.js" ]; then
    log_message "ERROR: js/main.js missing after update!"
    exit 1
fi

log_message "All critical files verified"

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
    echo "  - http://$SERVER_IP"
    echo "  - http://$DOMAIN_NAME"
    echo "  - http://www.$DOMAIN_NAME"
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
    echo "Performance Optimizations Applied:"
    echo "  - Gzip compression enabled"
    echo "  - Browser caching configured (1 year for static files)"
    echo "  - Apache timeout optimized (30 seconds)"
    echo "  - KeepAlive enabled for faster connections"
    echo "  - MPM settings optimized"
    echo "  - Apache listening on IP: $SERVER_IP"
    echo ""
    echo "Cleanup Completed:"
    echo "  - All caches cleared"
    echo "  - Logs rotated"
    echo "  - Old backup files removed"
    echo ""
    echo "To view Apache logs:"
    echo "  - Error log: tail -f /var/log/apache2/easterntopcompanys_error.log"
    echo "  - Access log: tail -f /var/log/apache2/easterntopcompanys_access.log"
    echo ""
    echo "To restart Apache2: sudo systemctl restart apache2"
    echo ""
    echo "To clean caches and logs manually:"
    echo "  - Run cleanup: sudo bash -c 'source setup.sh && clean_caches && clean_logs && clean_old_files'"
    echo ""
    echo "If CSS/JS files are not loading:"
    echo "  1. Run fix script: sudo bash fix-css-issue.sh"
    echo "  2. Verify files exist: ls -la $WEB_ROOT/css/"
    echo "  3. Check file permissions: ls -l $WEB_ROOT/css/style.css"
    echo "  4. Test CSS access: curl http://$SERVER_IP/css/style.css"
    echo "  5. Clear browser cache and hard refresh (Ctrl+Shift+R)"
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
    
    # Clean up old files, caches, and logs first
    print_status "Starting cleanup process..."
    clean_old_files
    clean_caches
    clean_logs
    
    # Execute setup steps
    update_system
    install_packages
    enable_modules
    configure_mime_types
    configure_apache_listener
    optimize_apache_performance
    create_web_directory
    copy_website_files
    set_permissions
    verify_website_files
    create_virtual_host
    enable_site
    configure_firewall
    
    # Clean caches again before restart
    print_status "Final cleanup before restart..."
    clean_caches
    
    test_configuration
    restart_apache
    create_update_script
    setup_cron_job
    
    # Display completion message
    display_completion
}

# Run main function
main

