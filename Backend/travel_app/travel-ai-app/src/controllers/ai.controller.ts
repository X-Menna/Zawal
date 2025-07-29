import { Request, Response } from 'express';

const travelData: Record<string, Array<{ place: string; budget: string; bestFor: string }>> = {
  "Japan": [
    { place: "Tokyo", budget: "$$$", bestFor: "Solo" },
    { place: "Kyoto", budget: "$$", bestFor: "Couples" }
  ],
  "France": [
    { place: "Paris", budget: "$$$", bestFor: "Romantic" },
    { place: "Nice", budget: "$$", bestFor: "Beach" }
  ]
};

export const getRecommendations = (req: Request, res: Response) => {
  const { country } = req.body;

  if (!country) {
    return res.status(400).json({ error: "Please send a country!" });
  }

  const recommendations = travelData[country];

  if (!recommendations) {
    return res.status(404).json({ error: "Country not found!" });
  }

  return res.json({
    success: true,
    country,
    recommendations
  });
};
