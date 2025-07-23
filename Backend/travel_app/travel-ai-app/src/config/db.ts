import mysql, { Pool, PoolConnection } from 'mysql2/promise';


export class  dataBaseConnection{
    private static pool:Pool; 
    private constructor(){}

    private static createPool():void{
        this.pool = mysql.createPool({
            host:'localhost',
            user:'root',
            password:'',
            database: 'travel_app',
            waitForConnections: true,
            connectionLimit: 10,
            queueLimit: 0,
        });
    }

    public static async getConnection ():Promise<PoolConnection>{
        if(!this.pool){
            this.createPool(); //create group of connections
        }

        return await this.pool.getConnection(); //use one each time instead of create new one everytime
    }

}