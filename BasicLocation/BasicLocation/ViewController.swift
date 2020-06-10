//
//  ViewController.swift
//  BasicLocation
//
//  Created by 90302781 on 5/12/20.
//  Copyright © 2020 90302781. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications
class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    let regionInMeters:Double = 10000
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        
        
        
    }
    func checkDistance(newLocation: CLLocation) -> Bool {
        let currentLocation = locationManager.location?.coordinate
        
        
        //Marc do your conversions here you can get the coordinates by doing newLocation.coordinate.latitute or .longitude and check if the distances are more less than 6 feet you can get the users location with currentLocation.coordinate.latitude or .longitude
        let distance = 5
        //change the distance variable to the distance between the two points
        if distance < 6 {
            return true
        }else{
            return false
        }
        
    }
    func sendNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.body = "Hello"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil )
        
        
        
    }
    func createAnnotation(otherPersonsLocation: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: otherPersonsLocation.coordinate.latitude, longitude: otherPersonsLocation.coordinate.longitude)
        
        
    }
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
            
        }else{
            
        }
    }
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            
        }
    }
}
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        // Ryan Create a function somewhere in the code and call it here for sending the users location to the database
        //The make another function for getting the locations from the database and call it here, assign the location to the otherPersonsLocation
        //let otherPersonsLocation = CLLocation()
        //createAnnotations(otherPersonsLocation)
        //otherPersonsLocation.coordinate.Latitude =
        //otherPersonsLocation.coordinate.Longitude =
        //if check distance(otherPersonsLocation){
        //sendNotification
        //}
        //
        
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
