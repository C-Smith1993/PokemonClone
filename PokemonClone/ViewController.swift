//
//  ViewController.swift
//  PokemonClone
//
//  Created by Chris Smith on 19/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    var updateCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
        
        let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 400, 400)
        mapView.setRegion(region, animated: false)
        updateCount += 1
        } else {
            // Not necessary but it saves battery life
            manager.stopUpdatingLocation()
        }
    }

    // If the current location dot goes off screen, clicking the compass image will recenter the current location dot on screen.
    @IBAction func centerTapped(_ sender: Any) {
        
        if let coord = manager.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coord, 400, 400)
        mapView.setRegion(region, animated: true)
    }
    }
    
    
}

















