//
//  Location.swift
//  Location
//
//  Created by Michael Warnatz on 16.08.20.
//  Copyright © 2020 Michael Warnatz. All rights reserved.
//

import CoreLocation
import Combine

class FetchLocation: NSObject, CLLocationManagerDelegate, ObservableObject {
    let lm = CLLocationManager()
    var trip: Trip?
    
    @Published var altitude: Double = 0
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    
    @Published var update: Bool = false {
        didSet {
            if update { start() }
            else { stop() }
        }
    }
    
    override init() {
        super.init()
        lm.delegate = self
        lm.distanceFilter = 5.0
        lm.allowsBackgroundLocationUpdates = true
        lm.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        lm.pausesLocationUpdatesAutomatically = false
    }
    
    func start() {
        if trip == nil {
            // Start new trip
            trip = Trip(title: "\(Date())", stages: [Stage(start: Date(), stop: Date(), track: [])])
        } else {
            // Continue trip with new stage
            trip?.stages.append(Stage(start: Date(), stop: Date(), track: []))
        }
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }
    
    func stop() {
        lm.stopUpdatingLocation()
        trip?.stopStage()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            altitude = location.altitude
            trip?.addCoordinates(latitude: latitude, longitude: longitude, altitude: altitude)
        }
    }
    
    func save() {
        guard let t = trip else { return }
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("track.txt") else { return }
        let encoder = JSONEncoder()
        if let jsondata = try? encoder.encode(t),
           let jsonstr = String(data: jsondata, encoding: .utf8) {
            do {
                try jsonstr.write(to: url, atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
