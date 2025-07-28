import {Request , Response } from 'express';
import { addUser, getUserByEmail, getUserByName, updatePassword, updateUsername } from '../repositories/user.repository';
import { isVerified } from '../services/isVerfied.service';
import { generateToken } from '../services/generateToken';
import bcrypt from 'bcrypt';



export const login_handle = async (req: Request, res: Response) => {
    const email = req.body.email;
    const password = req.body.password;
    if(!email || !password){
        return res.status(400).json({ error: "Email and Password are required" })
    }
    try {
        const user = await getUserByEmail(email);
        if (!user) {
            return res.status(404).json({ error: "User not Found" });
        }

        const isValid = await isVerified(email, password);
        if (!isValid) {
            return res.status(401).json({
                error: "InValid Credentials"
            });
        }
        const token = generateToken({ id: String(user.id), email: user.email });
        
        return res.status(200).json({ //discuss with frontend
            message: "Login Successful",
            token,
            userId: user.id,
            email: user.email,
        });
    } catch (err) {
        console.error("Login error: ", err);
        return res.status(500).json({ error: "Internal server error" });
    }
}


export const register_handle = async (req: Request, res: Response) => {
    const username = req.body.username;
    const password = req.body.password;
    const email = req.body.email;
    const birthDate = req.body.birthDate; // expected format: 'YYYY-MM-DD'
    const phone = req.body.phone;

    if (!username || !password || !email) {
        return res.status(400).json({ error: "Username, email & password are required" });
    }

    if (typeof username !== 'string' || typeof password !== 'string' || typeof email !== 'string') {
        return res.status(400).json({ error: "Username, email, and password must be strings" });
    }
    try {
        const userExistbyemail = await getUserByEmail(email);
        if (userExistbyemail) {
            return res.status(400).json({ error: 'User already exists' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const userId = await addUser(username, hashedPassword, email, birthDate, phone);

        return res.status(201).json({
            message: 'Register successful',
            userId,
            //for frontend
            username,
            password
        });

    } catch (err) {
        console.error(err);
        return res.status(500).json({
            error: 'Internal Server Error',
            message: (err as Error).message,
        });
    }
}


export const resetUsername = async (req: Request, res: Response) => {
    const username = req.body.username;
    const newusername = req.body.newusername;
    const currpassword = req.body.password;

    if (!username || !newusername || !currpassword) {
        return res.status(401).json({ error: 'All fields are required.' })
    }
    try {
        const user = await getUserByName(username);
        if (!user) {
            return res.status(404).json({ error: 'User not found.' })
        }

        if (user.password !== currpassword) {
            return res.status(401).json({ error: 'Incorrect current password.' })
        }

        await updateUsername(user.id, newusername)
        return res.status(200).json({messege: 'Username updated successfully.'})
    } catch (err) {
        console.error(err);
        return res.status(500).json({error:
            'Internal Server Error.'
        })
    }
}


export const resetPassword = async (req: Request, res: Response) => {
    const username = req.body.username;
    const currpassword = req.body.currpassword;
    const newpassword = req.body.newpassword;

    if (!currpassword || !newpassword || !username) {
        return res.status(401).json({error: 'All fields are required.'})
    }

    try {
        const user =await getUserByName(username);
        if (!user) {
            return res.status(404).json({error: 'User not found.' })
        }

        if (user.password !== currpassword) {
            return res.status(401).json({error: 'Incorrect old password.'})
        }

        await updatePassword(user.id, newpassword);
        return res.status(200).json({message: 'Password updated successfully.'})
    } catch (err) {
        console.error(err);
        return res.status(500).json({
            error:
                'Internal Server Error.'
        })
    }
}