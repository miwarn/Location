//
//  Track.swift
//  Location
//
//  Created by Michael Warnatz on 24.08.20.
//  Copyright © 2020 Michael Warnatz. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinates: Codable {
    var time: Date
    var latitude: Double
    var longitude: Double
    var altitude: Double
    
    var locationCoordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Stage: Codable {
    var start: Date
    var stop: Date
    var track: [Coordinates]
}

struct Trip: Codable {
    var title: String
    var stages: [Stage]
    
    mutating func startStage() {
        let time = Date()
        stages.append(Stage(start: time, stop: time, track: []))
    }
    
    mutating func stopStage() {
        stages[stages.count-1].stop = Date()
    }
    
    mutating func addCoordinates(latitude: Double, longitude: Double, altitude: Double) {
        stages[stages.count-1].track.append(Coordinates(time: Date(), latitude: latitude, longitude: longitude, altitude: altitude))
    }
}
