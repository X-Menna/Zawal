export interface user{
    id: number; //auto_incremented
    name: string;
    email: string;
    birthDate?: Date; 
    phone?: string;    
    password: string;
    create_at: Date;
    update_at: Date;
}
