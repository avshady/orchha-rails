/**
 * Orchha CMS Server
 * Run from the orchha-rails/ directory: node cms-server.js
 * Admin panel: http://localhost:4000/CMS.html
 */

const express = require('express');
const fs      = require('fs');
const path    = require('path');
const multer  = require('multer');

const app         = express();
const PORT        = process.env.CMS_PORT || 4000;
const CONTENT_FILE = path.join(__dirname, 'content.json');
const PUBLIC_DIR   = path.join(__dirname, 'public');
const IMAGES_DIR   = path.join(PUBLIC_DIR, 'images');
const VIDEOS_DIR   = path.join(PUBLIC_DIR, 'videos');
const CMS_PASSWORD = process.env.CMS_PASSWORD || 'orchha2026';

if (!fs.existsSync(IMAGES_DIR)) fs.mkdirSync(IMAGES_DIR, { recursive: true });
if (!fs.existsSync(VIDEOS_DIR)) fs.mkdirSync(VIDEOS_DIR, { recursive: true });

// ── Multer: images ────────────────────────────────────────────────────────────
const imageStorage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, IMAGES_DIR),
    filename: (req, file, cb) => {
        const ext  = path.extname(file.originalname).toLowerCase();
        const base = path.basename(file.originalname, ext)
            .toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_|_$/g, '');
        cb(null, base + '_' + Date.now() + ext);
    }
});
const uploadImage = multer({
    storage: imageStorage,
    limits: { fileSize: 20 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        if (/jpeg|jpg|png|webp|gif/.test(path.extname(file.originalname).toLowerCase()))
            return cb(null, true);
        cb(new Error('Only image files allowed'));
    }
});

// ── Multer: videos ────────────────────────────────────────────────────────────
const videoStorage = multer.diskStorage({
    destination: (req, file, cb) => cb(null, VIDEOS_DIR),
    filename: (req, file, cb) => {
        const ext  = path.extname(file.originalname).toLowerCase();
        const base = path.basename(file.originalname, ext)
            .toLowerCase().replace(/[^a-z0-9]+/g, '_').replace(/^_|_$/g, '');
        cb(null, base + '_' + Date.now() + ext);
    }
});
const uploadVideo = multer({
    storage: videoStorage,
    limits: { fileSize: 500 * 1024 * 1024 },
    fileFilter: (req, file, cb) => {
        if (/mp4|webm|mov|ogg/.test(path.extname(file.originalname).toLowerCase()))
            return cb(null, true);
        cb(new Error('Only video files allowed'));
    }
});

// ── Middleware ────────────────────────────────────────────────────────────────
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(express.static(PUBLIC_DIR, {
    etag: false,
    setHeaders: res => res.setHeader('Cache-Control', 'no-store')
}));

// ── Auth ──────────────────────────────────────────────────────────────────────
function requireAuth(req, res, next) {
    if (req.headers['x-cms-token'] !== CMS_PASSWORD)
        return res.status(401).json({ error: 'Unauthorized' });
    next();
}

app.post('/api/login', (req, res) => {
    if (req.body.password === CMS_PASSWORD)
        res.json({ success: true, token: CMS_PASSWORD });
    else
        res.status(401).json({ error: 'Invalid password' });
});

// ── Content ───────────────────────────────────────────────────────────────────
app.get('/api/content', (req, res) => {
    try {
        res.json(JSON.parse(fs.readFileSync(CONTENT_FILE, 'utf8')));
    } catch (err) {
        res.status(500).json({ error: 'Failed to read content' });
    }
});

app.post('/api/content', requireAuth, (req, res) => {
    try {
        fs.writeFileSync(CONTENT_FILE, JSON.stringify(req.body, null, 2), 'utf8');
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: 'Failed to save content' });
    }
});

// ── Upload: image → public/images/ ───────────────────────────────────────────
app.post('/api/upload-image', requireAuth, uploadImage.single('image'), (req, res) => {
    if (!req.file) return res.status(400).json({ error: 'No file uploaded' });
    res.json({ success: true, url: '/images/' + req.file.filename });
});

// ── Upload: video → public/videos/ ───────────────────────────────────────────
app.post('/api/upload-video', requireAuth, uploadVideo.single('video'), (req, res) => {
    if (!req.file) return res.status(400).json({ error: 'No file uploaded' });
    res.json({ success: true, url: '/videos/' + req.file.filename });
});

// ── Start ─────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
    console.log(`\n🏛️  Orchha CMS  →  http://localhost:${PORT}/CMS.html`);
    console.log(`🔑  Password: ${CMS_PASSWORD}\n`);
});
