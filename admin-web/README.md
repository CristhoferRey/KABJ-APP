# KABJ Admin Web

Admin web app for managing sectors, points, assignments and exports.

## Requirements
- Node.js 18+

## Setup
```bash
cd admin-web
cp .env.example .env
npm install
npm run dev
```

The dev server runs on `http://localhost:5173`.

## Environment variables
- `VITE_API_BASE_URL`: base URL for the FastAPI backend (default `http://localhost:8000`).
