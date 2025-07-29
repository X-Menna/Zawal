from fastapi import FastAPI
from pydantic import BaseModel
from typing import Dict, List, Tuple, Optional
import pandas as pd
import json
import os
from datetime import datetime
import cachetools
from flask import Flask, request, jsonify
from flask_cors import CORS
try:
    import cachetools
    HAS_CACHE_TOOLS = True
except ImportError:
    HAS_CACHE_TOOLS = False
    print("cachetools not found, using simple dictionary cache")

fastapi_app = FastAPI()
flask_app = Flask(__name__)
CORS(flask_app)  

class TravelPreferences(BaseModel):
    Country: str
    travel_type: Optional[str] = "solo"
    has_kids: Optional[bool] = False
    budget: Optional[float] = 500
    season: Optional[str] = "any"
    age: Optional[int] = 30
    language: Optional[str] = None
    activities: Optional[List[str]] = None

class UserInput(BaseModel):
    Country: str
    preferences: TravelPreferences

class AIRequest(BaseModel):
    user_id: str
    session_id: str
    input_data: UserInput  
    metadata: Optional[Dict] = None

class Safety:
    def __init__(self):
        if HAS_CACHE_TOOLS:
            self.safety_cache = cachetools.TTLCache(maxsize=100, ttl=3600)
        else:
            self.safety_cache = {}
            self.cache_expiry = {}

        # Load static safety data
        self.safety_ratings = {
            "Japan": {"score": 4.2, "message": "Extremely safe with low crime rates"},
            "South Korea": {"score": 4.0, "message": "Very safe, even at night"},
            "France": {"score": 3.5, "message": "Generally safe but beware of pickpockets"},
            "Brazil": {"score": 3.0, "message": "Exercise caution in certain areas"},
            "Mexico": {"score": 3.2, "message": "Safe in tourist areas but check advisories"},
            "United States": {"score": 3.5, "message": "Varies by location - research neighborhoods"},
            "Germany": {"score": 4.0, "message": "Very safe with excellent infrastructure"},
            "Spain": {"score": 3.8, "message": "Generally safe with minor petty theft"},
            "Italy": {"score": 3.7, "message": "Safe but be vigilant against scams"}
        }

        self.capitals = {
            "Japan": "Tokyo",
            "South Korea": "Seoul",
            "France": "Paris",
            "Brazil": "Brasília",
            "Mexico": "Mexico City",
            "United States": "Washington",
            "Germany": "Berlin",
            "Spain": "Madrid",
            "Italy": "Rome"
        }

        self.weather_templates = {
            "Tokyo": {"alerts": [], "main": {"temp": 22}, "weather": [{"main": "Clear"}]},
            "Seoul": {"alerts": [], "main": {"temp": 20}, "weather": [{"main": "Partly Cloudy"}]},
            "Paris": {"alerts": [], "main": {"temp": 18}, "weather": [{"main": "Cloudy"}]},
            "Brasília": {"alerts": [], "main": {"temp": 28}, "weather": [{"main": "Sunny"}]},
            "Mexico City": {"alerts": [], "main": {"temp": 24}, "weather": [{"main": "Smoke"}]},
            "Washington": {"alerts": [], "main": {"temp": 15}, "weather": [{"main": "Rain"}]},
            "Berlin": {"alerts": [], "main": {"temp": 16}, "weather": [{"main": "Drizzle"}]},
            "Madrid": {"alerts": [], "main": {"temp": 25}, "weather": [{"main": "Clear"}]},
            "Rome": {"alerts": [], "main": {"temp": 23}, "weather": [{"main": "Sunny"}]}
        }

    def _get_from_cache(self, country: str):
        if HAS_CACHE_TOOLS:
            return self.safety_cache.get(country)
        else:
            cached_data = self.safety_cache.get(country)
            if cached_data and datetime.now().timestamp() < self.cache_expiry.get(country, 0):
                return cached_data
            return None

    def _add_to_cache(self, country: str, data: tuple):
        if HAS_CACHE_TOOLS:
            self.safety_cache[country] = data
        else:
            self.safety_cache[country] = data
            self.cache_expiry[country] = datetime.now().timestamp() + 3600

    def _get_static_weather_data(self, city: str) -> dict:
        return self.weather_templates.get(city, {"alerts": []})

    def _get_capital(self, country: str) -> str:
        return self.capitals.get(country, "Unknown")

    def check_country(self, country: str) -> Tuple[bool, dict]:
        try:
            cached_result = self._get_from_cache(country)
            if cached_result:
                return cached_result

            safety_data = self.safety_ratings.get(country, {"score": 3.0, "message": "Standard precautions recommended"})
            capital = self._get_capital(country)
            weather_data = self._get_static_weather_data(capital)
            
            is_safe = safety_data['score'] >= 3.5
            
            result = (is_safe, {
                "safety_score": safety_data['score'],
                "safety_message": safety_data['message'],
                "weather_alerts": weather_data.get('alerts', []),
                "data_source": "Static data (offline mode)",
                "last_updated": datetime.now().isoformat(),
                "capital_checked": capital
            })
            
            self._add_to_cache(country, result)
            return result
            
        except Exception as e:
            print(f"Safety check error: {str(e)}")
            return (False, {
                "safety_score": 3.0,
                "safety_message": "Safety data unavailable",
                "weather_alerts": [],
                "data_source": "Fallback",
                "last_updated": datetime.now().isoformat(),
                "capital_checked": self._get_capital(country)
            })
