//
//  AnyLoaderView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import UIKit

protocol WithLoaderView: UIViewController {
    var loader: UIActivityIndicatorView? { get set }
}

extension WithLoaderView {
    func showLoader() {
        guard loader == nil else { return }
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .red
        loader.center = view.center
        loader.startAnimating()
        view.addSubview(loader)
        self.loader = loader
    }
    
    func hideLoader() {
        guard let loader = loader else { return }
        self.loader = nil
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
}
