from flask import Flask, jsonify, request
import random
import requests
import os
import json
from datetime import datetime
from flask_cors import CORS
from geopy.geocoders import Nominatim

app = Flask(__name__)
CORS(app)

# Configuration
API_KEY = '0e53c921b67f67218dbf186b7fd07ad0'  # OpenWeatherMap API key for air pollution data
DATA_DIR = 'data'  # Directory to store all JSON data files
os.makedirs(DATA_DIR, exist_ok=True)


class EnvironmentalNotificationsManager:
    # Initiate file and its data for environmental notifications in constructor
    def __init__(self):
        self.notifications_file = os.path.join(DATA_DIR, 'notifications.json')
        self.notifications_data = self._load_notifications()

    # Attempt to open JSON file that contains notification data
    # If not found, create the file and store the notification data in it
    def _load_notifications(self):
        try:
            with open(self.notifications_file, 'r') as file:
                return json.load(file)
        except FileNotFoundError:
            default_data = {
                "notifications": [
                    "Did you know? 100,000 marine animals die each year from plastic entanglement.",
                    "Today's a great day to plant a tree! One tree can absorb up to 48 pounds of CO2 per year.",
                    "Choose reusable over disposable items to reduce landfill waste.",
                    "A single plastic bag can take up to 1,000 years to decompose.",
                    "The average person generates over 4 pounds of trash daily!",
                    "Recycling one aluminum can saves enough energy to run a TV for 3 hours.",
                    "Taking public transportation instead of driving saves approximately 20 pounds of CO2 emissions daily.",
                    "The Great Pacific Garbage Patch is now twice the size of Texas.",
                    "Air pollution causes about 7 million premature deaths worldwide each year.",
                    "Americans use 500 million plastic straws every day – enough to circle the Earth twice!",
                    "A vegetarian diet reduces your carbon footprint by up to 73%.",
                    "Turning off the tap while brushing teeth can save up to 8 gallons of water per day.",
                    "Using LED bulbs reduces energy consumption by up to 80% compared to incandescent bulbs.",
                    "The fashion industry is responsible for 10% of global carbon emissions.",
                    "Electronic waste is the fastest-growing waste stream in the world.",
                    "Over 1 billion people lack access to clean drinking water worldwide.",
                    "Renewable energy now accounts for over 26% of global electricity generation.",
                    "Eating locally produced food can reduce transportation emissions by up to 25%.",
                    "An estimated 18 million acres of forest are lost each year to deforestation.",
                    "Switching to a reusable water bottle saves an average of 156 plastic bottles annually per person.",
                    "The Earth's average temperature has increased by 1.1°C since the pre-industrial era.",
                    "Up to 40% of food produced in the United States is never eaten.",
                    "Americans throw away enough office paper each year to build a 12-foot wall from NY to CA.",
                    "The oceans absorb about 30% of the CO2 produced by humans, causing ocean acidification.",
                    "Solar panels can reduce a household's carbon footprint by an average of 80%.",
                    "Your small actions today create big change for tomorrow's planet!",
                    "Earth is the only planet with life that we know of—let's keep it habitable!",
                    "Every eco-friendly choice matters. Thank you for making a difference!",
                    "Green living isn't just good for the planet—it's good for your health too.",
                    "Be the change you wish to see in the world. Go green today!"
                ]
            }
            self._save_data(default_data)
            return default_data

    # Store the notification data into the file
    def _save_data(self, data):
        with open(self.notifications_file, 'w') as file:
            json.dump(data, file, indent=4)

    # Choose a random notification to return to the user
    # If there is no notification data, return a default notification
    def get_random_notification(self):
        if self.notifications_data and 'notifications' in self.notifications_data:
            return {
                "notification": random.choice(self.notifications_data['notifications'])
            }
        return {"notification": "Please help protect our environment today!"}

    # Add a new notificataion to the notification data dictionary and save it to the notifications file
    def add_notification(self, message):
        if message and isinstance(message, str):
            self.notifications_data['notifications'].append(message)
            self._save_data(self.notifications_data)
            return {"success": True, "message": "Notification added successfully"}
        return {"success": False, "message": "Invalid notification format"}


