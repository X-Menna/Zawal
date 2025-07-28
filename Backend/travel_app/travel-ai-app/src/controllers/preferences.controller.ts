import { Request, Response } from "express";
import { getPreferencesByUserId, insertPreferences, updatePreferencesByUserId } from "../repositories/preferences.repository";


export const createUserPreferences = async (req: Request, res: Response) => {
  console.log("Incoming request body:", req.body);
  try {
    const user = (req as any).user;
    const user_id = user.id; //from token
    const {
      country,
      language,
      season,
      budget,
      age,
      activities,
      is_solo_travel, // frontend sends true or false
      is_kid_friendly_required = false  // frontend may still send it (if not solo)
    } = req.body;

    if (!user_id || !country || !budget || !age || !activities) {
      return res.status(400).json({ message: "Missing required fields" });
    }
    const existing = await getPreferencesByUserId(user_id);
    if (existing) {
      return res.status(400).json({ message: "Preferences already exist for this user" });
    }
    // If solo travel, we ignore is_kid_friendly_required and force it to false
    const finalKidFriendly = is_solo_travel ? false : is_kid_friendly_required;

    await insertPreferences({
      user_id,
      country,
      language: language ?? null,
      season: season ?? null,
      budget,
      age,
      activities,
      is_solo_travel: is_solo_travel ?? null,
      is_kid_friendly_required: finalKidFriendly ?? null
    });

    return res.status(201).json({ message: "Preferences saved successfully" });

  } catch (error) {
    console.error("Error:", error instanceof Error ? error.message : error);
    return res.status(500).json({ message: "Server error" });
  }
};


export const getUserPreferences = async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const user_id = user.id;

    const preferences = await getPreferencesByUserId(user_id);

    return res.status(200).json({ preferences });
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({ message: "Server error" });
  }
};


export const updateUserPreferences = async (req: Request, res: Response) => {
  const user = (req as any).user;
  const user_id = user.id;

  const updated = await updatePreferencesByUserId(user_id, req.body);
  return res.status(200).json({ message: "Updated successfully", updated });
};
