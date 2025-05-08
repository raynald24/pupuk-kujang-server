import express from 'express';
import {
    getSamples,
    getSampleById,
    createSample,
    updateSample,
    deleteSample,
    getSampleCounts
} from '../controllers/Sample.js';
import { verifyUser } from '../middleware/AuthUser.js';
import { getNamaBahan } from '../controllers/namaBahan.js';

const router = express.Router();

router.get('/samples/counts', getSampleCounts); 

router.get('/samples', verifyUser, getSamples);
router.get('/samples/:id', verifyUser, getSampleById);
router.post('/samples', verifyUser, createSample);
router.patch('/samples/:id', verifyUser, updateSample);
router.delete('/samples/:id', verifyUser, deleteSample);

router.get('/namaBahan', getNamaBahan);

export default router;
