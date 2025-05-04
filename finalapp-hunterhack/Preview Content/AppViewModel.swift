//
//  AppViewModel.swift
//  finalapp-hunterhack
//
//  Created by Linh Yui on 5/4/25.
//

import Foundation
import MapKit
import Observation
import SwiftUI
import XCAAQI

enum LocationStatus: Equatable{
    case requestingLocation
    case locationNotAuthorized(String)
    case error(String)
    case requestingAQIConditions
    case standy
}


@Observable
class AppViewModel {
    
    let aqiClient = AirQualityClient(apiKey:"AIzaSyCuwNEKNnK9DpKWb6wWNaOT-o5yo6fEYQA")
    let coordinatesFinder = CoordinatesFinder()
    
    var currentLocation: CLLocationCoordinate2D?
    var locationStatus = LocationStatus.requestingLocation
    var position: MapCameraPosition = .automatic
    var annotations: [AQIResponse] = []
    var selection: AQIResponse?
    var presentationDetent = PresentationDetent.height(176)
    
    var radiusNArray: [(Double, Int)]
    
    init(radiusNArray: [(Double, Int)] = [(4000, 6), (8000, 12)]){
        self.radiusNArray = radiusNArray
        self.currentLocation = .init(latitude:  40.758896, longitude: -73.985130)
        Task{
            await self.handleCoordinateChange(currentLocation!)
        }
        
    }
    
    func handleCoordinateChange(_ coordinate: CLLocationCoordinate2D) async{
        do {
            self.locationStatus = .requestingAQIConditions
            self.position = .region(.init(center: coordinate, latitudinalMeters: 0, longitudinalMeters: 16000))
            let coordinates = getCoordinatesAround(coordinate)
            self.annotations = try await aqiClient.getCurrentConditions(coordinates: coordinates.map{
                ($0.latitude, $0.longitude)})
            self.locationStatus = .standy
        }catch{
            self.locationStatus = .error(error.localizedDescription)
        }
   
}
    func getCoordinatesAround(_ coordinate: CLLocationCoordinate2D) -> [CLLocationCoordinate2D]{
        var results: [CLLocationCoordinate2D] = [coordinate]
        radiusNArray.forEach{
            results += coordinatesFinder.findCoordinates(coordinate, r:$0.0, n: $0.1)
        }
        return results
    }
}
