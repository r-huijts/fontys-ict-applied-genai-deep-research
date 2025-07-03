#!/bin/bash

# Script to automatically update the index.html file with current PDF files
# Run this script whenever you add new PDF files to the repository

echo "🔄 Updating index.html with current PDF files..."

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed. Please install Node.js first."
    exit 1
fi

# Generate the current file list
echo "📊 Scanning for PDF files..."
FILE_LIST=$(node generate-file-list.js)

if [ $? -ne 0 ]; then
    echo "❌ Error generating file list"
    exit 1
fi

# Count the files and calculate total size
PDF_COUNT=$(ls -1 *.pdf 2>/dev/null | wc -l | tr -d ' ')
TOTAL_SIZE=$(node -e "
const fs = require('fs');
const files = fs.readdirSync('.').filter(f => f.endsWith('.pdf'));
const totalBytes = files.reduce((sum, file) => sum + fs.statSync(file).size, 0);
const formatSize = (bytes) => {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
};
console.log(formatSize(totalBytes));
")

echo "📁 Found $PDF_COUNT PDF files (Total: $TOTAL_SIZE)"

# Create a backup of the current index.html
cp index.html index.html.backup
echo "💾 Created backup: index.html.backup"

# Update the stats in index.html
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/<div class=\"stat-number\" id=\"paper-count\">[0-9]*<\/div>/<div class=\"stat-number\" id=\"paper-count\">$PDF_COUNT<\/div>/" index.html
    sed -i '' "s/<div class=\"stat-number\" id=\"total-size\">[^<]*<\/div>/<div class=\"stat-number\" id=\"total-size\">$TOTAL_SIZE<\/div>/" index.html
else
    # Linux
    sed -i "s/<div class=\"stat-number\" id=\"paper-count\">[0-9]*<\/div>/<div class=\"stat-number\" id=\"paper-count\">$PDF_COUNT<\/div>/" index.html
    sed -i "s/<div class=\"stat-number\" id=\"total-size\">[^<]*<\/div>/<div class=\"stat-number\" id=\"total-size\">$TOTAL_SIZE<\/div>/" index.html
fi

echo "✅ Updated index.html successfully!"
echo ""
echo "📋 Current PDF files:"
node generate-file-list.js --markdown

echo ""
echo "🌐 You can now:"
echo "   1. Open index.html in your browser to see the changes"
echo "   2. Commit and push the changes to update your GitHub Pages site"
echo ""
echo "💡 Tip: The page will automatically try to fetch files via GitHub API when hosted,"
echo "   but the fallback list has been updated with current files."
