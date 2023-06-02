//
//  FavouritesTableViewController.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import UIKit
import Swinject

class FavouriteLeaguesViewController: LeaguesViewController {
    
    override class var storyboardId: String { "favouriteLeaguesVC" }
    
    override func inject(_ container: Container) {
        let wrappedContainer = Container(parent: container)
        wrappedContainer.register(AnyLeaguesViewModel.self) { resolver in
            resolver.require((any AnyFavouriteLeaguesViewModelFactory).self).create()
        }
        super.inject(wrappedContainer)
    }
    
}