class AirQualityMonitor:
    # Initiate file and its data for cities' air quality information in constructor
    def __init__(self):
        self.cities_file = os.path.join(DATA_DIR, 'cities_pollution.json')
        self.cities_data = self._load_cities_data()

    # Attempt to open JSON file that contains air quality data
    # If not found, create the file and store the cities' air quality data in it
    def _load_cities_data(self):
        try:
            with open(self.cities_file, 'r') as file:
                return json.load(file)
        except FileNotFoundError:
            default_cities = {
                "cities": [
                    {"name": "New York", "status": "yellow", "latitude": 40.7128, "longitude": -74.0060},
                    {"name": "Los Angeles", "status": "red", "latitude": 34.0522, "longitude": -118.2437},
                    {"name": "Chicago", "status": "green", "latitude": 41.8781, "longitude": -87.6298},
                    {"name": "Houston", "status": "yellow", "latitude": 29.7604, "longitude": -95.3698},
                    {"name": "Phoenix", "status": "red", "latitude": 33.4484, "longitude": -112.0740},
                    {"name": "Philadelphia", "status": "green", "latitude": 39.9526, "longitude": -75.1652},
                    {"name": "San Antonio", "status": "yellow", "latitude": 29.4241, "longitude": -98.4936},
                    {"name": "San Diego", "status": "green", "latitude": 32.7157, "longitude": -117.1611},
                    {"name": "Dallas", "status": "yellow", "latitude": 32.7767, "longitude": -96.7970},
                    {"name": "San Jose", "status": "green", "latitude": 37.3382, "longitude": -121.8863}
                ]
            }
            self._save_data(default_cities)
            return default_cities
            
    # Store the air quality data into the file
    def _save_data(self, data):
        with open(self.cities_file, 'w') as file:
            json.dump(data, file, indent=4)

    # Depending on the numerical AQI value, return a status for the air quality
    def _get_aqi_status(self, aqi):
        if aqi == 1:
            return "good"
        elif aqi == 2:
            return "fair"
        elif aqi == 3:
            return "moderate"
        elif aqi == 4:
            return "poor"
        else:  # aqi == 5
            return "very poor"
    # Use API to fetch current air quality data
    def get_local_air_quality(self, lat, lon):
        try:
            # Access API using lat, lon, and key
            url = f"http://api.openweathermap.org/data/2.5/air_pollution?lat={lat}&lon={lon}&appid={API_KEY}"
            response = requests.get(url)
            data = response.json()
            
            if response.status_code == 200 and 'list' in data and data['list']:
                aqi = data['list'][0]['main']['aqi']  # Fetch the AQI value (1-5) of the given location (lat, lon) from the API
                status = self._get_aqi_status(aqi) # Determine the AQI status based on the value
                
                # Map AQI to status colors
                status_color = {
                    "good": "green",
                    "fair": "green",
                    "moderate": "yellow",
                    "poor": "red",
                    "very poor": "red"
                }
                
                # Get city name if possible through reverse geocoding using Nominatim API
                geolocator = Nominatim(user_agent="eco_tracker")
                location = geolocator.reverse(f"{lat}, {lon}", language='en')
                city_name = "Unknown"

                
                if location and 'address' in location.raw:
                    address = location.raw['address']
                    city_name = address.get('city', address.get('town', address.get('village', "Unknown")))
                
                return {
                    "status": status_color.get(status, "yellow"),
                    "aqi_value": aqi,
                    "aqi_status": status,
                    "city": city_name,
                    "details": f"The air quality in {city_name} is {status}. The Air Quality Index (AQI) is {aqi} on a scale of 1-5."
                }
        except Exception as e:
            print(f"Error fetching pollution data: {e}")
        
        # Fallback to random data if API call fails
        statuses = ["green", "yellow", "red"]
        status = random.choices(statuses, weights=[0.4, 0.4, 0.2], k=1)[0]
        
        return {
            "status": status,
            "aqi_value": random.randint(1, 5),
            "aqi_status": "unknown",
            "city": "Unknown",
            "details": f"The air quality in your area is estimated to be {status}."
        }
    
    def get_all_cities_data(self):
        # In a real app, we would update pollution data from the API
        # For demo purposes, randomize statuses
        updated_cities = []
        
        for city in self.cities_data['cities']:
            statuses = ["green", "yellow", "red"]
            weights = [0.4, 0.4, 0.2]  # 40% good, 40% moderate, 20% bad
            city['status'] = random.choices(statuses, weights=weights, k=1)[0]
            updated_cities.append(city)
        
        # Save updated data
        self.cities_data['cities'] = updated_cities
        self._save_data(self.cities_data)
        
        return {"cities": updated_cities}


