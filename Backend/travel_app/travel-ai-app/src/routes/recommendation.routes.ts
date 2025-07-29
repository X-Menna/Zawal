import express, { Request, Response } from 'express';
const router = express.Router();

const zawal = {
  GetSuggestions: async (userInput: any) => {
    return {
      recommendation: ['Paris', 'Tokyo', 'Cairo'],
      based_on: userInput
    };
  }
};

router.post('/recommendations', async (req: Request, res: Response) => {
  try {
    const data = req.body;

    const user_input = {
      Country: data.Country,
      preferences: {
        travel_type: data.travel_type || 'solo',
        has_kids: data.has_kids ?? false,
        budget: data.budget || 500,
        season: data.season || 'any',
        age: data.age || 30,
        language: data.language,
        activities: data.activities || []
      }
    };

    const result = await zawal.GetSuggestions(user_input);

    return res.status(200).json(result);
  } catch (err: any) {
    console.error(err);
    return res.status(500).json({
      error: err.message || 'Internal Server Error',
      code: 500
    });
  }
});

export default router;
