//
//  AnyLoaderView.swift
//  BallPark
//
//  Created by Mostafa Ibrahim on 26/05/2023.
//

import Foundation
import UIKit

private var loaderKey: UInt8 = 0

protocol WithLoaderView: UIViewController {}

extension WithLoaderView {
    var loader: UIActivityIndicatorView? {
        get { objc_getAssociatedObject(self, &loaderKey) as? UIActivityIndicatorView }
        set { objc_setAssociatedObject(self, &loaderKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
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
