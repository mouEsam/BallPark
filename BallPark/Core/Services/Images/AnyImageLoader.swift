//
//  AnyImageLoader.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Foundation
import UIKit

protocol AnyImageLoader {
    func load(imageUrl: String, into view: UIImageView, placeholder: UIImage?)
}

extension AnyImageLoader {
    func load(imageUrl: String, into view: UIImageView, placeholder: UIImage? = nil) {
        load(imageUrl: imageUrl, into: view, placeholder: placeholder)
    }
    
    func load(imageUrl: String?, into view: UIImageView, placeholder: UIImage? = nil) {
        if let imageUrl = imageUrl {
            load(imageUrl: imageUrl, into: view, placeholder: placeholder)
        } else {
            view.image = placeholder
        }
    }
}
