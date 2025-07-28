import express from "express";
import { createUserPreferences, getUserPreferences, updateUserPreferences } from "../controllers/preferences.controller";
import { authGuard } from "../middlewares/auth.guard";
const router = express.Router();

router.post("/user_preferences", authGuard, createUserPreferences);
router.get("/user_preferences", authGuard, getUserPreferences);
router.put("/user_preferences", authGuard, updateUserPreferences);
export default router;
