#!/usr/bin/env bash
# deployment script for Solstice Cipher

echo "Select deployment platform:"
echo "1) Vercel"
echo "2) Google Cloud (Firebase Hosting)"
read -p "Enter 1 or 2: " choice

if [ "$choice" == "1" ]; then
    echo "Deploying to Vercel..."
    # Ensure Vercel is installed
    npx vercel --version &> /dev/null || npm install -g vercel
    
    echo "Vercel requires authentication. If the browser does not open, please follow the CLI prompts."
    npx vercel deploy --prod
elif [ "$choice" == "2" ]; then
    echo "Deploying to Google Cloud (Firebase)..."
    # Ensure Firebase is installed
    npx firebase-tools --version &> /dev/null || npm install -g firebase-tools
    
    echo "Firebase requires authentication."
    npx firebase login
    
    echo "Initializing Firebase project (select Hosting when prompted)..."
    npx firebase init hosting
    
    echo "Deploying to Firebase Hosting..."
    npx firebase deploy --only hosting
else
    echo "Invalid choice. Exiting."
    exit 1
fi
