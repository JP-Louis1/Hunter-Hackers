//
//  Endpoint.swift
//  Front-End page
//
//  Created by Linh Yui on 5/3/25.
//

import Foundation

struct Endpoint {
    // Base URL Configuration
    #if DEBUG
    static let baseURL = "http://localhost:5000"  // Local Flask server
    #else
    static let baseURL = "https://your-production-url.com"  // Live server
    #endif
    
    // MARK: - Backend Endpoints
    struct EnvironmentalAPI {
        static let tips = "\(baseURL)/api/tips/random"
        static let actions = "\(baseURL)/api/carbon/daily-actions"
        static let completeAction = "\(baseURL)/api/carbon/complete-action"
        static let userPoints = "\(baseURL)/api/carbon/points"
        static let cities = "\(baseURL)/api/globe/cities"
        
        static func pollution(latitude: Double, longitude: Double) -> String {
            return "\(baseURL)/api/pollution?lat=\(latitude)&lon=\(longitude)"
        }
    }
    
    // MARK: - Weather API (Example integration)
    struct WeatherAPI {
        static let base = "https://api.openweathermap.org/data/3.0"
        static let current = "\(base)/weather"
    }
}
