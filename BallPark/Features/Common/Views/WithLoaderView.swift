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
    private func getLoaderView(_ key: UnsafeRawPointer?) -> UIActivityIndicatorView? {
        if let key = key {
            return objc_getAssociatedObject(self, key) as? UIActivityIndicatorView
        } else {
            return objc_getAssociatedObject(self, &loaderKey) as? UIActivityIndicatorView
        }
    }
    
    private func setLoaderView(_ key: UnsafeRawPointer?, _ view: UIActivityIndicatorView?) {
        if let key = key {
            objc_setAssociatedObject(self, key, view, .OBJC_ASSOCIATION_ASSIGN)
        } else {
            objc_setAssociatedObject(self, &loaderKey, view, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func showLoader(anchorTo anchor: UIView? = nil, forKey key: UnsafePointer<EmptyViewKey>? = nil) {
        guard getLoaderView(key) == nil else { return }
        let view = anchor ?? self.view!

        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .red
        loader.center = view.center
        loader.startAnimating()
        view.addSubview(loader)
        setLoaderView(key, loader)
    }
    
    func hideLoader(forKey key: UnsafePointer<EmptyViewKey>? = nil) {
        guard let loader = getLoaderView(key) else { return }
        setLoaderView(key, nil)
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
}
