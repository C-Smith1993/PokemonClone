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
    var pokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                // Randomly spawn a Pokemon
                
                if let coord = self.manager.location?.coordinate {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coord
                    let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    let randomLong = (Double (arc4random_uniform(200)) - 100.0) / 50000.0
                    annotation.coordinate.latitude += randomLat
                    annotation.coordinate.longitude += randomLong
                    self.mapView.addAnnotation(annotation)
                }
            })
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    // This method is run once the user has authorised this app to use location services.
    // updateCount keeps track of location updates. The user will now be able to view surrounding areas on the map without constantly snapping back to the users current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
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
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
}

















