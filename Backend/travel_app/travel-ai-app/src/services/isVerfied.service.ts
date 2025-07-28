import { getUserByEmail, getUserByName } from "../repositories/user.repository"
import bcrypt from "bcrypt";

export const isVerified = async (email: string, hashedPassword: string ) => {
    
    try {
        const user = await getUserByEmail(email);
        if (!user) return false;
        if (email !== user.email) return false;

        //compare the password user entered with the hashed password in DB
        const isMatch = await bcrypt.compare(hashedPassword, user.password);
        return isMatch;
    }

    catch (err) {
        console.log("Error in user validation: ", err);
        console.log(err);
        return false;
    }
}