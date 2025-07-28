export interface UserPreferences {
  id?: number; // auto-incremented
  user_id: string;
  country: string;
  language?: string;              
  season?: string;              
  budget: number;
  age: number;
  activities: string[];       
  is_solo_travel: boolean;    
  is_kid_friendly_required: boolean;
  created_at?: Date;
  updated_at?: Date;
}
