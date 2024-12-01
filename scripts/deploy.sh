#!/bin/bash

# Step 0: ssh agent activation
echo "Starting ssh agent"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_bare_metal_remix
echo 
echo "Start Deploying"
# Step 1: Move to orbit backend folder
cd /home/admin/bare-metal-remix || { echo "Directory not found"; exit 1; }

# Step 2: Git pull
echo "Pulling latest changes from git..."
git pull || { echo "Git pull failed"; exit 1; }

# Step 3: Install dependencies using npm ci
echo "Installing dependencies..."
npm ci || { echo "npm ci failed"; exit 1; }

# Step 4: Build the project
echo "Building the project..."
npm run build || { echo "npm run build failed"; exit 1; }

# Step 5: Check if PM2 is installed and running
if ! command -v pm2 &> /dev/null; then
    echo "PM2 is not installed or not in PATH"
    exit 1
fi

# Step 6: Reload the application with PM2
echo "Reloading the application with PM2..."
pm2 reload bare-metal-remix || { echo "PM2 reload failed"; exit 1; }

echo "Deployment complete!"