export interface AIQuery {
  id: number;
  user_id: number; //connect user with trip.
  trip_id?: number; // optional: cause the user may ask questions before planning for a trip , so there will not be any trip yet.
  user_question: string;
  ai_response: string;
  created_at: Date;
}