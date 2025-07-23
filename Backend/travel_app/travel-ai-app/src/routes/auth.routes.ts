import express from "express";
import {login_handle, register_handle } from "../controllers/auth.controller";

const router = express.Router();

router.post("/register", register_handle);
router.post("/login", login_handle);

export default router;