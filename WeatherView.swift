//
//  WeatherView.swift
//  Front-End page
//
//  Created by Linh Yui on 5/2/25.
//

import SwiftUI
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherManager = WeatherManager()
    
    @MainActor
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        isLoading = true
        errorMessage = nil
        
        do {
            weather = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
        } catch {
            errorMessage = error.localizedDescription
            print("Error getting weather: \(error)")
        }
        
        isLoading = false
    }
}

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.blue, .white]),
                          startPoint: .topLeading,
                          endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            // Content
            if viewModel.isLoading {
                ProgressView()
            } else if let weather = viewModel.weather {
                WeatherContentView(weather: weather)
            }
        }
        .task {
            if let location = locationManager.location {
                await viewModel.getWeather(
                    latitude: location.latitude,
                    longitude: location.longitude
                )
            }
        }
    }
}

struct WeatherContentView: View {
    let weather: WeatherResponse
    
    var body: some View {
        VStack(spacing: 20) {
            // Location
            Text("\(weather.name), \(weather.sys.country)")
                .font(.title)
                .bold()
            
            // Main weather info
            VStack {
                if let weatherInfo = weather.weather.first {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherInfo.icon)@2x.png")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    
                    Text(weatherInfo.description.capitalized)
                        .font(.title2)
                    
                    Text("\(weather.main.temp, specifier: "%.1f")°C")
                        .font(.system(size: 50))
                        .bold()
                }
            }
            
            // Additional details
            HStack(spacing: 30) {
                WeatherDetailView(
                    icon: "thermometer",
                    value: String(format: "%.1f°C", weather.main.feels_like),
                    label: "Feels like"
                )
                
                WeatherDetailView(
                    icon: "humidity",
                    value: "\(weather.main.humidity)%",
                    label: "Humidity"
                )
                
                WeatherDetailView(
                    icon: "wind",
                    value: String(format: "%.1f m/s", weather.wind.speed),
                    label: "Wind"
                )
            }
            .padding(.top)
        }
        .foregroundColor(.white)
        .padding()
    }
}

struct WeatherDetailView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title)
            Text(value)
                .bold()
            Text(label)
                .font(.caption)
        }
    }
}


#Preview {
    WeatherView()
}
