//
//  ViewController.swift
//  PokemonClone
//
//  Created by Chris Smith on 19/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    var updateCount = 0
    var pokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setUp()
                    } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setUp()
        }
    }
    
    
    func setUp() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        manager.startUpdatingLocation()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            // Randomly spawn a Pokemon
            
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                
                let annotation = PokeAnnotation(coord: coord, pokemon: pokemon)
                let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randomLong = (Double (arc4random_uniform(200)) - 100.0) / 50000.0
                annotation.coordinate.latitude += randomLat
                annotation.coordinate.longitude += randomLong
                self.mapView.addAnnotation(annotation)
            }
        })

    }
    
    
    // Gets called everytime the map wants to show an annotation on screen.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // The users annotation
        if annotation is MKUserLocation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.image = UIImage(named: "player")
            var frame = annotationView.frame
            frame.size.height = 50
            frame.size.width = 50
            annotationView.frame = frame
            
            return annotationView
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annotationView.image = UIImage(named: pokemon.imageName!)
        var frame = annotationView.frame
        frame.size.height = 50
        frame.size.width = 50
        annotationView.frame = frame
        
        return annotationView
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
    
    
    // Determines whether or not the Pokemon are within reach.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
            if let coord = self.manager.location?.coordinate {
                let pokemon = (view.annotation! as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    // The Pokemon is within catching distance
                    
                    pokemon.caught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats", message: "You caught a \(pokemon.name!). You are a Pokemon master!", preferredStyle: .alert)
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertVC.addAction(pokedexAction)
                    
                    let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okayAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    
                } else {
                    // The Pokemon is too far away 
                    let alertVC = UIAlertController(title: "Uh-Oh", message: "You are too far away to catch the \(pokemon.name!). Move closer to it!", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertVC.addAction(okayAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        })
        
    }
    
    
    // If the current location dot goes off screen, clicking the compass image will recenter the current location dot on screen.
    @IBAction func centerTapped(_ sender: Any) {
        
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
            mapView.setRegion(region, animated: true)
        }
    }
}





































