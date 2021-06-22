//
//  BaseViewModel.swift
//  SmartNotepad
//
//  Created by Abdelrahman Hussein on 21/06/2021.
//

import Foundation
import CoreLocation

class BaseViewModel: NSObject, CLLocationManagerDelegate {
    
    //MARK:- Properties
    let locationManager: CLLocationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    var userLocation: CLLocation! {
        didSet {
            updateNearestNote()
        }
    }
    
    //MARK:- Binding Closures
    var errorMessage: String? {
        didSet {
            self.showAlert?()
        }
    }
    var state: ViewState = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var showAlert: (()->())?
    var setLocation: ((String)->())?
    var rejectLocationAccess: (() -> Void)?
    var updateLoadingStatus: (()->())?
    
    //MARK:- Location
    func updateNearestNote() {
        
    }
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization() // Always ask for permission
        if !hasLocationPermission() {
            rejectLocationAccess?()
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { // when location Autherization changes
        if !hasLocationPermission() {
            rejectLocationAccess?()
        }
    }
    
    func hasLocationPermission() -> Bool {
        if CLLocationManager.locationServicesEnabled() { // Check if location services is enabled
            return checkLocationAuth()
        } else {
            state = .error
            errorMessage = "Location services are not enabled"
            return false
        }
    }
    
    func checkLocationAuth() -> Bool {
        if #available(iOS 14.0, *) {
            let manager = CLLocationManager()
            switch manager.authorizationStatus {
            case .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                return true
            case .notDetermined:
                return true
            @unknown default:
                return false
            }
        } else {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                return true
            @unknown default:
                return false
            }
        }
    }
    
    // Gets current user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        longitude = userLocation.coordinate.longitude
        latitude = userLocation.coordinate.latitude
        fetchLocation(location: userLocation)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        state = .error
        errorMessage = "Location GPS Tracking is not working"
    }
    // convert latitude and longitude to CLLocation
    func fetchLocation(latitude: String, longitude: String) {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else { return }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        fetchLocation(location: location)
    }
    
    // Convert GPS location to their reverse-geocoded address
    func fetchLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            guard let placemarks = placemarks else {
                self.state = .error
                self.errorMessage = error?.localizedDescription
                return
            }
            if placemarks.count > 0  {
                let place = placemarks[0]
                if let area = place.name, let state = place.locality, let country = place.country {
                    let currentLocationString = "\(area), \(state), \(country)"
                    self.setLocation?(currentLocationString)
                }
            }
        }
    }
}
