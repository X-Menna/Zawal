import { dataBaseConnection } from "../config/db";
import { v4 as uuidv4 } from "uuid";

// Add new user
export const addUser = async (username: string, password: string, email: string, birthDate: any, phone: any): Promise<string> => {
    const id = uuidv4();
    const [result]: any = await (await dataBaseConnection.getConnection()).execute(
        `INSERT INTO users (id, name, password, email, birthDate, phone, create_at , update_at) 
        VALUES (? , ? , ? , ? , ? , ? , NOW() , NOW())`,
        [id, username, password , email , birthDate , phone]
    );
    return id;
};

// Get User By email
export const getUserByEmail = async (email: string): Promise<any> => {
    const connection = await dataBaseConnection.getConnection();
    const [rows]: any = await connection.execute(
        "SELECT * FROM users WHERE email = ? ",
        [email]
    );
    return rows.length ? rows[0]:null;
};

// Get User By username
export const getUserByName = async (username: string): Promise<any> => {
    const connection = await dataBaseConnection.getConnection();
    const [rows]: any = await connection.execute(
        "SELECT * FROM users WHERE username = ? ",
        [username]
    );
    return rows.length ? rows[0]:null;
};

//Update username 
export const updateUsername = async (id: any, username: string) => {
    const connection = await dataBaseConnection.getConnection();
    connection.execute("UPDATE users SET name = ? WHERE id = ?", [username, id])
};

//Update password
export const updatePassword = async (id: any, password: string) => {
    const connection = await dataBaseConnection.getConnection();
    connection.execute("UPDATE users SET password = ? WHERE id = ?", [password, id])
};

