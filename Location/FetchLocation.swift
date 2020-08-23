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
    var last: CLLocation? = nil
    
    @Published var distance: Double = 0
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var altitude: Double = 0
    @Published var course: Double = 0
    @Published var magneticHeading: Double = 0
    @Published var speed: Double = 0
    
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
        lm.activityType = .fitness
    }
    
    func start() {
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        lm.startUpdatingHeading()
    }
    
    func stop() {
        lm.stopUpdatingLocation()
        lm.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            altitude = location.altitude
            course = location.course
            speed = location.speed
            if let l = last {
                distance += location.distance(from: l)
            }
            last = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        magneticHeading = heading.magneticHeading
    }
}