class Zawal:
    def __init__(self):
        self.SafetyChecker = Safety()
        try:
            self.df = pd.read_csv("zawal - FinalData.csv")
            
            numeric_cols = ['Solo traveller score', 'Activity Duration (in Hrs)', 'Average age']
            for col in numeric_cols:
                if col in self.df.columns:
                    self.df[col] = pd.to_numeric(self.df[col], errors='coerce').fillna(0)
            
            if 'Number of Visitors' in self.df.columns:
                self.df['Number of Visitors'] = self.df['Number of Visitors'].str.replace(',', '').astype(float)
            
            if 'Kids Friendly' in self.df.columns:
                self.df['Kids Friendly'] = self.df['Kids Friendly'].map({'Yes': True, 'No': False}).fillna(False)
                
        except Exception as e:
            raise ValueError(f"Error loading data: {str(e)}")

    def getDefaultPrefs(self) -> Dict:
        return {
            'travel_type': 'solo',
            'has_kids': False,
            'budget': 500,
            'season': 'any',
            'age': 30
        }

    def GetSuggestions(self, UserInput: Dict) -> Dict:
        country = UserInput.get('Country')
        userPrefs = UserInput.get('preferences', self.getDefaultPrefs())
        
        try:
            is_safe, safety_report = self.SafetyChecker.check_country(country)
            
            if is_safe:
                return {
                    'Status': 'Safe',
                    'Message': 'Destination meets safety requirements',
                    'Safety_report': safety_report,
                    'Recommendations': self.getCountryRecommendations(country, userPrefs)
                }
            else:
                alternatives = self.SuggestAlternatives(userPrefs, safety_report)
                return {
                    "Status": "Unsafe",
                    "Message": "Safety concerns with selected country",
                    "Safety_report": safety_report,
                    "Alternatives": alternatives[:3]
                }
                
        except Exception as e:
            return {"error": str(e), "code": 500}

    def getCountryRecommendations(self, country: str, userPrefs: Dict) -> Dict:
        details = self.GetCountryDetails(country, userPrefs)
        recommendations = self.get_place_recommendations({
            "Country": country,
            "budget_level": "low" if userPrefs.get("budget", 500) < 500 else "high",
            "activities": userPrefs.get("activities", []),
            "season": userPrefs.get("season", "any"),
            "travel_type": userPrefs.get("travel_type", "solo"),
            "has_kids": userPrefs.get("has_kids", False),
            "language": userPrefs.get("language", ""),
            "age": userPrefs.get("age", 30)
        })
        
        return {
            'details': details,
            'places': recommendations,
            'activities': self.suggestActivities(country, userPrefs)
        }

    def GetCountryDetails(self, country: str, userPrefs: Dict) -> Dict:
        try:
            country_data = self.df[self.df['Country'] == country]
            if country_data.empty:
                return {"error": "Country not found", "code": 404}
            
            scores = self.calculateCountryScores(userPrefs)
            country_score = scores[scores['Country'] == country].iloc[0]
            
            return {
                'safety': self.SafetyChecker.check_country(country)[1],
                'scores': {
                    'overall': round(country_score['Adjusted Score'], 2),
                    'preferenceMatch': round(country_score['Preference Score'], 2),
                    'budget': self._get_budget_range(country_data),
                    'season': self._get_best_seasons(country_data),
                    'kidFriendly': self._get_kid_friendly_score(country_data)
                },
                'aiAnalysis': self.generateCountryDetails(country, userPrefs)
            }
            
        except Exception as e:
            return {"error": str(e), "code": 500}

    def calculateCountryScores(self, userPrefs: Dict) -> pd.DataFrame:
        try:
            aggs = {
                'Solo traveller score': 'mean',
                'Number of Visitors': 'mean',
                'Activity Duration (in Hrs)': 'mean',
                'Kids Friendly': 'mean',
                'Average age': 'mean',
                'First Season': lambda x: x.mode()[0],
                'Second Season': lambda x: x.mode()[0]
            }
            
            if all(col in self.df.columns for col in ['Activity lowBudget', 'Activity hiBudget']):
                aggs.update({
                    'Activity lowBudget': 'mean',
                    'Activity hiBudget': 'mean'
                })
            
            country_stats = self.df.groupby('Country').agg(aggs).reset_index()
            
            country_stats['Preference Score'] = self._calculate_preference_scores(country_stats, userPrefs)
            
            country_stats['Adjusted Score'] = (
                0.6 * country_stats['Preference Score'] + 
                0.4 * country_stats['Solo traveller score']
            )
            
            return country_stats
            
        except Exception as e:
            raise ValueError(f"Score calculation failed: {str(e)}")

    def _calculate_preference_scores(self, data: pd.DataFrame, prefs: Dict) -> pd.Series:
        score = 1.0
        
        if prefs['travel_type'] == 'family':
            score *= (0.7 * data['Kids Friendly'] + 0.3 * (1 - data['Solo traveller score']))
        else:
            score *= data['Solo traveller score']
        
        age_diff = abs(prefs.get('age', 30) - data['Average age'])
        score *= (1.0 - (age_diff/100))
        
        if all(col in data.columns for col in ['Activity lowBudget', 'Activity hiBudget']):
            budget_score = data.apply(
                lambda row: self._calculate_budget_score(
                    prefs.get('budget', 500),
                    row['Activity lowBudget'],
                    row['Activity hiBudget']
                ),
                axis=1
            )
            score *= budget_score.fillna(0.8)
        else:
            score *= 0.8
            
        return score

    def _calculate_budget_score(self, user_budget: float, low: float, high: float) -> float:
        try:
            if user_budget >= low and user_budget <= high:
                return 1.0
            elif user_budget < low:
                return max(0, 1 - (low - user_budget) / (low + 1))
            else:
                return max(0, 1 - (user_budget - high) / (high + 1))
        except:
            return 0.8

    def _get_budget_range(self, data: pd.DataFrame) -> str:
        try:
            if all(col in data.columns for col in ['Activity lowBudget', 'Activity hiBudget']):
                return f"{int(data['Activity lowBudget'].mean())}-{int(data['Activity hiBudget'].mean())}"
            return "Not available"
        except:
            return "Not available"

    def _get_best_seasons(self, data: pd.DataFrame) -> str:
        try:
            return f"{data['First Season'].mode()[0]}/{data['Second Season'].mode()[0]}"
        except:
            return "Not available"

    def _get_kid_friendly_score(self, data: pd.DataFrame) -> str:
        try:
            return f"{round(data['Kids Friendly'].mean() * 100, 0)}%"
        except:
            return "Not available"

    def generateCountryDetails(self, country: str, prefs: Dict) -> Dict:
        try:
            country_data = self.df[self.df['Country'] == country]
            if country_data.empty:
                return {"summary": f"General information about {country}", "tips": []}
            
            # Generate summary from the data
            top_places = country_data['Place'].value_counts().index[:3]
            avg_age = country_data['Average age'].mean()
            kid_friendly = country_data['Kids Friendly'].mean() > 0.5
            
            return {
                "summary": f"{country} offers {len(country_data)} recorded attractions. " +
                          f"Top places include {', '.join(top_places)}. " +
                          f"Average visitor age is {int(avg_age)} and it is " +
                          f"{'kid-friendly' if kid_friendly else 'less suitable for kids'}.",
                "tips": [
                    f"Best seasons: {self._get_best_seasons(country_data)}",
                    f"Average budget range: {self._get_budget_range(country_data)}",
                    "Try local foods: " + ", ".join(country_data['Food'].unique()[:3])
                ]
            }
        except Exception as e:
            return {"error": "Analysis unavailable", "details": str(e)}

    def suggestActivities(self, country: str, userPrefs: Dict) -> List[Dict]:
        try:
            country_data = self.df[self.df['Country'] == country]
            if country_data.empty:
                return []
                
            # Filter based on preferences
            filtered = country_data
            
            if userPrefs.get('has_kids', False):
                filtered = filtered[filtered['Kids Friendly']]
                
            if userPrefs.get('season', 'any') != 'any':
                filtered = filtered[
                    (filtered['First Season'] == userPrefs['season']) | 
                    (filtered['Second Season'] == userPrefs['season'])
                ]
                
            if userPrefs.get('activities'):
                activity_filter = filtered['Activity1'].isin(userPrefs['activities']) | \
                                filtered['Activity2'].isin(userPrefs['activities'])
                filtered = filtered[activity_filter]
            
            activities = filtered[[
                'Place', 'City', 'Activity1', 'Activity2', 
                'Activity Duration (in Hrs)', 'Food'
            ]].to_dict('records')
            
            return activities[:5]
            
        except:
            return []

    def SuggestAlternatives(self, prefs: Dict, safety_report: Dict) -> List[Dict]:
        try:
            scores = self.calculateCountryScores(prefs)
            top_countries = scores.sort_values('Adjusted Score', ascending=False)
            
            alternatives = []
            for _, row in top_countries.iterrows():
                country = row['Country']
                is_safe, _ = self.SafetyChecker.check_country(country)
                if is_safe and country != safety_report.get('country'):
                    alternatives.append({
                        'country': country,
                        'score': round(row['Adjusted Score'], 2),
                        'details': self.GetCountryDetails(country, prefs)
                    })
                    if len(alternatives) >= 5:
                        break
                        
            return alternatives
            
        except Exception as e:
            print(f"Error suggesting alternatives: {str(e)}")
            return []

    def _process_places_data(self):
        """Process the places data from CSV"""
        places = []
        for _, row in self.df.iterrows():
            try:
                place = {
                    "name": str(row["Place"]).strip(),
                    "city": str(row["City"]).strip(),
                    "country": str(row["Country"]).strip(),
                    "food": str(row["Food"]).strip(),
                    "budget": self._calculate_budget_level(row),
                    "avg_age": float(row["Average age"]) if pd.notna(row["Average age"]) else None,
                    "visitors": str(row["Number of Visitors"]),
                    "crowd_level": self._determine_crowd_level(row["Number of Visitors"]),
                    "activities": [
                        str(row["Activity1"]).strip().lower(),
                        str(row["Activity2"]).strip().lower()
                    ],
                    "language": [
                        str(row["Local language 1"]).strip().lower(),
                        str(row["Local langauge 2"]).strip().lower()
                    ],
                    "solo_score": float(row["Solo traveller score"]) if pd.notna(row["Solo traveller score"]) else 5,
                    "kids_friendly": bool(row["Kids Friendly"]) if 'Kids Friendly' in row else False,
                    "best_season": [
                        str(row["First Season"]).strip().lower(),
                        str(row["Second Season"]).strip().lower()
                    ],
                    "low_budget": float(row["Activity lowBudget"]) if pd.notna(row["Activity lowBudget"]) else 0,
                    "high_budget": float(row["Activity hiBudget"]) if pd.notna(row["Activity hiBudget"]) else 0
                }
                places.append(place)
            except Exception as e:
                print(f"Error processing row: {e}")
        return places

    def _calculate_budget_level(self, row):
        try:
            low = float(row["Activity lowBudget"])
            high = float(row["Activity hiBudget"])
            avg = (low + high)/2
            total_avg = (self.df["Activity lowBudget"].mean() + self.df["Activity hiBudget"].mean())/2
            return "low" if avg < total_avg*0.4 else "high" if avg > total_avg*0.6 else "medium"
        except:
            return "medium"

    def _determine_crowd_level(self, visitors):
        try:
            num = float(visitors)
            if num > 5000000: return "Very Crowded"
            elif num > 2000000: return "Crowded"
            elif num > 500000: return "Moderate"
            return "Quiet"
        except:
            return "Crowd data N/A"

    def _calculate_age_match_score(self, avg_age, user_age):
        try:
            diff = abs(float(avg_age) - user_age)
            if diff <= 5: return 1.0
            elif diff <= 15: return 0.7
            elif diff <= 25: return 0.4
            return 0.2
        except:
            return 0.7

    def _calculate_place_match_score(self, place, user_prefs):
        score = 0
        
        if place["country"].lower() != user_prefs["Country"].lower():
            return 0
        score += 50  # country weight

        if place["budget"].lower() == user_prefs.get("budget_level", "medium").lower():
            score += 15

        user_activities = user_prefs.get("activities", [])
        if user_activities and any(act in place["activities"] for act in user_activities):
            score += 10

        if user_prefs.get("season", "").lower() in place["best_season"]:
            score += 10

        if user_prefs.get("travel_type") == "family":
            if user_prefs.get("has_kids", False):
                if not place["kids_friendly"]:
                    return 0
                family_score = (place["solo_score"] - 1) / 9
                score += 10 * family_score * 1.2
            else:
                if place["kids_friendly"]:
                    score *= 0.7
        else:
            if not user_prefs.get("has_kids", False) and place["kids_friendly"]:
                score *= 0.6

        if any(lang == user_prefs.get("language", "").lower() for lang in place["language"]):
            score += 5

        if place["avg_age"]:
            score += 5 * self._calculate_age_match_score(
                place["avg_age"], user_prefs.get("age", 30)
            )

        return (score/100) * 100

    def get_place_recommendations(self, user_prefs, top_n=5):
        all_places = self._process_places_data()
        country_places = [
            p for p in all_places 
            if p["country"].lower() == user_prefs["Country"].lower()
        ]
        
        recommended = []
        for place in country_places:
            match_percentage = self._calculate_place_match_score(place, user_prefs)
            if match_percentage > 0:
                recommendation = {
                    "place": place["name"],
                    "city": place["city"],
                    "match_score": round(match_percentage, 1),
                    "budget_level": place["budget"],
                    "solo_score": place["solo_score"],
                    "kids_friendly": "Yes" if place["kids_friendly"] else "No",
                    "visitors": place["visitors"],
                    "crowd_level": place["crowd_level"],
                    "activities": place["activities"],
                    "best_season": place["best_season"],
                    "food": place["food"]
                }
                recommended.append(recommendation)
        
        recommended.sort(key=lambda x: x["match_score"], reverse=True)
        return recommended[:top_n]

    def save_to_json(self, data: Dict, filename: str = "travel_recommendations.json"):
        try:
            with open(filename, 'w', encoding='utf-8') as f:
                json.dump(data, f, ensure_ascii=False, indent=4)
            print(f"\nRecommendations saved to {filename}")
            return True
        except Exception as e:
            print(f"Error saving to JSON: {str(e)}")
            return False



