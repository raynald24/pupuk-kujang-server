import express from 'express';
import {
  createAnalysisResult,
  getAnalysisResultsBySampleId
} from '../controllers/AnalisaResult.js';

import { verifyUser } from '../middleware/AuthUser.js';

const router = express.Router();

// Analysis Result Routes
router.post('/analysis-result', verifyUser,createAnalysisResult); // Membuat hasil analisa baru
router.get('/analysis-result/:sampleId',verifyUser, getAnalysisResultsBySampleId); // Mendapatkan hasil analisa berdasarkan sampleId

export default router;
