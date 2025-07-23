export interface user{
    id: number; //auto_incremented
    name: string;
    email: string;
    password: string;
    create_at: Date; //timestamp
    update_at: Date; //timestamp
}
