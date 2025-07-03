
# Professional React Frontend Application

A modern, production-ready React frontend application built with TypeScript, Tailwind CSS, and shadcn/ui components. This application is designed to work with a Node.js/Express/PostgreSQL backend and includes comprehensive deployment configurations.

## 🚀 Features

- **Modern Tech Stack**: React 18, TypeScript, Vite, Tailwind CSS
- **UI Components**: shadcn/ui component library
- **State Management**: TanStack Query for server state
- **API Integration**: Configured API service layer
- **Production Ready**: PM2 process management, Nginx configuration
- **Responsive Design**: Mobile-first responsive layout
- **Professional Dashboard**: Clean, modern dashboard interface

## 📋 Prerequisites

Before installation, ensure you have:

- **Operating System**: Ubuntu 24.04 LTS (recommended)
- **Node.js**: Version 18.x or higher (will be installed by script)
- **npm**: Version 8.x or higher (comes with Node.js)
- **PM2**: Process manager (will be installed by script)
- **Nginx**: Web server (optional, can be installed by script)

## 🛠 Installation

### Automated Installation (Recommended)

1. **Clone or download the project**:
   ```bash
   git clone <your-repository-url>
   cd frontend-app
   ```

2. **Make the installation script executable**:
   ```bash
   chmod +x install.sh
   ```

3. **Run the installation script**:
   ```bash
   ./install.sh
   ```

   The script will:
   - Update system packages
   - Install Node.js (LTS version)
   - Install PM2 globally
   - Install project dependencies
   - Build the application
   - Configure PM2 for process management
   - Optionally install and configure Nginx

### Manual Installation

If you prefer manual installation:

1. **Install Node.js**:
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
   sudo apt install -y nodejs
   ```

2. **Install PM2**:
   ```bash
   sudo npm install -g pm2 serve
   ```

3. **Install dependencies and build**:
   ```bash
   npm install
   npm run build
   ```

4. **Start with PM2**:
   ```bash
   pm2 start ecosystem.config.js
   pm2 save
   pm2 startup
   ```

## 🏃‍♂️ Starting the Application

### Using PM2 (Production)

1. **Start the application**:
   ```bash
   pm2 start ecosystem.config.js
   ```

2. **Save PM2 configuration**:
   ```bash
   pm2 save
   ```

3. **Enable PM2 on system startup**:
   ```bash
   pm2 startup
   # Follow the command output instructions
   ```

### Using npm (Development)

```bash
# Development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview
```

## 🌐 Nginx Configuration

The application includes a production-ready Nginx configuration.

### Setup Nginx

1. **Install Nginx** (if not done by install script):
   ```bash
   sudo apt install -y nginx
   ```

2. **Copy the configuration**:
   ```bash
   sudo cp nginx.conf /etc/nginx/sites-available/frontend-app
   ```

3. **Enable the site**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/frontend-app /etc/nginx/sites-enabled/
   sudo rm /etc/nginx/sites-enabled/default  # Remove default site
   ```

4. **Update domain name**:
   ```bash
   sudo nano /etc/nginx/sites-available/frontend-app
   # Change 'your-domain.com' to your actual domain
   ```

5. **Test and reload Nginx**:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### SSL Configuration (Recommended)

For production, set up SSL with Let's Encrypt:

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
# API Configuration
REACT_APP_API_URL=http://localhost:3001/api

# Application Configuration
REACT_APP_ENV=production
```

### PM2 Configuration

The `ecosystem.config.js` file contains PM2 configuration:

- **Port**: 3002
- **Instances**: 1 (can be scaled)
- **Auto-restart**: Enabled
- **Memory limit**: 1GB
- **Logs**: Stored in `./logs/` directory

## 📱 Application Structure

```
src/
├── components/          # Reusable UI components
│   ├── ui/             # shadcn/ui components
│   └── Dashboard.tsx   # Main dashboard component
├── hooks/              # Custom React hooks
│   └── useApi.ts       # API integration hook
├── pages/              # Page components
│   ├── Index.tsx       # Home page
│   └── NotFound.tsx    # 404 page
├── services/           # API and external services
│   └── api.ts          # API service layer
└── lib/                # Utility functions
    └── utils.ts        # Helper utilities
```

## 🔍 Monitoring and Maintenance

### PM2 Commands

```bash
# View application status
pm2 status

# View logs
pm2 logs frontend-app

# Restart application
pm2 restart frontend-app

# Stop application
pm2 stop frontend-app

# Monitor in real-time
pm2 monit
```

### Health Check

Use the provided status script:

```bash
./check_status.sh
```

### Log Files

- **PM2 Logs**: `./logs/` directory
- **Nginx Logs**: `/var/log/nginx/`
- **System Logs**: `journalctl -u nginx`

## 🛡 Security Considerations

The application includes several security features:

- **Security Headers**: Configured in Nginx
- **GZIP Compression**: Enabled for better performance
- **Static Asset Caching**: 1-year cache for static files
- **API Proxy**: Configured for same-origin requests
- **Firewall**: UFW rules for necessary ports

## 🚨 Troubleshooting

### Common Issues

1. **Port 3002 already in use**:
   ```bash
   sudo lsof -i :3002
   kill -9 <PID>
   ```

2. **Permission issues**:
   ```bash
   sudo chown -R $USER:$USER /var/www/frontend-app
   ```

3. **PM2 not starting**:
   ```bash
   pm2 kill
   pm2 start ecosystem.config.js
   ```

4. **Nginx configuration errors**:
   ```bash
   sudo nginx -t
   sudo systemctl status nginx
   ```

### Log Analysis

```bash
# PM2 logs
pm2 logs --lines 100

# Nginx error logs
sudo tail -f /var/log/nginx/error.log

# System logs
journalctl -f -u nginx
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:

- Check the troubleshooting section
- Review log files for errors
- Ensure all prerequisites are met
- Verify network connectivity and ports

---

**Happy coding! 🎉**