class PersonalEcoTracker:
    
    def __init__(self):
        self.user_info_file = os.path.join(DATA_DIR, 'user_info.json')
        self.actions_file = os.path.join(DATA_DIR, 'eco_actions.json')
        
        self.users_data = self._load_user_data()
        self.actions_data = self._load_actions_data()
    
    def _load_user_data(self):
        try:
            with open(self.user_info_file, 'r') as file:
                data = json.load(file)
                return data if isinstance(data, dict) else {'users': {}}
        except FileNotFoundError:
            default_data = {'users': {}}
            self._save_user_data(default_data)
            return default_data
    
    def _load_actions_data(self):
        try:
            with open(self.actions_file, 'r') as file:
                data = json.load(file)
                if not data.get('actions'):
                    data['actions'] = self._get_default_actions()
                return data
        except FileNotFoundError:
            default_data = {'actions': self._get_default_actions()}
            self._save_actions_data(default_data)
            return default_data
    
    def _save_user_data(self, data=None):
        with open(self.user_info_file, 'w') as file:
            json.dump(data if data else self.users_data, file, indent=4)
    
    def _save_actions_data(self, data=None):
        with open(self.actions_file, 'w') as file:
            json.dump(data if data else self.actions_data, file, indent=4)
    
    def _get_default_actions(self):
        return [
            {"id": 1, "description": "Use reusable shopping bags", "points": 5, "details": "Saves 500 plastic bags per year"},
            {"id": 2, "description": "Take public transportation instead of driving", "points": 10, "details": "Reduces CO2 by 4,800 lbs annually"},
            {"id": 3, "description": "Turn off lights when leaving rooms", "points": 3, "details": "Saves 1,000 lbs of CO2 per year"},
            {"id": 4, "description": "Use a reusable water bottle", "points": 5, "details": "Prevents 167 plastic bottles annually"},
            {"id": 5, "description": "Eat a vegetarian meal", "points": 8, "details": "Saves 1,100 gallons of water per meal"},
            {"id": 6, "description": "Reduce shower time by 2 minutes", "points": 7, "details": "Saves up to 150 gallons per month"},
            {"id": 7, "description": "Use a reusable coffee cup", "points": 5, "details": "Saves 23 lbs of waste per year"},
            {"id": 8, "description": "Properly recycle all eligible items today", "points": 6, "details": "Diverts waste from landfills"},
            {"id": 9, "description": "Unplug electronics not in use", "points": 4, "details": "Reduces phantom energy consumption by 10%"},
            {"id": 10, "description": "Pick up litter in your neighborhood", "points": 15, "details": "Prevents pollution of local waterways"},
            {"id": 11, "description": "Air dry laundry instead of using dryer", "points": 8, "details": "Saves 4 lbs of CO2 per load"},
            {"id": 12, "description": "Compost food scraps", "points": 7, "details": "Reduces methane emissions from landfills"},
            {"id": 13, "description": "Plant a tree or garden plant", "points": 20, "details": "A single tree absorbs 48 lbs of CO2 annually"},
            {"id": 14, "description": "Use natural light instead of artificial when possible", "points": 3, "details": "Reduces energy usage by up to 10%"},
            {"id": 15, "description": "Wash clothes in cold water", "points": 5, "details": "Saves 90% of washing machine energy"},
            {"id": 16, "description": "Walked/biked/took public transport to work/school", "points": 10, "details": "Reduces carbon emissions from personal vehicles"},
            {"id": 17, "description": "Used no plastic water bottles today", "points": 5, "details": "Prevents plastic waste and pollution"},
            {"id": 18, "description": "Recycled paper, plastic, and glass today", "points": 7, "details": "Reduces landfill waste and conserves resources"},
            {"id": 19, "description": "Bought local produce from farmers market", "points": 8, "details": "Reduces transportation emissions and supports local economy"},
            {"id": 20, "description": "Used reusable bags for all shopping today", "points": 6, "details": "Prevents single-use plastic bag waste"}
        ]
    
    def init_user(self, user_id):
        if user_id not in self.users_data['users']:
            self.users_data['users'][user_id] = {
                'points': 0,
                'completed_actions': [],
                'pending_actions': [a['id'] for a in self.actions_data['actions']],
                'daily_task': None,
                'last_updated': datetime.now().strftime('%Y-%m-%d'),
                'location': None
            }
            self._save_user_data()
            return {"success": True, "message": "User initialized successfully"}
        return {"success": True, "message": "User already exists"}
    
    def get_daily_task(self, user_id):
        ## Initialize user if not already initialized
        self.init_user(user_id)
        user = self.users_data['users'][user_id]
        
        today = datetime.now().date()
        last_updated = datetime.strptime(user['last_updated'], '%Y-%m-%d').date()
        
        ## Reset task if it's a new day or no task exists
        if today > last_updated or user['daily_task'] is None:
            available = [
                a for a in self.actions_data['actions'] 
                if a['id'] in user['pending_actions']
            ]
            
            ## Make sure there are available tasks
            if available:
                ## Select just one random task
                selected = random.choice(available)
                user['daily_task'] = selected['id']
                user['last_updated'] = today.strftime('%Y-%m-%d')
                self._save_user_data()
            else:
                ## If no pending tasks, return a message
                return {"task": None, "message": "No pending tasks available"}
        
        ## Return the full action object for the selected task ID
        task = None
        for action in self.actions_data['actions']:
            if action['id'] == user['daily_task']:
                task = action
                break
        
        return {"task": task}
    
    def complete_action(self, user_id, action_id):
        self.init_user(user_id)
        user = self.users_data['users'][user_id]
        
        # Ensure action_id is an integer
        action_id = int(action_id)
        
        if action_id in user['pending_actions']:
            # Find the action to get its points
            action = None
            for a in self.actions_data['actions']:
                if a['id'] == action_id:
                    action = a
                    break
            
            if action:
                # Update user data
                user['pending_actions'].remove(action_id)
                user['completed_actions'].append(action_id)
                user['points'] += action['points']
                
                # Reset daily task if completed
                if action_id == user['daily_task']:
                    user['daily_task'] = None
                
                self._save_user_data()
                return {
                    "success": True, 
                    "message": "Action completed successfully", 
                    "points_earned": action['points'],
                    "total_points": user['points']
                }
        
        return {"success": False, "message": "Action could not be completed"}
    
    def get_user_stats(self, user_id):
        self.init_user(user_id)
        user = self.users_data['users'][user_id]
        
        # Get details for completed and pending actions
        completed_actions = []
        for action_id in user['completed_actions']:
            for action in self.actions_data['actions']:
                if action['id'] == action_id:
                    completed_actions.append(action)
                    break
        
        pending_actions = []
        for action_id in user['pending_actions']:
            for action in self.actions_data['actions']:
                if action['id'] == action_id:
                    pending_actions.append(action)
                    break
        
        # Get daily task with details
        daily_task = None
        if user['daily_task'] is not None:
            for action in self.actions_data['actions']:
                if action['id'] == user['daily_task']:
                    daily_task = action
                    break
        
        return {
            'points': user['points'],
            'completed_actions': completed_actions,
            'pending_actions': pending_actions,
            'daily_task': daily_task,
            'location': user['location']
        }
    
    def set_user_location(self, user_id, latitude, longitude):
        self.init_user(user_id)
        self.users_data['users'][user_id]['location'] = {
            'latitude': latitude,
            'longitude': longitude
        }
        self._save_user_data()
        return {"success": True, "message": "Location updated successfully"}
    
    def add_new_action(self, description, points, details=""):
        # Find the highest existing ID and increment by 1
        new_id = 1
        if self.actions_data['actions']:
            new_id = max(a['id'] for a in self.actions_data['actions']) + 1
        
        # Create new action
        new_action = {
            "id": new_id,
            "description": description,
            "points": points,
            "details": details
        }
        
        # Add to actions list
        self.actions_data['actions'].append(new_action)
        self._save_actions_data()
        
        # Add to all users' pending actions
        for user_id in self.users_data['users']:
            if new_id not in self.users_data['users'][user_id]['pending_actions']:
                self.users_data['users'][user_id]['pending_actions'].append(new_id)
        
        self._save_user_data()
        return {
            "success": True, 
            "message": "Action added successfully", 
            "action_id": new_id
        }


