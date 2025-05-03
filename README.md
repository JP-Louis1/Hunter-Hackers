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

## 🗂️ Project Structure
<pre> ```plaintext env_app/
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
    ├── Front-End pageUITests                 # UI tests ``` </pre>

## 🛠️ Installation
### Backend (Flask)

1. Navigate to `Enviromental_app_backend`

2. Create and activate a virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

4. Run the Flask app:

```bash
python python-backend-main.py
```

### Frontend (SwiftUI)
1. Open the `Front-End page` directory in Xcode.

2. Build and run the app on a simulator or device.

## 💬 Contributing
Pull requests are welcome! If you’d like to contribute, please fork the repo and submit a PR. Be sure to follow good commit message practices and keep your code clean.

## 📄 License
This project is licensed under the MIT License.
