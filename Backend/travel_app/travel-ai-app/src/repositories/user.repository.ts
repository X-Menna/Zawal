import { dataBaseConnection } from "../config/db";
import { v4 as uuidv4 } from "uuid";

// Add new user
export const addUser = async (username: string, password: string): Promise<string> => {
    const id = uuidv4();
    const [result]: any = await (await dataBaseConnection.getConnection()).execute(
        "INSERT INTO users (id, name, password) VALUES (? , ? , ?)",
        [id, username, password]
    );
    return id;
};

// Get User By name
export const getUserByName = async (username: string): Promise<any> => {
    const connection = await dataBaseConnection.getConnection();
    const [rows]: any = await connection.execute(
        "SELECT * FROM users WHERE name = ? ",
        [username]
    );
    return rows.length ? rows[0]:null;
};
