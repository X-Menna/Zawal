import { dataBaseConnection } from "../config/db";

export const insertPreferences = async (data : any) => {
  const {
    user_id,
    country,
    language,
    season,
    budget,
    age,
    activities,
    is_solo_travel,
    is_kid_friendly_required
  } = data;

  const connection = await dataBaseConnection.getConnection();

  await connection.execute(
    `INSERT INTO user_preferences 
    (user_id, country, language, season, budget, age, activities, is_solo_travel, is_kid_friendly_required)
    VALUES (?, ?, ?, ?, ? , ? , ? , ? , ?)`,
    [ user_id,
      country,
      language || null,
      season || null,
      budget,
      age,
      JSON.stringify(activities),
      is_solo_travel,
      is_kid_friendly_required
    ]
  );
};


export const getPreferencesByUserId = async (user_id: number | string) => {
  const conn = await dataBaseConnection.getConnection();
  const [rows] = await conn.query('SELECT * FROM user_preferences WHERE user_id = ?',
    [user_id]);
  conn.release();
  return Array.isArray(rows) && rows.length > 0 ? rows[0] : null;
};


export const updatePreferencesByUserId = async (user_id: number, data: any) => {
  const {
    country,
    language,
    season,
    budget,
    age,
    activities,
    is_solo_travel,
    is_kid_friendly_required
  } = data;

  const connection = await dataBaseConnection.getConnection();

  const [result] = await connection.execute(
    `UPDATE user_preferences 
      SET country = ?, 
        language = ?, 
        season = ?, 
        budget = ?, 
        age = ?, 
        activities = ?, 
        is_solo_travel = ?, 
        is_kid_friendly_required = ?,
        updated_at = CURRENT_TIMESTAMP
        WHERE user_id = ?`,
    [
      country,
      language,
      season,
      budget,
      age,
      JSON.stringify(activities),
      is_solo_travel,
      is_kid_friendly_required,
      user_id
    ]
  );

  connection.release();
  return result;
};
