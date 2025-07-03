# PDF Auto-Update System

This repository has an automated system to keep the `index.html` page updated with new PDF files.

## How It Works

### 1. GitHub Actions Workflow
- **File**: `.github/workflows/update-pdf-index.yml`
- **Trigger**: Automatically runs when:
  - New PDF files are committed to the main branch
  - The `index.html` file is modified
  - Can also be triggered manually from the GitHub Actions tab

### 2. Dynamic Discovery (Live Site)
When the site is hosted (GitHub Pages), the `index.html` page will:
1. **First try**: GitHub API to fetch current PDF files from the repository
2. **Fallback**: Use a hardcoded list of known files (updated by GitHub Actions)

### 3. Local Development Tools
- **`generate-file-list.js`**: Node.js script to scan local PDF files
- **`update-index.sh`**: Shell script for manual local updates

## Adding New PDFs

### Method 1: Just Commit (Recommended)
1. Add your new PDF file to the root directory
2. Commit and push to the main branch
3. GitHub Actions will automatically update `index.html`
4. The live site will show the new PDF within minutes

### Method 2: Manual Update (Local Development)
```bash
# Add your PDF file
cp new_research.pdf .

# Run the update script
./update-index.sh

# Commit the changes
git add .
git commit -m "Add new research PDF and update index"
git push
```

### Method 3: Using the Node.js Script
```bash
# Generate current file list
node generate-file-list.js

# Generate markdown table
node generate-file-list.js --markdown
```

## File Descriptions

The system automatically generates descriptions for known PDF files. To add a description for a new PDF:

1. Edit `index.html`
2. Find the `paperDescriptions` object (around line 230)
3. Add your PDF with a description:
```javascript
'your_new_file.pdf': 'Description of your research paper content and focus areas.'
```

## Troubleshooting

### GitHub Actions Not Running
- Check the Actions tab in your GitHub repository
- Ensure the workflow file has the correct permissions
- Verify the main branch protection rules allow automated commits

### PDF Not Showing on Live Site
- Wait a few minutes for GitHub Pages to rebuild
- Check browser cache (hard refresh with Ctrl+F5 or Cmd+Shift+R)
- Verify the PDF file is in the root directory (not in a subfolder)

### Local Scripts Not Working
- Ensure Node.js is installed: `node --version`
- Make sure you're in the repository root directory
- Check file permissions: `chmod +x update-index.sh`

## Technical Details

### GitHub API Integration
The live site uses the GitHub Contents API:
```
https://api.github.com/repos/r-huijts/fontys-ict-applied-genai-deep-research/contents
```

### File Size Calculation
File sizes are automatically calculated and displayed in human-readable format (B, KB, MB, GB).

### Auto-Refresh
The page automatically refreshes the file list every 60 seconds to pick up changes.

## Benefits

✅ **Zero maintenance**: Add PDFs and forget about updating the index  
✅ **Always current**: Live site reflects repository state  
✅ **Fallback resilient**: Works even if GitHub API is unavailable  
✅ **Mobile friendly**: Responsive design adapts to all screen sizes  
✅ **Professional appearance**: Clean, modern interface for research papers
