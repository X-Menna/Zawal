import {Request , Response } from 'express';
import { addUser, getUserByName } from '../repositories/user.repository';
import { isVerified } from '../services/auth.service';
import { generateToken } from '../services/generateToken';
import { error } from 'console';



export const login_handle = async (req: Request, res: Response) => {
    const username = req.body.username;
    const password = req.body.password;


    if(!username || !password){
        return res.status(400).json({ error: "Username and Password are required" })
    }

    try {
        const user = await getUserByName(username);
        if (!user) {
            return res.status(404).json({error: "User not Found"})
        }

        const isValid = await isVerified(username, password);
        if (!isValid) {
            return res.status(401).json({
                error: "InValid Credentials"
            });
        }
        const token = generateToken({ id: String(user.id), username: user.username });

        return res.status(200).json({ //discuss with flutter
            message: "Login Successful",
            token,
            userId: user.id,
            username: user.username,
        });
    } catch (err) {
        console.error("Login error: ", err);
        return res.status(500).json({ error: "Internal server error" });
    }
}

export const register_handle = async (req: Request, res: Response) => {
    const username = req.body.username;
    const password = req.body.password;
    if (!username || !password) {
        return res.status(400).json({ error: "Username & password are required" })
    }


    try {
        const userExist = await getUserByName(username);
        if (userExist) {
            return res.status(400).json({ error: 'User already exists' });
        }
        const userId = await addUser(username, password);
        return res.status(201).json({
            message: 'Register successful',
            userId, //for frontend
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({
        error: 'Internal Server Error',
        message: (err as Error).message,
    });
}
}