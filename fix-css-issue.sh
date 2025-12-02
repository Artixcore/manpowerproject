#!/bin/bash
# CSS Issue Fix Script - Diagnoses and fixes CSS loading problems

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
WEB_ROOT="/var/www/easterntopcompanys"

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}CSS Issue Diagnostic & Fix Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}[ERROR]${NC} Please run as root (use sudo)"
    exit 1
fi

echo -e "${GREEN}[INFO]${NC} Checking website files..."

# Check if web root exists
if [ ! -d "$WEB_ROOT" ]; then
    echo -e "${RED}[ERROR]${NC} Web root directory not found: $WEB_ROOT"
    exit 1
fi

# Check index.html
if [ ! -f "$WEB_ROOT/index.html" ]; then
    echo -e "${RED}[ERROR]${NC} index.html not found"
else
    echo -e "${GREEN}[OK]${NC} index.html exists"
fi

# Check CSS directory
if [ ! -d "$WEB_ROOT/css" ]; then
    echo -e "${RED}[ERROR]${NC} CSS directory not found!"
    echo -e "${YELLOW}[FIX]${NC} Creating CSS directory..."
    mkdir -p "$WEB_ROOT/css"
else
    echo -e "${GREEN}[OK]${NC} CSS directory exists"
fi

# Check style.css
if [ ! -f "$WEB_ROOT/css/style.css" ]; then
    echo -e "${RED}[ERROR]${NC} css/style.css not found!"
    echo -e "${YELLOW}[INFO]${NC} Please ensure css/style.css exists in the repository"
else
    echo -e "${GREEN}[OK]${NC} css/style.css exists"
    
    # Check file size
    FILE_SIZE=$(stat -f%z "$WEB_ROOT/css/style.css" 2>/dev/null || stat -c%s "$WEB_ROOT/css/style.css" 2>/dev/null || echo "0")
    if [ "$FILE_SIZE" -eq 0 ]; then
        echo -e "${RED}[ERROR]${NC} css/style.css is empty!"
    else
        echo -e "${GREEN}[OK]${NC} css/style.css size: $FILE_SIZE bytes"
    fi
fi

# Check JS directory
if [ ! -d "$WEB_ROOT/js" ]; then
    echo -e "${RED}[ERROR]${NC} JS directory not found!"
    echo -e "${YELLOW}[FIX]${NC} Creating JS directory..."
    mkdir -p "$WEB_ROOT/js"
else
    echo -e "${GREEN}[OK]${NC} JS directory exists"
fi

# Check main.js
if [ ! -f "$WEB_ROOT/js/main.js" ]; then
    echo -e "${RED}[ERROR]${NC} js/main.js not found!"
else
    echo -e "${GREEN}[OK]${NC} js/main.js exists"
fi

echo ""
echo -e "${GREEN}[INFO]${NC} Fixing file permissions..."

# Set proper permissions
chown -R www-data:www-data "$WEB_ROOT"
find "$WEB_ROOT" -type d -exec chmod 755 {} \;
find "$WEB_ROOT" -type f -exec chmod 644 {} \;

echo -e "${GREEN}[OK]${NC} Permissions fixed"

echo ""
echo -e "${GREEN}[INFO]${NC} Checking Apache configuration..."

# Check if MIME module is enabled
if apache2ctl -M 2>/dev/null | grep -q mime_module; then
    echo -e "${GREEN}[OK]${NC} MIME module is enabled"
else
    echo -e "${YELLOW}[FIX]${NC} Enabling MIME module..."
    a2enmod mime
fi

# Check MIME types file
MIME_TYPES_FILE="/etc/apache2/mime.types"
if [ -f "$MIME_TYPES_FILE" ]; then
    if grep -q "text/css" "$MIME_TYPES_FILE"; then
        echo -e "${GREEN}[OK]${NC} CSS MIME type configured"
    else
        echo -e "${YELLOW}[FIX]${NC} Adding CSS MIME type..."
        echo "text/css                    css" >> "$MIME_TYPES_FILE"
    fi
    
    if grep -q "application/javascript" "$MIME_TYPES_FILE"; then
        echo -e "${GREEN}[OK]${NC} JavaScript MIME type configured"
    else
        echo -e "${YELLOW}[FIX]${NC} Adding JavaScript MIME type..."
        echo "application/javascript      js" >> "$MIME_TYPES_FILE"
    fi
fi

echo ""
echo -e "${GREEN}[INFO]${NC} Testing Apache configuration..."

if apache2ctl configtest; then
    echo -e "${GREEN}[OK]${NC} Apache configuration is valid"
else
    echo -e "${RED}[ERROR]${NC} Apache configuration test failed"
    exit 1
fi

echo ""
echo -e "${GREEN}[INFO]${NC} Restarting Apache..."

systemctl restart apache2

if systemctl is-active --quiet apache2; then
    echo -e "${GREEN}[OK]${NC} Apache restarted successfully"
else
    echo -e "${RED}[ERROR]${NC} Apache failed to restart"
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Fix Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. Clear your browser cache (Ctrl+Shift+R or Cmd+Shift+R)"
echo "2. Check browser console for any CSS loading errors"
echo "3. Verify CSS file is accessible: http://your-server-ip/css/style.css"
echo "4. Check Apache error logs: tail -f /var/log/apache2/easterntopcompanys_error.log"
echo ""
echo "If CSS still doesn't load, check:"
echo "- File exists: ls -la $WEB_ROOT/css/style.css"
echo "- File permissions: ls -l $WEB_ROOT/css/style.css"
echo "- Apache can read: sudo -u www-data cat $WEB_ROOT/css/style.css"
echo ""

