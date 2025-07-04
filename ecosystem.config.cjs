module.exports = {
  apps: [{
    name: 'user-frontend',
    script: 'serve',
    args: '-s build -l 3002',
    cwd: '/var/www/user-frontend',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production'
    },
    error_file: '/var/log/pm2/user-frontend-error.log',
    out_file: '/var/log/pm2/user-frontend-out.log',
    log_file: '/var/log/pm2/user-frontend-combined.log',
    time: true,
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z'
  }]
};

