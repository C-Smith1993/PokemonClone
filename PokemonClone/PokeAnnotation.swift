//
//  PokeAnnotation.swift
//  PokemonClone
//
//  Created by Chris Smith on 21/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
