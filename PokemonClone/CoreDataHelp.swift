//
//  CoreDataHelp.swift
//  PokemonClone
//
//  Created by Chris Smith on 20/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Meowth", imageName: "meowth")
    createPokemon(name: "Pikachu", imageName: "pikachu-2")
    createPokemon(name: "Bullbasaur", imageName: "bullbasaur")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}


func createPokemon(name: String, imageName: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}





































