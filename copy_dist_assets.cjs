const fs = require('fs');
const path = require('path');

const dirsToCopy = ['courses', 'course-assets', 'about-assets', 'contact-assets', 'wp-content'];

for (const dir of dirsToCopy) {
  const src = path.join(__dirname, dir);
  const dest = path.join(__dirname, 'dist', dir);
  
  if (fs.existsSync(src)) {
    console.log(`Copying ${dir} to dist/${dir}...`);
    fs.cpSync(src, dest, {
      recursive: true,
      filter: (srcPath) => {
        // Exclude backup files or git files if any
        if (srcPath.includes('.backup') || srcPath.includes('.restored')) return false;
        return true;
      }
    });
  }
}

console.log('Static directories copied to dist successfully.');
