//
//  ViewController.swift
//  MapKitSample
//
//  Created by Karthik on 13/03/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    let locationManager = CLLocationManager()
    var pin =  MKPointAnnotation()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.requestLocationAccess()
        self.configCoreLocationManager()
    }
    
    func requestLocationAccess() {
        var status:CLAuthorizationStatus!
        if #available(iOS 14.0, *) {
             status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .notDetermined:
            print("denied user location access")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    //Configure Core Location manager notify delegates for location updates
    func configCoreLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            self.mapView.delegate = self
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK:- locationManager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        pin.coordinate = center
        mapView.addAnnotation(pin)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 0.01, longitudinalMeters: 0.01)
        self.mapView.setRegion(region, animated: true)
        print("location Manager.location received calling from \(#function)")
    }
    //MARK:- CLLocationManager Delegate
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapView.setCenter(userLocation.coordinate, animated: true)
      
        print("location update from \(#function)")
    }
}

