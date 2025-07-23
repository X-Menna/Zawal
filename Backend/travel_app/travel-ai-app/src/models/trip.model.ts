export interface Trip {
  id: number;
  user_id: number; //connect the user with the trip
  destination: string;
  start_date: Date; //trip start date
  end_date: Date; //trip end date
  created_at: Date; //when the trip added
  updated_at: Date; //when the last time updated
}