class EnvironmentalTipsManager:
    
    def __init__(self):
        self.tips_file = os.path.join(DATA_DIR, 'environmental_tips.json')
        self.tips_data = self._load_tips_data()
    
    def _load_tips_data(self):
        try:
            with open(self.tips_file, 'r') as file:
                return json.load(file)
        except FileNotFoundError:
            default_tips = {
                "tips": [
                    "Turn off lights when leaving a room to save energy.",
                    "Use reusable shopping bags to reduce plastic waste.",
                    "Take shorter showers to conserve water.",
                    "Unplug electronics when not in use to avoid phantom energy usage.",
                    "Use public transportation or carpool to reduce emissions.",
                    "Buy local produce to reduce transportation emissions.",
                    "Plant trees or support reforestation projects.",
                    "Use energy-efficient light bulbs in your home.",
                    "Reduce meat consumption, especially beef.",
                    "Compost food scraps to reduce landfill waste.",
                    "Fix leaky faucets to save water.",
                    "Use a refillable water bottle instead of buying plastic bottles.",
                    "Lower your thermostat by 1-2 degrees in winter to save energy.",
                    "Wash clothes in cold water to reduce energy usage.",
                    "Line dry clothes instead of using a dryer when possible.",
                    "Recycle paper, plastic, glass, and metal properly.",
                    "Use digital documents instead of printing when possible.",
                    "Support renewable energy through your energy provider.",
                    "Insulate your home properly to reduce heating/cooling needs.",
                    "Use natural cleaning products to reduce chemical pollution.",
                    "Buy secondhand items to reduce manufacturing demands.",
                    "Maintain your car properly for optimal fuel efficiency.",
                    "Use a programmable thermostat to reduce energy use when away.",
                    "Choose products with minimal packaging.",
                    "Start a backyard garden to grow some of your own food.",
                    "Turn off the water while brushing teeth or washing dishes.",
                    "Use a reusable mug for coffee or tea.",
                    "Properly dispose of hazardous waste like batteries and electronics.",
                    "Eat seasonal foods to reduce energy used in production.",
                    "Use natural light when possible instead of artificial lighting."
                ]
            }
            self._save_data(default_tips)
            return default_tips
    
    def _save_data(self, data):
        ## Save tips data to file
        with open(self.tips_file, 'w') as file:
            json.dump(data, file, indent=4)
    
    def get_random_tip(self):
        ## Get a single random environmental tip
        if self.tips_data and 'tips' in self.tips_data and self.tips_data['tips']:
            return {"tip": random.choice(self.tips_data['tips'])}
        return {"tip": "No tips available."}
    
    def add_tip(self, tip):
        ## Add a new environmental tip
        if tip and isinstance(tip, str):
            self.tips_data['tips'].append(tip)
            self._save_data(self.tips_data)
            return {"success": True, "message": "Tip added successfully"}
        return {"success": False, "message": "Invalid tip format"}


