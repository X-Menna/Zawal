import { Request, Response, NextFunction } from 'express';
import { verifyToken } from '../services/generateToken';

export const authGuard = (req: Request, res: Response, next: NextFunction) => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ error: 'Unauthorized: No token provided' });
    }

    const token = authHeader.split(' ')[1];

    try {
        const decoded = verifyToken(token);
        (req as any).user = decoded; //save data in request to use in every route
        next();
    } catch (err) {
        return res.status(401).json({ error: 'Invalid or expired token' });
    }
};
