import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const rootDir = __dirname;
const distDir = path.resolve(rootDir, 'dist');
const publicDir = path.resolve(rootDir, 'public');

console.log('Building production bundle for Vercel / Static hosting...');

// Clean dist directory
if (fs.existsSync(distDir)) {
  fs.rmSync(distDir, { recursive: true, force: true });
}
fs.mkdirSync(distDir, { recursive: true });

function copyRecursive(src, dest) {
  if (!fs.existsSync(src)) return;
  const stat = fs.statSync(src);
  if (stat.isDirectory()) {
    fs.mkdirSync(dest, { recursive: true });
    for (const file of fs.readdirSync(src)) {
      copyRecursive(path.join(src, file), path.join(dest, file));
    }
  } else {
    fs.copyFileSync(src, dest);
  }
}

// 1. Copy index.html
const indexPath = path.resolve(rootDir, 'index.html');
if (fs.existsSync(indexPath)) {
  fs.copyFileSync(indexPath, path.resolve(distDir, 'index.html'));
  console.log('✓ Copied index.html to dist/index.html');
}

// 2. Copy compiled assets from public/build to dist/build
const buildDir = path.resolve(publicDir, 'build');
if (fs.existsSync(buildDir)) {
  copyRecursive(buildDir, path.resolve(distDir, 'build'));
  console.log('✓ Copied public/build to dist/build');
}

// 3. Copy public/assets to dist/assets
const assetsDir = path.resolve(publicDir, 'assets');
if (fs.existsSync(assetsDir)) {
  copyRecursive(assetsDir, path.resolve(distDir, 'assets'));
  console.log('✓ Copied public/assets to dist/assets');
}

// 4. Copy public/storage to dist/storage
const storageDir = path.resolve(publicDir, 'storage');
if (fs.existsSync(storageDir)) {
  copyRecursive(storageDir, path.resolve(distDir, 'storage'));
  console.log('✓ Copied public/storage to dist/storage');
}

// 5. Copy other root public files (favicon.ico, robots.txt, etc.)
for (const item of fs.readdirSync(publicDir)) {
  if (['build', 'assets', 'storage', 'index.php'].includes(item)) continue;
  const itemPath = path.resolve(publicDir, item);
  const stat = fs.statSync(itemPath);
  if (stat.isFile()) {
    fs.copyFileSync(itemPath, path.resolve(distDir, item));
  }
}

console.log('✓ Dist build successfully completed in dist/');