# Create instances of the classes
notifications_manager = EnvironmentalNotificationsManager()
air_quality_monitor = AirQualityMonitor()
eco_tracker = PersonalEcoTracker()
tips_manager = EnvironmentalTipsManager()

# Flask routes
@app.route('/')
def home():
    ## This has all of the api information
    return jsonify({
        "message": "Welcome to the EcoTracker API",
        "endpoints": {
            "notifications": "/api/notifications/random",
            "tips": "/api/tips/random",
            "pollution": "/api/pollution?lat=37.77&lon=-122.41",
            "user_task": "/api/user/task?user_id=<user_id>",
            "complete_task": "/api/user/complete (POST)",
            "user_stats": "/api/user/stats?user_id=<user_id>",
            "cities": "/api/cities"
        },
        "app_info": "EcoTracker helps users reduce their environmental impact by tracking eco-friendly actions and providing local air quality information."
    })

# Notifications routes
@app.route('/api/notifications/random', methods=['GET'])
def get_random_notification():
    ## Gets a random environmental notification
    return jsonify(notifications_manager.get_random_notification())

@app.route('/api/notifications/add', methods=['POST'])
def add_notification():
    ## Adds a new notification
    data = request.get_json()
    message = data.get('message')
    return jsonify(notifications_manager.add_notification(message))

