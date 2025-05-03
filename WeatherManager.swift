//
//  WeatherManager.swift
//  Front-End page
//
//  Created by Linh Yui on 5/2/25.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponse {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\("b3d114366c5bd5f179eb92627a8b006f")") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let(data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data")
        }
        let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
               return decodedData
    }
}
import Foundation

struct WeatherResponse: Decodable {
    let coord: Coordinates
    let weather: [Weather]
    let main: Main
    let name: String
    let wind: Wind
    let sys: Sys
    
    struct Coordinates: Decodable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
    }
    
    struct Sys: Decodable {
        let country: String
        let sunrise: TimeInterval
        let sunset: TimeInterval
    }
}

