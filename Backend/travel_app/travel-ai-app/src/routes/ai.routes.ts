import express from 'express';
import { getRecommendations } from '../controllers/ai.controller';

const router = express.Router();

router.post('/get_recommendations', getRecommendations);

export default router;