# Tips routes
@app.route('/api/tips/random', methods=['GET'])
def get_random_tip():
    ## Gets a random environmental tip
    return jsonify(tips_manager.get_random_tip())

@app.route('/api/tips/add', methods=['POST'])
def add_tip():
    ## Creates a new environmental tip
    data = request.get_json()
    tip = data.get('tip')
    return jsonify(tips_manager.add_tip(tip))

# Air quality routes
@app.route('/api/pollution', methods=['GET'])
def get_pollution():
    ## Gets the pollution data for a given location
    lat = request.args.get('lat', type=float)
    lon = request.args.get('lon', type=float)
    
    if None in [lat, lon]:
        return jsonify({"error": "Both lat and lon parameters are required"}), 400
    
    pollution_data = air_quality_monitor.get_local_air_quality(lat, lon)
    
    # If a user ID is provided, update their location
    user_id = request.args.get('user_id')
    if user_id:
        eco_tracker.set_user_location(user_id, lat, lon)
    
    return jsonify(pollution_data)

@app.route('/api/cities', methods=['GET'])
def get_cities_data():
    ## This gets pollution data from different cities
    return jsonify(air_quality_monitor.get_all_cities_data())

# User eco-tracking routes
@app.route('/api/user/init', methods=['POST'])
def init_user():
    ## Creates a new user id
    data = request.get_json()
    user_id = data.get('user_id')
    
    if not user_id:
        return jsonify({"error": "user_id parameter is required"}), 400
    
    return jsonify(eco_tracker.init_user(user_id))

@app.route('/api/user/task', methods=['GET'])
def get_user_task():
    ## Gets a single daily task for a user
    user_id = request.args.get('user_id')
    
    if not user_id:
        return jsonify({"error": "user_id parameter is required"}), 400
    
    return jsonify(eco_tracker.get_daily_task(user_id))

@app.route('/api/user/complete', methods=['POST'])
def complete_user_task():
    ## This changes if a task is completed by a user
    data = request.get_json()
    user_id = data.get('user_id')
    action_id = data.get('action_id')
    
    if not all([user_id, action_id]):
        return jsonify({"error": "Missing required parameters"}), 400
    
    return jsonify(eco_tracker.complete_action(user_id, action_id))

@app.route('/api/user/stats', methods=['GET'])
def get_user_stats():
    ## This function returns a json object with the user stats
    user_id = request.args.get('user_id')
    
    if not user_id:
        return jsonify({"error": "user_id parameter is required"}), 400
    
    return jsonify(eco_tracker.get_user_stats(user_id))

@app.route('/api/user/location', methods=['POST'])
def set_user_location():
    ## This function would set the user location based on the user_id, lat and long values
    data = request.get_json()
    user_id = data.get('user_id')
    latitude = data.get('latitude')
    longitude = data.get('longitude')
    
    if not all([user_id, latitude, longitude]):
        return jsonify({"error": "Missing required parameters"}), 400
    
    return jsonify(eco_tracker.set_user_location(user_id, latitude, longitude)) ## Returns a json object with the user id, latitude and longitude values

@app.route('/api/actions', methods=['GET'])
def get_all_actions():
    ## Returns all of the eco-friendly actions that a user can perform
    return jsonify({"actions": eco_tracker.actions_data['actions']})

@app.route('/api/actions/add', methods=['POST'])
def add_new_action():
    ## This function would create an eco-friendly action and then add it 
    data = request.get_json()
    description = data.get('description')
    points = data.get('points', 5)
    details = data.get('details', '')
    
    if not description:
        return jsonify({"error": "Description is required"}), 400
    
    return jsonify(eco_tracker.add_new_action(description, points, details))

if __name__ == '__main__':
    # Get port from environment variable or default to 5000
    port = int(os.environ.get("PORT", 5000))
    # Important: Use host='0.0.0.0' to bind to all interfaces
    app.run(host='0.0.0.0', port=port)
