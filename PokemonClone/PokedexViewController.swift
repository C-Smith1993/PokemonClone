//
//  PokedexViewController.swift
//  PokemonClone
//
//  Created by Chris Smith on 20/03/2017.
//  Copyright © 2017 CDSApps. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caughtPokemons = getAllCaughtPokemons()
        uncaughtPokemons = getAllUncaughtPokemons()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
}