zawal = Zawal()

@fastapi_app.get("/")
async def root():
    return {"message": "Welcome to Zawal Travel Recommendations API"}

@fastapi_app.post("/recommendations/")
async def get_recommendations(user_input: UserInput):
    try:
        result = zawal.GetSuggestions(user_input.dict())
        return result
    except Exception as e:
        return {"error": str(e), "code": 500}

@fastapi_app.get("/default_preferences/")
async def get_default_preferences():
    return zawal.getDefaultPrefs()

@fastapi_app.post("/ai/recommendations/")
async def ai_get_recommendations(ai_request: AIRequest):
    
    try:
        print(f"AI Request received - User: {ai_request.user_id}, Session: {ai_request.session_id}")
        
        result = zawal.GetSuggestions(ai_request.input_data.dict())
        
        response = {
            "ai_version": "1.0",
            "timestamp": datetime.now().isoformat(),
            "request_metadata": ai_request.metadata,
            "recommendation_data": result
        }
        return response
    except Exception as e:
        return {
            "error": str(e),
            "code": 500,
            "ai_error": True,
            "timestamp": datetime.now().isoformat()
        }

@flask_app.route('/')
def flask_root():
    return jsonify({"message": "Welcome to Zawal Travel Recommendations API (Flask)"})

@flask_app.route('/recommendations', methods=['POST'])
def flask_recommendations():
    try:
        data = request.get_json()
        user_input = {
            'Country': data.get('Country'),
            'preferences': {
                'travel_type': data.get('travel_type', 'solo'),
                'has_kids': data.get('has_kids', False),
                'budget': data.get('budget', 500),
                'season': data.get('season', 'any'),
                'age': data.get('age', 30),
                'language': data.get('language'),
                'activities': data.get('activities', [])
            }
        }
        result = zawal.GetSuggestions(user_input)
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e), "code": 500}), 500

