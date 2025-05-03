# 🌍 Clean Living
**Have you ever wondered how the area you're standing in contributes to climate change?**
Do you want to feel motivated to make a difference in the climate crisis through simple daily actions?

**Look no further than *Clean Living*** — an app designed to keep you informed and active in combating climate change every day.

## ✨ Features
### 🔔 Frequent Notifications
Get regular tips on environmentally friendly habits you can integrate into your daily routine.

### 🏙️ Personalized City Emissions View
Monitor your area’s CO₂, methane, and other emission levels in real time.

### 🗺️ Global Pollution Map
View a 2D map where pollution levels are color-coded — from red (high pollution) to green (clean air).

### ✅ Daily Sustainable Goals
Complete eco-friendly tasks to earn points and track your personal carbon footprint.

*Clean Living keeps you accountable and inspired to be a responsible resident of Earth.*

# 🗂️ Project Structure
```env_app/
├───Enviromental_app_backend                  # Flask backend server
│   ├── data                                  # JSON data files
│   ├── venv                                  # Python virtual environment
│   ├── python-backend-main.py                # Main Flask app
│   ├── requirements.txt                      # Backend dependencies
│
└───Front-End page                            # SwiftUI frontend project
    ├── Main-Data Models                      # Data managers and models
    │   ├── ContentManager.swift
    │   ├── LocationManager.swift
    │   ├── WeatherManager.swift
    │
    ├── Network_Backend                       # Networking and API logic
    │   ├── API Communicator.swift
    │   ├── Endpoint.swift
    │
    ├── View                                  # UI Components
    │   ├── ContentView.swift
    │   ├── test.swift
    │   ├── WeatherView.swift
    │   ├── Front_End_pageAPP.swift
    │
    ├── Front-End pageTests                   # Unit tests
    ├── Front-End pageUITests                 # UI tests```
