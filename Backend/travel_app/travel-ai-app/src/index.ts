// import express, { Request, Response } from 'express';
// import { dataBaseConnection } from './config/db';
// const app = express();
// const PORT = 3000;

// app.use(express.json());

// app.get('/test-dbconnection', async (req: Request, res: Response) => {
//   try {
//     //will not work ,there is no data yet
//     const conn = await dataBaseConnection.getConnection();
//     const [rows] = await conn.query('SELECT * FROM users LIMIT 5');
//     conn.release(); //close connection and return it back to pool to be reused

//     res.json({
//       message: ' Database connection successful!',
//       users: rows,
//     });
//   } catch (error) {
//     console.error('❌ Database error:', error);
//     res.status(500).json({ message: '❌ Failed to connect to DB' });
//   }
// });

// app.listen(PORT, () => {
//   console.log(` Server is running at http://localhost:${PORT}`);
// });


import express from 'express';
import authRoutes from './routes/auth.routes';


const app = express();
const PORT = 8000;

app.use(express.json());

app.use('/api/auth', authRoutes);     


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