@flask_app.route('/default_preferences', methods=['GET'])
def flask_default_preferences():
    return jsonify(zawal.getDefaultPrefs())

@flask_app.route('/ai/recommendations', methods=['POST'])
def flask_ai_recommendations():

    try:
        data = request.get_json()
        
        if not all(k in data for k in ['user_id', 'session_id', 'input_data']):
            return jsonify({"error": "Missing required fields", "code": 400}), 400
            
        result = zawal.GetSuggestions(data['input_data'])
        
        response = {
            "ai_version": "1.0",
            "timestamp": datetime.now().isoformat(),
            "request_metadata": data.get('metadata', {}),
            "recommendation_data": result
        }
        return jsonify(response)
    except Exception as e:
        return jsonify({
            "error": str(e),
            "code": 500,
            "ai_error": True,
            "timestamp": datetime.now().isoformat()
        }), 500

def get_user_input() -> Dict:
    return {
        "Country": "Japan",
        "preferences": {
            "travel_type": "solo",
            "has_kids": False,
            "budget": 800,
            "season": "spring",
            "age": 30,
            "language": "Japanese",
            "activities": ["sightseeing", "food tasting"]
        }
    }

if __name__ == "__main__":
    import uvicorn
    import sys
    
    if "--fastapi" in sys.argv:
        uvicorn.run(fastapi_app, host="0.0.0.0", port=8000)
    elif "--flask" in sys.argv:
        flask_app.run(host="0.0.0.0", port=5000, debug=True)
    else:
        user_input = get_user_input()  
        result = zawal.GetSuggestions(user_input)
        print("\nRecommendation Results:")
        print(json.dumps(result, indent=2))
        zawal.save_to_json(result)