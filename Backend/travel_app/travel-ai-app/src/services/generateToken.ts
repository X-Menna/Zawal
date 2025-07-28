import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();

const SECRET = process.env.JWT_SECRET;
console.log("JWT_SECRET from generateToken.ts:", SECRET);

if (!SECRET) {
  throw new Error("JWT_SECRET is not defined");
}

export const generateToken = (user: any) => {
  return jwt.sign({ id: user.id }, SECRET, {
    expiresIn: "2h",
  });
};

export const verifyToken = (token: string) => {
  return jwt.verify(token, SECRET); 
};

