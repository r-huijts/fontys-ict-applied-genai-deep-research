#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

/**
 * Generate a list of PDF files in the current directory with their metadata
 * This script can be run to update the file list for the index.html page
 */

function formatFileSize(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
}

function getFileList() {
    const currentDir = process.cwd();
    const files = fs.readdirSync(currentDir);
    
    const pdfFiles = files
        .filter(file => file.endsWith('.pdf'))
        .map(file => {
            const filePath = path.join(currentDir, file);
            const stats = fs.statSync(filePath);
            
            return {
                name: file,
                size: stats.size,
                modified: stats.mtime.toISOString().split('T')[0],
                sizeFormatted: formatFileSize(stats.size)
            };
        })
        .sort((a, b) => a.name.localeCompare(b.name));
    
    return pdfFiles;
}

function generateJavaScriptArray() {
    const files = getFileList();
    
    console.log('// Generated file list - copy this into your index.html');
    console.log('const knownFiles = [');
    files.forEach((file, index) => {
        const comma = index < files.length - 1 ? ',' : '';
        console.log(`    { name: '${file.name}', size: ${file.size}, modified: '${file.modified}' }${comma}`);
    });
    console.log('];');
    console.log('');
    console.log(`// Total files: ${files.length}`);
    console.log(`// Total size: ${formatFileSize(files.reduce((sum, file) => sum + file.size, 0))}`);
}

function generateMarkdownTable() {
    const files = getFileList();
    
    console.log('\n## PDF Files in Repository\n');
    console.log('| File Name | Size | Modified |');
    console.log('|-----------|------|----------|');
    
    files.forEach(file => {
        console.log(`| ${file.name} | ${file.sizeFormatted} | ${file.modified} |`);
    });
    
    console.log(`\n**Total:** ${files.length} files, ${formatFileSize(files.reduce((sum, file) => sum + file.size, 0))}`);
}

// Main execution
if (require.main === module) {
    const args = process.argv.slice(2);
    
    if (args.includes('--markdown') || args.includes('-m')) {
        generateMarkdownTable();
    } else if (args.includes('--help') || args.includes('-h')) {
        console.log('Usage: node generate-file-list.js [options]');
        console.log('');
        console.log('Options:');
        console.log('  --markdown, -m    Generate markdown table format');
        console.log('  --help, -h        Show this help message');
        console.log('');
        console.log('Default: Generate JavaScript array for index.html');
    } else {
        generateJavaScriptArray();
    }
}

module.exports = { getFileList, formatFileSize };
