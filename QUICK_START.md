# Quick Start Guide - AWS Lightsail Deployment

## One-Command Deployment

1. **SSH into your AWS Lightsail instance:**
   ```bash
   ssh ubuntu@your-instance-ip
   ```

2. **Upload your website files** (if not already on the server):
   ```bash
   # From your local machine:
   scp -r index.html css/ js/ ubuntu@your-instance-ip:/home/ubuntu/manpowerproject/
   ```

3. **Run the setup script:**
   ```bash
   cd /home/ubuntu/manpowerproject  # or wherever your files are
   sudo bash setup.sh
   ```

4. **Access your website:**
   - Open browser: `http://your-instance-public-ip`
   - Done! 🎉

## What the Script Does

The `setup.sh` script automatically:
- ✅ Updates system packages
- ✅ Installs Apache2 web server
- ✅ Configures virtual host
- ✅ Deploys website files
- ✅ Sets proper permissions
- ✅ Enables and starts Apache2
- ✅ Configures firewall
- ✅ Tests configuration

## Troubleshooting

**Website not loading?**
```bash
sudo systemctl status apache2
sudo tail -f /var/log/apache2/easterntopcompanys_error.log
```

**Need to update files?**
```bash
sudo cp index.html /var/www/easterntopcompanys/
sudo cp -r css/ /var/www/easterntopcompanys/
sudo cp -r js/ /var/www/easterntopcompanys/
sudo systemctl reload apache2
```

For detailed instructions, see [DEPLOYMENT.md](DEPLOYMENT.md)

