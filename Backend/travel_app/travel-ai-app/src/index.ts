import dotenv from "dotenv";
import express from 'express';
import authRoutes from './routes/user.routes';
import preferencesRoutes from './routes/preferences.routes';
import travelRoutes from './routes/ai.routes';
import recommendationRoutes from './routes/recommendation.routes';


dotenv.config();
console.log("JWT_SECRET is:", process.env.JWT_SECRET);

const app = express();
const PORT =process.env.PORT || 4000;

app.use(express.json());

app.use('/api/auth', authRoutes);     

app.use('/api/preferences', preferencesRoutes);
app.use('/api', travelRoutes);
app.use('/api', recommendationRoutes);
app.get('/', (req, res) => {
  res.send('Welcome to Travel API');
});

app.listen(PORT, async () => {
  try {
    console.log(`Connected to DB`);
    console.log(`Server is running on http://localhost:${PORT}`);
  } catch (err) {
    console.error('Failed to connect to DB:', err);
  }
});