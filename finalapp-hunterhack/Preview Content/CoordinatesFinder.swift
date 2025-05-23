//
//  CoordinatesFinder.swift
//  finalapp-hunterhack
//
//  Created by Linh Yui on 5/4/25.
//

import Foundation
import CoreLocation

//Get from Dependencies Package
struct CoordinatesFinder {
    
    let R = 6371000.0 // radius of the Earth in meters
    let pi = 3.141592653589793 // pi constant

    // Define a function to convert degrees to radians
    func deg2rad(_ deg: Double) -> Double {
        return deg * pi / 180
    }

    // Define a function to convert radians to degrees
    func rad2deg(_ rad: Double) -> Double {
        return rad * 180 / pi
    }

    // Define a function to find coordinates on a circle around a given point
    func findCoordinates(_ coordinate: CLLocationCoordinate2D, r: Double, n: Int) -> [CLLocationCoordinate2D] {
        // Convert inputs to radians
        let phi1 = deg2rad(coordinate.latitude)
        let lambda1 = deg2rad(coordinate.longitude)
        let d = r / R // angular distance
        
        // Initialize an empty array to store the coordinates
        var coordinates: [CLLocationCoordinate2D] = []
        
        // Loop over different bearings
        for i in 0..<n {
            // Convert bearing to radians
            let theta = deg2rad(Double(i) * 360 / Double(n))
            
            // Apply the formula for destination point
            let phi2 = asin(sin(phi1) *  cos(d) + cos(phi1) * sin(d) * cos(theta))
            let lambda2 = lambda1 + atan2(sin(theta) * sin(d) * cos(phi1), cos(d) - sin(phi1) * sin(phi2))
            
            // Convert outputs to degrees
            let lat2 = rad2deg(phi2)
            let lon2 = rad2deg(lambda2)
            
            // Append the coordinate to the array
            coordinates.append(.init(latitude: lat2, longitude: lon2))
        }
        
        // Return the array of coordinates
        return coordinates
        
    }
    
}
