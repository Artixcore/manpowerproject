# Deployment Guide - Eastern Top Companys Website on AWS Lightsail

This guide explains how to deploy the Eastern Top Companys website on an AWS Lightsail instance using the automated setup script.

## Prerequisites

- AWS Lightsail instance (Ubuntu/Debian-based)
- SSH access to the instance
- Website files (index.html, css/, js/ directories)

## Quick Deployment

### Step 1: Connect to Your AWS Lightsail Instance

```bash
ssh ubuntu@your-instance-ip
# or
ssh ubuntu@your-instance-public-ip
```

### Step 2: Upload Website Files

You can upload files using one of these methods:

#### Option A: Using SCP (from your local machine)
```bash
scp -r index.html css/ js/ ubuntu@your-instance-ip:/home/ubuntu/
```

#### Option B: Using Git (if repository is on GitHub)
```bash
git clone your-repository-url
cd manpowerproject
```

#### Option C: Using AWS Lightsail File Transfer
- Use the AWS Lightsail console file browser to upload files

### Step 3: Run the Setup Script

```bash
# Make sure you're in the directory containing index.html
cd /home/ubuntu/manpowerproject  # or wherever you uploaded files

# Run the setup script with sudo
sudo bash setup.sh
```

The script will automatically:
- ✅ Update system packages
- ✅ Install Apache2 web server
- ✅ Configure Apache2 virtual host
- ✅ Copy website files to `/var/www/easterntopcompanys`
- ✅ Set proper permissions
- ✅ Enable and start Apache2 service
- ✅ Configure firewall rules
- ✅ Test configuration

### Step 4: Access Your Website

After the script completes, your website will be available at:
- `http://your-instance-public-ip`
- `http://your-domain-name` (if DNS is configured)

## Manual Steps (if needed)

### Configure Domain Name (Optional)

If you have a domain name:

1. **Update DNS Records**: Point your domain to the Lightsail instance IP
   - A record: `@` → `your-instance-ip`
   - A record: `www` → `your-instance-ip`

2. **Update setup.sh**: Edit the `DOMAIN_NAME` variable in setup.sh before running:
   ```bash
   DOMAIN_NAME="yourdomain.com"
   ```

3. **Re-run setup**: The virtual host will be configured for your domain

### Enable HTTPS (SSL Certificate)

To enable HTTPS with Let's Encrypt:

```bash
# Install Certbot
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-apache

# Get SSL certificate
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com

# Auto-renewal is set up automatically
```

## File Locations

After deployment:
- **Website files**: `/var/www/easterntopcompanys/`
- **Apache config**: `/etc/apache2/sites-available/easterntopcompanys.conf`
- **Error logs**: `/var/log/apache2/easterntopcompanys_error.log`
- **Access logs**: `/var/log/apache2/easterntopcompanys_access.log`

## Useful Commands

### Check Apache Status
```bash
sudo systemctl status apache2
```

### Restart Apache
```bash
sudo systemctl restart apache2
```

### View Error Logs
```bash
sudo tail -f /var/log/apache2/easterntopcompanys_error.log
```

### View Access Logs
```bash
sudo tail -f /var/log/apache2/easterntopcompanys_access.log
```

### Test Apache Configuration
```bash
sudo apache2ctl configtest
```

### Reload Apache Configuration
```bash
sudo systemctl reload apache2
```

## Troubleshooting

### Website Not Loading

1. **Check Apache Status**:
   ```bash
   sudo systemctl status apache2
   ```

2. **Check Firewall**:
   ```bash
   sudo ufw status
   # If needed, allow Apache:
   sudo ufw allow 'Apache Full'
   ```

3. **Check Apache Logs**:
   ```bash
   sudo tail -50 /var/log/apache2/easterntopcompanys_error.log
   ```
   
4. **Verify Files Exist**:
   ```bash
   ls -la /var/www/easterntopcompanys/
   ```

### Permission Issues

If you see permission errors:
```bash
sudo chown -R www-data:www-data /var/www/easterntopcompanys
sudo chmod -R 755 /var/www/easterntopcompanys
sudo find /var/www/easterntopcompanys -type f -exec chmod 644 {} \;
```

### Port Already in Use

If port 80 is already in use:
```bash
sudo netstat -tulpn | grep :80
# Kill the process or reconfigure
```

## Updating Website Files

To update website files after initial deployment:

```bash
# Copy new files
sudo cp index.html /var/www/easterntopcompanys/
sudo cp -r css/ /var/www/easterntopcompanys/
sudo cp -r js/ /var/www/easterntopcompanys/

# Set permissions
sudo chown -R www-data:www-data /var/www/easterntopcompanys
sudo chmod -R 755 /var/www/easterntopcompanys
sudo find /var/www/easterntopcompanys -type f -exec chmod 644 {} \;

# Reload Apache (no downtime)
sudo systemctl reload apache2
```

## Security Recommendations

1. **Keep System Updated**:
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

2. **Configure Firewall**:
   ```bash
   sudo ufw enable
   sudo ufw allow 22/tcp  # SSH
   sudo ufw allow 80/tcp   # HTTP
   sudo ufw allow 443/tcp  # HTTPS
   ```

3. **Enable HTTPS**: Use Let's Encrypt (see above)

4. **Regular Backups**: Backup `/var/www/easterntopcompanys/` regularly

## Support

For issues or questions:
- Check Apache error logs: `/var/log/apache2/easterntopcompanys_error.log`
- Verify configuration: `sudo apache2ctl configtest`
- Check system resources: `htop` or `free -h`

