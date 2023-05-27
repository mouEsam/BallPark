//
//  FavouritesTableViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import UIKit
import Swinject

class FavouritesTableViewController: LeaguesTableViewController {

    override func inject(_ container: Container) {
        let wrappedContainer = Container(parent: container)
        wrappedContainer.register(AnyLeaguesModel.self) { resolver in
            FavouriteLeaguesModel(database: resolver.require((any FavouritesDatabase<League>).self))
        }
        super.inject(wrappedContainer)
    }

}
