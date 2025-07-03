
#!/bin/bash

# Frontend App Installation Script for Ubuntu 24.04
# This script installs Node.js, dependencies, builds the app, and sets up PM2

set -e

echo "🚀 Starting Frontend App Installation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root"
    exit 1
fi

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required system packages
print_status "Installing system dependencies..."
sudo apt install -y curl wget gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release

# Install Node.js (LTS version)
print_status "Installing Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    print_success "Node.js installed: $(node --version)"
else
    print_warning "Node.js already installed: $(node --version)"
fi

# Install PM2 globally
print_status "Installing PM2..."
if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
    print_success "PM2 installed: $(pm2 --version)"
else
    print_warning "PM2 already installed: $(pm2 --version)"
fi

# Install serve package globally for serving static files
print_status "Installing serve package..."
sudo npm install -g serve

# Create application directory
APP_DIR="/var/www/frontend-app"
print_status "Creating application directory at $APP_DIR..."
sudo mkdir -p $APP_DIR
sudo chown -R $USER:$USER $APP_DIR

# Copy application files (assuming script is run from the project directory)
print_status "Copying application files..."
cp -r . $APP_DIR/ || {
    print_error "Failed to copy files. Make sure you're running this script from the project directory."
    exit 1
}

# Navigate to app directory
cd $APP_DIR

# Install dependencies
print_status "Installing Node.js dependencies..."
npm install

# Build the application
print_status "Building the application..."
npm run build

# Create logs directory
print_status "Creating logs directory..."
mkdir -p logs

# Setup PM2 to start on boot
print_status "Setting up PM2 startup..."
pm2 startup | grep -E "sudo.*pm2" | bash || print_warning "PM2 startup setup may have failed"

# Start the application with PM2
print_status "Starting application with PM2..."
pm2 start ecosystem.config.js
pm2 save

# Install and configure nginx (optional)
read -p "Do you want to install and configure Nginx? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Installing Nginx..."
    sudo apt install -y nginx
    
    # Backup default nginx config
    sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
    
    # Copy nginx configuration
    sudo cp nginx.conf /etc/nginx/sites-available/frontend-app
    
    # Enable the site
    sudo ln -sf /etc/nginx/sites-available/frontend-app /etc/nginx/sites-enabled/
    
    # Remove default site
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Test nginx configuration
    sudo nginx -t
    
    # Start and enable nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    print_success "Nginx installed and configured"
    print_warning "Remember to update the server_name in /etc/nginx/sites-available/frontend-app with your domain"
fi

# Setup firewall (if ufw is available)
if command -v ufw &> /dev/null; then
    print_status "Configuring firewall..."
    sudo ufw allow 22/tcp    # SSH
    sudo ufw allow 80/tcp    # HTTP
    sudo ufw allow 443/tcp   # HTTPS
    sudo ufw allow 3002/tcp  # App port
    sudo ufw --force enable
    print_success "Firewall configured"
fi

# Create a simple status check script
cat > check_status.sh << 'EOF'
#!/bin/bash
echo "=== Frontend App Status ==="
echo "PM2 Status:"
pm2 status
echo ""
echo "App URL: http://localhost:3002"
echo "Nginx Status:"
sudo systemctl status nginx --no-pager -l
EOF

chmod +x check_status.sh

print_success "🎉 Installation completed successfully!"
echo ""
echo "=== Next Steps ==="
echo "1. Check application status: ./check_status.sh"
echo "2. View application: http://localhost:3002"
echo "3. View PM2 logs: pm2 logs"
echo "4. Update Nginx config with your domain in /etc/nginx/sites-available/frontend-app"
echo "5. Consider setting up SSL with Let's Encrypt"
echo ""
echo "=== Useful Commands ==="
echo "- Restart app: pm2 restart frontend-app"
echo "- Stop app: pm2 stop frontend-app"
echo "- View logs: pm2 logs frontend-app"
echo "- Reload nginx: sudo systemctl reload nginx"
