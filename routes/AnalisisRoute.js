import express from 'express';
import { getParameters, saveAnalysis, getAnalysisBySample } from '../controllers/AnalysisResult.js';

const router = express.Router();

// Tambah CORS headers
router.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', 'http://localhost:5173');
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

// Rute untuk ambil parameter berdasarkan namaBahanId
router.get('/parameters/:namaBahanId', getParameters);

// Rute untuk simpan analisa
router.post('/', saveAnalysis);

// Rute untuk ambil analisa berdasarkan sample_id
router.get('/sample/:sampleId', getAnalysisBySample);

export default router;