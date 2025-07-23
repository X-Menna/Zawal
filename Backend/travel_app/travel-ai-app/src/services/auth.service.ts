import { getUserByName } from "../repositories/user.repository"


export const isVerified = async (username: string, password: string ) => {
    
    try {
        const user = await getUserByName(username);
        if (!user) return false;
        if (username !== user.name) return false;
        if (String(password) !== String(user.password)) return false;
        return true;
    }

    catch (err) {
        console.log("Error in user validation: ", err);
        console.log(err);
        return false;
    }
}