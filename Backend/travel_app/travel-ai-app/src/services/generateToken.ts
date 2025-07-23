import jwt from 'jsonwebtoken';

const SECRET = 'secret_key_123';

export const generateToken = (user: { id: string, username: string }) => {
    return jwt.sign({ id: user.id, username: user.username }, SECRET, { expiresIn: '1h' });
};

export const verifyToken = (token: string) => {
    return jwt.verify(token, SECRET);
};