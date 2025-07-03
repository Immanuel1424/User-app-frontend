
module.exports = {
  apps: [
    {
      name: 'frontend-app',
      script: 'npx',
      args: 'serve -s dist -l 3002',
      cwd: './dist',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 3002
      },
      error_file: './logs/err.log',
      out_file: './logs/out.log',
      log_file: './logs/combined.log',
      time: true
    }
  ]
};
