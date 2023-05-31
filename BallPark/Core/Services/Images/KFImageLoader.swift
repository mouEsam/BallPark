//
//  ImageLoader.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 31/05/2023.
//

import Kingfisher
import UIKit

struct KFImageLoader: AnyImageLoader {
    func load(imageUrl: String, into view: UIImageView, placeholder: UIImage?) {
        if let imageUrl = URL(string: imageUrl) {
            KF.url(imageUrl)
              .placeholder(placeholder)
              .loadDiskFileSynchronously()
              .cacheMemoryOnly()
              .fade(duration: 0.25)
              .set(to: view)
        } else {
            view.image = placeholder
        }
    }
}

