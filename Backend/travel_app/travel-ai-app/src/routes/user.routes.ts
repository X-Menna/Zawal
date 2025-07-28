import express from "express";
import {login_handle, register_handle, resetPassword, resetUsername } from "../controllers/user.controller";
import { authGuard } from '../middlewares/auth.guard';
const router = express.Router();

router.post("/register", register_handle);
router.post("/login", login_handle);
router.post("/reset_username", resetUsername);
router.post("/reset_password", resetPassword);
//Check routes protection
router.get('/profile', authGuard, (req, res) => {
    const user = (req as any).user;
    res.json({
    message: 'Protected Profile Route',
    user,
    });
});

export default router;